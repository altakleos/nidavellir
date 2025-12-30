---
name: feedback
description: Provide feedback on Eitri-generated extensions to improve future recommendations
---

# Feedback Command

Provide feedback on Eitri-generated extensions to improve recommendation accuracy. All learning data is stored locally on your filesystem.

## Usage

```
/forge:feedback [options]
```

## Options

| Option | Description | Example |
|--------|-------------|---------|
| `--extension=<name>` | Target extension for feedback | `--extension=code-reviewer` |
| `--success` | Mark extension as successful | `/forge:feedback --success` |
| `--issue` | Report an issue with extension | `/forge:feedback --issue` |
| `--override` | Record a type recommendation override | `/forge:feedback --override` |
| `--suggest` | Suggest an improvement | `/forge:feedback --suggest` |
| `--stats` | Show learning statistics | `/forge:feedback --stats` |
| `--reset` | Reset personal learning data | `/forge:feedback --reset` |
| `--export` | Export learning data | `/forge:feedback --export` |

## Feedback Types

### Success Feedback

Mark an extension as working well:

```
/forge:feedback --success --extension=code-reviewer
```

This records:
- Extension name and type
- Creation context (domain, complexity)
- Decision that led to this type
- Success indicator

**Effect:** Increases confidence in similar future recommendations.

### Issue Feedback

Report a problem with an extension:

```
/forge:feedback --issue --extension=test-runner
```

You'll be asked to describe:
- What went wrong
- Expected vs actual behavior
- Severity (minor, moderate, critical)

**Effect:** Adjusts patterns to avoid similar issues.

### Override Recording

When you disagreed with Eitri's recommendation and chose differently:

```
/forge:feedback --override
```

Records:
- What Eitri suggested (e.g., "agent")
- What you chose instead (e.g., "skill")
- Why you overrode (optional context)

**Effect:** Adjusts decision weights for similar contexts.

### Improvement Suggestions

Suggest ways to improve Eitri:

```
/forge:feedback --suggest
```

You can suggest:
- New patterns to recognize
- Better defaults for your domain
- Missing features
- Documentation improvements

**Effect:** Adds to suggestion queue for future consideration.

## Learning Statistics

View your learning profile:

```
/forge:feedback --stats
```

Output:

```
Eitri Learning Statistics
=========================

Session Information:
  Learning started: 2025-01-15
  Extensions created: 42
  Feedback provided: 28

Type Distribution:
  Skills:  12 (29%)
  Agents:  18 (43%)
  Suites:   8 (19%)
  Hybrids:  4 (9%)

Decision Accuracy:
  Recommendations accepted: 85%
  Overrides recorded: 6
  Post-creation success: 92%

Your Preferences:
  Preferred complexity: intermediate
  Common domains: development, devops
  Override patterns:
    - When "tight coupling" detected → prefer skill (3 times)
    - When "reusable formatter" → prefer agent (2 times)

Weight Adjustments:
  coupling_weight: +2 (from 10 to 12)
  reusability_weight: -1 (from 8 to 7)

Confidence Impact:
  Your feedback has improved accuracy by ~8%
```

## Reset Learning Data

Clear all personal learning data:

```
/forge:feedback --reset
```

**Warning:** This removes:
- All recorded feedback
- Weight adjustments
- Preference patterns
- Override history

Confirmation required before reset.

## Export Learning Data

Export your learning data for backup or sharing:

```
/forge:feedback --export
```

Exports to: `~/.claude/eitri/learning/export-YYYY-MM-DD.json`

## Data Storage Locations

All learning data is stored locally:

### User-Level Learning
**Location:** `~/.claude/eitri/learning/`

Files:
- `profile.json` - Your learning profile
- `feedback-log.jsonl` - Append-only feedback log
- `weight-adjustments.json` - Decision weight modifications
- `preferences.json` - Detected preferences

### Project-Level Learning
**Location:** `.claude/eitri/learning/`

Files:
- `project-patterns.json` - Project-specific patterns
- `team-preferences.json` - Team preference overrides

## Learning Algorithm

### How Feedback Improves Recommendations

1. **Override Tracking:**
   ```
   When you override a recommendation:
   - Record context dimensions (coupling, reusability, etc.)
   - Note the suggested vs chosen type
   - After 3+ consistent overrides, adjust weights
   ```

