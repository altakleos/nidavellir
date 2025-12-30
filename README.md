# AltaKleos Claude Code Marketplace

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Validation](https://github.com/altakleos/claude-code-marketplace/workflows/Validate%20Marketplace/badge.svg)

Private marketplace for internal AltaKleos development tools and Claude Code plugins.

## Quick Links

- [Installation](#for-users-installing-plugins)
- [Contributing](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)
- [Available Plugins](#available-plugins)

## Repository Structure

This repository contains the AltaKleos Claude Code plugin marketplace:

```
claude-code-marketplace/
├── .claude-plugin/        # Marketplace configuration
│   └── marketplace.json   # Plugin registry
├── .github/               # GitHub templates and workflows
├── plugins/               # Plugin directory
│   └── quickstart/        # Intelligent skill factory plugin
├── schemas/               # JSON validation schemas
├── scripts/               # Validation and utility scripts
├── CONTRIBUTING.md        # Contribution guidelines
├── SECURITY.md           # Security policy
└── README.md             # This file
```

## For Users: Installing Plugins

### Prerequisites

Authenticate with GitHub (one-time setup):

```bash
# Option A: GitHub CLI (recommended)
gh auth login

# Option B: SSH keys
# Follow: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
```

### Install the Marketplace

```bash
# Add the AltaKleos marketplace
/plugin marketplace add altakleos/claude-code-marketplace

# Verify it's added
/plugin marketplace list
```

### Browse and Install Plugins

```bash
# Browse all available plugins interactively
/plugin

# Install a specific plugin
/plugin install plugin-name@altakleos
```

### Auto-Install for Projects

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "altakleos": {
      "source": {
        "source": "github",
        "repo": "altakleos/claude-code-marketplace"
      }
    }
  },
  "enabledPlugins": [
    "your-plugin-name@altakleos"
  ]
}
```

When team members trust the project folder, plugins install automatically.

## Available Plugins

### quickstart

Intelligent skill factory that creates precisely optimized Claude Code extensions through deep contextual understanding and adaptive intelligence.

- **Version**: 1.1.1
- **Category**: Development
- **Installation**: `/plugin install quickstart@altakleos`
- **Command**: `/create-skill` - Launch the intelligent skill creation workflow

[View Plugin Documentation](plugins/quickstart/HOW_TO_USE.md)

## For Contributors: Developing Plugins

### Initial Setup

```bash
# Clone the repository
git clone git@github.com:altakleos/claude-code-marketplace.git
cd claude-code-marketplace

# Create a feature branch
git checkout -b feature/your-plugin-name
```

### Development Workflow

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

Quick overview:

1. Create plugin in `plugins/your-plugin-name/`
2. Add entry to `.claude-plugin/marketplace.json`
3. Test locally
4. Submit pull request

## Adding New Plugins

### 1. Create Plugin Structure

```bash
# Create plugin directory
cd plugins
mkdir my-new-plugin
cd my-new-plugin

# Create plugin directory structure
mkdir -p .claude-plugin

# Create plugin.json in .claude-plugin/
cat > .claude-plugin/plugin.json << 'EOF'
{
  "name": "my-new-plugin",
  "version": "1.0.0",
  "description": "Description of what the plugin does (10-500 chars)",
  "author": {
    "name": "Your Name",
    "email": "your.email@altakleos.com"
  },
  "keywords": ["keyword1", "keyword2"],
  "category": "productivity",
  "license": "MIT"
}
EOF

# Create README.md
cat > README.md << 'EOF'
# My New Plugin

Brief description of the plugin.

## Installation

\`\`\`bash
/plugin install my-new-plugin@altakleos
\`\`\`

## Usage

Describe how to use the plugin.
EOF

# Add plugin files (commands, skills, etc.)
mkdir -p .claude-plugin commands skills
```

### 2. Add to Marketplace

Edit `.claude-plugin/marketplace.json` to add your plugin:

```json
{
  "plugins": [
    {
      "name": "my-new-plugin",
      "source": "./plugins/my-new-plugin",
      "description": "Description of what the plugin does and when to use it",
      "version": "1.0.0",
      "author": {
        "name": "Your Name",
        "email": "your.email@altakleos.com"
      },
      "category": "productivity",
      "keywords": ["keyword1", "keyword2"]
    }
  ]
}
```

### 3. Test Locally

```bash
# Return to repository root
cd /path/to/claude-code-marketplace

# Run validation
npm run validate

# Add local marketplace for testing
/plugin marketplace add /path/to/claude-code-marketplace

# Install and test your plugin
/plugin install my-new-plugin@altakleos

# Test all commands and features
```

### 4. Commit and Push

```bash
git add plugins/my-new-plugin
git add .claude-plugin/marketplace.json
git commit -m "feat: Add my-new-plugin to marketplace"
git push -u origin feature/your-plugin-name
```

### 5. Create Pull Request

```bash
# Using GitHub CLI
gh pr create --title "Add my-new-plugin" --body "Description of the plugin and what it does"

# Or create PR on GitHub web interface
```

## Validation

Validate your changes before submitting:

```bash
# Run validation script
npm run validate

# Or directly
./scripts/validate.sh
```

This checks:
- JSON syntax validity
- Schema compliance
- Required files presence
- Version consistency

## Troubleshooting

### Can't Access Repository

**Error**: "Permission denied" or "Repository not found"

**Solution**:
```bash
# Test GitHub authentication
gh auth status

# Or test SSH
ssh -T git@github.com

# Verify repository access
git ls-remote git@github.com:altakleos/claude-code-marketplace.git
```

### Marketplace Not Loading

**Error**: Claude Code can't find plugins

**Solution**:
```bash
# Verify marketplace structure
cat .claude-plugin/marketplace.json

# Validate marketplace
npm run validate

# Test local marketplace (adjust path)
/plugin marketplace add /path/to/claude-code-marketplace
/plugin marketplace list
```

### Validation Failures

**Error**: Schema validation fails

**Solution**:
```bash
# Run validation to see specific errors
npm run validate

# Check JSON syntax
jq . .claude-plugin/marketplace.json
jq . plugins/*/plugin.json
```

### Plugin Installation Fails

**Error**: Can't install plugin from marketplace

**Solution**:
```bash
# Verify plugin exists in marketplace.json
jq '.plugins[] | select(.name=="plugin-name")' .claude-plugin/marketplace.json

# Check plugin directory exists
ls -la plugins/plugin-name/

# Verify plugin.json is valid
jq . plugins/plugin-name/plugin.json
```

## Best Practices

1. **Use descriptive branch names**: `feature/auth-helper`, `fix/marketplace-bug`, `docs/update-readme`
2. **Keep main stable**: Only merge tested, reviewed code
3. **Document plugins**: Add clear descriptions and usage examples in README.md
4. **Test locally first**: Always validate and test plugins before pushing
5. **Follow semver**: Use semantic versioning for plugin releases
6. **Security first**: Never commit secrets, API keys, or sensitive data
7. **Validate before commit**: Run `npm run validate` before every commit

## Resources

- [Claude Code Plugins Documentation](https://docs.claude.com/en/docs/claude-code/plugins)
- [Claude Code Plugin Marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)

## Support

For questions or issues:
- Email: hello@altakleos.com
- GitHub Issues: [Create an issue](https://github.com/altakleos/claude-code-marketplace/issues)
- Internal Documentation: See AltaKleos Vault

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
