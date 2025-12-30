---
name: agent-vs-skill-decision
type: reference
description: Framework for deciding between skills, agents, suites, and hybrid solutions
---

# Agent vs Skill Decision Framework

Comprehensive decision framework that guides Eitri's extension type recommendations.

## Core Decision Dimensions

### Dimension 1: Reusability
**High Reusability (→ Agent/Suite):**
- Works across any project
- Generic functionality
- No project-specific logic
- Standard industry pattern
- Examples: code formatter, linter, test runner

**Low Reusability (→ Skill):**
- Project-specific logic
- Custom business rules
- One-time use case
- Unique workflow
- Examples: custom reporting, specific integration

### Dimension 2: Invocation Pattern
**Task-Triggered (→ Agent):**
- "When X happens, do Y"
- Clear trigger conditions
- Automatic activation preferred
- Examples: "when file saves", "when code changes"

**Conversation-Driven (→ Skill):**
- Part of ongoing dialogue
- Requires context understanding
- Interactive decision points
- Examples: "help me analyze", "create report for"

### Dimension 3: Coupling
**Tight Coupling (→ Skill):**
- Operations depend on each other
- Shared state/context
- Must happen together
- Complex interdependencies

**Loose Coupling (→ Agent/Suite):**
- Independent operations
- Clear boundaries
- Can work separately
- Minimal dependencies

### Dimension 4: Context Dependency
**Heavy Context (→ Skill):**
- Needs deep project understanding
- Adapts to user/project
- Remembers previous interactions
- Complex decision making

**Light Context (→ Agent):**
- Self-contained operation
- Clear input/output
- Stateless execution
- No memory between runs

### Dimension 5: Tool Safety
**Benefits from Restrictions (→ Agent):**
- Limited scope operation
- Read-heavy operations
- Parallel execution valuable
- Safety through limitation

**Needs Full Access (→ Skill):**
- Complex operations
- Multiple tool types needed
- No benefit from restrictions
- Flexible tool usage

### Dimension 6: Multiple Roles
**Single Role (→ Skill or Agent):**
- One clear responsibility
- Unified purpose
- Single user/team

**Multiple Distinct Roles (→ Suite):**
- Different responsibilities
- Different tool needs
- Different team members
- Clear role separation

## Decision Matrix

| Characteristic | Skill | Agent | Suite | Hybrid |
|----------------|-------|-------|-------|--------|
| Reusability | Low | High | High | Mixed |
| Invocation | Conversational | Task-triggered | Task-triggered | Both |
| Coupling | Tight | Loose | Loose | Mixed |
| Context | Heavy | Light | Light-Medium | Heavy core |
| Tool Access | Full | Restricted | Varied | Varied |
| Roles | Single | Single | Multiple | Multiple |

## Example Scenarios

### Scenario 1: Code Formatting
**Requirements:**
- Format code on save
- Reusable across projects
- No context needed
- Clear trigger

**Analysis:**
- Reusability: High (✓ Agent)
- Invocation: Task-triggered (✓ Agent)
- Coupling: None (✓ Agent)
- Context: None needed (✓ Agent)
- Tools: Read, Write, Edit (✓ Agent)

**Decision: Agent**

### Scenario 2: Custom Business Reporting
**Requirements:**
- Generate monthly financial reports
- Specific business logic
- Multiple data sources
- Custom calculations

**Analysis:**
- Reusability: Low (✓ Skill)
- Invocation: Conversational (✓ Skill)
- Coupling: Tight (✓ Skill)
- Context: Heavy (✓ Skill)
- Tools: Full access needed (✓ Skill)

**Decision: Skill**

### Scenario 3: Development Workflow
**Requirements:**
- Plan features
- Write code (frontend + backend)
- Run tests
- Review code

**Analysis:**
- Reusability: Mixed
- Invocation: Task-triggered
- Coupling: Loose
- Context: Light per component
- Roles: Multiple distinct (✓ Suite)

**Decision: Agent Suite** (4 agents: planner, frontend-dev, backend-dev, tester)

### Scenario 4: Project Management with Automations
**Requirements:**
- Manage project context
- Coordinate team workflow
- Automatically format code
- Automatically run tests

**Analysis:**
- Core: Heavy context, conversational (✓ Skill)
- Utilities: Reusable, task-triggered (✓ Agents)
- Mixed characteristics (✓ Hybrid)

**Decision: Hybrid** (Skill orchestrator + agent specialists)

## Scoring Algorithm

Eitri calculates scores across dimensions:

```python
scores = {
    "skill": 0,
    "agent": 0,
    "suite": 0,
    "hybrid": 0
}

# Reusability (weight: 8)
if reusability == "high":
    scores["agent"] += 8
    scores["suite"] += 6
else:
    scores["skill"] += 8

# Invocation (weight: 9)
if invocation == "task_triggered":
    scores["agent"] += 9
    scores["suite"] += 7
else:
    scores["skill"] += 9

# ... (continue for all dimensions)

recommendation = max(scores, key=scores.get)
confidence = calculate_confidence(scores)
```

## Edge Cases

### Equal Scores
When scores are close:
- Present multiple viable options
- Explain trade-offs
- Let user decide
- Default to simpler (Skill > Agent > Suite)

### Low Confidence (<60%)
When uncertain:
- Ask clarifying questions
- Probe deeper with discovery
- Suggest starting simple
- Can always refactor

### Conflicting Indicators
When dimensions conflict:
- Weight by importance
- Consider user expertise
- Look for hybrid opportunity
- Recommend prototype first

## Evolution Paths

### Skill → Hybrid → Suite
1. Start: Monolithic skill
2. Extract: Reusable components as agents
3. Evolve: Full agent suite

### Agent → Suite
1. Start: Single agent
2. Add: Related agents
3. Coordinate: Create suite

### Suite → Hybrid
1. Start: Agent suite
2. Add: Central orchestrator skill
3. Integrate: Hybrid coordination

This framework guides Eitri's intelligent recommendations with transparency and context-awareness.
