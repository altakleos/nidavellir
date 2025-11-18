# Changelog

All notable changes to the AltaKleos Claude Code Marketplace will be documented in this file.

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

- Additional example plugins
- Enhanced validation scripts
- Plugin testing framework
- Documentation improvements

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the initial release of the AltaKleos Claude Code Marketplace. The marketplace is now ready for:

- Installing plugins via Claude Code CLI
- Contributing new plugins
- Validating plugin structure and metadata
- Automated testing via GitHub Actions

All critical infrastructure is in place, including comprehensive documentation, validation tools, and security policies.

---

**Note**: This changelog follows [semantic versioning](https://semver.org/). For a detailed list of changes, see the [commit history](https://github.com/altakleos/claude-code-marketplace/commits).
