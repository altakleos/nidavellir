#!/usr/bin/env python3
"""
Analyze Claude Code extensions and recommend improvements.

This script analyzes existing skills, agents, and suites to:
- Detect extension type (skill/agent/suite/hybrid)
- Calculate reusability scores
- Suggest migration paths (skill → agent if highly reusable)
- Identify missing documentation
- Check for orphaned files

Usage:
    python analyze_extension.py <path_to_extension>
    python analyze_extension.py plugins/eitri
"""

import argparse
import re
import sys
from pathlib import Path
from typing import Optional


class ExtensionAnalysis:
    """Container for extension analysis results."""

    def __init__(self):
        self.extension_type: str = "unknown"
        self.reusability_score: float = 0.0
        self.context_dependency: float = 0.0
        self.recommendations: list[str] = []
        self.orphaned_files: list[Path] = []
        self.missing_docs: list[str] = []
        self.stats: dict = {}


def parse_frontmatter(content: str) -> dict:
    """Extract YAML frontmatter from markdown content."""
    lines = content.split("\n")

    if not lines or lines[0].strip() != "---":
        return {}

    frontmatter_lines = []
    in_frontmatter = False

    for line in lines:
        if line.strip() == "---":
            if not in_frontmatter:
                in_frontmatter = True
                continue
            else:
                break
        if in_frontmatter:
            frontmatter_lines.append(line)

    frontmatter = {}
    current_key = None
    current_list = None

    for line in frontmatter_lines:
        if line.strip().startswith("- "):
            if current_key and current_list is not None:
                current_list.append(line.strip()[2:].strip())
            continue

        if ":" in line:
            key, _, value = line.partition(":")
            key = key.strip()
            value = value.strip()

            if current_key and current_list is not None:
                frontmatter[current_key] = current_list

            if value:
                frontmatter[key] = value
                current_key = None
                current_list = None
            else:
                current_key = key
                current_list = []

    if current_key and current_list is not None:
        frontmatter[current_key] = current_list

    return frontmatter


def detect_extension_type(path: Path, content: str, frontmatter: dict) -> str:
    """Detect what type of extension this is."""

    # Check for AGENT.md
    if (path / "AGENT.md").exists():
        return "agent"

    # Check for SUITE.md or suite-config.yaml
    if (path / "SUITE.md").exists() or (path / "suite-config.yaml").exists():
        return "suite"

    # Check for HYBRID.md or hybrid structure
    if (path / "HYBRID.md").exists():
        return "hybrid"

    # Check for agents/ subdirectory
    if (path / "agents").exists() and (path / "agents").is_dir():
        # Could be suite or hybrid
        if (path / "skill").exists():
            return "hybrid"
        return "suite"

    # Default to skill if SKILL.md exists
    if (path / "SKILL.md").exists():
        return "skill"

    return "unknown"


def calculate_reusability_score(content: str, frontmatter: dict) -> float:
    """Calculate how reusable this extension is (0.0 to 1.0)."""

    score = 0.5  # Start neutral

    description = frontmatter.get("description", "").lower()
    content_lower = content.lower()

    # High reusability signals
    generic_verbs = ["format", "lint", "test", "validate", "check", "analyze", "generate"]
    for verb in generic_verbs:
        if verb in description:
            score += 0.1

    # Low reusability signals
    custom_words = ["our", "my", "custom", "proprietary", "specific", "company"]
    for word in custom_words:
        if word in description or word in content_lower:
            score -= 0.1

    # Check for project-specific references
    if re.search(r"/home/|/Users/|C:\\", content):
        score -= 0.2

    # Check for business-specific terminology
    business_terms = ["mrr", "arr", "churn", "onboarding", "quarterly"]
    for term in business_terms:
        if term in content_lower:
            score -= 0.05

    # Bound the score
    return max(0.0, min(1.0, score))


