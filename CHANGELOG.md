# Changelog

All notable changes to the AltaKleos Claude Code Plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-18

### Added

- Initial marketplace setup with comprehensive structure
- Example plugin demonstrating best practices
- JSON schemas for validation (plugin.schema.json, marketplace.schema.json)
- Comprehensive documentation:
  - README.md with installation and contribution guidelines
  - CONTRIBUTING.md with detailed contribution process
  - SECURITY.md with security policies and best practices
- GitHub templates:
  - Issue templates (bug report, feature request, plugin submission)
  - Pull request template
- Automated validation:
  - Validation script (scripts/validate.sh)
  - GitHub Actions CI/CD workflow
  - JSON syntax validation
  - Schema compliance checks
- Package.json with validation commands
- MIT License
- Markdownlint configuration
- Security scanning workflow

### Infrastructure

- Plugins directory structure
- Schemas directory for JSON validation
- Scripts directory for automation
- GitHub workflows for CI/CD
- Issue and PR templates

### Plugins

- **example-plugin** v1.0.0: Example plugin demonstrating structure and best practices
  - Example slash command (/hello)
  - Example skill
  - Comprehensive documentation

### Documentation

- Installation instructions for users
- Plugin development guidelines for contributors
- Security best practices
- Troubleshooting guide
- Validation procedures

## [Unreleased]

### Planned

- Enhanced validation scripts
- Plugin testing framework
- Documentation improvements

## [Eitri 1.2.0] - 2025-12-30

### Added

- Reference loading for previously orphaned documentation files:
  - `references/context-dimensions.md` - Context understanding framework (578 lines)
  - `references/patterns.md` - Core generation patterns (420 lines)
  - `references/quality-criteria.md` - Quality validation standards (431 lines)
  - `references/tool-restrictions.md` - Agent safety configuration (212 lines)
- New utility script: `scripts/validate_extension.py` - Validates extension structure and SKILL.md compliance
- New utility script: `scripts/analyze_extension.py` - Analyzes extensions and recommends improvements
- Cross-references between documentation files (sample_prompt.md ↔ HOW_TO_USE.md, README.md)

### Fixed

- Removed broken script references in SKILL.md (analyze_extension.py, validate_agent.py)
- Connected 4 orphaned high-value reference files (1,641 lines of intelligence) to the skill
- Fixed "Eitri 2.0" reference in sample_prompt.md to match actual version

### Changed

- Enhanced discovery-engine.md with context-dimensions.md reference
- Enhanced all 4 generators with patterns.md reference
- Enhanced agent-generator.md with tool-restrictions.md reference
- Enhanced validation-framework.md with quality-criteria.md reference
- Updated SKILL.md Advanced Features section with accurate script descriptions

## [1.3.0] - 2025-12-30

### Changed

- **Renamed plugin**: `quickstart` → `eitri` (named after the legendary Norse dwarf smith who forged Mjolnir)
- **Renamed command**: `/create-skill` → `/forge`
- Installation command: `/plugin install eitri@altakleos`
- Updated all documentation and references

### Why the Rename

- "quickstart" was too generic and commonly used
- "eitri" is unique, memorable, and carries mythological weight
- The forge metaphor perfectly captures what the plugin does: crafting powerful tools
- `/forge` is a natural verb command that flows well in usage

## [1.2.0] - 2025-12-29

### Added

- **Eitri Plugin** (originally QuickStart 2.0) - Intelligent extension forge for creating Claude Code extensions
  - Command: `/forge` - Launch the intelligent extension creation workflow
  - Four extension types: Skills, Agents, Agent Suites, and Hybrids
  - Multi-dimensional context discovery engine
  - Domain-specific intelligence (Healthcare, Finance, E-commerce, SaaS, DevOps)
  - Safety rules and validation framework
  - Comprehensive examples and documentation

### Changed

- Updated marketplace to v1.2.0
- Updated owner email to hello@altakleos.com
- Updated README with correct Claude Code plugin structure
- Plugin creation instructions now use `.claude-plugin/plugin.json` and root-level `commands/`

### Removed

- **example-plugin** - Removed deprecated plugin (used non-compliant `.claude/commands/` structure)

### Fixed

- Plugin structure documentation now follows Claude Code standards:
  - `.claude-plugin/plugin.json` for plugin metadata
  - `commands/` at plugin root level (not inside `.claude/`)
  - `skills/` at plugin root level (not inside `.claude/`)

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the initial release of the AltaKleos Claude Code Plugins. The marketplace is now ready for:

- Installing plugins via Claude Code CLI
- Contributing new plugins
- Validating plugin structure and metadata
- Automated testing via GitHub Actions

All critical infrastructure is in place, including comprehensive documentation, validation tools, and security policies.

---

**Note**: This changelog follows [semantic versioning](https://semver.org/). For a detailed list of changes, see the [commit history](https://github.com/altakleos/plugins/commits).
