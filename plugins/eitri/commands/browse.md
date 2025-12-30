---
name: browse
description: Browse and discover templates from local filesystem (built-in, user, and project templates)
---

# Browse Command

Discover and explore templates for quick-start extension creation. This command scans local template directories without requiring any external servers or network connections.

## Usage

```
/forge:browse [options]
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--category=<cat>` | Filter by category: `agents`, `skills`, `hooks`, `mcp`, `suites`, `all` | `all` |
| `--location=<loc>` | Filter by source: `builtin`, `user`, `project`, `all` | `all` |
| `--sort=<field>` | Sort by: `name`, `modified`, `category` | `name` |
| `--search=<query>` | Search by name or description | none |
| `--limit=<n>` | Maximum results to show | `20` |
| `--details` | Show full template details | false |

## Template Sources

Templates are discovered from three local filesystem locations (in order of precedence):

### 1. Built-in Templates (`builtin`)
**Location:** `plugins/eitri/templates/` (within this plugin)

Pre-built, tested templates maintained by the Eitri team:
- `code-reviewer` - Code review agent
- `test-generator` - Unit test generation agent
- `pre-commit-validator` - Pre-commit hook for validation
- `postgres-integration` - PostgreSQL MCP server

### 2. User Templates (`user`)
**Location:** `~/.claude/eitri/templates/`

Personal templates created by the user, available across all projects:
- Custom templates for personal workflows
- Templates copied from other sources
- Shared within the user's development environment

### 3. Project Templates (`project`)
**Location:** `.claude/eitri/templates/` (in project root)

Project-specific templates shared with team members:
- Templates tailored for project conventions
- Team-wide standard extensions
- Shared via version control

## Examples

### Browse All Templates

```
/forge:browse
```

Shows all available templates from all locations.

### Filter by Category

```
/forge:browse --category=agents
/forge:browse --category=hooks
/forge:browse --category=mcp
```

### Filter by Location

```
/forge:browse --location=builtin   # Only built-in templates
/forge:browse --location=user      # Only user templates
/forge:browse --location=project   # Only project templates
```

### Search Templates

```
/forge:browse --search=review
/forge:browse --search="test generator"
/forge:browse --search=postgres
```

### Combined Filters

```
/forge:browse --category=agents --location=builtin --sort=modified
/forge:browse --search=security --category=hooks --limit=5
```

### Show Details

```
/forge:browse --details
/forge:browse --search=code-reviewer --details
```

## Output Format

### Standard Output

```
Available Templates (12 found)
==============================

AGENTS (4)
├─ code-reviewer         [builtin] Reviews code for bugs and best practices
├─ test-generator        [builtin] Generates unit tests for functions/classes
├─ my-custom-agent       [user]    Personal code analysis agent
└─ team-reviewer         [project] Team-specific code review standards

HOOKS (3)
├─ pre-commit-validator  [builtin] Validates edits, detects secrets
├─ backup-hook           [user]    Creates backups before modifications
└─ notify-hook           [project] Sends Slack notifications on changes

MCP (2)
├─ postgres-integration  [builtin] PostgreSQL database access
└─ custom-api            [user]    Internal API integration

SKILLS (2)
├─ report-generator      [user]    Generates formatted reports
└─ data-pipeline         [project] ETL workflow automation

SUITES (1)
└─ dev-workflow          [user]    Full development workflow suite

Use '/forge:template <name>' to create from a template
Use '/forge:browse --search=<query>' to search
Use '/forge:browse --details' for full information
```

### Detailed Output (with --details)

```
Template: code-reviewer
=======================
Name:        code-reviewer
Category:    agents
Location:    builtin
Path:        plugins/eitri/templates/code-reviewer.md
Description: Reviews code for bugs, security issues, and best practices

Metadata:
  Type:       agent
  Complexity: simple
  Tools:      Read, Grep, Glob
  Execution:  sequential

Customization Variables:
  - name: Agent name (default: code-reviewer)
  - focus: Review focus areas (default: quality, security, best practices)
  - focus_security: Include security section (default: true)
  - focus_performance: Include performance section (default: true)

Usage:
  /forge:template code-reviewer
  /forge:template code-reviewer --name my-reviewer --focus security

---
```

## Template Discovery Algorithm

The browse command discovers templates by:

