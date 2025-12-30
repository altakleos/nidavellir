#!/usr/bin/env python3
"""
Validate Claude Code extension structure and compliance.

This script validates skills, agents, and suites against the official
Claude Code specification and best practices.

Usage:
    python validate_extension.py <path_to_extension>
    python validate_extension.py plugins/eitri/examples/simple-skill
"""

import argparse
import re
import sys
from pathlib import Path
from typing import Optional


# Official SKILL.md frontmatter fields (per Claude Code spec)
OFFICIAL_FIELDS = {
    "name",
    "description",
    "version",
    "disable-model-invocation",
    "mode",
    "allowed-tools",
}

# Valid tools for allowed-tools field
VALID_TOOLS = {
    "Read", "Write", "Edit", "Glob", "Grep", "Bash", "Task",
    "WebFetch", "WebSearch", "NotebookEdit", "NotebookRead",
    "AskUserQuestion", "TodoWrite", "Skill", "EnterPlanMode",
    "ExitPlanMode", "KillShell", "TaskOutput",
}

# Anti-patterns to check for
ANTI_PATTERNS = [
    {
        "pattern": r"hardcoded\s+path|/home/\w+/",
        "message": "Potential hardcoded path detected",
        "severity": "warning",
    },
    {
        "pattern": r"TODO|FIXME|XXX",
        "message": "Unresolved TODO/FIXME comment",
        "severity": "info",
    },
]


class ValidationResult:
    """Container for validation results."""

    def __init__(self):
        self.errors: list[str] = []
        self.warnings: list[str] = []
        self.info: list[str] = []

    @property
    def passed(self) -> bool:
        return len(self.errors) == 0

    def add_error(self, message: str) -> None:
        self.errors.append(message)

    def add_warning(self, message: str) -> None:
        self.warnings.append(message)

    def add_info(self, message: str) -> None:
        self.info.append(message)


def parse_frontmatter(content: str) -> tuple[dict, Optional[str]]:
    """Extract YAML frontmatter from markdown content."""
    lines = content.split("\n")

    if not lines or lines[0].strip() != "---":
        return {}, "No frontmatter found (file must start with ---)"

    frontmatter_lines = []
    in_frontmatter = False
    end_line = 0

    for i, line in enumerate(lines):
        if line.strip() == "---":
            if not in_frontmatter:
                in_frontmatter = True
                continue
            else:
                end_line = i
                break
        if in_frontmatter:
            frontmatter_lines.append(line)

    if not frontmatter_lines:
        return {}, "Empty frontmatter"

    # Simple YAML parsing (handles basic key: value and lists)
    frontmatter = {}
    current_key = None
    current_list = None

    for line in frontmatter_lines:
        # Handle list items
        if line.strip().startswith("- "):
            if current_key and current_list is not None:
                current_list.append(line.strip()[2:].strip())
            continue

        # Handle key: value pairs
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

    # Don't forget last list
    if current_key and current_list is not None:
        frontmatter[current_key] = current_list

    return frontmatter, None


def validate_frontmatter(frontmatter: dict, result: ValidationResult) -> None:
    """Validate frontmatter against official spec."""

    # Check required fields
    if "name" not in frontmatter:
        result.add_error("Missing required field: name")
    if "description" not in frontmatter:
        result.add_error("Missing required field: description")

    # Validate name format
    name = frontmatter.get("name", "")
    if name:
        if not re.match(r"^[a-z0-9-]+$", name):
            result.add_error(f"Invalid name format: '{name}' (use lowercase, numbers, hyphens only)")
        if len(name) > 64:
            result.add_error(f"Name too long: {len(name)} chars (max 64)")

    # Validate description length
    description = frontmatter.get("description", "")
    if description and len(description) > 1024:
        result.add_error(f"Description too long: {len(description)} chars (max 1024)")

    # Validate version format (if present)
    version = frontmatter.get("version", "")
    if version:
        semver_pattern = r"^\d+\.\d+\.\d+(-[a-zA-Z0-9.-]+)?(\+[a-zA-Z0-9.-]+)?$"
        if not re.match(semver_pattern, version):
            result.add_error(f"Invalid version format: '{version}' (use semver: X.Y.Z)")

    # Check for non-standard fields
    for field in frontmatter:
        if field not in OFFICIAL_FIELDS:
            result.add_error(f"Non-standard frontmatter field: '{field}' (not in official Claude Code spec)")

    # Validate allowed-tools
    allowed_tools = frontmatter.get("allowed-tools", [])
    if isinstance(allowed_tools, list):
        for tool in allowed_tools:
            if tool not in VALID_TOOLS:
                result.add_warning(f"Unknown tool in allowed-tools: '{tool}'")


