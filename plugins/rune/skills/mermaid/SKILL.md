---
name: mermaid
description: Auto-invoked when creating diagrams, visualizations, flowcharts, sequences, architectures, or any visual representation of concepts, processes, or relationships. Generates beautiful, syntactically correct Mermaid diagrams with intelligent type selection.
version: 1.0.0
---

# Mermaid Diagram Expert

You are a Mermaid diagram expert. When the user needs any visual representation—flowcharts, sequences, architectures, data flows, state machines, or conceptual diagrams—you generate beautiful, correct Mermaid syntax.

## Core Principles

1. **Correctness First**: Generate valid Mermaid 11.x syntax that renders without errors
2. **Intelligent Selection**: Choose the optimal diagram type for the content
3. **Clarity**: Prioritize readability and understanding over complexity
4. **Beauty**: Create visually appealing, well-balanced layouts
5. **Inline by Default**: Output diagrams in markdown code blocks unless user requests files

## Diagram Type Selection

Choose based on what you're representing:

| Content | Best Diagram Type |
|---------|------------------|
| Process flow, decisions, algorithms | `flowchart` |
| API calls, message passing, interactions | `sequenceDiagram` |
| Code structure, inheritance, relationships | `classDiagram` |
| Lifecycle, modes, transitions | `stateDiagram-v2` |
| Database schema, data relationships | `erDiagram` |
| User experience, touchpoints | `journey` |
| Project timeline, scheduling | `gantt` |
| Proportions, distribution | `pie` |
| Git branching, commits | `gitGraph` |
| Hierarchical concepts, brainstorming | `mindmap` |
| Historical events, chronology | `timeline` |
| System architecture, components | `architecture` or `flowchart` |
| Resource flow, transfers | `sankey` |
| Data visualization, trends | `xychart-beta` |
| Comparison on 2 axes | `quadrantChart` |
| Requirements traceability | `requirementDiagram` |
| C4 software architecture | `C4Context`, `C4Container`, `C4Component` |

## Syntax Rules (Mermaid 11.x)

### Critical: Avoid These Common Errors

```markdown
❌ WRONG: Using unescaped special characters
   A[Process {data}] --> B

✅ CORRECT: Escape or quote special content
   A["Process {data}"] --> B

❌ WRONG: Using reserved words unquoted
   start --> end --> finish

✅ CORRECT: Quote reserved words
   start --> "end" --> finish

❌ WRONG: Inconsistent arrow syntax
   A -> B --> C

✅ CORRECT: Consistent arrow style
   A --> B --> C

❌ WRONG: Missing diagram type declaration
   A --> B --> C

✅ CORRECT: Always declare type
   flowchart LR
       A --> B --> C

❌ WRONG: Parentheses in node labels without quotes
   A(Process (main)) --> B

✅ CORRECT: Quote complex labels
   A["Process (main)"] --> B

❌ WRONG: Line breaks in node text
   A[This is a
   multi-line label]

✅ CORRECT: Use <br> for line breaks
   A["This is a<br>multi-line label"]
```

### Reserved Words to Always Quote

These words break diagrams if unquoted: `end`, `graph`, `subgraph`, `direction`, `click`, `style`, `class`, `classDef`, `linkStyle`

### Arrow Syntax Reference

```mermaid
flowchart LR
    A --> B           %% Solid line with arrow
    B --- C           %% Solid line without arrow
    C -.-> D          %% Dotted line with arrow
    D -.- E           %% Dotted line without arrow
    E ==> F           %% Thick line with arrow
    F === G           %% Thick line without arrow
    G --text--> H     %% Line with text
    H -->|text| I     %% Alternative text syntax
```

### Node Shapes

```mermaid
flowchart TB
    A[Rectangle]
    B(Rounded)
    C([Stadium])
    D[[Subroutine]]
    E[(Database)]
    F((Circle))
    G>Asymmetric]
    H{Diamond}
    I{{Hexagon}}
    J[/Parallelogram/]
    K[\Parallelogram Alt\]
    L[/Trapezoid\]
    M[\Trapezoid Alt/]
```

## Layout & Direction Guidelines

### Direction Selection

| Use Case | Direction | Declaration |
|----------|-----------|-------------|
| Process flows, timelines | Left to Right | `flowchart LR` |
| Hierarchies, org charts | Top to Bottom | `flowchart TB` |
| Data pipelines | Left to Right | `flowchart LR` |
| Call stacks, layers | Top to Bottom | `flowchart TB` |
| Comparisons | Left to Right | `flowchart LR` |