1. **Scanning Directories:**
   ```
   plugins/eitri/templates/    → builtin
   ~/.claude/eitri/templates/  → user
   .claude/eitri/templates/    → project
   ```

2. **Reading Template Files:**
   - Files matching `*.md` pattern
   - Must have valid YAML frontmatter
   - Must include `type: template` in frontmatter

3. **Extracting Metadata:**
   ```yaml
   ---
   name: template-name
   type: template
   category: agents|skills|hooks|mcp|suites
   description: What this template creates
   ---
   ```

4. **Applying Filters:**
   - Category filter (exact match)
   - Location filter (exact match)
   - Search filter (partial match on name + description)

5. **Sorting and Limiting:**
   - Sort by specified field
   - Limit to max results

## Creating User Templates

To create a user-level template:

```bash
# Create template directory (first time only)
mkdir -p ~/.claude/eitri/templates

# Create your template file
cat > ~/.claude/eitri/templates/my-template.md << 'EOF'
---
name: my-template
type: template
category: agents
description: My custom agent template
---

# My Custom Agent Template

## Template Metadata

```yaml
name: my-agent
type: agent
category: custom
tools: [Read, Write, Grep]
```

## Generated SKILL.md

```yaml
---
name: {{name}}
description: {{description}}
allowed-tools:
  - Read
  - Write
  - Grep
---
```

## Generated Content

```markdown
# {{name | titlecase}}

Your custom agent instructions here...
```

## Customization Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `name` | Agent name | `my-agent` |
| `description` | Description | Custom agent |
EOF
```

Then browse to verify:

```
/forge:browse --location=user
```

## Creating Project Templates

To create a project-level template (shared with team):

```bash
# In your project root
mkdir -p .claude/eitri/templates

# Create template file
# (same format as user templates)
```

Commit to version control to share with your team.

## Template File Format

Templates must follow this structure:

```markdown
---
name: template-name           # Required: unique identifier
type: template                # Required: must be "template"
category: agents              # Required: agents|skills|hooks|mcp|suites
description: What it does     # Required: brief description
---

# Template Title

## Template Metadata

Metadata about the generated extension.

## Generated SKILL.md

The YAML frontmatter for the generated SKILL.md.

## Generated Content

The markdown body content for the generated extension.

## Customization Variables

Table of variables that can be customized.

## Usage

Example commands showing how to use this template.
```

## Integration with /forge:template

After browsing, use `/forge:template` to create from a template:

```
# Browse to find templates
/forge:browse --category=agents

# Create from a template
/forge:template code-reviewer

# Create with customization
/forge:template code-reviewer --name my-reviewer --focus security
```

## Troubleshooting

### No Templates Found

**Issue:** `/forge:browse` returns empty results

**Solutions:**
1. Check if templates directory exists:
   ```bash
   ls -la plugins/eitri/templates/
   ls -la ~/.claude/eitri/templates/
   ls -la .claude/eitri/templates/
   ```

2. Verify template files have valid frontmatter:
   ```yaml
   ---
   name: my-template
   type: template  # This is required!
   category: agents
   description: Description
   ---
   ```

3. Ensure files have `.md` extension

### Template Not Loading

**Issue:** Template exists but doesn't appear in browse

**Solutions:**
1. Validate YAML frontmatter syntax
2. Ensure `type: template` is present
3. Check for category spelling: `agents`, `skills`, `hooks`, `mcp`, `suites`

### Search Not Finding Templates

**Issue:** Search returns fewer results than expected

**Solutions:**
1. Search matches name and description only
2. Try broader search terms
3. Use `--category` filter instead of search for categories

## Related Commands

| Command | Purpose |
|---------|---------|
| `/forge:template` | Create extension from a template |
| `/forge` | Full conversational extension creation |
| `/forge:validate` | Validate created extensions |
| `/forge:install` | Install extensions to Claude Code |

## Philosophy

The browse command embraces **local-first** principles:

1. **No Network Required:** All templates are on local filesystem
2. **Privacy Preserving:** No template usage tracking or telemetry
3. **Version Control Friendly:** Project templates live in git
4. **User Controlled:** Full control over available templates
5. **Offline Capable:** Works without internet connection

This ensures Eitri remains a self-contained, privacy-respecting tool.
