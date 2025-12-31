# Rune

> **Diagrams that just work.**

Rune generates beautiful, syntactically correct diagrams through intelligent format selection and validated syntax. No more broken Mermaid, no more trial-and-error.

Named after Norse magical symbols carved in stone—documentation that lasts.

---

## Quick Start

**Install:**
```bash
/plugin install rune@altakleos
```

**Use:**
Just describe what you need. Rune auto-invokes when diagrams are relevant.

```
"Show me the authentication flow"
"Create a class diagram for the User model"
"Visualize the database schema"
```

---

## What Rune Does

| Problem | Rune's Solution |
|---------|-----------------|
| Broken Mermaid syntax | Validated against Mermaid 11.x spec |
| Misaligned ASCII boxes | Character-counted alignment rules |
| Wrong diagram type | Intelligent selection based on content |
| Ugly layouts | Optimized direction, grouping, and styling |
| Confusing diagrams | Clarity-first design principles |

## Supported Formats

### Mermaid
- Flowcharts & process diagrams
- Sequence diagrams
- Class & ER diagrams
- State machines
- Gantt charts, timelines, mindmaps
- Architecture diagrams

### ASCII
- Perfectly aligned box diagrams
- Tree structures (directory listings)
- Terminal-friendly flowcharts
- Tables and grids
- Plain text architectures

### Coming Soon
- PlantUML (complex UML)

---

## Examples

**Process Flow:**
```
"Show the order processing workflow"
```
→ Generates optimized flowchart with proper direction and grouping

**API Sequence:**
```
"Diagram the OAuth2 flow"
```
→ Generates sequence diagram with autonumbering and activation boxes

**Data Model:**
```
"Create an ER diagram for the e-commerce schema"
```
→ Generates ER diagram with proper cardinality and constraints

**ASCII Architecture:**
```
"Show me the system architecture in ASCII"
```
→ Generates perfectly aligned box diagram for terminal/plain text

---

## Why Rune?

LLMs frequently generate broken diagrams:

**Mermaid issues:**
- Unescaped special characters
- Unquoted reserved words
- Inconsistent arrow styles
- Missing type declarations

**ASCII issues:**
- Misaligned box borders
- Off-by-one line widths
- Broken corner connections
- Inconsistent spacing

Rune embeds deep expertise to prevent these errors before they happen.

---

## Part of AltaKleos

Rune is a sibling to [Eitri](../eitri/README.md)—forged by the same team:
- **Eitri** forges Claude Code extensions
- **Rune** forges diagrams and documentation

---

## License

MIT
