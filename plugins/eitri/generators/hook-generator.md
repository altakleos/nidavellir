---
name: hook-generator
type: module
description: Creates event-driven hooks for Claude Code automation workflows
---

# Hook Generator - Event-Driven Extension Creation

This module creates hooks - event-driven automations that execute shell commands in response to Claude Code events. Hooks provide powerful integration points without modifying Claude Code's core behavior.

## When This Generator is Used

The hook generator is invoked when the decision framework detects:
- Event-driven automation needs ("when X happens, do Y")
- Shell command execution requirements
- Pre/post processing workflows
- Notification or logging requirements
- Session lifecycle management

## Understanding Claude Code Hooks

### Event Types

Claude Code supports these hook events:

| Event | Trigger | Common Use Cases |
|-------|---------|-----------------|
| `PreToolCall` | Before any tool executes | Validation, logging, backup |
| `PostToolCall` | After any tool completes | Post-processing, notifications |
| `Notification` | Claude sends notification | Custom alerts, external integrations |
| `Stop` | Main agent stops | Cleanup, final reports |
| `SubagentStop` | Subagent completes | Coordination, aggregation |
| `SessionStart` | New session begins | Setup, context loading |
| `SessionEnd` | Session closes | Cleanup, state persistence |

### Hook Configuration Structure

Hooks are configured in `.claude/settings.json` or `.claude/settings.local.json`:

```json
{
  "hooks": {
    "PreToolCall": [
      {
        "matcher": "Edit",
        "hooks": [
          "backup-before-edit.sh"
        ]
      }
    ],
    "PostToolCall": [
      {
        "matcher": "Bash",
        "hooks": [
          "log-bash-commands.sh"
        ]
      }
    ],
    "Notification": [
      {
        "matcher": ".*",
        "hooks": [
          "send-to-slack.sh"
        ]
      }
    ]
  }
}
```

## Hook Generation Framework

### Phase 1: Event Analysis

Determine which events are needed based on user requirements:

**Event Selection Logic:**

```python
def select_events(requirements):
    events = []

    if requirements.needs_validation:
        events.append("PreToolCall")

    if requirements.needs_postprocessing:
        events.append("PostToolCall")

    if requirements.needs_alerts:
        events.append("Notification")

    if requirements.needs_cleanup:
        events.extend(["Stop", "SessionEnd"])

    if requirements.needs_setup:
        events.append("SessionStart")

    if requirements.coordinates_agents:
        events.append("SubagentStop")

    return events
```

**Matcher Pattern Selection:**

- Specific tool: `"Edit"`, `"Bash"`, `"Write"`
- Multiple tools: `"Edit|Write"` (regex pattern)
- All tools: `".*"`
- Pattern match: `".*Test.*"` (tools with "Test" in name)

### Phase 2: Script Generation

Create shell scripts that implement the hook logic:

**Script Template:**

```bash
#!/bin/bash
# Hook: [hook-name]
# Event: [event-type]
# Matcher: [pattern]
# Description: [what this hook does]

# Claude Code passes context via stdin as JSON
# Parse the input to get tool name, parameters, result, etc.
INPUT=$(cat)

# Extract relevant fields (example for PostToolCall)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_RESULT=$(echo "$INPUT" | jq -r '.tool_result // empty')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

# Your hook logic here
# ...

# Exit codes:
# 0 = success, continue execution
# non-zero = failure (for PreToolCall, blocks the tool)
exit 0
```

**Input Context by Event:**

| Event | Available Fields |
|-------|-----------------|
| `PreToolCall` | `tool_name`, `tool_input`, `session_id` |
| `PostToolCall` | `tool_name`, `tool_input`, `tool_result`, `session_id` |
| `Notification` | `message`, `level`, `session_id` |
| `Stop` | `reason`, `session_id`, `exit_code` |
| `SubagentStop` | `agent_id`, `result`, `session_id` |
| `SessionStart` | `session_id`, `working_directory`, `project` |
| `SessionEnd` | `session_id`, `duration`, `tool_calls` |

### Phase 3: Safety Validation

Ensure hooks are safe and don't cause issues:

**Safety Checks:**