def calculate_context_dependency(content: str, frontmatter: dict) -> float:
    """Calculate how context-dependent this extension is (0.0 to 1.0)."""

    score = 0.3  # Start slightly low

    content_lower = content.lower()

    # High context signals
    context_words = ["context", "conversation", "understand", "remember", "state", "history"]
    for word in context_words:
        count = content_lower.count(word)
        score += min(0.1 * count, 0.2)

    # Workflow complexity
    if "phase" in content_lower:
        phases = len(re.findall(r"phase\s+\d+|phase:?\s+\w+", content_lower))
        score += min(0.1 * phases, 0.3)

    # Integration mentions
    integration_words = ["integrate", "connect", "api", "endpoint", "workflow"]
    for word in integration_words:
        if word in content_lower:
            score += 0.05

    return max(0.0, min(1.0, score))


def find_orphaned_files(path: Path, content: str) -> list[Path]:
    """Find files that exist but aren't referenced."""

    orphaned = []

    # Get all .md files
    md_files = list(path.rglob("*.md"))

    for md_file in md_files:
        if md_file.name in ["SKILL.md", "README.md", "CHANGELOG.md", "HOW_TO_USE.md"]:
            continue

        # Get relative path from extension root
        rel_path = md_file.relative_to(path)
        rel_str = str(rel_path)

        # Check if referenced in main content
        if rel_str not in content and md_file.name not in content:
            orphaned.append(rel_path)

    return orphaned


def check_missing_docs(path: Path) -> list[str]:
    """Check for missing recommended documentation."""

    missing = []

    recommended_files = [
        ("README.md", "Main documentation for users"),
        ("CHANGELOG.md", "Version history"),
    ]

    for filename, description in recommended_files:
        if not (path / filename).exists():
            missing.append(f"{filename} ({description})")

    return missing


def get_stats(path: Path, content: str) -> dict:
    """Gather statistics about the extension."""

    stats = {
        "total_files": 0,
        "md_files": 0,
        "py_files": 0,
        "lines_of_content": len(content.split("\n")),
        "subdirectories": 0,
    }

    for item in path.rglob("*"):
        if item.is_file():
            stats["total_files"] += 1
            if item.suffix == ".md":
                stats["md_files"] += 1
            elif item.suffix == ".py":
                stats["py_files"] += 1
        elif item.is_dir():
            stats["subdirectories"] += 1

    return stats


def generate_recommendations(analysis: ExtensionAnalysis) -> list[str]:
    """Generate improvement recommendations based on analysis."""

    recommendations = []

    # Reusability recommendations
    if analysis.reusability_score > 0.7 and analysis.extension_type == "skill":
        recommendations.append(
            "HIGH REUSABILITY DETECTED: Consider migrating to an agent for "
            "auto-invocation and better tool restrictions."
        )

    if analysis.reusability_score < 0.3 and analysis.extension_type == "agent":
        recommendations.append(
            "LOW REUSABILITY: This agent may be too context-specific. "
            "Consider converting to a skill for better integration."
        )

    # Context dependency recommendations
    if analysis.context_dependency > 0.7 and analysis.extension_type == "agent":
        recommendations.append(
            "HIGH CONTEXT DEPENDENCY: Agents work best with low context needs. "
            "Consider a skill or hybrid approach."
        )

    # Orphaned files
    if analysis.orphaned_files:
        recommendations.append(
            f"ORPHANED FILES: {len(analysis.orphaned_files)} file(s) exist but "
            "are not referenced. Add references or remove them."
        )

    # Missing docs
    if analysis.missing_docs:
        recommendations.append(
            f"MISSING DOCUMENTATION: Consider adding: {', '.join(analysis.missing_docs)}"
        )

    # Stats-based recommendations
    if analysis.stats.get("lines_of_content", 0) > 500:
        recommendations.append(
            "LARGE EXTENSION: Consider breaking into smaller, focused components "
            "or extracting reusable parts as separate agents."
        )

    if not recommendations:
        recommendations.append(
            "No significant issues found. Extension appears well-structured."
        )

    return recommendations


