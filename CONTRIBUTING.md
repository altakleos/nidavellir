# Contributing to AltaKleos Claude Code Marketplace

Thank you for your interest in contributing to the AltaKleos Claude Code Marketplace! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Plugin Development Guidelines](#plugin-development-guidelines)
- [Submission Process](#submission-process)
- [Review Process](#review-process)

## Code of Conduct

By participating in this project, you agree to:

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other contributors

## Getting Started

### Prerequisites

- Git installed and configured
- GitHub account with access to AltaKleos organization
- Claude Code CLI installed
- Familiarity with markdown and JSON

### Initial Setup

1. Clone the repository:
   ```bash
   git clone git@github.com:altakleos/claude-code-marketplace.git
   cd claude-code-marketplace
   ```

2. Create a feature branch:
   ```bash
   git checkout -b feature/your-plugin-name
   ```

## How to Contribute

### Reporting Bugs

- Use the GitHub issue tracker
- Search existing issues first
- Provide detailed reproduction steps
- Include relevant version information

### Suggesting Enhancements

- Open an issue with the "enhancement" label
- Clearly describe the proposed feature
- Explain the use case and benefits

### Adding New Plugins

This is the most common contribution type. See [Plugin Development Guidelines](#plugin-development-guidelines) below.

## Plugin Development Guidelines

### Plugin Structure

Every plugin must follow this structure:

```
plugins/your-plugin-name/
├── plugin.json          # Required: Plugin metadata
├── README.md            # Required: Documentation
└── .claude/
    ├── commands/        # Optional: Slash commands
    │   └── *.md
    └── skills/          # Optional: Skills
        └── *.md
```

### Plugin Metadata (plugin.json)

Your `plugin.json` must validate against `/schemas/plugin.schema.json`:

```json
{
  "name": "your-plugin-name",
  "version": "1.0.0",
  "description": "Clear description of what your plugin does (10-500 chars)",
  "author": {
    "name": "Your Name",
    "email": "your.email@altakleos.com"
  },
  "keywords": ["keyword1", "keyword2"],
  "category": "productivity",
  "license": "MIT"
}
```

**Required Fields:**
- `name`: lowercase, hyphens allowed, no spaces
- `version`: Semantic versioning (MAJOR.MINOR.PATCH)
- `description`: 10-500 characters
- `author.name` and `author.email`

**Valid Categories:**
- productivity
- development
- testing
- documentation
- security
- ai-assistance
- utilities
- integration
- other

### README Requirements

Every plugin must include a comprehensive README.md with:

1. **Title and Description**: What the plugin does
2. **Installation**: How to install it
3. **Usage**: Examples of commands/skills
4. **Configuration**: Any settings or prerequisites
5. **License**: Should match plugin.json

See `/plugins/example-plugin/README.md` for a template.

### Commands

Slash commands should:

- Have a clear, single purpose
- Include description in frontmatter
- Provide helpful error messages
- Be well-documented in the plugin README

Example:
```markdown
---
description: Brief description of what this command does
---

Command instructions for Claude...
```

### Skills

Skills should:

- Have descriptive names
- Specify `skillType` (proactive or reactive)
- Include clear activation criteria
- Be documented in the plugin README

### Testing Your Plugin

Before submitting:

1. **Validate JSON**:
   ```bash
   npm run validate
   ```

2. **Test Locally**:
   ```bash
   /plugin marketplace add /path/to/claude-code-marketplace
   /plugin install your-plugin-name@altakleos
   ```

3. **Test All Features**:
   - Run all commands
   - Verify skills activate correctly
   - Check for errors in logs

## Submission Process

### 1. Prepare Your Plugin

- [ ] Plugin structure follows guidelines
- [ ] `plugin.json` validates against schema
- [ ] README.md is complete and clear
- [ ] All commands/skills tested locally
- [ ] No sensitive information (API keys, secrets)

### 2. Update Marketplace

Add your plugin to `.claude-plugin/marketplace.json`:

```json
{
  "name": "your-plugin-name",
  "source": "./plugins/your-plugin-name",
  "description": "Same as plugin.json description",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "your.email@altakleos.com"
  },
  "category": "productivity",
  "keywords": ["keyword1", "keyword2"]
}
```

### 3. Commit Your Changes

```bash
git add plugins/your-plugin-name
git add .claude-plugin/marketplace.json
git commit -m "Add your-plugin-name plugin"
```

Follow commit message conventions:
- `feat: Add new plugin for X`
- `fix: Correct bug in Y plugin`
- `docs: Update README for Z plugin`
- `chore: Update dependencies`

### 4. Push and Create PR

```bash
git push -u origin feature/your-plugin-name
gh pr create --title "Add your-plugin-name plugin" --body "Description of the plugin"
```

## Review Process

### What We Check

1. **Functionality**: Does it work as described?
2. **Security**: No vulnerabilities or malicious code
3. **Quality**: Clean, maintainable code
4. **Documentation**: Clear and complete
5. **Schema Compliance**: Passes validation
6. **Naming**: No conflicts with existing plugins

### Timeline

- Initial review: 2-3 business days
- Feedback/revision cycle: Varies
- Merge: After approval from 1+ maintainers

### After Approval

- Your plugin will be merged to the main branch
- Users can install it via `/plugin install your-plugin-name@altakleos`
- You become a contributor!

## Plugin Maintenance

### Updating Your Plugin

1. Create a new branch: `git checkout -b update/your-plugin-name`
2. Make changes
3. Update version in `plugin.json` (follow semver)
4. Update version in `.claude-plugin/marketplace.json`
5. Update CHANGELOG.md
6. Submit PR with changes

### Versioning

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Deprecation

If deprecating features:
1. Mark as deprecated in docs
2. Provide migration guide
3. Set timeline for removal
4. Update in next MAJOR version

## Questions?

- Email: admin@altakleos.com
- GitHub Issues: For bugs and feature requests
- Internal Docs: See AltaKleos Vault

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
