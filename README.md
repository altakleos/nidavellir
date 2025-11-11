# AltaKleos Claude Code Marketplace

Private marketplace for internal AltaKleos development tools and Claude Code plugins.

## Repository Structure

This repository uses **git worktrees** for parallel branch development:

```
claude-plugins/
├── .git/              # Bare repository (git history)
├── main/              # Worktree: production marketplace
├── develop/           # Worktree: staging/development
└── feature-*/         # Worktrees: feature branches
```

Each directory is an independent working tree, all sharing the same git history. This allows you to work on multiple branches simultaneously without switching contexts.

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

## For Contributors: Developing Plugins

### Initial Setup

```bash
# Clone the repository
cd ~/workspace/platform
git clone git@github.com:altakleos/claude-code-marketplace.git claude-plugins
cd claude-plugins

# Add develop worktree (if not exists)
git worktree add develop origin/develop

# List all worktrees
git worktree list
```

### Working with Worktrees

#### Create a Feature Branch Worktree

```bash
# From claude-plugins/ directory
git worktree add feature-new-plugin -b feature-new-plugin

# Work in the new worktree
cd feature-new-plugin
# Make changes, test, commit
git add .
git commit -m "Add new plugin"
git push -u origin feature-new-plugin
```

#### Switch Between Worktrees

```bash
# Work on production
cd ~/workspace/platform/claude-plugins/main

# Switch to development
cd ~/workspace/platform/claude-plugins/develop

# Switch to feature
cd ~/workspace/platform/claude-plugins/feature-new-plugin
```

#### Remove a Worktree

```bash
# From claude-plugins/ directory
git worktree remove feature-new-plugin

# Or force remove if needed
git worktree remove --force feature-new-plugin
```

### Git Worktree Quick Reference

```bash
# List all worktrees
git worktree list

# Add new worktree from existing branch
git worktree add <path> <existing-branch>

# Add new worktree with new branch
git worktree add <path> -b <new-branch>

# Remove worktree
git worktree remove <path>

# Prune stale worktrees
git worktree prune

# Move worktree
git worktree move <old-path> <new-path>
```

## Adding New Plugins

### 1. Create Plugin Structure

```bash
# In your worktree (e.g., develop/ or feature-*)
cd plugins
mkdir my-new-plugin
cd my-new-plugin

# Create plugin.json (optional if using marketplace entry)
cat > plugin.json << 'EOF'
{
  "name": "my-new-plugin",
  "version": "1.0.0",
  "description": "Description of what the plugin does",
  "author": {
    "name": "Your Name",
    "email": "your.email@altakleos.com"
  }
}
EOF

# Add plugin files (commands, skills, etc.)
```

### 2. Add to Marketplace

Edit `.claude-plugin/marketplace.json`:

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
# Add local marketplace for testing
/plugin marketplace add ~/workspace/platform/claude-plugins/develop

# Install and test your plugin
/plugin install my-new-plugin@altakleos
```

### 4. Commit and Push

```bash
git add .
git commit -m "Add my-new-plugin to marketplace"
git push
```

### 5. Create Pull Request

```bash
# Using GitHub CLI
gh pr create --title "Add my-new-plugin" --body "Description of the plugin and what it does"

# Or create PR on GitHub web interface
```

## Workflow Patterns

### Pattern 1: Quick Fix (Hotfix)

```bash
# Create hotfix worktree from main
git worktree add hotfix-urgent main

# Make fix
cd hotfix-urgent
# ... fix the issue ...
git add .
git commit -m "Fix critical marketplace loading bug"
git push -u origin hotfix-urgent

# Create PR, merge, then clean up
cd ..
git worktree remove hotfix-urgent
```

### Pattern 2: Feature Development

```bash
# Create feature worktree
git worktree add feature-auth-plugin -b feature-auth-plugin

# Develop over time
cd feature-auth-plugin
# ... multiple commits ...

# When ready, create PR
gh pr create

# After merge, clean up
cd ..
git worktree remove feature-auth-plugin
```

### Pattern 3: Parallel Development

```bash
# Work on multiple features simultaneously
git worktree add feature-a -b feature-a
git worktree add feature-b -b feature-b

# Terminal 1
cd feature-a
# ... work on feature A ...

# Terminal 2
cd feature-b
# ... work on feature B ...

# Each has independent working state!
```

## Troubleshooting

### Can't Access Repository

**Error**: "Permission denied" or "Repository not found"

**Solution**:
```bash
# Test GitHub authentication
gh auth status

# Or test SSH
ssh -T git@github.com

# Test manual clone
git clone git@github.com:altakleos/claude-code-marketplace.git /tmp/test
rm -rf /tmp/test
```

### Marketplace Not Loading

**Error**: Claude Code can't find plugins

**Solution**:
```bash
# Verify marketplace structure
cat .claude-plugin/marketplace.json

# Validate JSON syntax
claude plugin validate .

# Test local marketplace
/plugin marketplace add ~/workspace/platform/claude-plugins/main
/plugin marketplace list
```

### Worktree Issues

**Error**: "fatal: 'path' is already checked out"

**Solution**: Can't have the same branch checked out in multiple worktrees. Either:
- Use different branches for each worktree
- Remove the old worktree first: `git worktree remove <path>`

## Best Practices

1. **Use descriptive branch names**: `feature-auth-helper`, `fix-marketplace-bug`, `docs-update-readme`
2. **Keep main stable**: Only merge tested, reviewed code
3. **Use develop for integration**: Merge features to develop first, then to main
4. **Clean up old worktrees**: Remove feature worktrees after merging PRs
5. **Document plugins**: Add clear descriptions and usage examples
6. **Test locally first**: Always test plugins in your local marketplace before pushing

## Resources

- [Claude Code Plugins Documentation](https://docs.anthropic.com/en/docs/claude-code/plugins)
- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Claude Code Plugin Marketplaces](https://docs.anthropic.com/en/docs/claude-code/plugin-marketplaces)

## Support

For questions or issues:
- Email: admin@altakleos.com
- GitHub Issues: Create an issue in this repository
- Internal Documentation: See AltaKleos Vault
