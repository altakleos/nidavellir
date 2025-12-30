---
name: pre-commit-validator-template
type: template
category: hooks
description: Template for creating pre-commit validation hooks
---

# Pre-Commit Validator Hook Template

## Template Metadata

```yaml
name: pre-commit-validator
type: hook
event: PreToolCall
matcher: Edit|Write
complexity: simple
```

## Generated Hook Script

```bash
#!/bin/bash
# Hook: {{name | default: "pre-commit-validator"}}
# Event: PreToolCall
# Matcher: Edit|Write
# Description: {{description | default: "Validates file edits before they happen"}}

# Read input from Claude Code
INPUT=$(cat)

# Extract file path being modified
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Exit early if no file path
if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

{{#if check_protected}}
# ======================
# Protected Files Check
# ======================
PROTECTED_PATTERNS=(
    "*.lock"
    "*.min.js"
    "*.min.css"
    ".env"
    ".env.*"
    "package-lock.json"
    "yarn.lock"
    "Cargo.lock"
    "poetry.lock"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == $pattern ]]; then
        echo "Error: Cannot modify protected file: $FILE_PATH" >&2
        echo "Protected patterns: ${PROTECTED_PATTERNS[*]}" >&2
        exit 1
    fi
done
{{/if}}

{{#if check_secrets}}
# ======================
# Secrets Detection
# ======================
NEW_CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // .tool_input.content // empty')

if [[ -n "$NEW_CONTENT" ]]; then
    # Check for common secret patterns
    SECRET_PATTERNS=(
        "password\s*=\s*['\"][^'\"]+['\"]"
        "api[_-]?key\s*=\s*['\"][^'\"]+['\"]"
        "secret\s*=\s*['\"][^'\"]+['\"]"
        "token\s*=\s*['\"][^'\"]+['\"]"
        "AWS_SECRET"
        "PRIVATE_KEY"
        "-----BEGIN.*PRIVATE KEY-----"
    )

    for pattern in "${SECRET_PATTERNS[@]}"; do
        if echo "$NEW_CONTENT" | grep -qiE "$pattern"; then
            echo "Warning: Possible secret detected in content" >&2
            echo "Pattern matched: $pattern" >&2
            echo "Please use environment variables instead" >&2
            # Warning only, don't block (change to exit 1 to block)
        fi
    done
fi
{{/if}}

{{#if check_size}}
# ======================
# File Size Check
# ======================
MAX_SIZE={{max_file_size | default: 1048576}}  # 1MB default

if [[ -f "$FILE_PATH" ]]; then
    CURRENT_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
    if [[ "$CURRENT_SIZE" -gt "$MAX_SIZE" ]]; then
        echo "Warning: File $FILE_PATH is large ($(($CURRENT_SIZE / 1024))KB)" >&2
    fi
fi
{{/if}}

{{#if backup}}
# ======================
# Backup Before Edit
# ======================
if [[ -f "$FILE_PATH" ]]; then
    BACKUP_DIR=".claude/backups/$(date +%Y-%m-%d)"
    mkdir -p "$BACKUP_DIR"
    BACKUP_FILE="$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).bak"
    cp "$FILE_PATH" "$BACKUP_FILE"
    echo "Backup created: $BACKUP_FILE" >&2
fi
{{/if}}

# All checks passed
exit 0
```

## Generated Settings Configuration

```json
{
  "hooks": {
    "PreToolCall": [
      {
        "matcher": "{{matcher | default: 'Edit|Write'}}",
        "hooks": [
          ".claude/hooks/{{name | default: 'pre-commit-validator'}}.sh"
        ]
      }
    ]
  }
}
```

## Customization Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `name` | Hook script name | `pre-commit-validator` |
| `matcher` | Tool matcher regex | `Edit\|Write` |
| `check_protected` | Check protected files | true |
| `check_secrets` | Detect secrets | true |
| `check_size` | Check file sizes | false |
| `backup` | Create backups | true |
| `max_file_size` | Max file size (bytes) | 1048576 |

## Usage

```
/forge:template pre-commit-validator
/forge:template pre-commit-validator --backup --check-secrets
/forge:template pre-commit-validator --name my-validator --no-backup
```

## Installation

After generation:

```bash
chmod +x .claude/hooks/pre-commit-validator.sh
```

The settings.json merge happens automatically during `/forge:install`.
