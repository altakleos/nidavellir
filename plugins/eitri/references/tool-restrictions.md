---
name: tool-restrictions
type: reference
description: Guide to configuring allowed-tools for skills and agents
---

# Tool Restrictions Reference

This guide explains how to use the `allowed-tools` frontmatter field to control tool access in skills and agents.

## Overview

The `allowed-tools` field restricts which tools Claude can use when a skill or agent is active. This follows the principle of least privilege and improves security.

## Available Tools

| Tool | Purpose | Risk Level |
|------|---------|------------|
| `Read` | Read file contents | Low |
| `Glob` | Find files by pattern | Low |
| `Grep` | Search file contents | Low |
| `Write` | Create new files | Medium |
| `Edit` | Modify existing files | Medium |
| `Bash` | Execute shell commands | High |
| `Task` | Launch subagents | Medium |
| `WebFetch` | Fetch web content | Low |
| `WebSearch` | Search the web | Low |
| `NotebookEdit` | Edit Jupyter notebooks | Medium |
| `AskUserQuestion` | Ask user questions | Low |
| `TodoWrite` | Manage todo lists | Low |

## Recommended Configurations

### Read-Only Agents

For agents that analyze but don't modify:

```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
```

Use cases: Code reviewers, security scanners, documentation analyzers

### Code Modification Agents

For agents that need to create or modify files:

```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
```

Use cases: Formatters, refactoring tools, code generators

### Full Access Agents

For agents that need to run commands:

```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
  - Bash
```

Use cases: Build tools, test runners, deployment agents

**Note**: Use with caution. Consider coordinated or sequential execution patterns when Bash is included.

### Research Agents

For agents that gather information:

```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
  - WebFetch
  - WebSearch
```

Use cases: Documentation gatherers, API explorers, research assistants

### Orchestration Skills

For skills that coordinate other agents:

```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
  - Bash
  - Task
```

Use cases: Workflow coordinators, multi-agent orchestrators

## Best Practices

### 1. Start Minimal

Begin with the smallest set of tools needed:

```yaml
# Start with just reading
allowed-tools:
  - Read
  - Glob
  - Grep
```

Add more tools only when the skill explicitly needs them.

### 2. Match Execution Pattern to Tools

| Execution Pattern | Recommended Tools |
|-------------------|-------------------|
| Parallel | Read, Glob, Grep, WebFetch, WebSearch |
| Coordinated | All except Bash (use with caution) |
| Sequential | All tools available |

### 3. Consider Safety Implications

- **Bash** + **Parallel** = Potential race conditions
- **Edit** + **Parallel** = Potential file conflicts
- Quality agents with full tools should be sequential

### 4. Document Tool Usage

In your skill/agent content, explain why each tool is needed:

```markdown
## Tools Used

- **Read**: Analyze source files for patterns
- **Glob**: Find all TypeScript files
- **Grep**: Search for specific code patterns
- **Write**: Generate report files
```

## Examples

### Secure Code Scanner

```yaml
---
name: security-scanner
description: Scans code for security vulnerabilities using static analysis
allowed-tools:
  - Read
  - Glob
  - Grep
---
```

Read-only access ensures the scanner cannot accidentally modify code.

### Test Generator

```yaml
---
name: test-generator
description: Generates unit tests for functions in the codebase
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
---
```

Needs Write to create test files, but not Edit (creates new files only).

### Build Runner

```yaml
---
name: build-runner
description: Runs build commands and reports results
allowed-tools:
  - Read
  - Glob
  - Bash
---
```

Needs Bash for build commands. Should use sequential execution.

## When to Omit allowed-tools

If `allowed-tools` is omitted, the skill doesn't restrict tools - Claude can use any available tool. This is appropriate for:

- General-purpose skills that need flexibility
- Skills where tool needs vary by context
- Skills where restricting tools would reduce effectiveness

However, for focused, specialized agents, explicit tool restrictions improve safety and predictability.

## Web Research Tools

Web research tools enable extensions to access external information. Use these thoughtfully.

### WebFetch

| Aspect | Details |
|--------|---------|
| Purpose | Fetch content from known URLs |
| Risk Level | Low |
| Best For | Official documentation, known API docs, GitHub repos |

**Recommended for:**
- Official documentation sites (e.g., `code.claude.com`)
- Known API documentation (Stripe, AWS, Twilio, etc.)
- GitHub repositories for examples

**Security considerations:**
- Only fetch from trusted, known domains
- Handle timeouts gracefully (network issues happen)
- Validate that response content is expected format

**Example use cases:**
- Fetching latest Claude Code SKILL.md specification
- Getting API documentation for services mentioned by user
- Retrieving example code from official repositories

### WebSearch

| Aspect | Details |
|--------|---------|
| Purpose | Search the web for information |
| Risk Level | Medium |
| Best For | Domain research, current regulations, unfamiliar fields |

**Recommended for:**
- Domain research (accounting, legal, medical, real estate, etc.)
- Current regulations and compliance requirements
- Industry best practices and terminology
- Time-sensitive information (current year tax rules, etc.)

**Security considerations:**
- Include current year in time-sensitive searches
- Prefer authoritative sources (government, professional associations)
- Verify critical information from multiple sources
- Be skeptical of unofficial or outdated sources

**Example use cases:**
- Researching 2025 tax preparation requirements
- Understanding GAAP accounting standards
- Finding medical billing compliance requirements
- Learning real estate transaction workflows

### Web Research Configuration Examples

**Research-only agent:**
```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
  - WebFetch
  - WebSearch
```

**Documentation validator:**
```yaml
allowed-tools:
  - Read
  - WebFetch
```

**Domain research skill:**
```yaml
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - WebSearch
```

See `references/web-research.md` for detailed guidance on when to use each tool.
