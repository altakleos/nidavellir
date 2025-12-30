# Learning Engine Module

This module handles personalized learning from user feedback to improve Eitri's recommendations over time. All learning is local and privacy-preserving.

## Overview

The learning engine:
1. Collects feedback from user interactions
2. Detects patterns in user preferences
3. Adjusts decision weights based on overrides
4. Improves recommendation accuracy over time

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Learning Engine                    │
├─────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │
│  │  Feedback   │  │   Pattern   │  │   Weight    │ │
│  │  Collector  │  │  Detector   │  │  Adjuster   │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘ │
│         │                │                │        │
│         ▼                ▼                ▼        │
│  ┌─────────────────────────────────────────────┐   │
│  │              Storage Layer                   │   │
│  │  ~/.claude/eitri/learning/                  │   │
│  │  .claude/eitri/learning/                    │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## Data Structures

### User Learning Profile

```json
{
  "version": "1.0.0",
  "created": "2025-01-15T10:00:00Z",
  "last_updated": "2025-01-30T14:30:00Z",
  "user_id": "anonymous-hash-abc123",

  "statistics": {
    "sessions": 42,
    "extensions_created": 28,
    "feedback_provided": 15,
    "recommendations_accepted": 24,
    "overrides_recorded": 4
  },

  "type_distribution": {
    "skills": 12,
    "agents": 10,
    "suites": 4,
    "hybrids": 2,
    "hooks": 0,
    "mcp": 0
  },

  "domain_experience": {
    "development": 15,
    "devops": 8,
    "data": 3,
    "finance": 2
  },

  "preferences": {
    "default_complexity": "intermediate",
    "prefer_agents_for_reusable": true,
    "prefer_skills_for_custom": true
  }
}
```

### Feedback Log Entry

```json
{
  "timestamp": "2025-01-30T14:30:00Z",
  "type": "success|issue|override|suggest",
  "extension_name": "code-reviewer",
  "extension_type": "agent",
  "context": {
    "domain": "development",
    "complexity": "simple",
    "reusability": "high",
    "coupling": "low"
  },
  "details": {
    "success": true,
    "satisfaction": 0.9
  }
}
```

### Weight Adjustments

```json
{
  "version": "1.0.0",
  "base_weights": {
    "reusability": 8,
    "invocation_pattern": 9,
    "coupling": 10,
    "context_dependency": 9,
    "tool_safety": 8,
    "multiple_roles": 9,
    "complexity": 6
  },
  "adjustments": {
    "coupling": {
      "delta": 2,
      "reason": "User prefers skills for tightly coupled scenarios",
      "sample_size": 4,
      "last_updated": "2025-01-28T10:00:00Z"
    },
    "reusability": {
      "delta": -1,
      "reason": "User sometimes prefers skills even for reusable tasks",
      "sample_size": 3,
      "last_updated": "2025-01-25T15:00:00Z"
    }
  },
  "effective_weights": {
    "reusability": 7,
    "invocation_pattern": 9,
    "coupling": 12,
    "context_dependency": 9,
    "tool_safety": 8,
    "multiple_roles": 9,
    "complexity": 6
  }
}
```

### Override Pattern

```json
{
  "id": "override-001",
  "suggested": "agent",
  "chosen": "skill",
  "context_signals": {
    "coupling": "high",
    "reusability": "medium",
    "complexity": "intermediate"
  },
  "count": 3,
  "first_seen": "2025-01-15T10:00:00Z",
  "last_seen": "2025-01-28T14:00:00Z",
  "weight_impact": {
    "dimension": "coupling",
    "adjustment": 2
  }
}
```

## Learning Algorithms

### Feedback Collection

