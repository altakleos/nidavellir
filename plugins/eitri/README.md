# Eitri

Intelligent extension forge that creates precisely optimized Claude Code extensions through deep contextual understanding and adaptive intelligence.

Named after the legendary Norse dwarf smith who forged Thor's hammer Mjolnir.

## Installation

```bash
/plugin install eitri@altakleos
```

## Usage

```
/forge
```

Launch Eitri and describe what you need. Through natural conversation, Eitri determines the optimal extension type and creates it for you.

## Extension Types

Eitri creates six types of Claude Code extensions:

| Type | Best For |
|------|----------|
| **Skills** | Integrated, context-aware solutions |
| **Agents** | Specialized, auto-invoking, reusable components |
| **Agent Suites** | Coordinated multi-agent systems |
| **Hybrid** | Skills orchestrating agents |
| **Hooks** | Event-driven automations |
| **MCP Servers** | External service integrations |

## Commands

| Command | Purpose |
|---------|---------|
| `/forge` | Launch intelligent extension creation workflow |
| `/forge:validate` | Validate extensions for specification compliance |
| `/forge:install` | Install extensions to Claude Code environment |
| `/forge:upgrade` | Upgrade existing extensions with new features |
| `/forge:template` | Quick-start from pre-built templates |
| `/forge:browse` | Discover templates from local filesystem |
| `/forge:feedback` | Provide feedback to improve recommendations |
| `/forge:publish` | Publish extensions to marketplaces |
| `/forge:export` | Export to Agent Skills standard for cross-platform use |
| `/forge:test` | Test extensions in sandbox before deployment |
| `/forge:diagram` | Visualize extension architecture with Mermaid diagrams |
| `/forge:improve` | Optimize extension prompts based on feedback |

## Supported Industries

Eitri adapts to domain-specific requirements:

| Industry | Considerations |
|----------|----------------|
| Healthcare | HIPAA compliance, audit trails, PHI protection |
| Finance | SOX compliance, precision calculations, audit logging |
| E-commerce | Inventory, payments, customer data handling |
| DevOps | CI/CD pipelines, infrastructure automation |
| Education | FERPA considerations, student data protection |

## Troubleshooting

### Agent Not Auto-Invoking
- Check description clarity: "when X" should be explicit
- Verify trigger condition is met
- Check agent naming (no conflicts)

### Quality Agent Safety Warnings
Quality agents (test, review, validation) MUST run sequentially.
This is enforced automatically for system stability.

### Suite Coordination Issues
- Check phase configuration
- Verify max_concurrent settings
- Ensure quality agents are sequential

## Documentation

- [HOW_TO_USE.md](HOW_TO_USE.md) - Complete usage guide
- [sample_prompt.md](sample_prompt.md) - Copy-paste example prompts

## Version

1.9.0

## Author

AltaKleos Platform Team (hello@altakleos.com)
