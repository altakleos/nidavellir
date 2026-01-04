---
name: eitri:improve
description: Optimize extension prompts based on collected feedback
---

# Improve Command

Improve extension prompts using accumulated feedback. This command analyzes pending feedback, proposes prompt improvements, and applies them with proper versioning.

## Usage

```
/forge:improve <extension-path> [options]
```

## Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `extension-path` | Path to extension directory | `./my-agent`, `./plugins/eitri` |

## Options

| Option | Description | Example |
|--------|-------------|---------|
| `--dry-run` | Show proposed changes without applying | `/forge:improve ./my-agent --dry-run` |
| `--feedback-id=<id>` | Apply specific feedback only | `--feedback-id=fb-20251230-001` |
| `--auto` | Skip confirmation (for CI/automation) | `/forge:improve ./my-agent --auto` |
| `--rollback` | Revert to previous version | `/forge:improve ./my-agent --rollback` |
| `--history` | Show optimization history | `/forge:improve ./my-agent --history` |
| `--merge` | Merge pending feedback after remote update | `/forge:improve ./my-agent --merge` |

## Command Flow

### Standard Improvement

```
/forge:improve ./plugins/code-reviewer

Step 1: Load Extension
────────────────────────────────────────────
Loading: ./plugins/code-reviewer/SKILL.md
Current version: 1.1.0 (sha256:b4e9d3f2...)

Step 2: Gather Pending Feedback
────────────────────────────────────────────
Found 3 pending feedback items:
  [fb-001] HIGH: Missed SQL injection (2025-12-28)
  [fb-002] MED:  False positive on sanitized input (2025-12-29)
  [fb-003] LOW:  Verbose output for clean files (2025-12-30)

Step 3: LLM Analysis
────────────────────────────────────────────
Analyzing feedback against current prompt...

Identified improvements:
  1. Add SQL injection pattern: string concatenation in queries
     Confidence: 92%
  2. Reduce false positives: check for sanitization calls
     Confidence: 85%
  3. Suppress verbose output: add summary mode
     Confidence: 78%

Overall Confidence: 87%

Step 4: Proposed Changes
────────────────────────────────────────────
--- SKILL.md (current)
+++ SKILL.md (proposed)
@@ -15,6 +15,12 @@
 ## Security Analysis

+### SQL Injection Detection
+When reviewing database code:
+- Flag string concatenation in SQL queries
+- Check for parameterized query usage
+- Verify input sanitization before query construction

Step 5: Confirmation
────────────────────────────────────────────
Apply these changes? [y/n/edit]: y

✓ Changes applied
  Version: 1.1.0 → 1.2.0
  Feedback marked as applied: fb-001, fb-002, fb-003

To verify improvements work:
  /forge:feedback --verify fb-001
```

### Dry Run

```
/forge:improve ./my-agent --dry-run

[Shows all steps except Step 5]

(Dry run - no changes made)
```

### View History

```
/forge:improve ./plugins/code-reviewer --history

Optimization History: code-reviewer
═══════════════════════════════════════════

Version 1.2.0 (current)
  Created: 2025-12-30T10:00:00Z
  Source: optimization
  Feedback applied: fb-001, fb-002, fb-003
  Summary: Added SQL injection detection, reduced false positives

Version 1.1.0
  Created: 2025-12-15T14:00:00Z
  Source: optimization
  Feedback applied: fb-20251210-001
  Summary: Improved XSS detection in template literals

Version 1.0.0
  Created: 2025-12-01T10:00:00Z
  Source: generated
  Note: Initial generation by Eitri
```

### Rollback

```
/forge:improve ./plugins/code-reviewer --rollback

Available versions:
  1. 1.1.0 (2025-12-15) - Improved XSS detection
  2. 1.0.0 (2025-12-01) - Initial generation

Rollback to version [1/2]: 1

Rolling back to version 1.1.0...
✓ Rollback complete
  Current version: 1.1.0
  Note: Feedback fb-001, fb-002, fb-003 marked as 'reopened'
```

### Merge After Conflict

```
/forge:improve ./my-agent --merge

Conflict detected:
  Local version: 1.1.0
  Remote version: 1.2.0

Fetching latest version (1.2.0)...

Your pending feedback:
  [fb-003] MED: Missing error handling (not yet applied)
  [fb-004] LOW: Verbose logging (not yet applied)

Applying your feedback on top of 1.2.0...

[Standard improvement flow continues]
```

## Self-Improvement

When targeting Eitri itself:

```
/forge:improve ./plugins/eitri

Detected: Eitri self-improvement
Identifying components with pending feedback...

Components with pending feedback:
  1. generators/skill-generator.md (2 items)
  2. core/decision-framework.md (1 item)

Select component to improve [1/2/all]: 1

[Standard improvement flow for selected component]
```

## Behavior