```python
class FeedbackCollector:
    def __init__(self, storage_path):
        self.storage_path = storage_path
        self.log_file = storage_path / "feedback-log.jsonl"

    def record_feedback(self, feedback_type, extension_name, context, details):
        """Record a feedback entry to the append-only log."""
        entry = {
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "type": feedback_type,
            "extension_name": extension_name,
            "extension_type": self._get_extension_type(extension_name),
            "context": context,
            "details": details
        }

        with open(self.log_file, "a") as f:
            f.write(json.dumps(entry) + "\n")

        # Trigger pattern detection
        self.pattern_detector.analyze_recent(entry)

    def record_success(self, extension_name):
        """Record that an extension worked well."""
        context = self._get_creation_context(extension_name)
        self.record_feedback("success", extension_name, context, {
            "success": True,
            "satisfaction": 1.0
        })

    def record_issue(self, extension_name, description, severity):
        """Record an issue with an extension."""
        context = self._get_creation_context(extension_name)
        self.record_feedback("issue", extension_name, context, {
            "success": False,
            "description": description,
            "severity": severity
        })

    def record_override(self, suggested, chosen, reason=None):
        """Record when user overrode a recommendation."""
        context = self._get_current_context()
        self.record_feedback("override", None, context, {
            "suggested": suggested,
            "chosen": chosen,
            "reason": reason
        })
```

### Pattern Detection

```python
class PatternDetector:
    def __init__(self, storage_path, min_samples=3):
        self.storage_path = storage_path
        self.min_samples = min_samples
        self.patterns_file = storage_path / "detected-patterns.json"

    def analyze_recent(self, new_entry):
        """Analyze recent feedback for patterns."""
        if new_entry["type"] != "override":
            return

        # Load existing overrides
        overrides = self._load_overrides()
        overrides.append(new_entry)

        # Group by context signature
        groups = self._group_by_context(overrides)

        # Check for emerging patterns
        for context_sig, entries in groups.items():
            if len(entries) >= self.min_samples:
                self._create_or_update_pattern(context_sig, entries)

    def _group_by_context(self, overrides):
        """Group overrides by similar context."""
        groups = defaultdict(list)

        for override in overrides:
            # Create context signature
            ctx = override["context"]
            sig = self._context_signature(ctx)
            groups[sig].append(override)

        return groups

    def _context_signature(self, context):
        """Create a hashable signature from context."""
        # Key dimensions that matter for patterns
        key_dims = ["coupling", "reusability", "complexity"]
        return tuple(context.get(d, "unknown") for d in key_dims)

    def _create_or_update_pattern(self, context_sig, entries):
        """Create or update a detected pattern."""
        patterns = self._load_patterns()

        # Find most common override
        suggested_to_chosen = Counter(
            (e["details"]["suggested"], e["details"]["chosen"])
            for e in entries
        )
        most_common = suggested_to_chosen.most_common(1)[0]

        pattern = {
            "context_signature": context_sig,
            "suggested": most_common[0][0],
            "chosen": most_common[0][1],
            "count": most_common[1],
            "confidence": most_common[1] / len(entries),
            "last_updated": datetime.utcnow().isoformat() + "Z"
        }

        # Update patterns
        patterns[str(context_sig)] = pattern
        self._save_patterns(patterns)

        # Trigger weight adjustment if confident
        if pattern["confidence"] >= 0.7:
            self.weight_adjuster.apply_pattern(pattern)
```

### Weight Adjustment