```python
def validate_hook_safety(hook_config):
    warnings = []
    errors = []

    # Check for infinite loops
    if hook_config.event == "PreToolCall" and hook_config.calls_claude_tool():
        errors.append("PreToolCall hooks should not call Claude tools (infinite loop risk)")

    # Check for blocking operations
    if hook_config.has_network_calls() and hook_config.event == "PreToolCall":
        warnings.append("Network calls in PreToolCall may slow down operations")

    # Check for proper error handling
    if not hook_config.has_error_handling():
        warnings.append("Hook should handle errors gracefully")

    # Check script permissions
    if not hook_config.script_is_executable():
        errors.append("Hook script must be executable (chmod +x)")

    return errors, warnings
```

**Critical Safety Rules:**

1. **PreToolCall hooks can block** - Exit non-zero to prevent tool execution
2. **Never create infinite loops** - Don't call tools from PreToolCall hooks
3. **Handle timeouts** - Hooks have execution time limits
4. **Fail gracefully** - Hook failures shouldn't break Claude Code
5. **Secure input handling** - Sanitize JSON input before use

### Phase 4: Hook Categories

I generate different types of hooks based on purpose:

#### Validation Hooks (PreToolCall)

```bash
#!/bin/bash
# Validates file edits against project rules

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Check if editing protected files
PROTECTED_PATTERNS=("*.lock" "*.min.js" ".env*")
for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == $pattern ]]; then
        echo "Error: Cannot edit protected file: $FILE_PATH" >&2
        exit 1  # Blocks the edit
    fi
done

exit 0  # Allow the edit
```

#### Logging Hooks (PostToolCall)

```bash
#!/bin/bash
# Logs all Bash commands executed

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
RESULT=$(echo "$INPUT" | jq -r '.tool_result // empty' | head -c 500)
TIMESTAMP=$(date -Iseconds)

# Append to log file
echo "[$TIMESTAMP] $TOOL_NAME: $COMMAND" >> ~/.claude/logs/commands.log
echo "Result: $RESULT" >> ~/.claude/logs/commands.log
echo "---" >> ~/.claude/logs/commands.log

exit 0
```

#### Notification Hooks

```bash
#!/bin/bash
# Sends Claude notifications to Slack

INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r '.message // empty')
LEVEL=$(echo "$INPUT" | jq -r '.level // "info"')

# Send to Slack webhook (example)
if [[ "$LEVEL" == "error" || "$LEVEL" == "warning" ]]; then
    curl -s -X POST "$SLACK_WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "{\"text\": \"[$LEVEL] $MESSAGE\"}" \
        > /dev/null
fi

exit 0
```

#### Session Lifecycle Hooks

```bash
#!/bin/bash
# SessionStart: Load project context

INPUT=$(cat)
PROJECT=$(echo "$INPUT" | jq -r '.project // empty')
WORKING_DIR=$(echo "$INPUT" | jq -r '.working_directory // empty')

# Load project-specific environment
if [[ -f "$WORKING_DIR/.claude-env" ]]; then
    source "$WORKING_DIR/.claude-env"
fi

# Log session start
echo "Session started in $PROJECT at $(date)" >> ~/.claude/logs/sessions.log

exit 0
```

### Phase 5: Configuration Generation

Generate the settings.json configuration:

```json
{
  "hooks": {
    "PreToolCall": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          ".claude/hooks/validate-edit.sh"
        ]
      }
    ],
    "PostToolCall": [
      {
        "matcher": "Bash",
        "hooks": [
          ".claude/hooks/log-commands.sh"
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          ".claude/hooks/session-setup.sh"
        ]
      }
    ]
  }
}
```

### Phase 6: Documentation

Generate usage documentation for each hook:

```markdown
## Hook: validate-edit

**Event:** PreToolCall
**Matcher:** Edit|Write
**Purpose:** Validates file edits against project rules

### What It Does
- Checks if target file is in protected list
- Validates file path is within project boundaries
- Ensures backup exists before major edits

### Configuration
Add to `.claude/settings.json`:
```json
{
  "hooks": {
    "PreToolCall": [
      {
        "matcher": "Edit|Write",
        "hooks": [".claude/hooks/validate-edit.sh"]
      }
    ]
  }
}
```

### Customization
Edit the `PROTECTED_PATTERNS` array in the script to add more protected file patterns.

### Troubleshooting
- If hook blocks unexpectedly, check the stderr output
- Use `exit 0` to allow the operation, `exit 1` to block
```

