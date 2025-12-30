---
name: upgrade
description: Upgrade existing Claude Code extensions with new features, fixes, or version bumps
---

# Upgrade Command

This command upgrades existing Claude Code extensions - adding features, fixing issues, or bumping versions.

## What It Does

When you run `/forge:upgrade`, I will:

1. **Analyze the existing extension** - Understand current structure and capabilities
2. **Identify upgrade opportunities** - Outdated patterns, missing features, improvements
3. **Propose changes** - Show what will be upgraded and why
4. **Apply upgrades** - Make changes with your approval
5. **Validate results** - Ensure the upgrade was successful

## How to Use

### Upgrade Current Extension

```
/forge:upgrade
```

Analyzes and upgrades the extension in the current directory.

### Upgrade Specific Extension

```
/forge:upgrade ./plugins/my-extension
```

Upgrades the extension at the specified path.

### Version Bump Only

```
/forge:upgrade --bump patch
```

Just bumps the version (patch, minor, or major).

### Add Specific Feature

```
/forge:upgrade --add hooks
```

Adds a specific capability to an existing extension.

## Upgrade Types

### 1. Version Bumps

```
/forge:upgrade --bump <type>
```

| Type | From | To | When to Use |
|------|------|-----|-------------|
| `patch` | 1.0.0 | 1.0.1 | Bug fixes, minor tweaks |
| `minor` | 1.0.0 | 1.1.0 | New features, backward compatible |
| `major` | 1.0.0 | 2.0.0 | Breaking changes |

**What happens:**
- Updates version in SKILL.md frontmatter
- Updates version in plugin.json (if exists)
- Updates version in marketplace.json entry (if exists)

### 2. Specification Compliance

```
/forge:upgrade --spec
```

Updates extension to match latest Claude Code specification:

- Fixes deprecated frontmatter fields
- Updates to new field names
- Adds missing required fields
- Removes unsupported fields

**Example output:**
```
Specification Compliance Upgrade
================================

Analyzing: my-old-skill

Issues found:
  ⚠ Using deprecated 'tools' field (should be 'allowed-tools')
  ⚠ Missing 'version' field (recommended)
  ✗ Using unsupported 'author' in SKILL.md (move to plugin.json)

Proposed changes:
  1. Rename 'tools' → 'allowed-tools'
  2. Add 'version: 1.0.0'
  3. Remove 'author' from SKILL.md frontmatter

Apply these changes? [Y/n]
```

### 3. Add Capabilities

```
/forge:upgrade --add <capability>
```

| Capability | What It Adds |
|------------|--------------|
| `hooks` | Event-driven hook scripts |
| `mcp` | MCP server configuration |
| `commands` | Slash command(s) |
| `agents` | Sub-agent definitions |
| `validation` | Test/validation scripts |

**Example - Adding hooks:**
```
Adding Hooks Capability
=======================

Analyzing: my-skill

Current capabilities:
  ✓ Skill (SKILL.md)
  ✓ Commands (2 commands)
  ✗ Hooks (none)

What hooks would you like to add?

1. Pre-edit validation (backup before edits)
2. Command logging (audit trail)
3. Notifications (Slack/webhook integration)
4. Session setup (environment loading)
5. Custom (describe your needs)

Select options (comma-separated): 1, 2

Generating hooks...
  ✓ Created .claude/hooks/validate-edit.sh
  ✓ Created .claude/hooks/log-commands.sh
  ✓ Updated .claude/settings.json

Hooks added successfully!
```

### 4. Pattern Modernization

```
/forge:upgrade --modernize
```

Updates extension to use modern patterns:

- Improves tool restrictions for safety
- Optimizes execution patterns
- Enhances descriptions for better auto-discovery
- Adds missing documentation

**Example output:**
```
Pattern Modernization
=====================

Analyzing: legacy-agent

Modernization opportunities:

1. Tool Restrictions
   Current: All tools allowed
   Recommended: Read, Grep, Glob (read-only agent)
   Reason: Agent only analyzes, doesn't modify

2. Execution Pattern
   Current: Not specified
   Recommended: parallel
   Reason: Read-only operations are parallel-safe

3. Description
   Current: "Analyzes code"
   Recommended: "Analyzes code for security vulnerabilities when files
                 are modified. Checks for OWASP Top 10, injection flaws,
                 and authentication issues."
   Reason: More specific for reliable auto-discovery

Apply these modernizations? [Y/n]
```

