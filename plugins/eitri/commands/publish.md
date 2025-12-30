---
name: publish
description: Publish extensions to Claude Code marketplaces with guided workflow
---

# Publish Command

This command guides you through publishing extensions to Claude Code marketplaces.

## What It Does

When you run `/forge:publish`, I will:

1. **Validate your extension** - Ensure it meets marketplace requirements
2. **Generate marketplace metadata** - Create or update marketplace.json entry
3. **Prepare git release** - Create proper tags and release notes
4. **Guide submission** - Walk through marketplace submission process
5. **Verify publication** - Confirm the extension is discoverable

## How to Use

### Publish Current Extension

```
/forge:publish
```

Publishes the extension in the current directory.

### Publish to Specific Marketplace

```
/forge:publish --marketplace skillsmp
```

Targets a specific marketplace (skillsmp, claude-plugins-dev, custom).

### Dry Run

```
/forge:publish --dry-run
```

Shows what would happen without making changes.

## Publication Workflow

### Step 1: Pre-Publication Validation

```
Pre-Publication Check
=====================

Extension: my-awesome-skill
Version: 1.0.0
Type: Skill

Marketplace Requirements:
  ✓ SKILL.md present and valid
  ✓ Name follows conventions (lowercase, hyphens)
  ✓ Description is clear and specific
  ✓ Version is semantic (1.0.0)
  ✓ No hardcoded secrets
  ✓ README.md present
  ✗ LICENSE file missing (required for public marketplaces)

Issues to fix:
  1. Add LICENSE file (MIT, Apache-2.0, or other OSI-approved)

Fix issues and run again, or use --skip-license for private marketplaces.
```

### Step 2: Marketplace Entry Generation

```
Generating Marketplace Entry
============================

Plugin information:
  Name: my-awesome-skill
  Version: 1.0.0
  Description: A skill that does awesome things
  Category: development

Detected keywords: awesome, skill, automation

Generated marketplace.json entry:

{
  "name": "my-awesome-skill",
  "source": "https://github.com/user/my-awesome-skill",
  "description": "A skill that does awesome things",
  "version": "1.0.0",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "category": "development",
  "keywords": ["awesome", "skill", "automation"]
}

Edit this entry? [y/N]:
```

### Step 3: Git Release Preparation

```
Preparing Git Release
=====================

Current state:
  ✓ Working directory clean
  ✓ On main branch
  ✓ Up to date with remote

Creating release:
  Tag: v1.0.0
  Title: my-awesome-skill v1.0.0

Release notes (auto-generated):

## my-awesome-skill v1.0.0

Initial release.

### Features
- Awesome thing 1
- Awesome thing 2

### Installation
```
claude plugins add user/my-awesome-skill
```

Edit release notes? [y/N]:

Creating tag v1.0.0...
  ✓ Tag created locally

Push to remote? [Y/n]: y
  ✓ Tag pushed to origin
```

### Step 4: Marketplace Submission

```
Marketplace Submission
======================

Target: SkillsMP (skillsmp.com)

Submission options:

1. Auto-submit via GitHub
   - Create PR to marketplace registry
   - Automated review process
   - ~24-48 hours for approval

2. Manual submission
   - Copy marketplace.json entry
   - Submit via web form
   - Faster for urgent submissions

Select option [1]:

Creating PR to skillsmp/registry...
  ✓ Forked registry
  ✓ Added entry to plugins.json
  ✓ Created PR #1234

PR created: https://github.com/skillsmp/registry/pull/1234

Next steps:
  1. Wait for automated checks to pass
  2. Respond to any reviewer feedback
  3. Extension will be live after merge
```

### Step 5: Verification

```
Post-Publication Verification
=============================

Checking marketplace listing...

⏳ Pending (PR not yet merged)

Run '/forge:publish --status' to check again later.

After merge, verify:
  - Search for "my-awesome-skill" on marketplace
  - Test installation: claude plugins add user/my-awesome-skill
  - Verify README displays correctly
```

## Marketplace Options

### SkillsMP (skillsmp.com)

The largest marketplace with 25,000+ skills.

```
/forge:publish --marketplace skillsmp
```

**Requirements:**
- Public GitHub repository
- MIT, Apache-2.0, or similar license
- README.md with usage instructions
- No hardcoded secrets

### claude-plugins.dev

Community-indexed marketplace.

```
/forge:publish --marketplace claude-plugins-dev
```

**Requirements:**
- Public GitHub repository
- Valid plugin.json or SKILL.md
- Git tags for versions

### Private/Custom Marketplace

For internal or custom marketplaces.

```
/forge:publish --marketplace custom --registry https://your-registry.com
```

## Required Files

For successful publication:

| File | Required | Purpose |
|------|----------|---------|
| `SKILL.md` | Yes | Extension definition |
| `README.md` | Yes | Usage documentation |
| `LICENSE` | Yes* | Legal terms (*public only) |
| `.claude-plugin/plugin.json` | For plugins | Plugin metadata |
| `marketplace.json` | Generated | Marketplace entry |

## Versioning

Use semantic versioning for releases:

| Version | When to Use |
|---------|-------------|
| 1.0.0 | Initial public release |
| 1.0.1 | Bug fixes |
| 1.1.0 | New features (backward compatible) |
| 2.0.0 | Breaking changes |

## Publication Checklist

Before publishing, ensure:

- [ ] Extension passes `/forge:validate --strict`
- [ ] README.md explains usage clearly
- [ ] LICENSE file present (for public marketplaces)
- [ ] No secrets or credentials in code
- [ ] Version numbers are consistent
- [ ] Git repository is public (for public marketplaces)
- [ ] Git tags follow v1.0.0 format

## Options Reference

| Option | Description |
|--------|-------------|
| `--marketplace <name>` | Target marketplace (skillsmp, claude-plugins-dev, custom) |
| `--registry <url>` | Custom registry URL |
| `--dry-run` | Show changes without making them |
| `--skip-license` | Skip license check (private only) |
| `--status` | Check publication status |
| `--update` | Update existing listing |

## Updating Published Extensions

To update an already-published extension:

```
/forge:publish --update
```

This will:
1. Validate the new version
2. Create new git tag
3. Update marketplace entry
4. Submit update PR

## Troubleshooting

### "Repository not found"
- Ensure GitHub repository is public
- Check repository URL in marketplace.json

### "Version already exists"
- Bump version in SKILL.md and plugin.json
- Use `/forge:upgrade --bump patch`

### "Validation failed"
- Run `/forge:validate --strict`
- Fix all errors before retrying

### "PR rejected"
- Check reviewer comments
- Common issues: missing docs, unclear description, license problems

## Best Practices

1. **Write good descriptions** - Clear, specific, searchable
2. **Include examples** - Show how to use the extension
3. **Add keywords** - Help users find your extension
4. **Keep README updated** - Document all features
5. **Respond to feedback** - Address reviewer comments quickly
6. **Version properly** - Follow semantic versioning
7. **Test before publishing** - Ensure everything works

Ready to publish? Run `/forge:publish --dry-run` first!
