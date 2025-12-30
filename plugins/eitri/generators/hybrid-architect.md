---
name: hybrid-architect
type: module
description: Creates hybrid solutions combining skills and agents for best-of-both-worlds architecture
---

# Hybrid Architect - Integrated Yet Modular Solutions

This module creates hybrid solutions - combinations of skills (for contextual orchestration) and agents (for specialized, reusable tasks) that work together seamlessly.

## When This Generator is Used

The hybrid architect is invoked when the decision framework determines:
- Central orchestration with specialized components
- Mix of custom workflow and reusable utilities
- Some parts conversational, others task-triggered
- Complex coordination with simple executors
- Evolutionary architecture (start integrated, extract over time)

## Hybrid Architecture Patterns

### Pattern 1: Orchestrator + Specialists

A skill provides central coordination while agents handle specialized tasks:

```
[Skill: Project Manager]
    ├─> Delegates to: code-formatter (agent)
    ├─> Delegates to: test-runner (agent)
    └─> Delegates to: documentation-generator (agent)
```

**Best For:**
- Project management workflows
- Complex business processes with utility tasks
- Custom workflows needing standard operations

### Pattern 2: Context Provider + Executors

A skill maintains context and state while agents execute stateless operations:

```
[Skill: Data Pipeline Orchestrator]
    ├─> Maintains: configuration, state, progress
    ├─> Invokes: data-validator (agent)
    ├─> Invokes: format-converter (agent)
    └─> Invokes: quality-checker (agent)
```

**Best For:**
- Stateful workflows
- Complex data pipelines
- Multi-step processes with context

### Pattern 3: Custom Core + Generic Utilities

A skill handles custom business logic while agents provide generic utilities:

```
[Skill: Custom Reporting System]
    ├─> Custom: business rules, calculations, formatting
    ├─> Uses: pdf-generator (agent)
    ├─> Uses: email-sender (agent)
    └─> Uses: file-archiver (agent)
```

**Best For:**
- Business-specific workflows
- Custom logic with standard outputs
- Domain-specific processes

### Pattern 4: Evolutionary Architecture

Start with a skill, gradually extract agents as patterns emerge:

```
Phase 1: [Skill: Monolithic Workflow]

Phase 2: [Skill: Core Workflow]
             └─> Extracted: formatter (agent)

Phase 3: [Skill: Core Workflow]
             ├─> formatter (agent)
             ├─> validator (agent)
             └─> reporter (agent)
```

**Best For:**
- Unclear boundaries initially
- Iterative development
- Learning and refactoring

## Hybrid Generation Process

### Phase 1: Boundary Analysis

Determine what should be skill vs agents:

```python
def analyze_boundaries(requirements, discovery_context):
    boundaries = {
        "skill_components": [],
        "agent_components": [],
        "shared_data": [],
        "integration_points": []
    }

    for component in requirements.components:
        if should_be_skill(component):
            boundaries["skill_components"].append(component)
        elif should_be_agent(component):
            boundaries["agent_components"].append(component)

        # Identify shared data and integration points
        for other in requirements.components:
            if shares_data(component, other):
                boundaries["shared_data"].append((component, other))
            if integrates_with(component, other):
                boundaries["integration_points"].append((component, other))

    return boundaries

def should_be_skill(component):
    """Component should be skill if it needs context and conversation"""
    return (
        component.needs_heavy_context or
        component.requires_conversation or
        component.has_complex_state or
        component.is_highly_custom
    )

def should_be_agent(component):
    """Component should be agent if it's reusable and task-based"""
    return (
        component.is_reusable and
        component.has_clear_trigger and
        component.is_stateless and
        component.benefits_from_restrictions
    )
```

### Phase 2: Integration Strategy

Define how skill and agents communicate:

**Delegation Pattern:**
```markdown
# In Skill

When I need to format code:
1. Prepare the code for formatting
2. Invoke code-formatter agent
3. Receive formatted code
4. Continue with my workflow
```

