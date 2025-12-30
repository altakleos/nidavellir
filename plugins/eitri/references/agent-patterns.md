---
name: agent-patterns
type: reference
description: Agent creation patterns, safety guidelines, and best practices
---

# Agent Patterns - Reference Guide

Comprehensive guide to agent patterns that QuickStart uses and adapts contextually.

## Agent Concept

Agents are specialized Claude Code extensions that:
- Auto-invoke based on task descriptions
- Run in separate context windows
- Have optimized tool access for safety
- Work independently or in coordination

## When Agents Are Appropriate

Use agents when you need:
- **Reusability**: Same functionality across multiple projects
- **Auto-invocation**: Trigger based on specific conditions
- **Single responsibility**: One clear, focused purpose
- **Safety through restrictions**: Benefit from limited tool access
- **Independence**: Minimal context requirements

## Agent Characteristics Framework

### Function Types (Context-Adaptive)

**Strategic (Planning & Research):**
- Lightweight, read-heavy operations
- Tools: Read, Write, Grep typically
- Execution: Parallel-safe (4-5 concurrent max)
- Process load: 10-20 processes
- Examples: Requirements analyst, research agent, planner

**Implementation (Building & Creating):**
- Full tool access for development
- Tools: Read, Write, Edit, Bash, Grep, Glob
- Execution: Coordinated (2-3 concurrent max)
- Process load: 20-30 processes
- Examples: Code writer, API builder, feature developer

**Quality (Testing & Validation):**
- Full tools for thorough checking
- Tools: Read, Write, Edit, Bash, Grep, Glob
- Execution: SEQUENTIAL ONLY (CRITICAL)
- Process load: 12-18 processes
- Examples: Test runner, code reviewer, security auditor

**Coordination (Orchestration):**
- Manages other agents and workflows
- Tools: Read, Write, Grep typically
- Execution: Varies based on coordination needs
- Process load: 10-15 processes
- Examples: Workflow manager, task delegator

## Safety Framework

### Critical Safety Rule: Sequential Quality Agents

Quality agents MUST be sequential:
```yaml
# CORRECT
name: test-runner
function: quality
execution_pattern: sequential

# WRONG - System crashes
name: test-runner
function: quality
execution_pattern: parallel  # NEVER!
```

### Tool Access Safety

**Parallel-Safe Tool Combinations:**
- Read + Grep: Always safe
- Read + Write: Safe for independent files
- Read + Grep + Glob: Safe

**Requires Coordination:**
- Read + Write + Edit: Potential conflicts
- Bash in implementation: Needs coordination
- Any write operations to shared resources

**Sequential Required:**
- Quality operations (testing, review)
- Critical system modifications
- State-changing operations

### Process Load Management

Monitor and limit process usage:
- Strategic parallel: 10-20 processes each, 5 max concurrent
- Implementation coordinated: 20-30 each, 3 max concurrent
- Quality sequential: 12-18, only 1 at a time
- Warning threshold: 40 total processes
- Critical threshold: 60 total processes

## Description Optimization

Agent descriptions must be clear for auto-discovery:

**Formula:**
```
[Action Verb] + [Scope] + [Trigger Condition] + [Key Capabilities]
```

**Good Examples:**
- "Reviews Python code for security vulnerabilities whenever files change. Checks OWASP Top 10, injection attacks, and crypto issues."
- "Formats JavaScript and TypeScript using Prettier when code is saved. Preserves project configuration and integrates with ESLint."
- "Generates comprehensive test suites for functions on demand. Creates unit tests, edge cases, mocks, and assertions."

**Poor Examples:**
- "Code helper" (too vague)
- "Does various things with code" (unclear trigger)
- "Might help with testing sometimes" (ambiguous)

## Common Agent Patterns

### Pattern: Code Formatter Agent
```yaml
name: code-formatter
description: Formats code files using project style guide when saved
tools: Read, Write, Edit
execution_pattern: parallel
function: implementation
process_load_estimate: "15-20"
```

### Pattern: Test Runner Agent
```yaml
name: test-runner
description: Executes test suites and reports results when requested
tools: Read, Write, Bash, Grep
execution_pattern: sequential  # Quality agent
function: quality
process_load_estimate: "12-18"
```

### Pattern: Code Reviewer Agent
```yaml
name: code-reviewer
description: Reviews code changes for quality and best practices after modifications
tools: Read, Grep
execution_pattern: sequential  # Quality agent
function: quality
process_load_estimate: "12-18"
```

### Pattern: Documentation Generator
```yaml
name: doc-generator
description: Generates API documentation from code annotations on demand
tools: Read, Write
execution_pattern: parallel
function: implementation
process_load_estimate: "15-20"
```

## Integration Patterns

### Standalone Agent
Works independently, no coordination needed:
```yaml
name: formatter
coordination: none
triggers: file_save_event
```

### Coordinated Agents
Work together in sequence:
```yaml
agents:
  - name: builder
    runs_before: [tester]
  - name: tester
    runs_after: [builder]
    runs_before: [deployer]
  - name: deployer
    runs_after: [tester]
```

### Parallel Agent Group
Run simultaneously:
```yaml
parallel_group:
  - frontend-linter
  - backend-linter
  - docs-checker
all_parallel_safe: true
```

## MCP Tool Integration

When MCP tools are available:
```yaml
name: github-pr-reviewer
description: Reviews GitHub pull requests for code quality
tools: Read, Grep
mcp_tools: mcp__github
```

System prompt includes MCP usage:
```markdown
## Using MCP Tools

Use `mcp__github` to:
- Fetch PR details and diffs
- Check CI/CD status
- Post review comments
```

## Best Practices

1. **Single Responsibility**: One agent, one clear purpose
2. **Clear Triggers**: Specific conditions for auto-invocation
3. **Minimal Tools**: Only include tools actually needed
4. **Safety First**: Follow execution pattern rules strictly
5. **Clear Descriptions**: Optimized for auto-discovery
6. **Context-Free**: Avoid heavy context dependency
7. **Test Thoroughly**: Validate auto-invocation works
8. **Document Integration**: Show how it works with others

## Anti-Patterns to Avoid

- Multiple responsibilities in one agent
- Vague or ambiguous descriptions
- Unnecessary tool access
- Quality agents not marked sequential
- Heavy context requirements
- No clear trigger conditions
- Overly complex logic

## Evolution and Maintenance

Agents should:
- Start simple, add features as needed
- Maintain backward compatibility
- Version appropriately (semver)
- Document breaking changes
- Provide migration guides

This reference guides QuickStart's agent generation with context-appropriate adaptations.
