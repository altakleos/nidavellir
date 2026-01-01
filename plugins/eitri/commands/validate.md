---
name: validate
description: Validate Claude Code extensions (skills, agents, plugins) for specification compliance and common issues
---

# Validate Command

This command validates Claude Code extensions against the official specification and checks for common mistakes.

## What It Validates

When you run `/forge:validate`, I check:

1. **SKILL.md Frontmatter**
   - Required fields present (name, description)
   - Field values within limits (name ≤64 chars, description ≤1024 chars)
   - Name format (lowercase, numbers, hyphens only)
   - Valid optional fields (version, allowed-tools, disable-model-invocation, mode)
   - No unsupported fields in frontmatter

2. **Plugin Structure**
   - `.claude-plugin/plugin.json` exists and is valid JSON
   - Required fields present (name, version, description)
   - Commands in correct location (`commands/` not `.claude-plugin/commands/`)
   - Components properly specified

3. **Marketplace Entry**
   - Valid `marketplace.json` structure
   - Version consistency across plugin.json, SKILL.md, and marketplace.json
   - Required fields for marketplace listing

4. **Common Mistakes**
   - Commands in wrong directory
   - Version mismatches
   - Missing git tags for releases
   - Over-broad tool permissions
   - Hardcoded secrets

## How to Use

### Validate Current Directory

```
/forge:validate
```

Validates the extension in the current working directory.

### Validate Specific Path

```
/forge:validate ./plugins/my-extension
```

Validates the extension at the specified path.

### Validate Before Publishing

```
/forge:validate --strict
```

Performs strict validation suitable for marketplace submission.

## Validation Checks

### SKILL.md Frontmatter

```yaml
# VALID
---
name: my-skill
description: A brief description under 1024 characters
version: 1.0.0
allowed-tools:
  - Read
  - Grep
---

# INVALID - name too long, unsupported field
---
name: this-is-a-very-long-name-that-exceeds-the-sixty-four-character-limit
description: Description here
author: Someone  # ERROR: author not allowed in SKILL.md frontmatter
---
```

### Plugin Structure

```
# VALID structure
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   └── my-command.md        # Commands at plugin root
├── SKILL.md                 # Main skill file
└── README.md                # Documentation

# INVALID - commands in wrong location
my-plugin/
├── .claude-plugin/
│   ├── plugin.json
│   └── commands/            # WRONG: commands here won't be discovered
│       └── my-command.md
└── SKILL.md
```

### Version Consistency

All three locations must have matching versions:
- `.claude-plugin/plugin.json` → `"version": "1.0.0"`
- `SKILL.md` frontmatter → `version: 1.0.0`
- `marketplace.json` entry → `"version": "1.0.0"`

## Validation Output

### Success Output

```
Extension Validation: my-skill
============================

FRONTMATTER CHECKS:
✓ name: valid (8 characters)
✓ description: valid (45 characters)
✓ version: valid semver (1.0.0)
✓ allowed-tools: valid (3 tools)
✓ No unsupported fields

STRUCTURE CHECKS:
✓ .claude-plugin/plugin.json exists
✓ plugin.json is valid JSON
✓ Commands in correct location
✓ SKILL.md present

VERSION CHECKS:
✓ All versions match: 1.0.0

SECURITY CHECKS:
✓ No hardcoded secrets detected
✓ Tool permissions appropriate

OVERALL: PASSED ✓
Ready for use or marketplace submission.
```

### Failure Output