2. **Weight Adjustment:**
   ```python
   # Example: User keeps choosing skills when we suggest agents
   if override_pattern.count >= 3:
       if override_pattern.context == "tight_coupling":
           weights["coupling"] += 2  # Increase coupling weight
           # Now tight coupling signals skill more strongly
   ```

3. **Confidence Calibration:**
   ```python
   # Track prediction accuracy
   if recommendation_accepted:
       accuracy_history.append(True)
   else:
       accuracy_history.append(False)

   # Adjust confidence threshold
   if recent_accuracy < 0.7:
       confidence_threshold += 0.05  # More conservative
   ```

### Weight Adjustment Limits

To prevent over-fitting:
- Maximum adjustment: ±30% from defaults
- Minimum sample size: 3 consistent signals
- Decay factor: Old feedback matters less over time

## Examples

### Complete Feedback Workflow

```
# 1. Create an extension
/forge
... [conversation and creation] ...

# 2. Extension works well
/forge:feedback --success --extension=my-agent

# 3. Later, you disagree with a recommendation
/forge
Eitri: I recommend creating an agent...
You: Actually, I want a skill for this

/forge:feedback --override
# Records: suggested=agent, chosen=skill, context=current

# 4. Check your stats
/forge:feedback --stats

# 5. Report an issue
/forge:feedback --issue --extension=my-agent
# Describe what went wrong

# 6. Suggest improvement
/forge:feedback --suggest
# Share your ideas
```

### Domain-Specific Learning

```
# Work mostly in DevOps
/forge
... create 5 DevOps extensions ...

# Your stats will show:
/forge:feedback --stats

Domain Expertise Detected:
  devops: 85% of extensions
  Recommended defaults: agent suites for CI/CD workflows
  Learned: prefer hooks for pipeline events
```

## Privacy & Data Control

### What's Collected

- Extension names and types you create
- Feedback you explicitly provide
- Override patterns (no conversation content)
- Success/issue indicators

### What's NOT Collected

- Your code or file contents
- Conversation history
- Personal information
- Network telemetry (all local)

### Data Locations

All data stays on your machine:
- User: `~/.claude/eitri/learning/`
- Project: `.claude/eitri/learning/`

### Full Control

- View: `/forge:feedback --stats`
- Export: `/forge:feedback --export`
- Delete: `/forge:feedback --reset`

## Integration with Decision Framework

When making recommendations, Eitri:

1. Loads your learning profile (if exists)
2. Applies weight adjustments
3. Considers your override patterns
4. Factors in domain preferences
5. Shows personalization indicator

```
Extension Type Analysis:
┌─────────────────────────────────────────┐
│ Factor              │ Skill │ Agent │
├─────────────────────┼───────┼───────┤
│ Reusability         │   2   │   8   │
│ Coupling level      │  12*  │   4   │ ← *Personalized
├─────────────────────┼───────┼───────┤
│ TOTAL              │  28   │  24   │
└─────────────────────────────────────────┘

Recommendation: Skill
Confidence: 82%
[📊 Personalized based on your feedback]
```

## Troubleshooting

### Feedback Not Affecting Recommendations

**Issue:** Weight adjustments not showing

**Solutions:**
1. Minimum 3 consistent signals needed
2. Check stats: `/forge:feedback --stats`
3. Adjustments are gradual, not immediate

### Learning Data Corrupted

**Issue:** Error reading learning files

**Solutions:**
1. Export what you can: `/forge:feedback --export`
2. Reset and start fresh: `/forge:feedback --reset`
3. Remove corrupted files manually from `~/.claude/eitri/learning/`

### Want to Share Learning Data

**Issue:** Share patterns with team

**Solutions:**
1. Export: `/forge:feedback --export`
2. Share the JSON file
3. Team members can import (future feature)
4. Or commit project-level patterns to git

## Related Commands

| Command | Purpose |
|---------|---------|
| `/forge` | Create extensions (collects implicit feedback) |
| `/forge:validate` | Validate extensions |
| `/forge:upgrade` | Upgrade extensions |
| `/forge:browse` | Browse templates |

## Philosophy

The learning system embraces:

1. **Local-First:** All data on your machine
2. **Explicit Consent:** Only learns from feedback you provide
3. **Transparent:** See exactly what's learned (`--stats`)
4. **Reversible:** Reset anytime (`--reset`)
5. **Gradual:** Small adjustments, not dramatic changes
6. **Privacy-Preserving:** No network, no telemetry