def analyze_extension(path: Path) -> Optional[ExtensionAnalysis]:
    """Main analysis function."""

    if not path.exists():
        print(f"Error: Path does not exist: {path}")
        return None

    if not path.is_dir():
        print(f"Error: Path is not a directory: {path}")
        return None

    # Find the main content file
    skill_md = path / "SKILL.md"
    agent_md = path / "AGENT.md"
    suite_md = path / "SUITE.md"

    content_file = None
    if skill_md.exists():
        content_file = skill_md
    elif agent_md.exists():
        content_file = agent_md
    elif suite_md.exists():
        content_file = suite_md

    if not content_file:
        print(f"Error: No SKILL.md, AGENT.md, or SUITE.md found in {path}")
        return None

    content = content_file.read_text()
    frontmatter = parse_frontmatter(content)

    analysis = ExtensionAnalysis()
    analysis.extension_type = detect_extension_type(path, content, frontmatter)
    analysis.reusability_score = calculate_reusability_score(content, frontmatter)
    analysis.context_dependency = calculate_context_dependency(content, frontmatter)
    analysis.orphaned_files = find_orphaned_files(path, content)
    analysis.missing_docs = check_missing_docs(path)
    analysis.stats = get_stats(path, content)
    analysis.recommendations = generate_recommendations(analysis)

    return analysis


def print_analysis(analysis: ExtensionAnalysis, path: Path) -> None:
    """Print analysis results in a nice format."""

    print("\n" + "=" * 60)
    print("Extension Analysis Report")
    print(f"Path: {path}")
    print("=" * 60)

    print(f"\n📊 TYPE DETECTION")
    print(f"   Extension Type: {analysis.extension_type.upper()}")

    print(f"\n📈 METRICS")
    print(f"   Reusability Score: {analysis.reusability_score:.0%}")
    print(f"   Context Dependency: {analysis.context_dependency:.0%}")

    print(f"\n📁 STATISTICS")
    for key, value in analysis.stats.items():
        print(f"   {key.replace('_', ' ').title()}: {value}")

    if analysis.orphaned_files:
        print(f"\n⚠️  ORPHANED FILES ({len(analysis.orphaned_files)})")
        for f in analysis.orphaned_files:
            print(f"   • {f}")

    if analysis.missing_docs:
        print(f"\n📝 MISSING DOCUMENTATION")
        for doc in analysis.missing_docs:
            print(f"   • {doc}")

    print(f"\n💡 RECOMMENDATIONS")
    for rec in analysis.recommendations:
        print(f"   • {rec}")

    # Migration suggestion
    print(f"\n🔄 MIGRATION ANALYSIS")
    if analysis.extension_type == "skill" and analysis.reusability_score > 0.6:
        print("   This skill has potential for agent conversion:")
        print("   - Reusability is high enough for cross-project use")
        print("   - Consider extracting reusable parts as agents")
    elif analysis.extension_type == "agent" and analysis.context_dependency > 0.6:
        print("   This agent may benefit from skill conversion:")
        print("   - High context dependency suits integrated approach")
        print("   - Consider a hybrid solution with skill orchestrator")
    else:
        print(f"   Current type ({analysis.extension_type}) appears appropriate.")

    print("\n" + "=" * 60 + "\n")


def main():
    parser = argparse.ArgumentParser(
        description="Analyze Claude Code extensions and recommend improvements"
    )
    parser.add_argument(
        "path",
        type=Path,
        help="Path to the extension directory"
    )
    parser.add_argument(
        "--json", "-j",
        action="store_true",
        help="Output results as JSON"
    )

    args = parser.parse_args()

    analysis = analyze_extension(args.path)

    if not analysis:
        sys.exit(1)

    if args.json:
        import json
        output = {
            "extension_type": analysis.extension_type,
            "reusability_score": analysis.reusability_score,
            "context_dependency": analysis.context_dependency,
            "orphaned_files": [str(f) for f in analysis.orphaned_files],
            "missing_docs": analysis.missing_docs,
            "stats": analysis.stats,
            "recommendations": analysis.recommendations,
        }
        print(json.dumps(output, indent=2))
    else:
        print_analysis(analysis, args.path)


if __name__ == "__main__":
    main()
