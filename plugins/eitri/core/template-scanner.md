# Template Scanner Module

This module handles local filesystem scanning for template discovery. It provides the intelligence behind the `/forge:browse` command.

## Overview

The template scanner discovers templates from three hierarchical locations:

```
Priority (highest to lowest):
1. Project templates  → .claude/eitri/templates/
2. User templates     → ~/.claude/eitri/templates/
3. Built-in templates → plugins/eitri/templates/
```

When templates have the same name, higher priority locations override lower ones.

## Scanner Algorithm

### Phase 1: Directory Discovery

```python
def discover_template_directories():
    """Find all template directories that exist."""
    directories = []

    # Built-in templates (always exists with plugin)
    builtin = get_plugin_path() / "templates"
    if builtin.exists():
        directories.append(("builtin", builtin))

    # User templates (optional)
    user = Path.home() / ".claude" / "eitri" / "templates"
    if user.exists():
        directories.append(("user", user))

    # Project templates (optional)
    project = Path.cwd() / ".claude" / "eitri" / "templates"
    if project.exists():
        directories.append(("project", project))

    return directories
```

### Phase 2: File Discovery

```python
def discover_template_files(directories):
    """Find all markdown files in template directories."""
    files = []

    for location, directory in directories:
        for file_path in directory.glob("*.md"):
            # Skip README files
            if file_path.name.lower() == "readme.md":
                continue
            files.append((location, file_path))

    return files
```

### Phase 3: Metadata Extraction

```python
def extract_template_metadata(file_path):
    """Parse YAML frontmatter from template file."""
    content = file_path.read_text()

    # Check for YAML frontmatter
    if not content.startswith("---"):
        return None

    # Extract frontmatter
    parts = content.split("---", 2)
    if len(parts) < 3:
        return None

    frontmatter = yaml.safe_load(parts[1])

    # Validate required fields
    required = ["name", "type", "category", "description"]
    if not all(field in frontmatter for field in required):
        return None

    # Must be a template
    if frontmatter.get("type") != "template":
        return None

    # Validate category
    valid_categories = ["agents", "skills", "hooks", "mcp", "suites"]
    if frontmatter.get("category") not in valid_categories:
        return None

    return {
        "name": frontmatter["name"],
        "category": frontmatter["category"],
        "description": frontmatter["description"],
        "metadata": frontmatter
    }
```

### Phase 4: Index Building

```python
def build_template_index(files):
    """Build searchable index of templates."""
    index = {}

    for location, file_path in files:
        metadata = extract_template_metadata(file_path)
        if metadata is None:
            continue

        name = metadata["name"]

        # Higher priority locations override
        if name in index:
            existing_priority = get_priority(index[name]["location"])
            new_priority = get_priority(location)
            if new_priority <= existing_priority:
                continue

        index[name] = {
            **metadata,
            "location": location,
            "path": str(file_path),
            "modified": file_path.stat().st_mtime
        }

    return index

def get_priority(location):
    """Return priority for location (higher = more priority)."""
    return {"project": 3, "user": 2, "builtin": 1}.get(location, 0)
```

### Phase 5: Filtering and Sorting

```python
def filter_templates(index, category=None, location=None, search=None):
    """Apply filters to template index."""
    results = list(index.values())

    if category and category != "all":
        results = [t for t in results if t["category"] == category]

    if location and location != "all":
        results = [t for t in results if t["location"] == location]

    if search:
        search_lower = search.lower()
        results = [
            t for t in results
            if search_lower in t["name"].lower()
            or search_lower in t["description"].lower()
        ]

    return results

def sort_templates(templates, sort_by="name"):
    """Sort templates by specified field."""
    if sort_by == "name":
        return sorted(templates, key=lambda t: t["name"])
    elif sort_by == "modified":
        return sorted(templates, key=lambda t: t["modified"], reverse=True)
    elif sort_by == "category":
        return sorted(templates, key=lambda t: (t["category"], t["name"]))
    return templates
```

## Metadata Schema

Templates must include this frontmatter:

```yaml
---
# Required fields
name: string          # Unique identifier (kebab-case)
type: template        # Must be "template"
category: string      # One of: agents, skills, hooks, mcp, suites
description: string   # Brief description (max 256 chars)

# Optional fields
version: string       # Semantic version (e.g., "1.0.0")
author: string        # Template author
tags: [string]        # Additional search tags
complexity: string    # simple, moderate, complex
requires: string      # Eitri version requirement (e.g., ">=1.5.0")
---
```

## Category Definitions

| Category | Description | Extensions Generated |
|----------|-------------|---------------------|
| `agents` | Auto-invoking reusable components | SKILL.md with agent patterns |
| `skills` | Context-aware integrated solutions | SKILL.md with skill patterns |
| `hooks` | Event-driven automations | Hook shell scripts |
| `mcp` | External service integrations | MCP server configurations |
| `suites` | Coordinated multi-agent systems | Multiple related SKILL.md files |

