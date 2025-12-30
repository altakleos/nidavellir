# Eitri Templates

Pre-built templates for quick extension creation.

## Available Templates

### Agents

| Template | File | Description |
|----------|------|-------------|
| code-reviewer | `code-reviewer.md` | Reviews code for bugs, security, best practices |
| test-generator | `test-generator.md` | Generates unit tests for functions/classes |

### Hooks

| Template | File | Description |
|----------|------|-------------|
| pre-commit-validator | `pre-commit-validator.md` | Validates edits, detects secrets, creates backups |

### MCP Integrations

| Template | File | Description |
|----------|------|-------------|
| postgres-integration | `postgres-integration.md` | PostgreSQL database access |

## Usage

Use templates via the `/forge:template` command:

```
/forge:template code-reviewer
/forge:template test-generator --framework pytest
/forge:template pre-commit-validator --backup
/forge:template postgres-integration --name my-db
```

## Template Structure

Each template file contains:

1. **Metadata** - Template type, category, complexity
2. **Generated Content** - The SKILL.md or config that will be created
3. **Customization Variables** - Options for personalization
4. **Usage Examples** - How to use the template

## Creating Custom Templates

Add your own templates to this directory following the pattern:

```yaml
---
name: my-template
type: template
category: agents|skills|hooks|mcp|suites
description: What this template creates
---

# Template Name

## Template Metadata
...

## Generated Content
...

## Customization Variables
...
```

## Contributing Templates

Good templates are:
- **Focused** - Solve one problem well
- **Customizable** - Support common variations
- **Documented** - Clear usage instructions
- **Tested** - Verified to work correctly