```python
class WeightAdjuster:
    def __init__(self, storage_path, max_adjustment=0.3):
        self.storage_path = storage_path
        self.max_adjustment = max_adjustment  # 30% max
        self.weights_file = storage_path / "weight-adjustments.json"
        self.base_weights = {
            "reusability": 8,
            "invocation_pattern": 9,
            "coupling": 10,
            "context_dependency": 9,
            "tool_safety": 8,
            "multiple_roles": 9,
            "complexity": 6
        }

    def apply_pattern(self, pattern):
        """Apply weight adjustment based on detected pattern."""
        adjustments = self._load_adjustments()

        # Determine which dimension to adjust
        dimension = self._identify_dimension(pattern)
        if not dimension:
            return

        # Calculate adjustment
        current = adjustments.get(dimension, {"delta": 0, "sample_size": 0})
        new_delta = self._calculate_delta(pattern, current)

        # Apply limits
        base = self.base_weights[dimension]
        max_delta = base * self.max_adjustment
        new_delta = max(-max_delta, min(max_delta, new_delta))

        # Update adjustment
        adjustments[dimension] = {
            "delta": new_delta,
            "reason": self._generate_reason(pattern),
            "sample_size": pattern["count"],
            "last_updated": datetime.utcnow().isoformat() + "Z"
        }

        self._save_adjustments(adjustments)

    def _identify_dimension(self, pattern):
        """Identify which dimension the pattern affects."""
        context_sig = pattern["context_signature"]

        # Map context signals to dimensions
        signal_to_dimension = {
            "coupling": "coupling",
            "reusability": "reusability",
            "complexity": "complexity"
        }

        # Find the strongest signal in the context
        for i, (signal, value) in enumerate(zip(
            ["coupling", "reusability", "complexity"],
            context_sig
        )):
            if value in ["high", "low"]:  # Strong signal
                return signal_to_dimension.get(signal)

        return None

    def _calculate_delta(self, pattern, current):
        """Calculate new delta based on pattern."""
        suggested = pattern["suggested"]
        chosen = pattern["chosen"]

        # If user chose skill over agent when coupling was high
        # → increase coupling weight (makes skill more likely)
        if chosen == "skill" and suggested in ["agent", "suite"]:
            return current["delta"] + 1
        elif chosen in ["agent", "suite"] and suggested == "skill":
            return current["delta"] - 1

        return current["delta"]

    def get_effective_weights(self):
        """Get current effective weights with adjustments."""
        adjustments = self._load_adjustments()
        effective = dict(self.base_weights)

        for dimension, adj in adjustments.items():
            if dimension in effective:
                effective[dimension] = self.base_weights[dimension] + adj["delta"]

        return effective
```

## Storage Layer

### File Structure

```
~/.claude/eitri/learning/
├── profile.json           # User profile and statistics
├── feedback-log.jsonl     # Append-only feedback log
├── weight-adjustments.json # Weight modifications
├── detected-patterns.json  # Detected preference patterns
├── preferences.json        # Explicit user preferences
└── export-YYYY-MM-DD.json  # Exported snapshots

.claude/eitri/learning/
├── project-patterns.json   # Project-specific patterns
└── team-preferences.json   # Team preference overrides
```

### File Operations

```python
class LearningStorage:
    def __init__(self):
        self.user_path = Path.home() / ".claude" / "eitri" / "learning"
        self.project_path = Path.cwd() / ".claude" / "eitri" / "learning"

    def ensure_directories(self):
        """Create learning directories if they don't exist."""
        self.user_path.mkdir(parents=True, exist_ok=True)
        # Project path created on demand

    def load_profile(self):
        """Load user learning profile."""
        profile_file = self.user_path / "profile.json"
        if profile_file.exists():
            return json.loads(profile_file.read_text())
        return self._create_default_profile()

    def save_profile(self, profile):
        """Save user learning profile."""
        profile["last_updated"] = datetime.utcnow().isoformat() + "Z"
        profile_file = self.user_path / "profile.json"
        profile_file.write_text(json.dumps(profile, indent=2))

    def append_feedback(self, entry):
        """Append feedback to log (append-only)."""
        log_file = self.user_path / "feedback-log.jsonl"
        with open(log_file, "a") as f:
            f.write(json.dumps(entry) + "\n")

    def export_all(self, output_path=None):
        """Export all learning data to JSON."""
        if output_path is None:
            date = datetime.now().strftime("%Y-%m-%d")
            output_path = self.user_path / f"export-{date}.json"

        export_data = {
            "exported_at": datetime.utcnow().isoformat() + "Z",
            "profile": self.load_profile(),
            "weights": self._load_json("weight-adjustments.json"),
            "patterns": self._load_json("detected-patterns.json"),
            "preferences": self._load_json("preferences.json"),
            "feedback_count": self._count_feedback()
        }

        output_path.write_text(json.dumps(export_data, indent=2))
        return output_path

    def reset(self):
        """Reset all learning data."""
        files_to_remove = [
            "profile.json",
            "feedback-log.jsonl",
            "weight-adjustments.json",
            "detected-patterns.json",
            "preferences.json"
        ]

        for filename in files_to_remove:
            file_path = self.user_path / filename
            if file_path.exists():
                file_path.unlink()
```

