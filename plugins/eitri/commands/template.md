---
name: template
description: Quick-start extension creation from pre-built templates and common patterns
---

# Template Command

This command creates extensions from pre-built templates for common use cases.

## What It Does

When you run `/forge:template`, I will:

1. **Show available templates** - Categorized by extension type
2. **Let you select a template** - Based on your needs
3. **Customize for your context** - Names, descriptions, specifics
4. **Generate the extension** - Complete and ready to use
5. **Optionally install** - Put it in the right location

## How to Use

### Browse Templates

```
/forge:template
```

Shows all available templates organized by category.

### Use Specific Template

```
/forge:template code-reviewer
```

Creates an extension from the code-reviewer template.

### List Templates Only

```
/forge:template --list
```

Shows available templates without creating anything.

## Available Templates

### Agents

| Template | Description |
|----------|-------------|
| `code-reviewer` | Reviews code for bugs, security issues, and best practices |
| `test-generator` | Generates unit tests for functions and classes |
| `security-scanner` | Scans code for OWASP vulnerabilities |
| `doc-generator` | Generates documentation from code |
| `refactor-assistant` | Suggests and applies code refactoring |

### Skills

| Template | Description |
|----------|-------------|
| `project-onboarding` | Helps new developers understand a codebase |
| `api-designer` | Designs RESTful or GraphQL APIs |
| `database-modeler` | Designs database schemas |
| `deployment-guide` | Guides through deployment processes |
| `debugging-helper` | Helps debug complex issues |

### Hooks

| Template | Description |
|----------|-------------|
| `pre-commit-validator` | Validates code before commits |
| `audit-logger` | Logs all Claude Code operations |
| `backup-manager` | Creates backups before file modifications |
| `notification-sender` | Sends notifications to Slack/webhooks |
| `session-initializer` | Sets up environment on session start |

### MCP Integrations

| Template | Description |
|----------|-------------|
| `postgres-integration` | PostgreSQL database access |
| `github-integration` | GitHub API for issues, PRs, repos |
| `slack-integration` | Slack messaging and channels |
| `custom-api` | Template for custom API integration |

### Suites

| Template | Description |
|----------|-------------|
| `dev-workflow` | Planning → Implementation → Review → Test |
| `ci-cd-pipeline` | Build → Test → Deploy workflow |
| `code-quality` | Lint → Review → Security → Test |

## Template Details

### code-reviewer

**Type:** Agent
**Tools:** Read, Grep, Glob
**Execution:** Sequential

**What it does:**
- Reviews code changes for bugs and logic errors
- Checks for security vulnerabilities
- Suggests improvements and best practices
- Validates against project conventions

**Customization options:**
- Focus areas (security, performance, style)
- Severity levels to report
- Project-specific rules

---

### test-generator

**Type:** Agent
**Tools:** Read, Grep, Glob, Write
**Execution:** Coordinated

**What it does:**
- Analyzes function signatures and behavior
- Generates unit tests with good coverage
- Creates edge case tests
- Follows project testing patterns

**Customization options:**
- Test framework (pytest, jest, etc.)
- Coverage targets
- Mock strategies

---

### security-scanner

**Type:** Agent
**Tools:** Read, Grep, Glob
**Execution:** Sequential

**What it does:**
- Scans for OWASP Top 10 vulnerabilities
- Detects hardcoded secrets
- Identifies injection risks
- Checks authentication/authorization patterns

**Customization options:**
- Vulnerability categories to check
- Severity thresholds
- Compliance requirements (PCI, HIPAA)

---

### pre-commit-validator

**Type:** Hook (PreToolCall)
**Matcher:** Edit|Write

**What it does:**
- Validates file edits before they happen
- Checks for protected files
- Ensures code style compliance
- Prevents accidental secret commits

**Customization options:**
- Protected file patterns
- Validation rules
- Bypass conditions

---

### postgres-integration

**Type:** MCP Server
**Package:** @modelcontextprotocol/server-postgres

**What it does:**
- Connects to PostgreSQL database
- Enables SQL queries from Claude
- Provides schema introspection
- Supports read and write operations

