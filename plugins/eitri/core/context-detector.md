# Context Detector

Detect the current working context to determine optimal output location for forged extensions.

## Detection Hierarchy

Check in this order (first match wins):

```
1. Am I inside a plugin directory?
   └─ Look for .claude-plugin/plugin.json in cwd or ancestors
   └─ If found → PLUGIN context

2. Am I in a marketplace repo?
   └─ Look for .claude-plugin/marketplace.json in cwd or ancestors
   └─ If found → MARKETPLACE context

3. Default: PROJECT context
```

## Context Types

### PLUGIN Context

**Detection**: `.claude-plugin/plugin.json` exists in cwd or ancestor directory

**Meaning**: User is working inside an existing plugin

**Default output location by extension type**:
| Extension | Location |
|-----------|----------|
| Skill | `{plugin_root}/skills/{name}/SKILL.md` or `{plugin_root}/SKILL.md` (if first) |
| Command | `{plugin_root}/commands/{name}.md` |
| Agent | `{plugin_root}/agents/{name}.md` |
| Hook | `{plugin_root}/hooks/` |

**User message**:
```
Detected: You're inside the "{plugin_name}" plugin.
Recommended: Add to this plugin → {suggested_path}

[Enter to confirm] or type: new-plugin | project | user
```

### MARKETPLACE Context

**Detection**: `.claude-plugin/marketplace.json` exists in cwd or ancestor directory

**Meaning**: User is in a plugin marketplace repository

**Default output**: Create new plugin at `plugins/{name}/`

**User message**:
```
Detected: You're in the "{marketplace_name}" marketplace.
Recommended: Create new plugin → plugins/{name}/

[Enter to confirm] or type: project | user | <custom-path>
```

### PROJECT Context

**Detection**: Default when no plugin.json or marketplace.json found

**Meaning**: Regular project, not a plugin development context

**Default output by extension type**:
| Extension | Location |
|-----------|----------|
| Skill | `.claude/skills/{name}/SKILL.md` |
| Command | `.claude/commands/{name}.md` |
| Agent | `.claude/agents/{name}.md` |

**User message**:
```
Detected: Regular project.
Recommended: Project-scoped → .claude/skills/{name}/

[Enter to confirm] or type: user | <custom-path>
```

## Detection Logic

```python
def detect_context(cwd):
    """Walk up directory tree to detect context."""
    current = cwd

    while current != current.parent:  # Stop at filesystem root
        # Check for plugin context (highest priority)
        plugin_json = current / ".claude-plugin" / "plugin.json"
        if plugin_json.exists():
            return PluginContext(
                type="plugin",
                root=current,
                name=json.load(plugin_json)["name"]
            )

        # Check for marketplace context
        marketplace_json = current / ".claude-plugin" / "marketplace.json"
        if marketplace_json.exists():
            return MarketplaceContext(
                type="marketplace",
                root=current,
                name=json.load(marketplace_json)["name"],
                plugins_dir=current / "plugins"
            )

        current = current.parent

    # Default: project context
    git_root = find_git_root(cwd)
    return ProjectContext(
        type="project",
        root=git_root or cwd
    )
```

## Override Keywords

Users can override the detected context with these keywords:

| Keyword | Meaning |
|---------|---------|
| `project` | Use `.claude/` in current project |
| `user` or `global` | Use `~/.claude/` for all projects |
| `new-plugin` | Create new plugin (even if in existing plugin) |
| `<path>` | Custom path (absolute or relative) |

## File Existence Checks

Before writing, check if target exists:

```python
def check_target(path):
    if path.exists():
        return f"⚠️  {path} already exists. Overwrite? [y/N]"
    return None
```

## Integration Points

This context detection should be called:
1. **In SKILL.md**: Add awareness of context to main Eitri prompt
2. **In /forge command**: After extension generation, before writing files
3. **In /forge:install command**: To validate user's chosen location