## Template Body Structure

After frontmatter, templates should include:

```markdown
# Template Name

## Template Metadata
- Type, category, complexity
- Required tools
- Execution patterns

## Generated SKILL.md
- YAML frontmatter to generate
- Uses {{variable}} placeholders

## Generated Content
- Markdown body content
- Uses {{variable}} and {{#if}} constructs

## Customization Variables
- Table of available variables
- Default values

## Usage
- Example commands
- Common customization patterns
```

## Placeholder Syntax

Templates use Handlebars-style placeholders:

```handlebars
{{variable}}              # Simple substitution
{{variable | default: "value"}}  # Default value
{{variable | titlecase}}  # Transformation
{{#if condition}}...{{/if}}      # Conditional
{{#unless condition}}...{{/unless}}  # Inverse conditional
```

### Supported Transformations

| Transform | Description | Example |
|-----------|-------------|---------|
| `default` | Default value | `{{name \| default: "agent"}}` |
| `titlecase` | Title Case | `{{name \| titlecase}}` → "Code Reviewer" |
| `uppercase` | UPPERCASE | `{{name \| uppercase}}` → "CODE-REVIEWER" |
| `lowercase` | lowercase | `{{name \| lowercase}}` → "code-reviewer" |
| `camelcase` | camelCase | `{{name \| camelcase}}` → "codeReviewer" |

## Error Handling

### Invalid Template Detection

Templates are skipped (not errors) when:
- Missing `---` frontmatter delimiters
- Missing required fields (name, type, category, description)
- `type` is not "template"
- `category` is not in valid list
- File is not `.md` extension

### Graceful Degradation

```python
def safe_scan(directory):
    """Scan directory with error handling."""
    templates = []

    if not directory.exists():
        return templates

    for file_path in directory.glob("*.md"):
        try:
            metadata = extract_template_metadata(file_path)
            if metadata:
                templates.append(metadata)
        except Exception as e:
            # Log warning but continue
            log_warning(f"Skipping {file_path}: {e}")

    return templates
```

## Performance Considerations

### Caching Strategy

For large template collections:

```python
class TemplateCache:
    def __init__(self, ttl=300):  # 5 minute TTL
        self.cache = {}
        self.ttl = ttl

    def get_or_scan(self, directory):
        cache_key = str(directory)
        now = time.time()

        if cache_key in self.cache:
            entry = self.cache[cache_key]
            if now - entry["timestamp"] < self.ttl:
                return entry["templates"]

        templates = scan_directory(directory)
        self.cache[cache_key] = {
            "templates": templates,
            "timestamp": now
        }
        return templates
```

### Lazy Loading

For detailed view:

```python
def get_template_details(template_path):
    """Load full template only when details requested."""
    content = Path(template_path).read_text()

    # Parse full content
    parts = content.split("---", 2)
    frontmatter = yaml.safe_load(parts[1])
    body = parts[2]

    # Extract sections
    return {
        "frontmatter": frontmatter,
        "body": body,
        "generated_skill": extract_section(body, "Generated SKILL.md"),
        "generated_content": extract_section(body, "Generated Content"),
        "variables": extract_variables_table(body),
        "usage": extract_section(body, "Usage")
    }
```

## Integration Points

### With /forge:browse

The browse command uses this scanner to:
1. Discover all templates
2. Apply user filters
3. Format output
4. Display results

### With /forge:template

The template command uses this scanner to:
1. Find template by name
2. Load full template content
3. Parse customization variables
4. Apply user overrides
5. Generate extension files

## Testing Considerations

### Test Cases

1. **Empty directories:** Handle gracefully
2. **Missing frontmatter:** Skip file, no error
3. **Invalid YAML:** Skip file, no error
4. **Name collisions:** Higher priority wins
5. **Permission errors:** Skip with warning
6. **Large collections:** Performance acceptable
7. **Search edge cases:** Empty query, special chars

### Test Directory Structure

```
test_templates/
├── valid/
│   ├── simple-agent.md      # Valid template
│   └── complex-suite.md     # Valid template
├── invalid/
│   ├── no-frontmatter.md    # Missing ---
│   ├── missing-type.md      # No type field
│   └── wrong-type.md        # type: skill (not template)
└── edge-cases/
    ├── duplicate-name.md    # Same name as valid
    └── special-chars.md     # Unicode in content
```

## Security Considerations

1. **Path Traversal:** Sanitize all paths, stay within allowed directories
2. **File Size:** Limit file size to prevent memory issues
3. **YAML Safety:** Use safe_load, never load arbitrary code
4. **No Execution:** Templates are data only, never executed

## Future Enhancements

Potential improvements for future versions:

1. **Template versioning:** Track template versions
2. **Dependency resolution:** Templates requiring other templates
3. **Template validation:** Pre-flight checks before use
4. **Template analytics:** Usage tracking (opt-in)
5. **Template updates:** Check for newer versions of built-in templates