**Customization options:**
- Connection string
- Read-only mode
- Allowed operations

---

### dev-workflow

**Type:** Suite (4 agents)
**Pattern:** Pipeline

**Agents included:**
1. `planner` - Analyzes requirements, creates plan
2. `implementer` - Writes code following plan
3. `reviewer` - Reviews implementation
4. `tester` - Generates and runs tests

**Customization options:**
- Agent order
- Handoff criteria
- Quality gates

## Using Templates

### Interactive Mode

```
/forge:template

Available Templates
===================

AGENTS:
  1. code-reviewer     - Reviews code for bugs and best practices
  2. test-generator    - Generates unit tests
  3. security-scanner  - Scans for vulnerabilities
  4. doc-generator     - Generates documentation
  5. refactor-assistant - Suggests refactoring

SKILLS:
  6. project-onboarding - Helps understand codebases
  7. api-designer       - Designs APIs
  ...

Select template (number or name): 1

Creating from template: code-reviewer
=====================================

Customization:

Name [code-reviewer]: my-code-reviewer
Description [Reviews code for bugs...]: Reviews Python code for our Django project
Focus areas [all]: security, performance
Project framework [auto-detect]: django

Generating...
✓ Created my-code-reviewer/AGENT.md
✓ Created my-code-reviewer/README.md

Install now? [Y/n]: y
✓ Installed to .claude/skills/my-code-reviewer/

Done! Your code reviewer is ready to use.
```

### Direct Mode

```
/forge:template security-scanner --name my-scanner --focus "api,auth"
```

Creates directly with specified options.

## Customization

Every template supports customization:

### Common Options

| Option | Description |
|--------|-------------|
| `--name` | Custom name for the extension |
| `--description` | Custom description |
| `--output` | Output directory |
| `--install` | Install after creation |

### Template-Specific Options

Each template has its own options. Use `--help` to see them:

```
/forge:template code-reviewer --help

code-reviewer options:
  --focus <areas>     Focus areas: security, performance, style, all
  --severity <level>  Minimum severity: info, warning, error
  --framework <name>  Project framework for conventions
  --rules <file>      Custom rules file
```

## Creating Custom Templates

You can create your own templates:

### Template Structure

```
templates/
└── my-template/
    ├── template.yaml      # Template metadata
    ├── SKILL.md.tmpl      # Template content
    └── README.md.tmpl     # Template docs
```

### Template Metadata (template.yaml)

```yaml
name: my-template
type: agent
description: My custom template
category: custom

variables:
  - name: focus_area
    prompt: "What should this focus on?"
    default: "general"

  - name: tool_set
    prompt: "Which tools to include?"
    type: multiselect
    options:
      - Read
      - Write
      - Bash
    default: [Read]

files:
  - source: SKILL.md.tmpl
    target: SKILL.md
  - source: README.md.tmpl
    target: README.md
```

### Template Content (SKILL.md.tmpl)

```markdown
---
name: {{name}}
description: {{description}}
allowed-tools:
{{#each tool_set}}
  - {{this}}
{{/each}}
---

# {{name | titlecase}}

Focus area: {{focus_area}}

## Approach
...
```

## Template Categories

### By Complexity

| Level | Templates |
|-------|-----------|
| Simple | code-reviewer, doc-generator, pre-commit-validator |
| Medium | test-generator, security-scanner, api-designer |
| Complex | dev-workflow, ci-cd-pipeline, code-quality |

### By Domain

| Domain | Templates |
|--------|-----------|
| Development | code-reviewer, test-generator, refactor-assistant |
| Security | security-scanner, pre-commit-validator |
| Documentation | doc-generator, project-onboarding |
| DevOps | ci-cd-pipeline, deployment-guide |
| Data | postgres-integration, database-modeler |

## Tips

1. **Start with templates** - Faster than building from scratch
2. **Customize after creation** - Templates are starting points
3. **Combine with /forge** - Templates handle common cases, /forge handles unique needs
4. **Share templates** - Add your templates to `templates/` for reuse

Ready to start? Run `/forge:template --list` to see all options!