**Event Pattern:**
```markdown
# In Skill

When certain conditions are met:
1. Emit event that triggers agent
2. Agent processes event
3. Agent returns result
4. I continue based on result
```

**Coordination Pattern:**
```markdown
# In Skill

I coordinate multiple agents:
1. Invoke agent-1 with context
2. Wait for completion
3. Invoke agent-2 with agent-1's output
4. Aggregate results
5. Present final output
```

### Phase 3: Skill Generation

Use skill-generator for the orchestrator component:

```python
def generate_orchestrator_skill(boundaries, discovery_context):
    skill_spec = {
        "name": generate_orchestrator_name(boundaries),
        "description": create_orchestrator_description(boundaries),
        "components": boundaries["skill_components"],
        "coordinates": boundaries["agent_components"],
        "integration_strategy": determine_integration_strategy(boundaries),
        "context": discovery_context
    }

    return skill_generator.generate(skill_spec)
```

**Skill Content Includes:**
- Core workflow logic
- Context management
- Agent invocation instructions
- State management
- Integration coordination

### Phase 4: Agent Generation

Use agent-generator for specialist components:

```python
def generate_specialist_agents(boundaries, discovery_context):
    agents = []

    for agent_component in boundaries["agent_components"]:
        agent_spec = {
            "name": agent_component.name,
            "function": agent_component.function,
            "tools": agent_component.tools,
            "execution": agent_component.execution_pattern,
            "context": discovery_context,
            "hybrid_context": {
                "orchestrated_by": boundaries["skill_name"],
                "provides_to": agent_component.consumers,
                "depends_on": agent_component.dependencies
            }
        }

        agent = agent_generator.generate(agent_spec)
        agents.append(agent)

    return agents
```

### Phase 5: Integration Documentation

Create clear documentation on how components work together:

```markdown
# Hybrid Solution: Development Workflow Manager

## Architecture Overview

This hybrid solution combines:
- **Skill**: `development-workflow-manager` (orchestrator)
- **Agents**:
  - `code-formatter` (utility)
  - `test-runner` (quality)
  - `commit-message-generator` (utility)

## How It Works

### The Skill (Orchestrator)

The development-workflow-manager skill:
- Understands your project context
- Manages workflow state
- Coordinates agent invocations
- Provides conversational interface
- Adapts to your specific needs

### The Agents (Specialists)

Each agent handles a specific, reusable task:
- **code-formatter**: Automatically formats code when files change
- **test-runner**: Runs tests on demand or automatically
- **commit-message-generator**: Creates commit messages from diffs

## Integration Flow

```
User: "I've finished the authentication feature"

Skill: [Understands context, knows what to do next]
  1. Formats code using code-formatter agent
  2. Runs tests using test-runner agent
  3. If tests pass, generates commit message
  4. Presents results and next steps
```

## Benefits of Hybrid Approach

**From Skill:**
- Context awareness (knows your project)
- Conversational interaction
- Complex workflow management
- Custom business logic

**From Agents:**
- Reusable across projects
- Auto-invocation when needed
- Safe tool restrictions
- Focused responsibilities

## Evolution Path

This hybrid solution can evolve:
- Extract more agents as patterns emerge
- Add new agents for new needs
- Refine skill orchestration logic
- Scale agents independently
```

### Phase 6: Shared Data Strategy

Define how data flows between components:

**Data Contract Pattern:**
```yaml
shared_data:
  - name: code_analysis_result
    produced_by: skill
    consumed_by: [code-formatter, test-runner]
    format: json
    schema:
      files: [list of file paths]
      issues: [list of issues found]
      metrics: object

  - name: formatted_code
    produced_by: code-formatter
    consumed_by: skill
    format: string
    schema: formatted source code

  - name: test_results
    produced_by: test-runner
    consumed_by: skill
    format: json
    schema:
      passed: number
      failed: number
      details: [list of test results]
```

**Implementation in Skill:**
```markdown
# In Skill

## Working with Agents

### Invoking code-formatter Agent

When I need to format code:
1. Prepare code_analysis_result in required format
2. Request code-formatter agent
3. Receive formatted_code
4. Continue workflow

### Invoking test-runner Agent

When tests need to run:
1. Ensure code is formatted
2. Request test-runner agent
3. Receive test_results
4. Present results to user
```

