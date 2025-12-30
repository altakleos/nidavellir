# Plugin Packager - Usage Examples

## Quick Start

The simplest way to use Plugin Packager:

```
Package my-analytics-skill as a plugin
```

Then just answer a few questions and I'll handle everything.

## Common Use Cases

### Use Case 1: Package New Skill for Sharing

**Scenario**: You created a skill with Eitri and want to share it with your team via the marketplace.

```
I just created a skill called "deployment-helper" with Eitri.
Can you package it as a plugin and add it to our marketplace?
```

**What happens**:
- I find the skill
- Ask for author (default: AltaKleos Platform Team)
- Create plugin.json
- Move to plugins/ directory
- Add to marketplace.json
- Stage changes and offer to commit

### Use Case 2: Fix Broken Plugin Structure

**Scenario**: Plugin slash command isn't working, structure might be wrong.

```
My eitri plugin's /forge command isn't showing up.
Can you validate the structure and fix any issues?
```

**What happens**:
- I check plugin.json exists
- Verify commands/ location
- Check version consistency
- Auto-fix any issues found
- Explain what was wrong and what I fixed

### Use Case 3: Add Slash Command to Existing Plugin

**Scenario**: You want to add a new slash command to an existing plugin.

```
Add a /validate command to the plugin-packager plugin.
It should check if a plugin structure is correct.
```

**What happens**:
- I create commands/validate.md at plugin root
- Generate proper command markdown
- Validate placement
- Stage changes

### Use Case 4: Update Plugin Version

**Scenario**: You made changes to a plugin and want to bump the version.

```
Update eitri plugin to version 1.2.0
```

**What happens**:
- I update version in plugin.json
- Update version in SKILL.md
- Update version in marketplace.json
- Verify consistency
- Offer to commit

### Use Case 5: Check If Plugin Structure Is Correct

**Scenario**: Not sure if your plugin follows the right structure.

```
Is my data-pipeline plugin structured correctly?
```

**What happens**:
- I check all structural requirements
- Report what's correct
- Auto-fix any issues
- Explain what I fixed

## Different Ways to Invoke

### Direct Operations

```
Package reporting-skill as a plugin
```

```
Validate the eitri plugin
```

```
Add plugin-packager to the marketplace
```

### With Context

```
I created a skill in .claude/skills/api-monitor/.
Can you turn it into a plugin with version 2.0.0
and add it to our marketplace?
```

### Troubleshooting

```
My plugin commands aren't showing up after install.
What's wrong with the structure?
```

```
Getting manifest conflict errors for my plugin.
Can you fix it?
```

### Batch Operations

```
Check all plugins in plugins/ directory and fix
any structural issues
```

## Conversational Examples

### Example 1: First Time Packaging

**You**: "Package my-skill as a plugin"

**Me**: "Found skill at .claude/skills/my-skill/. Let me package it.

What author should I use?
Default: AltaKleos Platform Team (hello@altakleos.com)
[Press enter for default]"

**You**: [enter]

**Me**: "✓ Created plugin structure with version 1.0.0
✓ Moved to plugins/my-skill/
✓ Structure validated

Add to marketplace?"

**You**: "yes"

**Me**: "Category? (development/productivity/tools/data)"

**You**: "tools"

**Me**: "Keywords? (suggest: automation, utility)"

**You**: "automation, helper, utility"

**Me**: "✓ Added to marketplace.json
✓ All changes staged

Commit with message: 'feat: Add my-skill plugin to marketplace'?"

**You**: "yes"

**Me**: "✓ Committed successfully
Plugin ready! Install with: /plugin install my-skill@altakleos"

### Example 2: Fix Structural Issues

**You**: "Validate eitri"

**Me**: "Checking eitri structure...

Issues found:
❌ Commands in .claude-plugin/commands/ (wrong location)
❌ Version mismatch: plugin.json=1.0.0, SKILL.md=1.1.1

Auto-fixing...
✓ Moved commands/ to root. Claude Code finds commands there.
✓ Synced versions to 1.1.1 across all manifests.

Structure now valid! Commit these fixes?"

**You**: "yes"

**Me**: "✓ Committed: 'fix: Correct plugin structure for eitri'
Done!"

### Example 3: Complex Migration

**You**: "I have a skill at ~/my-projects/cool-skill/. Can you package it
for our marketplace? It's version 2.5.0 and authored by John Doe."

**Me**: "I'll package ~/my-projects/cool-skill/ as a plugin.

Moving to your plugins directory and setting up structure...
✓ Created plugin.json (v2.5.0, author: John Doe)
✓ Copied to plugins/cool-skill/
✓ Structure validated

Original files remain at ~/my-projects/cool-skill/.

Add to marketplace?"

**You**: "yes, it's a productivity tool with keywords: automation, workflow, helper"

**Me**: "✓ Added to marketplace.json
   - Category: productivity
   - Keywords: automation, workflow, helper
✓ Changes staged

Commit?"

**You**: "yes"

**Me**: "✓ Committed successfully
Plugin ready!"

## Tips for Best Results

1. **Be specific about location** if you have skills in multiple places:
   ```
   Package the skill at .claude/skills/my-skill/
   ```

2. **Mention version explicitly** if not using default 1.0.0:
   ```
   Package analytics-tool as a plugin with version 2.0.0
   ```

3. **Specify author** if not using default:
   ```
   Package my-skill authored by John Smith (john@example.com)
   ```

4. **Ask for validation** when unsure:
   ```
   Check if all my plugins are properly structured
   ```

5. **Let me infer** when obvious:
   ```
   Package my-skill
   [I'll ask questions as needed]
   ```

## Common Patterns

### Pattern 1: Eitri → Package → Marketplace

```
Step 1: /forge
[Create skill content with Eitri]

Step 2: Package my-new-skill as a plugin and add to marketplace
[I handle all the packaging]

Step 3: Install and use!
```

### Pattern 2: Fix Existing Plugin

```
My plugin isn't working right. Validate [plugin-name] and fix issues.
```

### Pattern 3: Add Command Later

```
Add a /help command to [plugin-name] that shows usage examples
```

### Pattern 4: Version Updates

```
I updated [plugin-name]. Bump it to version 1.2.0
```

## What I Don't Do

I focus on plugin packaging and structure. I don't:
- Create skill content (use Eitri for that)
- Modify skill logic or functionality
- Handle git operations beyond staging/committing package changes
- Deploy or publish to external registries
- Manage user permissions or marketplace access

For creating skills, use `/forge` with Eitri first, then use me to package them!

## Troubleshooting

**"Can't find my skill"**
- Specify full path: `Package ~/.claude/skills/my-skill/`
- Or I'll show available skills and you pick

**"Validation errors"**
- Just say "validate [plugin-name]" and I'll auto-fix

**"Command still not showing"**
- Make sure commands/ is at plugin root, not .claude-plugin/
- Verify plugin is enabled after install
- Restart Claude Code to pick up changes

**"Version conflicts"**
- I automatically sync versions across manifests
- If issues persist, say "fix versions for [plugin-name]"

## Quick Reference

| Operation | Command |
|-----------|---------|
| Package skill | `Package [skill-name] as a plugin` |
| Validate | `Validate [plugin-name]` |
| Add to marketplace | `Add [plugin-name] to marketplace` |
| Add command | `Add a /[cmd] command to [plugin-name]` |
| Update version | `Update [plugin-name] to version X.Y.Z` |
| Fix structure | `Fix the structure of [plugin-name]` |
| Check all | `Validate all plugins` |

---

**Remember**: I turn the complex plugin packaging process into a simple conversation. Just tell me what you want, and I'll handle the technical details!
