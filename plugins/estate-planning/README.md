# Estate Planning Plugin

A comprehensive estate planning assistant for Claude Code that guides users through document preparation with state-specific intelligence, educational guidance, and professional boundaries.

## Features

- **5-Phase Workflow**: Welcome/Discovery → Document Selection → Drafting → Execution Guidance → Funding/Next Steps
- **51 State Jurisdictions**: Complete coverage of all 50 states + DC with execution requirements, state taxes, and special considerations
- **7 Specialized Agents**: Glossary lookup, state requirements, trust/will/POA/healthcare generation, and validation
- **Educational-First Philosophy**: Explains concepts, provides context, and recommends attorney review
- **Professional Boundaries**: Clear warnings for complex situations, never provides legal advice

## Commands

| Command | Description |
|---------|-------------|
| `/estate` | Full estate planning workflow |
| `/estate:lookup [state]` | Quick state requirement lookup |

## Document Types Supported

- Revocable Living Trust
- Pour-Over Will
- Financial Power of Attorney
- Healthcare Directive Package (Healthcare POA + Living Will + HIPAA)

## Intelligence Database

### State Coverage
- 12 Tier 1 states with comprehensive documentation
- 38 Tier 2 states + DC with essential requirements
- State-specific execution requirements
- State death tax information
- Community property vs. common law distinctions

### Specialized Topics
- Special Needs Trust Planning
- Blended Family Considerations
- Digital Assets Management
- Business Succession Planning

## Architecture

```
estate-planning/
├── SKILL.md                 # Main orchestrator
├── agents/                  # 7 specialized agents
├── commands/                # Slash commands
└── intelligence/
    ├── glossary/            # 12 term category files
    ├── state-laws/          # 51 jurisdiction files
    ├── templates/           # 4 document templates
    ├── concepts/            # Property type explanations
    ├── specialized/         # Complex scenario guidance
    └── tax/                 # Federal and state tax data
```

## Usage

```
/estate                     # Start estate planning session
/estate:lookup CA           # Look up California requirements
/estate:lookup NY tax       # Look up New York tax information
```

## Important Notices

**Educational Purpose Only**: All documents generated are drafts intended for attorney review. This plugin does not provide legal advice.

**Louisiana Warning**: Louisiana uses civil law (not common law). Estate planning documents from other states are often invalid in Louisiana. Louisiana residents must work with a Louisiana-licensed attorney.

## Version

- Plugin Version: 1.0.0
- Data Version: 2025-12
- Federal Exemption: $13.99M (2025)