### Phase 7: Failure Handling

Define failure boundaries and recovery:

```markdown
## Failure Handling in Hybrid Solution

### Skill Failure
If the orchestrator skill fails:
- Agents continue to function independently
- Users can invoke agents directly
- State can be recovered

### Agent Failure
If an agent fails:
- Skill detects failure
- Implements recovery strategy
- Continues workflow if possible
- Reports issue to user

### Recovery Strategies

**code-formatter fails:**
- Continue without formatting
- Allow manual formatting
- Retry with different settings

**test-runner fails:**
- Report test execution failure
- Allow manual test run
- Continue to commit (with warning)

**commit-message-generator fails:**
- Generate basic commit message
- Prompt user for manual message
- Use previous message template
```

### Phase 8: Performance Optimization

Optimize hybrid solution performance:

**Parallel Agent Invocation:**
```markdown
# In Skill

When multiple agents can run in parallel:
1. Invoke code-formatter and linter simultaneously
2. Wait for both to complete
3. Aggregate results
4. Continue workflow

Safety: Ensure agents are parallel-safe before concurrent invocation
```

**Lazy Agent Loading:**
```markdown
# In Skill

Only invoke agents when needed:
- Don't format if code hasn't changed
- Don't test if no code changes
- Don't generate commit message until ready
```

**Caching:**
```markdown
# In Skill

Cache agent results:
- Store formatting results per file
- Cache test results per commit
- Reuse when inputs unchanged
```

## Output Structure

Generate complete hybrid solution package:

```
my-hybrid-solution/
├── HYBRID.md                   # Solution overview
├── skill/
│   ├── SKILL.md               # Orchestrator skill
│   ├── integration.md         # Integration guide
│   └── scripts/               # Skill-specific scripts
├── agents/
│   ├── code-formatter/
│   │   └── AGENT.md
│   ├── test-runner/
│   │   └── AGENT.md
│   └── commit-message-generator/
│       └── AGENT.md
└── docs/
    ├── architecture.md        # Detailed architecture
    ├── data-contracts.md      # Shared data formats
    ├── usage-guide.md         # How to use
    └── evolution-guide.md     # How to evolve
```

## Migration Support

Provide guidance for evolving from skill to hybrid:

```markdown
## Migrating from Skill to Hybrid

### Identifying Extraction Candidates

Components that could become agents:
- Stateless operations
- Reusable across projects
- Clear input/output
- No context dependency

### Extraction Process

1. Identify component boundaries
2. Create agent specification
3. Generate agent using agent-generator
4. Update skill to delegate to agent
5. Test integration
6. Remove code from skill

### Example: Extracting Formatter

**Before (Skill only):**
```
Skill handles formatting internally
```

**After (Hybrid):**
```
Skill delegates to code-formatter agent
```

Benefits:
- code-formatter reusable in other projects
- Skill focuses on orchestration
- Cleaner separation of concerns
```

## Version Management

Start with version 1.0.0 for new hybrid solutions:
- Patch (1.0.1): Bug fixes, minor improvements
- Minor (1.1.0): New agents or skill enhancements, backward compatible
- Major (2.0.0): Breaking changes to integration contracts

## Related Modules

- **Decision Framework**: See `core/decision-framework.md` for type selection logic
- **Validation**: See `core/validation-framework.md` for validation rules
- **Other Generators**:
  - Skills: `generators/skill-generator.md`
  - Agents: `generators/agent-generator.md`
  - Suites: `generators/suite-coordinator.md`

## Success Criteria

A successful hybrid solution:
- Clear boundaries between skill and agents
- Seamless integration
- Best of both worlds (context + reusability)
- Easy to understand and maintain
- Natural evolution path
- Performance optimized
- Failure boundaries defined

Every hybrid solution should be elegantly composed - integrated where it matters, modular where it helps.