### No Pending Feedback

```
/forge:improve ./my-agent

Step 1: Load Extension
────────────────────────────────────────────
Loading: ./my-agent/SKILL.md
Current version: 1.0.0

Step 2: Gather Pending Feedback
────────────────────────────────────────────
No pending feedback found for my-agent.

Nothing to improve. To provide feedback:
  /forge:feedback --issue --extension=my-agent
```

### Low Confidence

```
/forge:improve ./my-agent

[... earlier steps ...]

Step 3: LLM Analysis
────────────────────────────────────────────
Analyzing feedback against current prompt...

Identified improvements:
  1. Possible change to error handling
     Confidence: 35%

Overall Confidence: 35%

⚠ Low confidence in proposed changes.
  The feedback may be ambiguous or already addressed.

Proceed anyway? [y/n]: n

Improvement cancelled.
Tip: Add more specific feedback or clarify existing items.
```

### Specific Feedback

```
/forge:improve ./my-agent --feedback-id=fb-20251230-001

Applying only: fb-20251230-001

[Standard improvement flow with single feedback item]
```

## Data Flow

```
┌──────────────────┐     ┌────────────────────┐
│ Extension Path   │────→│  Extension Loader  │
└──────────────────┘     └─────────┬──────────┘
                                   │
                                   ▼
┌──────────────────┐     ┌────────────────────┐
│ Feedback Files   │────→│ Feedback Aggregator│
│ (team + personal)│     └─────────┬──────────┘
└──────────────────┘               │
                                   ▼
                         ┌────────────────────┐
                         │  Prompt Improver   │
                         │  (LLM analysis)    │
                         └─────────┬──────────┘
                                   │
                                   ▼
                         ┌────────────────────┐
                         │   User Confirms    │
                         └─────────┬──────────┘
                                   │
                                   ▼
                         ┌────────────────────┐
                         │  Version Manager   │
                         │  (apply + version) │
                         └─────────┬──────────┘
                                   │
                                   ▼
                         ┌────────────────────┐
                         │  Session Logger    │
                         └────────────────────┘
```

## Storage Locations

### Created/Updated Files

| File | Purpose |
|------|---------|
| `.claude/eitri/optimization/versions/{name}.json` | Version manifest |
| `.claude/eitri/optimization/prompts/{name}/{version}.md` | Archived prompts |
| `.claude/eitri/optimization/sessions/opt-*.json` | Session logs (optional) |

### Read Files

| File | Purpose |
|------|---------|
| `{extension}/SKILL.md` or `AGENT.md` | Current prompt |
| `.claude/eitri/learning/team-feedback.jsonl` | Team feedback |
| `~/.claude/eitri/learning/feedback-log.jsonl` | Personal feedback |

## Auto-Suggestion

When pending feedback reaches threshold (default: 5), Eitri suggests optimization:

```
[During any /forge command]

📊 Optimization Suggestion
Found 5 pending feedback items for code-reviewer.
Run: /forge:improve ./plugins/code-reviewer
```

Configure threshold in `.claude/eitri/config.json`:

```json
{
  "optimization": {
    "auto_suggest_threshold": 5
  }
}
```

## Examples

### Basic Improvement

```
/forge:improve ./plugins/my-agent
```

### Preview Without Applying

```
/forge:improve ./plugins/my-agent --dry-run
```

### Improve Specific Issue

```
/forge:improve ./plugins/my-agent --feedback-id=fb-20251230-001
```

### Improve Eitri's Skill Generator

```
/forge:improve ./plugins/eitri
# Then select: generators/skill-generator.md
```

### Rollback After Bad Improvement

```
/forge:improve ./plugins/my-agent --rollback
# Select version to restore
```

### Resolve Team Conflict

```
git pull  # Conflict on version manifest
/forge:improve ./plugins/my-agent --merge
```

## Related Commands

| Command | Purpose |
|---------|---------|
| `/forge:feedback` | Provide feedback on extensions |
| `/forge:feedback --pending` | View pending feedback queue |
| `/forge:feedback --verify` | Verify applied improvements |
| `/forge` | Create new extensions |
| `/forge:validate` | Validate extension structure |

## Troubleshooting

### "No SKILL.md or AGENT.md found"

Ensure the path points to a valid extension directory containing either `SKILL.md` or `AGENT.md`.

### "No pending feedback found"

Feedback may have already been applied or marked as rejected. Check with:
```
/forge:feedback --stats --extension=my-agent
```

### Low Confidence Improvements

The LLM may not understand the feedback. Try:
1. Adding more context to feedback descriptions
2. Including expected vs actual behavior
3. Specifying which section of the prompt needs change

### Merge Conflicts

When multiple team members optimize the same extension:
1. Run `/forge:improve --merge` to apply your feedback on top of remote changes
2. The LLM will skip feedback already addressed in the remote version
