# AltaKleos Plugin Marketplace

> **Extend Claude Code with powerful plugins.**

The official AltaKleos marketplace for Claude Code plugins. Install extensions that supercharge your development workflow—from AI-assisted code generation to automated documentation.

---

## Quick Start

**1. Add the marketplace** (one-time):
```bash
/plugin marketplace add altakleos/nidavellir
```

**2. Browse and install**:
```bash
/plugin                           # Browse all plugins
/plugin install eitri@altakleos   # Install a plugin
```

That's it. You're ready to go.

---

## Featured: Eitri

> **Forge Claude Code extensions with AI.**

Eitri is an intelligent extension forge that creates precisely optimized Claude Code extensions. Named after the legendary Norse dwarf smith who forged Thor's hammer.

**What Eitri Creates:**
| Extension Type | What It Does |
|----------------|--------------|
| **Skills** | Add new capabilities to Claude Code |
| **Agents** | Specialized sub-agents for complex tasks |
| **Agent Suites** | Coordinated teams of agents working together |
| **Hooks** | Automated actions on tool calls and events |
| **MCP Servers** | Connect Claude to external services |

**Install:**
```bash
/plugin install eitri@altakleos
```

**Use:**
```
/forge                # Start creating an extension
/forge:template       # Quick-start from templates
/forge:validate       # Check your extension
```

[Full Eitri documentation →](plugins/eitri/README.md)

---

## More Plugins

| Plugin | What It Does |
|--------|--------------|
| **[Rune](plugins/rune/README.md)** | Generate beautiful Mermaid and ASCII diagrams that just work |
| **[Skuld](plugins/skuld/README.md)** | Guided estate document preparation with state-specific rules |

---

## Installation Options

### Per-Session Install
```bash
/plugin install plugin-name@altakleos
```

### Project Auto-Install

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "altakleos": {
      "source": {
        "source": "github",
        "repo": "altakleos/nidavellir"
      }
    }
  },
  "enabledPlugins": [
    "eitri@altakleos"
  ]
}
```

Plugins install automatically when team members trust the project folder.

---

## Prerequisites

Authenticate with GitHub once:

```bash
# Using GitHub CLI (recommended)
gh auth login

# Or using SSH keys
# See: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
```

---

## Resources

- [Claude Code Plugins Documentation](https://docs.claude.com/en/docs/claude-code/plugins)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)

## Support

- GitHub Issues: [Create an issue](https://github.com/altakleos/nidavellir/issues)
- Email: hello@altakleos.com

---

**License:** MIT
