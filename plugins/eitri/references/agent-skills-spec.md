# Agent Skills Open Standard Specification

This reference documents the Agent Skills open standard adopted by GitHub Copilot, OpenAI Codex, and Claude Code for cross-platform skill portability.

## Overview

Agent Skills are modular capabilities that extend AI coding assistants. Each skill consists of a SKILL.md file with instructions, plus optional scripts, references, and templates. Skills are designed to be **model-invoked** - the AI automatically decides when to use them based on context.

## Standard Adoption

| Platform | Directory | Status |
|----------|-----------|--------|
| GitHub Copilot | `.github/skills/` | Production (Dec 2025) |
| OpenAI Codex CLI | `.codex/skills/` | Production (Dec 2025) |
| Claude Code | `.claude/skills/` | Production (Oct 2025) |

## Directory Structure

```
.github/skills/
└── <skill-name>/
    ├── SKILL.md              # Required: Main definition
    ├── scripts/              # Optional: Executable scripts
    │   ├── script1.sh
    │   └── script2.py
    ├── references/           # Optional: Reference documentation
    │   └── patterns.md
    └── templates/            # Optional: Template files
        └── template.md
```

### Naming Conventions

- Skill directory name: lowercase, hyphens only (`^[a-z0-9-]+$`)
- Maximum length: 64 characters
- Examples: `code-reviewer`, `test-generator`, `api-designer`

## SKILL.md Format

### Required Frontmatter

```yaml
---
name: skill-name
description: Brief description of what the skill does
---
```

| Field | Required | Constraints |
|-------|----------|-------------|
| `name` | Yes | ≤64 chars, `^[a-z0-9-]+$` |
| `description` | Yes | ≤1024 chars |

### Optional Frontmatter

```yaml
---
name: skill-name
description: Brief description
version: 1.0.0
---
```

| Field | Required | Description |
|-------|----------|-------------|
| `version` | No | Semantic version (e.g., 1.0.0) |

### Body Content

The body of SKILL.md contains the skill's instructions in Markdown format:

```markdown
---
name: code-reviewer
description: Reviews code for bugs and best practices
---

# Code Reviewer

You are a code review assistant. When the user requests a code review:

1. Read the specified files
2. Analyze for common issues
3. Provide structured feedback

## Review Checklist

- Logic errors and bugs
- Security vulnerabilities
- Performance concerns
- Code style consistency

## Output Format

Provide feedback as:
- **Critical**: Must fix before merge
- **Warning**: Should fix
- **Suggestion**: Nice to have
```

## Platform-Specific Extensions

### GitHub Copilot

GitHub Copilot supports additional fields through VS Code settings:

```yaml
---
name: my-skill
description: Description here
---
```

**Discovery:** Copilot reads skill metadata at load time. Clear, specific descriptions improve auto-invocation accuracy.

### OpenAI Codex

Codex supports the standard format with these additional capabilities:

- **Explicit invocation:** Use `/skills` or `$skill-name` in prompts
- **Auto-discovery:** Codex finds relevant skills based on prompt content
- **Custom instructions:** AGENTS.md file provides global context

### Claude Code

Claude Code extends the standard with:

```yaml
---
name: my-skill
description: Description here
allowed-tools:                    # Claude Code extension
  - Read
  - Write
  - Bash
disable-model-invocation: false   # Claude Code extension
mode: false                       # Claude Code extension
---
```

| Extension Field | Description |
|-----------------|-------------|
| `allowed-tools` | Restrict tool access |
| `disable-model-invocation` | Require explicit invocation |
| `mode` | Show in Mode Commands panel |

## Scripts

Scripts in the `scripts/` directory must be:
- Executable (`chmod +x`)
- Have proper shebang (`#!/bin/bash`, `#!/usr/bin/env python3`)
- Accept input via stdin or arguments
- Output results to stdout

### Example Script

```bash
#!/bin/bash
# scripts/analyze.sh
# Analyzes a file and outputs findings

FILE="$1"
if [[ -z "$FILE" ]]; then
    echo "Usage: analyze.sh <file>"
    exit 1
fi

# Analysis logic here
grep -n "TODO" "$FILE" | while read line; do
    echo "Found TODO: $line"
done
```

## References

Reference documents in `references/` provide additional context:
- Best practices documentation
- Pattern libraries
- API references
- Example outputs

These are read by the AI when the skill is invoked.

## Templates

Templates in `templates/` are used for code generation:
- Boilerplate code
- Configuration templates
- Documentation starters

Use Handlebars-style placeholders: `{{variable}}`.

## Discovery Mechanism

### How Platforms Find Skills

1. **Directory scan:** Platforms scan known skill directories at startup
2. **Metadata extraction:** Read `name` and `description` from frontmatter
3. **Lightweight index:** Build index of available skills
4. **Contextual matching:** Match user prompts to skill descriptions

### Improving Discovery

Write descriptions that:
- Start with an action verb
- Mention the trigger context
- List key capabilities

**Good:**
```yaml
description: Reviews code for bugs, security issues, and best practices when code modifications are made
```

**Bad:**
```yaml
description: A tool for code review
```

## Cross-Platform Compatibility

### Guaranteed Portable

These features work across all platforms:

- `name` and `description` frontmatter
- Markdown body content
- `scripts/` directory
- `references/` directory
- `templates/` directory

### Platform-Specific (Non-Portable)

These features are platform-specific:

| Feature | Platform |
|---------|----------|
| `allowed-tools` | Claude Code |
| `disable-model-invocation` | Claude Code |
| `mode` | Claude Code |
| `/skills` command | Codex CLI |
| `chat.useAgentSkills` setting | VS Code/Copilot |

## Eitri Extensions

Eitri adds rich metadata for intelligent extension generation. When exporting, these are handled as follows:

### Preserved as Comments

```markdown
<!-- eitri:model=sonnet -->
<!-- eitri:color=red -->
<!-- eitri:field=quality -->
<!-- eitri:execution_pattern=sequential -->
```

### Transformed to Sections

| Eitri Field | Transformation |
|-------------|----------------|
| `allowed-tools` | "## Tools Required" section |
| `field` | "**Domain:**" in body |
| `execution_pattern` | "**Execution:**" in body |
| `expertise` | Informs content complexity |

## Validation Checklist

Before publishing a skill, verify:

- [ ] `SKILL.md` exists at skill root
- [ ] `name` is lowercase, hyphens only, ≤64 chars
- [ ] `description` is clear and ≤1024 chars
- [ ] No unsupported frontmatter fields
- [ ] Scripts are executable
- [ ] No hardcoded secrets
- [ ] Works in target platform

## Official Documentation

### GitHub Copilot
- [Agent Skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [GitHub Copilot Changelog](https://github.blog/changelog/2025-12-18-github-copilot-now-supports-agent-skills/)

### OpenAI Codex
- [Agent Skills Documentation](https://developers.openai.com/codex/skills)
- [Create Skills Guide](https://developers.openai.com/codex/skills/create-skill/)

### Claude Code
- [Skills Documentation](https://code.claude.com/docs/en/skills)
- [Claude Code Plugins](https://claude.com/blog/claude-code-plugins)

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Dec 2025 | Initial open standard release |

---

*This reference is maintained as part of the Eitri plugin for Claude Code.*
