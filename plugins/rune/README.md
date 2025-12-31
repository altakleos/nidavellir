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
| Wrong diagram type | Intelligent selection based on content |
| Ugly layouts | Optimized direction, grouping, and styling |
| Confusing diagrams | Clarity-first design principles |

## Supported Formats

### Mermaid (Primary)
- Flowcharts & process diagrams
- Sequence diagrams
- Class & ER diagrams
- State machines
- Gantt charts, timelines, mindmaps
- Architecture diagrams

### Coming Soon
- ASCII diagrams (terminal-friendly)
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

---

## Why Rune?

LLMs frequently generate broken Mermaid syntax:
- Unescaped special characters
- Unquoted reserved words
- Inconsistent arrow styles
- Missing type declarations

Rune embeds deep Mermaid expertise to prevent these errors before they happen.

---

## Part of AltaKleos

Rune is a sibling to [Eitri](../eitri/README.md)—forged by the same team:
- **Eitri** forges Claude Code extensions
- **Rune** forges diagrams and documentation

---

## License

MIT
