# Eitri - Quick Start Guide

This guide provides a quick overview of using Eitri. For detailed command documentation, see the individual command files in `commands/`.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/forge` | Launch intelligent extension creation workflow |
| `/forge:validate` | Validate extensions for specification compliance |
| `/forge:install` | Install extensions to Claude Code environment |
| `/forge:upgrade` | Upgrade existing extensions with new features |
| `/forge:template` | Quick-start from pre-built templates |
| `/forge:browse` | Discover templates from local filesystem |
| `/forge:feedback` | Provide feedback to improve recommendations |
| `/forge:improve` | Optimize extension prompts based on feedback |
| `/forge:publish` | Publish extensions to marketplaces |
| `/forge:export` | Export to Agent Skills standard for cross-platform use |
| `/forge:test` | Test extensions in sandbox before deployment |
| `/forge:diagram` | Visualize extension architecture with Mermaid diagrams |

## Quick Start

1. **Invoke Eitri**: Type `/forge`
2. **Describe your need**: Explain what you want to accomplish
3. **Answer questions**: Eitri asks clarifying questions about your context
4. **Review recommendation**: Eitri proposes an extension type with reasoning
5. **Receive output**: Eitri generates the complete extension

Eitri determines the optimal extension type automatically based on the conversation.

## Extension Types

Eitri creates six types of Claude Code extensions:

### Skills
Context-aware solutions tightly integrated with specific workflows. Best for custom business processes, conversational interfaces, and one-time unique implementations.

### Agents
Specialized, auto-invoking components that work across projects. Best for reusable tasks like code formatting, test running, and commit message generation.

### Agent Suites
Coordinated multi-agent systems for complex workflows. Best for pipelines like "plan → build → test → review" with parallel and sequential execution patterns.

### Hybrid Solutions
Skills that orchestrate agents, combining custom workflow management with reusable automations. Best when you need both context-aware coordination and generic task execution.

### Hooks
Event-driven automations triggered by Claude Code events (PreToolCall, PostToolCall, SessionStart, etc.). Best for validation, logging, and automatic actions.

### MCP Servers
Model Context Protocol integrations for external services. Best for database access, API integrations (GitHub, Slack, Jira), and custom data sources.

## How Eitri Decides

Eitri analyzes conversation signals to recommend extension types:

| Signal | Suggests |
|--------|----------|
| "Automatically format when..." | Agent (auto-invocation) |
| "Our custom workflow..." | Skill (context-heavy) |
| "Plan, build, test, review..." | Suite (multiple roles) |
| "Manage workflow + auto-format" | Hybrid (orchestration + specialists) |
| "Before every edit..." | Hook (event-driven) |
| "Connect to database..." | MCP Server (external service) |

Users can override any recommendation during the conversation.

## Workflow Phases

### Phase 1: Context Discovery
Eitri explores business context, technical environment, team dynamics, and constraints through open-ended questions.

### Phase 2: Architecture Proposal
Based on gathered context, Eitri proposes an approach with trade-offs explained.

### Phase 3: Configuration
Details are configured: complexity level, team technical capability, and sharing preferences.

### Phase 4: Generation
Eitri creates the complete extension with all necessary files and documentation.

## Feedback and Improvement

Eitri includes a self-improving feedback system:

1. **Report issues**: `/forge:feedback --issue --extension=<name>`
2. **View pending**: `/forge:feedback --pending`
3. **Apply improvements**: `/forge:improve ./path/to/extension`
4. **Verify fixes**: `/forge:feedback --verify=<id>`

See `commands/feedback.md` and `commands/improve.md` for detailed documentation.

## Output Structure

Generated extensions include:

| Extension Type | Output Files |
|----------------|--------------|
| Skills | `SKILL.md`, optional Python scripts, sample prompts |
| Agents | Single `.md` file with YAML frontmatter |
| Agent Suites | Multiple agent files, suite config, coordination docs |
| Hybrids | Skill orchestrator + agent specialists, integration guide |
| Hooks | Shell scripts, hook configuration |
| MCP Servers | Server implementation (Python/Node.js), config files |

## Detailed Documentation

For comprehensive command documentation:

- **Feedback system**: See `commands/feedback.md`
- **Prompt improvement**: See `commands/improve.md`
- **Templates**: See `commands/template.md`
- **Validation**: See `commands/validate.md`
- **Testing**: See `commands/test.md`
- **Diagrams**: See `commands/diagram.md`