### 5. Convert Extension Type

```
/forge:upgrade --convert-to <type>
```

Converts between extension types:

| From | To | Command |
|------|-----|---------|
| Skill | Agent | `--convert-to agent` |
| Skill | Plugin | `--convert-to plugin` |
| Agent | Skill | `--convert-to skill` |

**Example - Skill to Plugin:**
```
Converting Skill to Plugin
==========================

Current structure:
  my-skill/
  └── SKILL.md

New structure:
  my-skill/
  ├── .claude-plugin/
  │   └── plugin.json
  ├── commands/
  │   └── my-command.md (optional)
  ├── SKILL.md
  └── README.md

Changes:
  1. Create .claude-plugin/plugin.json
  2. Extract command to commands/ (if applicable)
  3. Generate README.md

Proceed with conversion? [Y/n]
```

## Upgrade Process

### Full Analysis Mode

```
/forge:upgrade --analyze
```

Performs comprehensive analysis without making changes:

```
Extension Analysis Report
=========================

Extension: my-extension
Type: Plugin
Version: 1.0.0

Health Score: 72/100

Issues:
  HIGH   - Using deprecated 'tools' field
  MEDIUM - No version specified
  LOW    - Description could be more specific

Opportunities:
  ✓ Could add hooks for better automation
  ✓ Could add MCP for database access
  ✓ Could improve tool restrictions

Recommendations:
  1. Run: /forge:upgrade --spec
  2. Run: /forge:upgrade --add hooks
  3. Run: /forge:upgrade --modernize

Run with --fix to apply recommended changes.
```

### Auto-Fix Mode

```
/forge:upgrade --fix
```

Automatically applies safe fixes:

```
Auto-Fix Upgrade
================

Applying safe fixes...

✓ Fixed: 'tools' → 'allowed-tools'
✓ Fixed: Added version: 1.0.0
✓ Fixed: Removed unsupported 'author' field
⚠ Skipped: Description improvement (requires review)
⚠ Skipped: Tool restriction changes (may affect behavior)

3 fixes applied, 2 skipped (review recommended)

Run /forge:upgrade --modernize to review skipped items.
```

## Options Reference

| Option | Description |
|--------|-------------|
| `--bump <type>` | Version bump: patch, minor, major |
| `--spec` | Update to latest specification |
| `--add <cap>` | Add capability: hooks, mcp, commands, agents |
| `--modernize` | Apply modern patterns and best practices |
| `--convert-to <type>` | Convert extension type |
| `--analyze` | Analyze without making changes |
| `--fix` | Auto-apply safe fixes |
| `--dry-run` | Show changes without applying |
| `--force` | Skip confirmation prompts |

## Backup and Rollback

Before any upgrade, I create a backup:

```
Backup created: .claude/backups/my-extension-1.0.0-20250130.tar.gz

To rollback:
  tar -xzf .claude/backups/my-extension-1.0.0-20250130.tar.gz
```

## Upgrade Workflow

Typical upgrade workflow:

```
1. /forge:upgrade --analyze      # See what can be improved
2. /forge:upgrade --spec         # Fix specification issues
3. /forge:upgrade --modernize    # Apply modern patterns
4. /forge:upgrade --add hooks    # Add new capabilities
5. /forge:upgrade --bump minor   # Bump version
6. /forge:validate               # Validate changes
7. /forge:install                # Reinstall upgraded version
```

## Batch Upgrades

Upgrade multiple extensions at once:

```
/forge:upgrade --all --spec
```

Upgrades all extensions in the project to latest specification.

```
Batch Upgrade Results
=====================

Upgraded:
  ✓ my-skill (1.0.0 → 1.0.1)
  ✓ my-agent (1.2.0 → 1.2.1)
  ✓ my-plugin (2.0.0 → 2.0.1)

Skipped:
  - other-plugin (already compliant)

Failed:
  ✗ broken-skill (validation errors - run /forge:validate)
```

Ready to upgrade? Run `/forge:upgrade --analyze` to see opportunities!