def validate_file_structure(path: Path, result: ValidationResult) -> Optional[Path]:
    """Validate extension file structure and return SKILL.md path."""

    # Check for SKILL.md
    skill_md = path / "SKILL.md"
    if not skill_md.exists():
        result.add_error(f"SKILL.md not found in {path}")
        return None

    # Check for README.md (warning only)
    readme = path / "README.md"
    if not readme.exists():
        result.add_warning("README.md not found (recommended for documentation)")

    return skill_md


def check_anti_patterns(content: str, result: ValidationResult) -> None:
    """Check for common anti-patterns in content."""

    for pattern_info in ANTI_PATTERNS:
        matches = re.findall(pattern_info["pattern"], content, re.IGNORECASE)
        if matches:
            severity = pattern_info["severity"]
            message = f"{pattern_info['message']}: found {len(matches)} occurrence(s)"

            if severity == "error":
                result.add_error(message)
            elif severity == "warning":
                result.add_warning(message)
            else:
                result.add_info(message)


def check_references(content: str, base_path: Path, result: ValidationResult) -> None:
    """Check that referenced files exist."""

    # Find all path references like (see `path/to/file.md`)
    ref_pattern = r"\(see\s+[`'\"]?([^`'\")\s]+)[`'\"]?\)"
    references = re.findall(ref_pattern, content)

    for ref in references:
        # Clean up the reference
        ref = ref.strip("`'\"")
        ref_path = base_path / ref

        if not ref_path.exists():
            result.add_warning(f"Referenced file not found: {ref}")


def validate_extension(path: Path) -> ValidationResult:
    """Main validation function."""

    result = ValidationResult()

    # Validate path exists
    if not path.exists():
        result.add_error(f"Path does not exist: {path}")
        return result

    if not path.is_dir():
        result.add_error(f"Path is not a directory: {path}")
        return result

    # Validate file structure
    skill_md = validate_file_structure(path, result)
    if not skill_md:
        return result

    # Read and validate SKILL.md
    content = skill_md.read_text()

    # Parse and validate frontmatter
    frontmatter, error = parse_frontmatter(content)
    if error:
        result.add_error(f"Frontmatter error: {error}")
    else:
        validate_frontmatter(frontmatter, result)

    # Check for anti-patterns
    check_anti_patterns(content, result)

    # Check references
    check_references(content, path, result)

    return result


def print_results(result: ValidationResult, path: Path) -> None:
    """Print validation results in a nice format."""

    print("\n" + "=" * 50)
    print(f"Extension Validation Report")
    print(f"Path: {path}")
    print("=" * 50)

    if result.errors:
        print(f"\n❌ ERRORS ({len(result.errors)}):")
        for error in result.errors:
            print(f"   • {error}")

    if result.warnings:
        print(f"\n⚠️  WARNINGS ({len(result.warnings)}):")
        for warning in result.warnings:
            print(f"   • {warning}")

    if result.info:
        print(f"\nℹ️  INFO ({len(result.info)}):")
        for info in result.info:
            print(f"   • {info}")

    print("\n" + "-" * 50)
    if result.passed:
        print("✅ VALIDATION PASSED")
        if result.warnings:
            print("   (with warnings)")
    else:
        print("❌ VALIDATION FAILED")
    print("-" * 50 + "\n")


def main():
    parser = argparse.ArgumentParser(
        description="Validate Claude Code extension structure and compliance"
    )
    parser.add_argument(
        "path",
        type=Path,
        help="Path to the extension directory"
    )
    parser.add_argument(
        "--quiet", "-q",
        action="store_true",
        help="Only output errors, not warnings or info"
    )

    args = parser.parse_args()

    result = validate_extension(args.path)

    if not args.quiet:
        print_results(result, args.path)
    else:
        if not result.passed:
            for error in result.errors:
                print(f"ERROR: {error}")

    sys.exit(0 if result.passed else 1)


if __name__ == "__main__":
    main()
