---
name: install
description: Install a forged extension to your Claude Code environment (local project or user-wide)
---

# Install Command

This command installs extensions created by Eitri to your Claude Code environment.

## What It Does

When you run `/forge:install`, I will:

1. **Detect the extension type** (skill, agent, plugin, hooks, MCP)
2. **Determine installation location** (project-local or user-wide)
3. **Copy files to the correct location**
4. **Verify installation success**
5. **Provide usage instructions**

## How to Use

### Install from Current Directory

```
/forge:install
```

Installs the extension in the current working directory.

### Install from Specific Path

```
/forge:install ./my-extension
```

Installs the extension at the specified path.

### Install to User-Wide Location

```
/forge:install --global
```

Installs to `~/.claude/` for availability across all projects.

### Install to Project-Local Location

```
/forge:install --local
```

Installs to `./.claude/` for current project only (default).

## Installation Locations

### Skills and Agents

| Scope | Location |
|-------|----------|
| Project-local | `.claude/skills/<name>/SKILL.md` |
| User-wide | `~/.claude/skills/<name>/SKILL.md` |

### Plugins (with plugin.json)

| Scope | Location |
|-------|----------|
| Project-local | `.claude/plugins/<name>/` |
| User-wide | `~/.claude/plugins/<name>/` |

### Hooks

| Scope | Location |
|-------|----------|
| Project-local | `.claude/hooks/<script>.sh` + settings.json |
| User-wide | `~/.claude/hooks/<script>.sh` + settings.json |

### MCP Servers

| Scope | Location |
|-------|----------|
| Project-local | `.claude/.mcp.json` (merged) |
| User-wide | `~/.claude/.mcp.json` (merged) |

## Installation Process

### For Skills/Agents

```
Installing skill: my-awesome-skill
================================

1. Detecting extension type...
   ✓ Type: Skill (SKILL.md found)

2. Validating extension...
   ✓ Frontmatter valid
   ✓ No security issues

3. Determining location...
   → Installing to: .claude/skills/my-awesome-skill/

4. Copying files...
   ✓ SKILL.md copied
   ✓ README.md copied (if present)

5. Verifying installation...
   ✓ Extension accessible

Installation complete!

Usage:
  This skill is now available in your Claude Code session.
  It will auto-invoke based on its description, or you can
  reference it directly in conversation.
```

### For Plugins

```
Installing plugin: my-plugin
============================

1. Detecting extension type...
   ✓ Type: Plugin (.claude-plugin/plugin.json found)

2. Validating extension...
   ✓ plugin.json valid
   ✓ SKILL.md valid
   ✓ Commands valid

3. Determining location...
   → Installing to: .claude/plugins/my-plugin/

4. Copying files...
   ✓ .claude-plugin/ copied
   ✓ commands/ copied
   ✓ SKILL.md copied

5. Verifying installation...
   ✓ Plugin accessible
   ✓ Commands registered

Installation complete!

Available commands:
  /my-command - Description here
```

### For Hooks

```
Installing hooks: audit-hooks
=============================

1. Detecting extension type...
   ✓ Type: Hooks (shell scripts + settings found)

2. Validating hooks...
   ✓ Scripts are executable
   ✓ Settings.json valid
   ✓ No security issues

3. Determining location...
   → Installing to: .claude/hooks/

4. Copying files...
   ✓ log-commands.sh copied
   ✓ validate-edit.sh copied

5. Merging settings...
   ✓ Hook configuration merged into .claude/settings.json

6. Verifying installation...
   ✓ Hooks registered

Installation complete!

Active hooks:
  PreToolCall: validate-edit.sh (matcher: Edit|Write)
  PostToolCall: log-commands.sh (matcher: Bash)
```

### For MCP Servers

```
Installing MCP: database-tools
==============================

1. Detecting extension type...
   ✓ Type: MCP Server (.mcp.json found)

2. Validating configuration...
   ✓ Server configuration valid
   ✓ No hardcoded secrets

3. Determining location...
   → Installing to: .claude/.mcp.json

4. Merging configuration...
   ✓ MCP server "postgres" added
   ✓ MCP server "redis" added

5. Checking requirements...
   ⚠ Environment variables needed:
     - POSTGRES_URL
     - REDIS_URL

Installation complete!

MCP servers available:
  mcp__postgres - PostgreSQL database access
  mcp__redis - Redis cache access

Set environment variables before use:
  export POSTGRES_URL="postgresql://..."
  export REDIS_URL="redis://..."
```

## Handling Conflicts

### Name Conflicts

```
⚠ Conflict detected!

An extension named "my-skill" already exists at:
  .claude/skills/my-skill/

Options:
1. Overwrite existing (--force)
2. Install with different name (--name new-name)
3. Cancel installation

What would you like to do?
```

### Version Conflicts

```
⚠ Version conflict detected!

Existing: my-skill v1.0.0
Installing: my-skill v1.2.0

Options:
1. Upgrade to v1.2.0 (--upgrade)
2. Keep existing v1.0.0 (cancel)
3. Install both (--name my-skill-v2)

What would you like to do?
```

### Hook Conflicts

```
⚠ Hook conflict detected!

Existing PreToolCall hook for "Edit":
  .claude/hooks/old-validator.sh

Installing PreToolCall hook for "Edit":
  validate-edit.sh

Options:
1. Replace existing hook (--force)
2. Add as additional hook (--append)
3. Cancel installation

What would you like to do?
```

## Options Reference

| Option | Description |
|--------|-------------|
| `--global` | Install to user-wide location (~/.claude/) |
| `--local` | Install to project location (./.claude/) - default |
| `--force` | Overwrite existing extensions |
| `--name <n>` | Install with a different name |
| `--upgrade` | Upgrade existing extension to new version |
| `--dry-run` | Show what would be installed without doing it |

## Post-Installation

After installation, I provide:

1. **Confirmation** - What was installed and where
2. **Usage instructions** - How to use the extension
3. **Environment setup** - Any required environment variables
4. **Verification** - How to confirm it's working

## Uninstalling

To remove an installed extension:

```
/forge:install --uninstall my-skill
```

Or manually:
```bash
rm -rf .claude/skills/my-skill/
```

## Tips

1. **Use --dry-run first** - See what will happen before installing
2. **Prefer project-local** - Keeps projects self-contained
3. **Set environment variables** - Required for MCP servers
4. **Restart Claude Code** - Some changes require restart to take effect

## Workflow Integration

Typical workflow after forging:

```
1. /forge                    # Create extension
2. /forge:validate           # Validate it
3. /forge:install            # Install it
4. Test the extension
5. /forge:install --global   # Install globally if useful
```

Ready to install? Run `/forge:install` now!