## Integration Points

### With Decision Framework

```python
def get_recommendation(discovery_result):
    """Get recommendation with personalized weights."""

    # Load learning engine
    learning = LearningEngine()

    # Get personalized weights
    weights = learning.get_effective_weights()

    # Calculate scores with personalized weights
    scores = calculate_scores(discovery_result, weights)

    # Check for matching override patterns
    pattern_match = learning.find_matching_pattern(discovery_result)
    if pattern_match and pattern_match["confidence"] > 0.8:
        # Apply pattern override
        scores = apply_pattern_boost(scores, pattern_match)

    # Get recommendation
    recommendation = max(scores, key=scores.get)
    confidence = calculate_confidence(scores, learning)

    # Check if personalized
    is_personalized = learning.has_adjustments()

    return {
        "type": recommendation,
        "confidence": confidence,
        "scores": scores,
        "personalized": is_personalized
    }
```

### With Feedback Command

```python
def handle_feedback_command(args):
    """Handle /forge:feedback command."""
    learning = LearningEngine()

    if args.stats:
        return learning.get_statistics()

    if args.reset:
        if confirm_reset():
            learning.reset()
            return "Learning data reset successfully."
        return "Reset cancelled."

    if args.export:
        path = learning.export()
        return f"Learning data exported to: {path}"

    if args.success:
        learning.record_success(args.extension)
        return "Success feedback recorded."

    if args.issue:
        description = prompt_issue_description()
        severity = prompt_severity()
        learning.record_issue(args.extension, description, severity)
        return "Issue feedback recorded."

    if args.override:
        suggested = prompt_what_was_suggested()
        chosen = prompt_what_you_chose()
        reason = prompt_why_optional()
        learning.record_override(suggested, chosen, reason)
        return "Override recorded."
```

## Statistics Generation

```python
def generate_statistics(profile, weights, patterns):
    """Generate learning statistics for display."""

    stats = {
        "session_info": {
            "learning_started": profile["created"],
            "extensions_created": profile["statistics"]["extensions_created"],
            "feedback_provided": profile["statistics"]["feedback_provided"]
        },
        "type_distribution": profile["type_distribution"],
        "decision_accuracy": {
            "accepted": profile["statistics"]["recommendations_accepted"],
            "overrides": profile["statistics"]["overrides_recorded"],
            "acceptance_rate": (
                profile["statistics"]["recommendations_accepted"] /
                max(profile["statistics"]["extensions_created"], 1)
            )
        },
        "weight_adjustments": weights.get("adjustments", {}),
        "detected_patterns": len(patterns),
        "domain_expertise": profile.get("domain_experience", {})
    }

    return stats
```

## Privacy Considerations

### Data Minimization

- Only store what's needed for learning
- No code content or file contents
- No conversation history
- Anonymized user ID (hash, not identifiable)

### User Control

- View: `/forge:feedback --stats`
- Export: `/forge:feedback --export`
- Delete: `/forge:feedback --reset`
- All operations are local

### No Network

- All data stored locally
- No telemetry or analytics
- No external API calls
- Works completely offline

## Future Enhancements

Potential improvements for future versions:

1. **Team Learning Sharing:**
   - Export/import learning profiles
   - Merge team patterns
   - Project-level defaults

2. **Advanced Patterns:**
   - Multi-dimensional pattern matching
   - Temporal patterns (time-of-day preferences)
   - Framework-specific learning

3. **Active Learning:**
   - Proactive feedback requests
   - A/B testing for recommendations
   - Confidence-based prompting

4. **Visualization:**
   - Learning curve graphs
   - Decision tree visualization
   - Pattern network maps
