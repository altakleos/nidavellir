# Plugin Packager - How to Use

## What This Skill Does

Plugin Packager automates the tedious work of packaging Claude Code skills into properly structured plugins and managing them in your marketplace. It handles all the structural requirements, validation, and common issues so you don't have to.

## Quick Start (30 seconds)

1. Create a skill with Eitri: `/forge`
2. Package it: "Package my-skill as a plugin"
3. Done! Your plugin is ready to install

## When to Use This Skill

**Use Plugin Packager when you want to**:
- ✅ Share a skill with your team via marketplace
- ✅ Add slash commands to skills/plugins
- ✅ Fix plugin structural issues
- ✅ Validate plugin structure is correct
- ✅ Update plugin versions consistently

**Don't need it for**:
- Creating skill content (use Eitri)
- Using plugins (just install them)
- Local-only skills that won't be shared

## The Typical Workflow

```
Eitri → Creates skill content
     ↓
Plugin Packager → Adds plugin structure
     ↓
Marketplace → Ready to install
```

## Core Operations

### 1. Package Skill → Plugin

**What it does**: Takes any skill and transforms it into a properly structured plugin.

**Say this**:
```
Package [skill-name] as a plugin
```

**What happens**:
- Creates `.claude-plugin/plugin.json` with metadata
- Moves skill to `plugins/` directory
- Validates structure
- Optionally adds to marketplace

**Example**:
```
Package data-analyzer as a plugin
```

### 2. Validate Plugin Structure

**What it does**: Checks if plugin follows correct structure and auto-fixes issues.

**Say this**:
```
Validate [plugin-name]
```

**What it checks**:
- plugin.json exists with required fields
- Commands in correct location (plugin root, not .claude-plugin/)
- Version consistency across manifests
- Proper naming (kebab-case)

**Example**:
```
Validate eitri
```

### 3. Add to Marketplace

**What it does**: Registers plugin in your marketplace.json with proper metadata.

**Say this**:
```
Add [plugin-name] to marketplace
```

**What it does**:
- Validates plugin structure first
- Adds entry to marketplace.json
- Sets category and keywords
- Ensures no manifest conflicts

**Example**:
```
Add plugin-packager to marketplace
```

### 4. Add Slash Command

**What it does**: Creates a new slash command for a plugin in the correct location.

**Say this**:
```
Add a /[command] command to [plugin-name]
```

**What it does**:
- Creates `commands/[command].md` at plugin root
- Generates proper command markdown
- Validates placement

**Example**:
```
Add a /validate command to plugin-packager
```

### 5. Update Version

**What it does**: Updates version consistently across all manifests.

**Say this**:
```
Update [plugin-name] to version X.Y.Z
```

**What it does**:
- Updates plugin.json
- Updates SKILL.md frontmatter
- Updates marketplace.json entry
- Verifies consistency

**Example**:
```
Update eitri to version 1.2.0
```

## Understanding Plugin Structure

### What Plugin Packager Creates

```
plugins/your-plugin/
├── .claude-plugin/
│   └── plugin.json          ← Plugin metadata (required)
├── commands/                 ← Slash commands (optional, at root!)
│   └── command-name.md
├── SKILL.md                 ← Your skill content
└── other files...           ← Supporting files
```

### Critical Rules It Enforces

1. **Commands location**: Must be `commands/` at plugin root
   - ❌ NOT: `.claude-plugin/commands/`
   - ✅ YES: `commands/` at plugin root

2. **Version consistency**: Same version everywhere
   - plugin.json
   - SKILL.md frontmatter
   - marketplace.json

3. **No manifest conflicts**: With `strict: false`
   - Component specs in plugin.json only
   - Not in marketplace.json

## Auto-Fix Capabilities

Plugin Packager automatically fixes these common issues:

- ✓ Missing plugin.json → Creates it
- ✓ Commands in wrong location → Moves them
- ✓ Version mismatches → Syncs versions
- ✓ Invalid naming → Fixes to kebab-case
- ✓ Manifest conflicts → Removes duplicate specs

**Example**:
```
You: "Validate eitri"

Me: "Issues found:
❌ Commands in .claude-plugin/commands/
❌ Version mismatch

Auto-fixing...
✓ Moved commands/ to root
✓ Synced versions

Done!"
```

