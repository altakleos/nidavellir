# AltaKleos Claude Code Plugin Marketplace

Private marketplace for internal development tools and Claude Code plugins.

## Quick Reference

| Item | Value |
|------|-------|
| Marketplace Registry | `.claude-plugin/marketplace.json` |
| Plugins Directory | `plugins/[name]/` |
| Validation Schemas | `schemas/*.schema.json` |
| Validate Command | `npm run validate` |
| Main Plugin | `eitri` (command: `/forge`) |
| Local Skill | `plugin-packager` |

## Critical Plugin Structure Rules

### 1. Commands Location (CRITICAL)
```
CORRECT:  plugins/[name]/commands/[cmd].md
WRONG:    plugins/[name]/.claude-plugin/commands/[cmd].md
```
Claude Code discovers commands at plugin root only.

### 2. Version Consistency
Versions must match across all three locations:
- `.claude-plugin/plugin.json`
- `SKILL.md` frontmatter
- `.claude-plugin/marketplace.json` entry

### 3. Naming Convention
- Plugin names: **kebab-case only** (lowercase with hyphens)
- Pattern: `^[a-z0-9-]+$`
- Examples: `eitri`, `plugin-packager`, `data-pipeline`

### 4. Manifest Conflicts
With `strict: false` in marketplace.json:
- Component specs belong in `plugin.json` only
- Do not duplicate specs in marketplace entry

### 5. SKILL.md Frontmatter Compliance

Use only official frontmatter fields (per Claude Code specification):

**Required:**
- `name` - max 64 chars, lowercase/numbers/hyphens only
- `description` - max 1024 chars

**Optional:**
- `version` - semantic versioning (e.g., `1.0.0`)
- `disable-model-invocation` - boolean, prevents auto-invocation
- `mode` - boolean, marks as mode command
- `allowed-tools` - array of tool names to restrict access

**Do NOT use in SKILL.md frontmatter:**
- `author` - put in `plugin.json` instead
- `keywords` - put in `plugin.json` instead
- Custom fields not in official spec

Example compliant frontmatter:
```yaml
---
name: my-skill
description: A brief description of what this skill does
version: 1.0.0
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
---
```

### 6. Agent Frontmatter Fields (Eitri-Specific)

The Eitri plugin uses additional frontmatter fields for agent examples and generation.
These are **internal to Eitri** and not part of the official Claude Code spec:

| Field | Values | Purpose |
|-------|--------|---------|
| `model` | `sonnet`, `opus`, `haiku` | Recommended model for this agent |
| `color` | `blue`, `green`, `red`, `purple` | Visual categorization (blue=strategic, green=implementation, red=quality, purple=coordination) |
| `field` | domain string | Domain area (e.g., `development`, `testing`, `architecture`) |
| `expertise` | `beginner`, `intermediate`, `expert` | User technical level adaptation |
| `execution_pattern` | `parallel`, `coordinated`, `sequential` | How this agent should be executed |
| `process_load_estimate` | string range (e.g., `"12-18"`) | Estimated process count |
| `max_concurrent` | number | Maximum concurrent instances |

**Example Eitri agent frontmatter:**
```yaml
---
name: code-reviewer
description: Reviews code for bugs and best practices when modifications are made
allowed-tools:
  - Read
  - Grep
  - Glob
model: sonnet
color: red
field: quality
expertise: intermediate
execution_pattern: sequential
process_load_estimate: "12-18"
---
```

**Note:** These fields are used by Eitri for agent generation guidance.
The official Claude Code fields (`name`, `description`, `version`, `allowed-tools`, etc.) take precedence.

## Common Operations

### Creating a New Plugin
1. Create skill content (use `/forge` with eitri)
2. Package with plugin-packager patterns
3. Add to `plugins/[name]/` directory
4. Register in `.claude-plugin/marketplace.json`
5. Validate: `npm run validate`

### Adding a Slash Command
Create `plugins/[name]/commands/[cmd].md`:
```yaml
---
name: command-name
description: Brief command description
---
# Command Name
[Command implementation details]
```

### Updating Plugin Version
Sync across all 3 locations:
1. `plugins/[name]/.claude-plugin/plugin.json`
2. `plugins/[name]/SKILL.md` frontmatter
3. `.claude-plugin/marketplace.json`

## Key Files

| Purpose | Path |
|---------|------|
| Marketplace registry | `.claude-plugin/marketplace.json` |
| Plugin schema | `schemas/plugin.schema.json` |
| Skill schema | `schemas/skill.schema.json` |
| Marketplace schema | `schemas/marketplace.schema.json` |
| Validation script | `scripts/validate.sh` |
| Eitri plugin | `plugins/eitri/` |
| Plugin-packager skill | `.claude/skills/plugin-packager/` |
| Contribution guide | `CONTRIBUTING.md` |
| Security policy | `SECURITY.md` |

## Commit Conventions

```
feat: Add new plugin or feature
fix: Bug fixes
docs: Documentation updates
chore: Maintenance, version updates
```

## Validation

Before committing changes:
```bash
npm run validate
```

This checks:
- JSON syntax validity
- Schema compliance
- Version consistency
- Required files presence
- SKILL.md frontmatter compliance

## Documentation References

For detailed guidelines, see:
- **Contributing**: `CONTRIBUTING.md`
- **Security**: `SECURITY.md`
- **Plugin Development**: `README.md`

## Policies

@.claude/policies/file-creation-policy.md
