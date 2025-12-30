---
name: optimization-engine
type: module
description: Feedback-driven prompt optimization with versioning and lifecycle tracking
---

# Optimization Engine - Prompt Improvement System

This module enables Eitri to improve any extension's prompts (including its own) through collected feedback, with proper versioning and lifecycle tracking.

## Core Concept

```
Feedback → Accumulate → Analyze → Propose Improvements → Apply → Track
    ↑                                                          |
    └──────────────────── Verify ──────────────────────────────┘
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Optimization Engine                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │  Extension  │  │  Feedback   │  │    Prompt Improver     │ │
│  │   Loader    │  │ Aggregator  │  │  (LLM-based analysis)  │ │
│  └──────┬──────┘  └──────┬──────┘  └───────────┬─────────────┘ │
│         │                │                      │               │
│         ▼                ▼                      ▼               │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    Version Manager                       │   │
│  │  .claude/eitri/optimization/versions/                   │   │
│  │  .claude/eitri/optimization/prompts/                    │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## `/forge:improve` Command Flow

### Step 1: Load Extension

```python
class ExtensionLoader:
    def load(self, extension_path):
        """Load extension and its metadata."""
        # Detect extension type
        if (extension_path / "SKILL.md").exists():
            prompt_file = extension_path / "SKILL.md"
            ext_type = "skill"
        elif (extension_path / "AGENT.md").exists():
            prompt_file = extension_path / "AGENT.md"
            ext_type = "agent"
        else:
            raise ValueError(f"No SKILL.md or AGENT.md found in {extension_path}")

        # Load current prompt
        prompt_content = prompt_file.read_text()
        prompt_hash = hashlib.sha256(prompt_content.encode()).hexdigest()[:16]

        # Load version manifest (if exists)
        version = self._get_current_version(extension_path)

        return {
            "name": extension_path.name,
            "path": extension_path,
            "type": ext_type,
            "prompt_file": prompt_file,
            "prompt_content": prompt_content,
            "prompt_hash": prompt_hash,
            "version": version
        }

    def _get_current_version(self, extension_path):
        """Get current version from manifest or plugin.json."""
        # Try version manifest first
        manifest_path = Path(".claude/eitri/optimization/versions") / f"{extension_path.name}.json"
        if manifest_path.exists():
            manifest = json.loads(manifest_path.read_text())
            return manifest["current_version"]

        # Try plugin.json
        plugin_json = extension_path / ".claude-plugin" / "plugin.json"
        if plugin_json.exists():
            plugin = json.loads(plugin_json.read_text())
            return plugin.get("version", "1.0.0")

        return "1.0.0"
```

### Step 2: Gather Pending Feedback

```python
class FeedbackAggregator:
    def __init__(self, storage_path):
        self.team_feedback = storage_path / ".claude/eitri/learning/team-feedback.jsonl"
        self.personal_feedback = Path.home() / ".claude/eitri/learning/feedback-log.jsonl"

    def get_pending(self, extension_name, current_version, prompt_hash):
        """Get all pending feedback for an extension."""
        pending = []

        for feedback_file in [self.team_feedback, self.personal_feedback]:
            if not feedback_file.exists():
                continue

            for line in feedback_file.read_text().splitlines():
                if not line.strip():
                    continue

                entry = json.loads(line)

                # Filter by extension
                if entry.get("extension", {}).get("name") != extension_name:
                    continue

                # Filter by lifecycle status
                lifecycle = entry.get("lifecycle", {})
                if lifecycle.get("status") != "pending":
                    continue

                # Filter by version (only feedback for current or older versions)
                entry_version = entry.get("extension", {}).get("version", "1.0.0")
                if self._version_gt(entry_version, current_version):
                    continue

                pending.append(entry)

        # Sort by severity (high first), then by date
        severity_order = {"critical": 0, "high": 1, "medium": 2, "low": 3}
        pending.sort(key=lambda e: (
            severity_order.get(e.get("content", {}).get("severity", "low"), 3),
            e.get("timestamp", "")
        ))

        return pending

    def _version_gt(self, v1, v2):
        """Check if v1 > v2 (semver comparison)."""
        def parse(v):
            return tuple(int(x) for x in v.split("."))
        try:
            return parse(v1) > parse(v2)
        except:
            return False
