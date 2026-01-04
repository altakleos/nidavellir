---
name: eitri:export
description: Export Eitri extensions to Agent Skills standard format for cross-platform compatibility
---

# Export Command

This command exports Eitri-generated extensions to the Agent Skills open standard format, enabling cross-platform compatibility with GitHub Copilot, OpenAI Codex, and other AI coding assistants.

## What It Does

When you run `/forge:export`, I will:

1. **Locate the extension** - Find SKILL.md, AGENT.md, or plugin structure
2. **Parse metadata** - Extract frontmatter and content
3. **Translate format** - Convert Eitri-specific fields to standard format
4. **Copy supporting files** - Include scripts, references, and templates
5. **Validate output** - Ensure compliance with Agent Skills specification
6. **Report results** - Show what was exported and where

## Why Export?

The Agent Skills open standard (December 2025) is adopted by:
- **GitHub Copilot** - `.github/skills/` directory
- **OpenAI Codex CLI** - `.codex/skills/` directory
- **Claude Code** - `.claude/skills/` directory

Exporting lets you share Eitri-generated extensions across these platforms.

## How to Use

### Export Current Extension

```
/forge:export
```

Exports the extension in the current directory to `.github/skills/<name>/`.

### Export Specific Path

```
/forge:export ./plugins/my-skill
```

Exports the extension at the specified path.

### Export to Custom Location

```
/forge:export --target=./exported-skills/
```

Exports to a custom directory instead of `.github/skills/`.

### Preview Without Writing

```
/forge:export --dry-run
```

Shows what would be exported without creating files.

## Export Formats

### Agent Skills Standard (Default)

The universal format compatible with all platforms:

```
/forge:export --format=agent-skills
```

**Output location:** `.github/skills/<name>/`

### GitHub Copilot Optimized

Optimized for GitHub Copilot with Copilot-specific hints:

```
/forge:export --format=copilot
```

**Output location:** `.github/skills/<name>/`

### OpenAI Codex Optimized

Optimized for OpenAI Codex CLI:

```
/forge:export --format=codex
```

**Output location:** `.codex/skills/<name>/`

## Metadata Translation

Eitri extensions have rich metadata. When exporting, fields are translated:

### Preserved Fields

| Eitri Field | Standard Field | Notes |
|-------------|----------------|-------|
| `name` | `name` | Direct copy |
| `description` | `description` | Direct copy |
| `version` | `version` | Direct copy (optional in standard) |

### Transformed Fields

| Eitri Field | Transformation |
|-------------|----------------|
| `allowed-tools` | Added as "## Tools Required" section in body |
| `field` | Added as "**Domain:** {field}" in body |
| `execution_pattern` | Added as "**Execution:** {pattern}" in body |

### Dropped Fields (Eitri-Specific)

These fields are not part of the standard and are removed:

- `model` (sonnet/opus/haiku)
- `color` (blue/green/red/purple)
- `expertise` (beginner/intermediate/expert)
- `process_load_estimate`
- `max_concurrent`

The information is preserved as comments in the exported SKILL.md.

## Export Workflow

### Step 1: Source Detection

```
Export Source Detection
=======================

Searching for extension...

Found: ./plugins/code-reviewer/
Type: Agent
Main file: SKILL.md

Detected components:
  ✓ SKILL.md (main definition)
  ✓ scripts/ (2 files)
  ✓ references/ (1 file)
  ✗ templates/ (not present)

Continue with export? [Y/n]:
```

### Step 2: Metadata Translation

```
Metadata Translation
====================

Source frontmatter:
  name: code-reviewer
  description: Reviews code for bugs and best practices
  version: 1.2.0
  allowed-tools: [Read, Grep, Glob]
  model: sonnet
  color: red
  field: quality
  execution_pattern: sequential

Target frontmatter (Agent Skills standard):
  name: code-reviewer
  description: Reviews code for bugs and best practices

Translated to body:
  - Tools Required: Read, Grep, Glob
  - Domain: quality
  - Execution: sequential

Eitri-specific fields (commented):
  <!-- eitri:model=sonnet -->
  <!-- eitri:color=red -->
```

### Step 3: Content Export