## Common Hook Patterns

### Pre-Edit Backup

```bash
#!/bin/bash
# Creates backup before file modifications

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -f "$FILE_PATH" ]]; then
    BACKUP_DIR=".claude/backups/$(date +%Y-%m-%d)"
    mkdir -p "$BACKUP_DIR"
    cp "$FILE_PATH" "$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).bak"
fi

exit 0
```

### Command Audit Trail

```bash
#!/bin/bash
# Creates audit trail of all commands

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TOOL_INPUT=$(echo "$INPUT" | jq -c '.tool_input // {}')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

AUDIT_FILE=".claude/audit/$(date +%Y-%m-%d).jsonl"
mkdir -p "$(dirname "$AUDIT_FILE")"

echo "{\"timestamp\":\"$(date -Iseconds)\",\"session\":\"$SESSION_ID\",\"tool\":\"$TOOL_NAME\",\"input\":$TOOL_INPUT}" >> "$AUDIT_FILE"

exit 0
```

### External Notification

```bash
#!/bin/bash
# Notifies external systems of important events

INPUT=$(cat)
EVENT_TYPE="$HOOK_EVENT_TYPE"
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only notify for certain events
case "$TOOL_NAME" in
    Bash|Write|Edit)
        curl -s -X POST "https://your-webhook.example.com/claude-events" \
            -H "Content-Type: application/json" \
            -d "{\"event\":\"$EVENT_TYPE\",\"tool\":\"$TOOL_NAME\"}" \
            > /dev/null 2>&1 &  # Run in background to avoid blocking
        ;;
esac

exit 0
```

## Output Structure

Generate complete hook package:

```
.claude/
├── hooks/
│   ├── validate-edit.sh          # PreToolCall validation
│   ├── log-commands.sh           # PostToolCall logging
│   ├── notify-slack.sh           # Notification integration
│   └── session-setup.sh          # SessionStart setup
├── settings.json                 # Hook configuration
└── README-hooks.md               # Hook documentation
```

## Integration with Other Extension Types

### Hooks + Skills

Skills can reference hooks for validation or post-processing:

```markdown
## Integration

This skill works best with these hooks:
- `validate-edit.sh`: Ensures edits comply with project rules
- `log-commands.sh`: Tracks all operations for audit

Install hooks before using this skill for full functionality.
```

### Hooks + Agents

Agents can trigger notifications via hooks:

```yaml
---
name: deployment-agent
description: Deploys applications with notifications
---
# This agent's deployments trigger the notify-slack.sh hook
```

### Hooks + Suites

Suites can use SubagentStop hooks for coordination:

```bash
#!/bin/bash
# Coordinates multi-agent suite execution

INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // empty')
RESULT=$(echo "$INPUT" | jq -r '.result // empty')

# Track completion for coordination
echo "$AGENT_ID:completed:$(date -Iseconds)" >> ".claude/suite-state.log"

# Trigger next phase if all agents complete
COMPLETED=$(grep -c ":completed:" ".claude/suite-state.log" 2>/dev/null || echo 0)
if [[ "$COMPLETED" -ge 3 ]]; then
    echo "All agents complete, triggering final phase..."
fi

exit 0
```

## Validation Framework

Before generating hooks, validate:

**Configuration Validation:**
- JSON syntax is valid
- Event names are correct
- Matchers are valid regex
- Script paths exist

**Script Validation:**
- Shebang present (`#!/bin/bash`)
- Script is executable
- Handles stdin properly
- Has proper exit codes
- No infinite loop risks

**Security Validation:**
- No hardcoded secrets
- Input sanitization
- Safe file operations
- Proper permissions

## Related Modules

- **Decision Framework**: See `core/decision-framework.md` for when to use hooks
- **Validation**: See `core/validation-framework.md` for validation rules
- **Other Generators**:
  - Skills: `generators/skill-generator.md`
  - Agents: `generators/agent-generator.md`
  - Suites: `generators/suite-coordinator.md`
  - MCP: `generators/mcp-generator.md`

## Success Criteria

A successful hook:
- Triggers reliably on correct events
- Executes quickly without blocking
- Handles errors gracefully
- Provides clear logging/feedback
- Integrates well with workflows
- Follows security best practices