```

### Step 3: LLM Analysis & Improvement

The `prompt-improver.md` module handles the LLM-based analysis. See `intelligence/prompt-improver.md`.

### Step 4: Apply Changes

```python
class VersionManager:
    def __init__(self, project_root):
        self.versions_dir = project_root / ".claude/eitri/optimization/versions"
        self.prompts_dir = project_root / ".claude/eitri/optimization/prompts"

    def apply_improvement(self, extension, proposed_prompt, feedback_applied, changes_summary):
        """Apply prompt improvement and update version."""
        # Calculate new version
        old_version = extension["version"]
        new_version = self._bump_version(old_version)

        # Archive current prompt
        self._archive_prompt(extension, old_version)

        # Write new prompt
        extension["prompt_file"].write_text(proposed_prompt)
        new_hash = hashlib.sha256(proposed_prompt.encode()).hexdigest()[:16]

        # Update version manifest
        self._update_manifest(
            extension["name"],
            old_version,
            new_version,
            new_hash,
            feedback_applied,
            changes_summary
        )

        # Update feedback lifecycle status
        self._mark_feedback_applied(feedback_applied, new_version)

        return new_version

    def _bump_version(self, version):
        """Bump minor version."""
        parts = version.split(".")
        parts[1] = str(int(parts[1]) + 1)
        parts[2] = "0"  # Reset patch
        return ".".join(parts)

    def _archive_prompt(self, extension, version):
        """Archive current prompt before modification."""
        archive_dir = self.prompts_dir / extension["name"]
        archive_dir.mkdir(parents=True, exist_ok=True)

        archive_file = archive_dir / f"{version}.md"
        archive_file.write_text(extension["prompt_content"])

    def _update_manifest(self, name, old_version, new_version, prompt_hash, feedback_applied, changes_summary):
        """Update version manifest."""
        manifest_file = self.versions_dir / f"{name}.json"
        self.versions_dir.mkdir(parents=True, exist_ok=True)

        if manifest_file.exists():
            manifest = json.loads(manifest_file.read_text())
        else:
            manifest = {"extension": name, "versions": []}

        manifest["current_version"] = new_version
        manifest["versions"].append({
            "version": new_version,
            "prompt_hash": f"sha256:{prompt_hash}",
            "created_at": datetime.utcnow().isoformat() + "Z",
            "source": "optimization",
            "parent_version": old_version,
            "feedback_applied": [f["id"] for f in feedback_applied],
            "changes_summary": changes_summary
        })

        manifest_file.write_text(json.dumps(manifest, indent=2))

    def _mark_feedback_applied(self, feedback_entries, new_version):
        """Update feedback entries to 'applied' status."""
        # This updates the JSONL file in place by rewriting it
        # In production, consider append-only with a separate status file
        for entry in feedback_entries:
            entry["lifecycle"]["status"] = "applied"
            entry["lifecycle"]["applied_in_version"] = new_version
            entry["lifecycle"]["applied_at"] = datetime.utcnow().isoformat() + "Z"

    def rollback(self, extension_name, target_version):
        """Rollback to a previous version."""
        archive_file = self.prompts_dir / extension_name / f"{target_version}.md"
        if not archive_file.exists():
            raise ValueError(f"No archived prompt for version {target_version}")

        # Load archived prompt
        archived_prompt = archive_file.read_text()

        # Get current extension path from manifest
        manifest_file = self.versions_dir / f"{extension_name}.json"
        manifest = json.loads(manifest_file.read_text())

        # Find extension path (assumes standard location)
        extension_path = Path(f"plugins/{extension_name}")
        prompt_file = extension_path / "SKILL.md"
        if not prompt_file.exists():
            prompt_file = extension_path / "AGENT.md"

        # Write rolled-back prompt
        prompt_file.write_text(archived_prompt)

        # Update manifest
        manifest["current_version"] = target_version
        manifest["versions"].append({
            "version": target_version,
            "created_at": datetime.utcnow().isoformat() + "Z",
            "source": "rollback",
            "rolled_back_from": manifest["current_version"]
        })

        manifest_file.write_text(json.dumps(manifest, indent=2))

        return target_version
```

## Eitri Self-Improvement

When `/forge:improve ./plugins/eitri` is invoked, special handling routes feedback to appropriate components.

### Component Detection

```python
def get_eitri_components(eitri_path):
    """Identify all optimizable components in Eitri."""
    components = []

    # Main skill
    components.append({
        "name": "eitri/SKILL",
        "path": eitri_path / "SKILL.md",
        "category": "main"
    })

    # Generators
    for gen in (eitri_path / "generators").glob("*.md"):
        components.append({
            "name": f"eitri/generators/{gen.stem}",
            "path": gen,
            "category": "generators"
        })

    # Core modules
    for core in (eitri_path / "core").glob("*.md"):
        components.append({
            "name": f"eitri/core/{core.stem}",
            "path": core,
            "category": "core"
        })

    # Intelligence modules
    for intel in (eitri_path / "intelligence").glob("*.md"):
        components.append({
            "name": f"eitri/intelligence/{intel.stem}",
            "path": intel,
            "category": "intelligence"
        })

    # Commands
    for cmd in (eitri_path / "commands").glob("*.md"):
        components.append({
            "name": f"eitri/commands/{cmd.stem}",
            "path": cmd,
            "category": "commands"
        })

    return components
```

### Feedback Routing

```python
def route_eitri_feedback(feedback, components):
    """Route feedback to the appropriate Eitri component."""

    description = feedback.get("content", {}).get("description", "").lower()

    # Keyword-based routing
    routing_rules = {
        "skill generation": "generators/skill-generator",
        "agent generation": "generators/agent-generator",
        "suite": "generators/suite-coordinator",
        "type recommendation": "core/decision-framework",
        "wrong type": "core/decision-framework",
        "validation": "core/validation-framework",
        "hook": "generators/hook-generator",
        "mcp": "generators/mcp-generator",
        "test harness": "core/test-harness",
        "template": "core/template-scanner"
    }

    for keyword, component_stem in routing_rules.items():
        if keyword in description:
            for comp in components:
                if component_stem in comp["name"]:
                    return comp

    # Default: LLM-assisted routing (handled by prompt-improver)
    return None