```
Extension Validation: problematic-plugin
========================================

FRONTMATTER CHECKS:
✓ name: valid (18 characters)
✗ description: MISSING (required field)
✓ version: valid semver (1.0.0)
⚠ allowed-tools: includes Bash (high-risk)

STRUCTURE CHECKS:
✓ .claude-plugin/plugin.json exists
✗ Commands in WRONG location (.claude-plugin/commands/)
  Move to: ./commands/

VERSION CHECKS:
✗ Version mismatch detected:
  - plugin.json: 1.0.0
  - SKILL.md: 1.0.1
  - marketplace.json: 1.0.0

SECURITY CHECKS:
✗ Possible hardcoded secret in: config.json line 15
⚠ Very broad tool permissions (all tools allowed)

OVERALL: FAILED ✗

Fix 4 errors and review 2 warnings before proceeding.

Errors:
1. Add 'description' to SKILL.md frontmatter
2. Move commands/ from .claude-plugin/ to plugin root
3. Sync versions across all files (recommend: 1.0.1)
4. Remove or secure the hardcoded value in config.json

Warnings:
1. Consider restricting Bash tool access
2. Review if all tools are necessary
```

## Validation Rules

### Frontmatter Fields

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | ≤64 chars, `^[a-z0-9-]+$` |
| `description` | Yes | ≤1024 chars |
| `version` | No | Semantic versioning |
| `allowed-tools` | No | Array of valid tool names |
| `disable-model-invocation` | No | Boolean |
| `mode` | No | Boolean |

### Valid Tool Names

```
Read, Write, Edit, Glob, Grep, Bash, Task,
WebFetch, WebSearch, NotebookEdit, AskUserQuestion, TodoWrite
```

### Plugin.json Required Fields

```json
{
  "name": "plugin-name",      // Required
  "version": "1.0.0",         // Required
  "description": "...",       // Required
  "author": {}                // Recommended
}
```

Note: Component paths (`commands`, `agents`, `skills`, `hooks`, `mcpServers`) are optional top-level fields. Claude Code auto-discovers from default directories if not specified.

### Invalid Fields (Claude Code Rejects)

These fields are NOT valid in plugin.json and will cause installation to fail:

| Invalid Field | Error | Fix |
|---------------|-------|-----|
| `category` | Unrecognized key | Remove from plugin.json (belongs in marketplace.json only) |
| `components` | Unrecognized key | Remove entirely; use specific paths like `commands`, `agents` |
| `data_version` | Unrecognized key | Remove entirely; not a valid field |

The plugin.json schema has `additionalProperties: false` - only documented fields are allowed.

## Common Issues and Fixes

### Issue: Invalid Plugin.json Fields

**Symptom:** Installation fails with "Unrecognized key(s) in object: 'category', 'components', 'data_version'"

**Fix:** Remove invalid fields from plugin.json. Only use fields listed above.

### Issue: Commands Not Discovered

**Symptom:** Slash commands don't appear in Claude Code

**Fix:** Move `commands/` to plugin root:
```bash
mv .claude-plugin/commands ./commands
```

### Issue: Version Mismatch

**Symptom:** Validation shows version inconsistency

**Fix:** Update all three locations:
```bash
# Update plugin.json
jq '.version = "1.0.1"' .claude-plugin/plugin.json > tmp && mv tmp .claude-plugin/plugin.json

# Update SKILL.md frontmatter manually

# Update marketplace.json entry
```

### Issue: Missing Git Tags

**Symptom:** Plugin can't be installed from marketplace

**Fix:** Create and push tags:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### Issue: Hardcoded Secrets

**Symptom:** Validation detects potential secrets

**Fix:** Use environment variables:
```json
// Before (WRONG)
{ "api_key": "sk-12345abcde" }

// After (CORRECT)
{ "api_key": "${MY_API_KEY}" }
```

## Integration with Forge Workflow

After creating an extension with `/forge`, always validate:

```
1. /forge                    # Create extension
2. /forge:validate           # Validate before use
3. Fix any reported issues
4. /forge:validate --strict  # Final check for marketplace
5. Publish if all checks pass
```

## Tips for Passing Validation

1. **Keep names short** - Under 64 characters
2. **Write clear descriptions** - Under 1024 characters, be specific
3. **Match versions** - All three files must agree
4. **Right location** - Commands at plugin root, not in .claude-plugin
5. **Minimal permissions** - Only request tools you need
6. **No secrets** - Use environment variables
7. **Tag releases** - Create git tags for marketplace

Ready to validate? Run `/forge:validate` now!