## Smart Defaults

**Version**: Starts at 1.0.0 for new plugins

**Author**: Asks with default:
- Default: AltaKleos Platform Team (hello@altakleos.com)
- Just press Enter to use default
- Or type custom author

**Marketplace**: Infers from context:
- New plugin → Asks if you want to add
- Existing plugin → Doesn't ask (assumes update)
- Unclear → Asks explicitly

## Example Conversations

### Example 1: Simple Package

```
You: Package my-skill as a plugin

Me: Found skill. What author?
    Default: AltaKleos Platform Team

You: [enter]

Me: ✓ Created plugin structure
    ✓ Structure validated
    Add to marketplace?

You: yes

Me: ✓ Added to marketplace
    ✓ Changes staged
    Commit?

You: yes

Me: ✓ Done! Plugin ready.
```

### Example 2: Fix Issues

```
You: My plugin command isn't working. Check it.

Me: Checking structure...
    ❌ Commands in wrong location

    Auto-fixing...
    ✓ Moved to correct location

    Fixed! Commit?

You: yes

Me: ✓ Committed. Try installing again.
```

## Integration with Your Workflow

### With Eitri

```
Step 1: /forge
[Eitri creates skill content]

Step 2: Package [skill-name] as a plugin
[Plugin Packager adds structure]

Step 3: Install and use!
```

### With Git

Plugin Packager integrates with your git workflow:
- Stages changes automatically
- Suggests clear commit messages
- You can review and revert if needed
- Trusts you have git for safety (no excessive backups)

### With Marketplace

```
Package → Validate → Add to marketplace → Install
```

All in one conversation!

## Tips & Best Practices

### Tip 1: Let It Infer

Don't overthink - just say what you want:
```
✓ "Package my-skill"
✓ "Validate eitri"
✓ "Add this to marketplace"
```

I'll ask questions if I need clarification.

### Tip 2: Trust the Auto-Fix

When validation finds issues, I fix them automatically. You can trust the fixes because:
- They're based on Claude Code's official requirements
- You have git to revert if needed
- I explain what I'm fixing and why

### Tip 3: Check Before Sharing

Before adding to marketplace:
```
Validate [plugin-name]
```

Ensures structure is correct and won't cause issues for team.

### Tip 4: Version Consistently

Let me handle versions:
```
Update [plugin-name] to version 1.2.0
```

I'll update everywhere consistently.

## Common Issues & Solutions

**Issue**: "Slash command not appearing after install"
**Solution**: `Validate [plugin-name]` - probably wrong commands/ location

**Issue**: "Manifest conflict error"
**Solution**: I'll remove duplicate component specs automatically

**Issue**: "Version mismatch warnings"
**Solution**: I sync versions across all manifests automatically

**Issue**: "Can't find my skill"
**Solution**: Specify path: `Package ~/.claude/skills/my-skill/`

## What Makes This Different

Unlike manual packaging, Plugin Packager:

- ✅ **Knows the rules**: Built with deep knowledge of Claude Code requirements
- ✅ **Auto-fixes issues**: Doesn't just report problems, fixes them
- ✅ **Educates briefly**: Explains what's happening and why
- ✅ **Context-aware**: Infers what you want from situation
- ✅ **Git-integrated**: Works naturally with your workflow
- ✅ **Conversational**: No rigid commands or forms

## Quick Reference Card

| Want to... | Say this... |
|------------|-------------|
| Package skill | `Package [name] as a plugin` |
| Fix issues | `Validate [name]` |
| Add to marketplace | `Add [name] to marketplace` |
| Add command | `Add /[cmd] to [name]` |
| Update version | `Update [name] to X.Y.Z` |
| Check structure | `Is [name] structured correctly?` |

## Getting Help

**Need clarification?** Just ask:
- "What's wrong with my plugin structure?"
- "Why do commands need to be at the root?"
- "What's the correct plugin structure?"

I'll explain in clear terms.

## Next Steps

Ready to package your first plugin?

1. Make sure you have a skill (use `/forge` if not)
2. Say: `Package [skill-name] as a plugin`
3. Answer a couple questions
4. Done!

Your skill is now a properly structured, validated, marketplace-ready plugin. 🚀

---

**Remember**: I handle the complexity. You focus on creating great skills. Let's package something!