```

### Component Context Guidance

When optimizing Eitri components, include contextual guidance:

```python
COMPONENT_GUIDANCE = {
    "core": """These components define Eitri's fundamental behavior.
Changes here affect all future extension generation.
Consider preserving: 6-type output constraint, validation-before-generation flow.""",

    "generators": """These define how each extension type is created.
Changes affect the quality and structure of generated extensions.""",

    "intelligence": """These handle learning and pattern recognition.
Changes affect how Eitri adapts to user feedback.""",

    "commands": """These define user-facing interactions.
Changes affect UX and discoverability."""
}

def get_component_guidance(component):
    """Get contextual guidance for a component."""
    category = component["category"]
    return COMPONENT_GUIDANCE.get(category, "")
```

## Auto-Suggestion Threshold

When pending feedback count reaches threshold, suggest optimization:

```python
class OptimizationSuggester:
    def __init__(self, threshold=5):
        self.threshold = threshold

    def check_and_suggest(self, extension_name):
        """Check if optimization should be suggested."""
        aggregator = FeedbackAggregator(Path.cwd())
        pending = aggregator.get_pending(extension_name, "999.0.0", "")  # Get all pending

        if len(pending) >= self.threshold:
            return {
                "suggest": True,
                "pending_count": len(pending),
                "message": f"Found {len(pending)} pending feedback items for {extension_name}. "
                          f"Consider running: /forge:improve ./{extension_name}"
            }

        return {"suggest": False}
```

## Optimization Session Logging

Record each optimization session for audit:

```python
class SessionLogger:
    def __init__(self, project_root):
        self.sessions_dir = project_root / ".claude/eitri/optimization/sessions"

    def log_session(self, extension, from_version, to_version, feedback_considered, analysis, approved):
        """Log an optimization session."""
        self.sessions_dir.mkdir(parents=True, exist_ok=True)

        session_id = f"opt-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
        session_file = self.sessions_dir / f"{session_id}.json"

        session = {
            "session_id": session_id,
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "extension": extension["name"],
            "from_version": from_version,
            "to_version": to_version,
            "feedback_considered": [
                {"id": f["id"], "status": "applied" if approved else "skipped"}
                for f in feedback_considered
            ],
            "llm_analysis": {
                "identified_gaps": analysis.get("gaps", []),
                "proposed_changes": analysis.get("changes", []),
                "confidence": analysis.get("confidence", 0)
            },
            "user_approved": approved
        }

        session_file.write_text(json.dumps(session, indent=2))
        return session_id
```

## Merge Conflict Resolution

When optimizing on top of diverged versions:

```python
class ConflictResolver:
    def detect_conflict(self, extension_name, local_version):
        """Check if remote has a different version."""
        # In practice, this would check git remote
        # Simplified: check version manifest against expected parent
        manifest_file = Path(f".claude/eitri/optimization/versions/{extension_name}.json")
        if not manifest_file.exists():
            return None

        manifest = json.loads(manifest_file.read_text())
        current = manifest["current_version"]

        if current != local_version:
            return {
                "conflict": True,
                "local_version": local_version,
                "remote_version": current,
                "action": "merge"
            }

        return None

    def resolve_with_merge(self, extension, pending_feedback):
        """Resolve by applying pending feedback to latest version."""
        # Load latest version
        loader = ExtensionLoader()
        latest = loader.load(extension["path"])

        # Filter feedback that wasn't already applied
        manifest_file = Path(f".claude/eitri/optimization/versions/{extension['name']}.json")
        manifest = json.loads(manifest_file.read_text())

        applied_ids = set()
        for v in manifest.get("versions", []):
            applied_ids.update(v.get("feedback_applied", []))

        unresolved = [f for f in pending_feedback if f["id"] not in applied_ids]

        return latest, unresolved
```

## Storage Locations

### Project Level (Git-tracked)

```
.claude/eitri/
├── optimization/
│   ├── versions/           # Version manifests (tracked)
│   │   ├── code-reviewer.json
│   │   └── eitri.json
│   └── prompts/            # Archived prompts (tracked)
│       ├── code-reviewer/
│       │   ├── 1.0.0.md
│       │   └── 1.1.0.md
│       └── eitri/
│           └── skill-generator/
│               └── 1.0.0.md
└── learning/
    └── team-feedback.jsonl  # Team issue discoveries (tracked)
```

### Session Level (Optional tracking)

```
.claude/eitri/optimization/
└── sessions/               # Optimization session logs (opt-in)
    └── opt-20251230-001.json
```

### User Level (Never tracked)

```
~/.claude/eitri/
└── learning/
    ├── feedback-log.jsonl     # Personal feedback
    ├── profile.json           # Personal profile
    └── weight-adjustments.json # Personal weights
```

## Command Interface

See `commands/improve.md` for the full `/forge:improve` command specification.