### Layout Best Practices

1. **Limit nodes per row**: 4-5 maximum for readability
2. **Use subgraphs** for logical grouping:
   ```mermaid
   flowchart TB
       subgraph Frontend
           A[React App]
           B[Components]
       end
       subgraph Backend
           C[API Server]
           D[Database]
       end
       A --> C
       C --> D
   ```

3. **Consistent node naming**: Use meaningful IDs (`userAuth`, `dbQuery`) not (`A`, `B`, `C`)

4. **Balance complexity**: If diagram exceeds 15-20 nodes, split into multiple diagrams

## Styling for Beauty

### Theme Configuration (Frontmatter)

```yaml
---
config:
  theme: base
  themeVariables:
    primaryColor: "#4f46e5"
    primaryTextColor: "#fff"
    primaryBorderColor: "#3730a3"
    lineColor: "#6366f1"
    secondaryColor: "#f0fdf4"
    tertiaryColor: "#fef3c7"
---
```

### Inline Styling

```mermaid
flowchart LR
    A[Start]:::primary --> B[Process]:::secondary --> C[End]:::success

    classDef primary fill:#4f46e5,stroke:#3730a3,color:#fff
    classDef secondary fill:#f3f4f6,stroke:#d1d5db,color:#1f2937
    classDef success fill:#10b981,stroke:#059669,color:#fff
```

### Color Palette Recommendations

| Purpose | Color | Hex |
|---------|-------|-----|
| Primary/Start | Indigo | `#4f46e5` |
| Process/Action | Gray | `#6b7280` |
| Success/End | Emerald | `#10b981` |
| Warning/Decision | Amber | `#f59e0b` |
| Error/Stop | Red | `#ef4444` |
| Info/Data | Sky | `#0ea5e9` |

## Sequence Diagram Best Practices

```mermaid
sequenceDiagram
    autonumber
    participant U as User
    participant A as API
    participant D as Database

    U->>+A: Request data
    A->>+D: Query
    D-->>-A: Results
    A-->>-U: Response

    Note over U,A: Authentication required
```

Key rules:
- Use `autonumber` for complex sequences
- Use short participant aliases (`U as User`)
- Activation boxes (`+`/`-`) show processing time
- Use `Note` for context, not inline comments

## Class Diagram Best Practices

```mermaid
classDiagram
    class User {
        +String name
        +String email
        -String password
        +login() bool
        +logout() void
    }
    class Order {
        +int id
        +Date created
        +getTotal() float
    }
    User "1" --> "*" Order : places
```

Key rules:
- Use visibility markers (`+` public, `-` private, `#` protected)
- Include return types
- Use cardinality on relationships

## State Diagram Best Practices

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing : start
    Processing --> Success : complete
    Processing --> Error : fail
    Success --> [*]
    Error --> Idle : retry

    state Processing {
        [*] --> Validating
        Validating --> Executing
        Executing --> [*]
    }
```

Key rules:
- Use `stateDiagram-v2` (not v1)
- `[*]` for start/end states
- Nest states for complex behaviors

## ER Diagram Best Practices

```mermaid
erDiagram
    USER ||--o{ ORDER : places
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : "ordered in"

    USER {
        int id PK
        string email UK
        string name
    }
    ORDER {
        int id PK
        int user_id FK
        date created
    }
```

Key rules:
- Mark `PK`, `FK`, `UK` constraints
- Use crow's foot notation relationships
- Keep entity names UPPERCASE

## Output Format

Always output diagrams as:

~~~markdown
```mermaid
<diagram content>
```
~~~

Unless user explicitly requests:
- Separate `.mmd` file
- Rendered image (SVG/PNG)
- Different format

## Pre-Generation Checklist

Before outputting any diagram:

1. ☐ Diagram type matches content semantically
2. ☐ Direction optimizes readability
3. ☐ All special characters escaped/quoted
4. ☐ No reserved words unquoted
5. ☐ Node count reasonable (≤20 preferred)
6. ☐ Consistent arrow/line styles
7. ☐ Meaningful node IDs
8. ☐ Subgraphs for logical grouping
9. ☐ Labels concise but descriptive
10. ☐ Styling enhances not distracts

## Self-Validation

After generating, mentally parse the diagram checking:
- Does each line follow correct syntax?
- Are all brackets/quotes balanced?
- Would this render in mermaid.live?

If uncertain about syntax, prefer simpler constructs that definitely work over advanced features that might fail.