```
Exporting Content
=================

Creating: .github/skills/code-reviewer/

Files:
  ✓ SKILL.md (translated)
  ✓ scripts/analyze.sh (copied)
  ✓ scripts/report.py (copied)
  ✓ references/patterns.md (copied)

Total: 4 files exported
```

### Step 4: Validation

```
Export Validation
=================

Checking Agent Skills compliance...

  ✓ SKILL.md present
  ✓ Frontmatter valid (name, description)
  ✓ No unsupported fields
  ✓ Body content preserved
  ✓ Scripts executable (+x)

EXPORT SUCCESSFUL ✓

Location: .github/skills/code-reviewer/

This skill can now be used by:
  - GitHub Copilot (VS Code Insiders)
  - OpenAI Codex CLI
  - Claude Code
```

## Output Structure

Exported skills follow the Agent Skills standard structure:

```
.github/skills/<skill-name>/
├── SKILL.md              # Main skill definition
├── scripts/              # Optional executable scripts
│   ├── script1.sh
│   └── script2.py
├── references/           # Optional reference documentation
│   └── patterns.md
└── templates/            # Optional templates
    └── template.md
```

### Exported SKILL.md Format

```yaml
---
name: code-reviewer
description: Reviews code for bugs and best practices
---

# Code Reviewer

<!-- Exported from Eitri v1.5.0 -->
<!-- eitri:model=sonnet eitri:color=red -->

## Tools Required

This skill uses the following tools:
- `Read` - Read source files
- `Grep` - Search for patterns
- `Glob` - Find files by pattern

## Domain

**Quality assurance and code review**

## Execution Pattern

**Sequential** - Reviews are performed one at a time to ensure thorough analysis.

---

[Original skill content preserved below]

...
```

## Options Reference

| Option | Description | Default |
|--------|-------------|---------|
| `--format=<fmt>` | Export format: `agent-skills`, `copilot`, `codex` | `agent-skills` |
| `--target=<path>` | Output directory | `.github/skills/<name>/` |
| `--include-scripts` | Include executable scripts | `true` |
| `--validate` | Validate output against spec | `true` |
| `--dry-run` | Preview without writing files | `false` |
| `--force` | Overwrite existing files | `false` |
| `--preserve-eitri` | Keep Eitri fields as comments | `true` |

## Re-Importing Exported Skills

Exported skills can be re-imported back to Eitri format:

```
# Future command (not yet implemented)
/forge:import .github/skills/code-reviewer --enhance
```

The `--enhance` flag will restore Eitri-specific metadata from the preserved comments.

## Platform-Specific Notes

### GitHub Copilot

- Skills must be in `.github/skills/` directory
- Enable `chat.useAgentSkills` in VS Code Insiders
- Skills are automatically discovered by name and description

### OpenAI Codex CLI

- Skills can be in `.codex/skills/` or `~/.codex/skills/`
- Use `/skills` command or `$` prefix to invoke
- Supports both explicit invocation and auto-discovery

### Claude Code

- Skills in `.claude/skills/` (project) or `~/.claude/skills/` (user)
- Model-invoked based on conversation context
- Eitri extensions already work natively

## Troubleshooting

### "No extension found"

The command couldn't locate an extension at the specified path.

**Fix:** Ensure the path contains SKILL.md or a valid plugin structure.

### "Invalid frontmatter"

The source extension has invalid metadata.

**Fix:** Run `/forge:validate` first to identify and fix issues.

### "Target exists"

The output directory already contains files.

**Fix:** Use `--force` to overwrite, or specify a different `--target`.

### "Scripts not copied"

Scripts weren't included in the export.

**Fix:** Ensure `--include-scripts` is enabled (default: true).

## Best Practices

1. **Validate first** - Run `/forge:validate` before exporting
2. **Test the export** - Try the exported skill in the target platform
3. **Keep originals** - Don't delete Eitri sources after export
4. **Version properly** - Export when you have a stable version
5. **Document well** - Clear descriptions help cross-platform discovery
6. **Minimal tools** - List only required tools for portability

## Integration with Eitri Workflow

```
1. /forge                    # Create extension with Eitri
2. /forge:validate           # Validate the extension
3. /forge:export --dry-run   # Preview the export
4. /forge:export             # Export to Agent Skills format
5. Test in target platform   # Verify it works
6. Commit .github/skills/    # Share with team
```

Ready to export? Run `/forge:export --dry-run` to preview!
