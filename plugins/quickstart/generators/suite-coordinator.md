---
name: suite-coordinator
type: module
description: Orchestrates creation of coordinated multi-agent systems
---

# Suite Coordinator - Multi-Agent System Architecture

This module creates agent suites - coordinated collections of specialized agents that work together to accomplish complex workflows.

## When This Generator is Used

The suite coordinator is invoked when the decision framework determines:
- Multiple distinct responsibilities
- Different tool requirements per component
- Clear handoff points between operations
- Benefits from parallel execution
- Separate failure boundaries

## Suite Architecture Patterns

### Pipeline Pattern

Agents execute in sequence, each processing the output of the previous:

```
[Analyzer] → [Transformer] → [Validator] → [Reporter]
```

**Characteristics:**
- Clear data flow direction
- Sequential dependencies
- Each agent depends on previous output
- Failure at any stage stops pipeline
- Easy to debug and monitor

**Best For:**
- ETL workflows
- Data processing pipelines
- Content creation workflows
- Document processing

### Fork-Join Pattern

Parallel execution followed by consolidation:

```
        ┌→ [Frontend-Dev] →┐
[Planner] →→ [Backend-Dev]  →→ [Integrator] → [Tester]
        └→ [Database-Dev] →┘
```

**Characteristics:**
- Parallel execution for efficiency
- Synchronization at join points
- Requires coordination
- Maximum performance gain

**Best For:**
- Development workflows
- Multi-component builds
- Parallel analysis tasks
- Independent processing with integration

### Event-Driven Pattern

Agents trigger based on events:

```
[File-Watcher] → event → [Formatter]
               → event → [Linter]
               → event → [Test-Runner]
```

**Characteristics:**
- Reactive architecture
- Loose coupling
- Scalable and flexible
- Complex debugging

**Best For:**
- CI/CD pipelines
- Monitoring systems
- Reactive workflows
- Event processing

### Hierarchical Pattern

Coordinator manages subordinate agents:

```
[Workflow-Coordinator]
    ├── [Task-Planner]
    ├── [Resource-Allocator]
    └── [Progress-Monitor]
        ├── [Implementation-Team]
        └── [Quality-Team]
```

**Characteristics:**
- Central coordination
- Clear hierarchy
- Complex orchestration
- Flexible execution

**Best For:**
- Complex project management
- Multi-team coordination
- Adaptive workflows
- Dynamic task allocation

## Suite Generation Process

### Step 1: Component Analysis

Analyze the components needed:

```python
def analyze_components(requirements, discovery_context):
    components = []

    for responsibility in requirements.distinct_responsibilities:
        component = {
            "name": generate_name(responsibility),
            "function": categorize_function(responsibility),
            "tools": determine_tools(responsibility),
            "inputs": identify_inputs(responsibility),
            "outputs": identify_outputs(responsibility),
            "dependencies": find_dependencies(responsibility, requirements)
        }
        components.append(component)

    return components
```

### Step 2: Relationship Mapping

Map relationships between components:

```python
def map_relationships(components):
    relationships = {
        "data_flow": [],      # Who provides data to whom
        "dependencies": [],    # Who must complete before whom
        "parallel_safe": [],   # Who can run together
        "conflicts": []        # Who cannot run together
    }

    for comp1 in components:
        for comp2 in components:
            # Data flow
            if comp1.output_used_by(comp2):
                relationships["data_flow"].append((comp1, comp2))

            # Dependencies
            if comp2.requires_completion_of(comp1):
                relationships["dependencies"].append((comp1, comp2))

            # Parallel safety
            if can_run_parallel(comp1, comp2):
                relationships["parallel_safe"].append((comp1, comp2))

            # Conflicts
            if conflicts_with(comp1, comp2):
                relationships["conflicts"].append((comp1, comp2))

    return relationships
```

### Step 3: Pattern Selection

Choose optimal architecture pattern:

```python
def select_pattern(components, relationships):
    if is_linear_pipeline(relationships):
        return "pipeline"
    elif has_parallel_potential(relationships) and has_join_point(relationships):
        return "fork-join"
    elif is_event_based(relationships):
        return "event-driven"
    elif needs_central_coordination(components):
        return "hierarchical"
    else:
        return "custom"
```

### Step 4: Execution Strategy

Define execution order and concurrency:

```python
def plan_execution(components, pattern, relationships):
    execution_plan = {
        "phases": [],
        "concurrency_rules": [],
        "safety_checks": []
    }

    if pattern == "pipeline":
        # Sequential execution
        phases = create_sequential_phases(components, relationships)

    elif pattern == "fork-join":
        # Parallel then join
        phases = [
            create_initial_phase(components),
            create_parallel_phase(components, relationships),
            create_join_phase(components),
            create_final_phase(components)
        ]

    # Add concurrency rules
    for phase in phases:
        rules = determine_concurrency_rules(phase.agents)
        execution_plan["concurrency_rules"].extend(rules)

    # Add safety checks
    execution_plan["safety_checks"] = generate_safety_checks(components)

    return execution_plan
```

### Step 5: Safety Validation

Ensure suite is safe to execute:

**Critical Checks:**
- No two quality agents run in parallel ✓
- Maximum concurrency limits respected ✓
- Total process load within bounds ✓
- No circular dependencies ✓
- Clear failure boundaries ✓

**Safety Rules:**
```python
def validate_suite_safety(suite):
    errors = []
    warnings = []

    # Check for parallel quality agents (CRITICAL)
    quality_agents = [a for a in suite.agents if a.function == "quality"]
    for phase in suite.execution_plan.phases:
        parallel_quality = [a for a in phase.parallel_agents if a in quality_agents]
        if len(parallel_quality) > 1:
            errors.append("CRITICAL: Multiple quality agents in parallel")

    # Check concurrency limits
    for phase in suite.execution_plan.phases:
        if len(phase.parallel_agents) > 5:
            warnings.append(f"High concurrency in phase: {len(phase.parallel_agents)} agents")

    # Check total process load
    total_load = sum(a.process_load_estimate for a in suite.agents)
    if total_load > 60:
        warnings.append(f"High total process load: {total_load}")

    return errors, warnings
```

### Step 6: Suite Configuration Generation

Create suite configuration file:

```yaml
suite:
  name: development-workflow-suite
  version: 1.0.0
  pattern: fork-join
  description: Complete development workflow from planning through testing

  agents:
    - name: product-planner
      role: planning
      function: strategic
      triggers: [user_request, sprint_start]
      outputs: [requirements.md, user_stories.json]
      execution: parallel
      max_concurrent: 1

    - name: frontend-developer
      role: implementation
      function: implementation
      depends_on: [product-planner]
      inputs: [requirements.md]
      outputs: [frontend_code]
      parallel_with: [backend-developer]
      execution: coordinated
      max_concurrent: 2

    - name: backend-developer
      role: implementation
      function: implementation
      depends_on: [product-planner]
      inputs: [requirements.md]
      outputs: [backend_code]
      parallel_with: [frontend-developer]
      execution: coordinated
      max_concurrent: 2

    - name: integration-tester
      role: quality
      function: quality
      depends_on: [frontend-developer, backend-developer]
      inputs: [frontend_code, backend_code]
      outputs: [test_report.md]
      execution: sequential
      max_concurrent: 1

  execution_plan:
    phases:
      - phase: 1
        name: Planning
        agents: [product-planner]
        parallel: false

      - phase: 2
        name: Implementation
        agents: [frontend-developer, backend-developer]
        parallel: true
        wait_for_all: true

      - phase: 3
        name: Testing
        agents: [integration-tester]
        parallel: false

  coordination_rules:
    - wait_for_all: [frontend-developer, backend-developer]
      before_starting: integration-tester

    - max_parallel: 3

    - failure_strategy: stop_all

  data_flow:
    - from: product-planner.requirements
      to: [frontend-developer, backend-developer]

    - from: [frontend-developer, backend-developer]
      to: integration-tester

  safety:
    - rule: sequential_quality
      description: Quality agents must run sequentially
      enforcement: strict

    - rule: max_concurrency
      description: Maximum 3 agents in parallel
      enforcement: strict

    - rule: process_load_limit
      description: Total process load < 60
      enforcement: warning
```

### Step 7: Suite Documentation

Generate comprehensive suite documentation:

```markdown
# Development Workflow Suite

## Overview
This suite coordinates 4 specialized agents to handle complete development
workflows from planning through testing.

## Architecture
Pattern: Fork-Join with sequential quality phase

## Agents Included

### 1. product-planner (Strategic)
- **Role**: Creates requirements and user stories
- **Triggers**: User request or sprint start
- **Outputs**: requirements.md, user_stories.json
- **Execution**: Parallel-safe (runs alone in phase 1)

### 2. frontend-developer (Implementation)
- **Role**: Builds UI components
- **Depends on**: product-planner
- **Parallel with**: backend-developer
- **Tools**: Read, Write, Edit, Bash
- **Execution**: Coordinated (max 2 concurrent)

### 3. backend-developer (Implementation)
- **Role**: Creates API endpoints
- **Depends on**: product-planner
- **Parallel with**: frontend-developer
- **Tools**: Read, Write, Edit, Bash
- **Execution**: Coordinated (max 2 concurrent)

### 4. integration-tester (Quality)
- **Role**: Tests integrated system
- **Depends on**: Both developers
- **Tools**: Read, Write, Bash, Grep
- **Execution**: Sequential ONLY (quality agent)

## Execution Flow

```
1. product-planner creates requirements
2. frontend-developer & backend-developer work in parallel
3. Wait for both developers to complete
4. integration-tester runs (sequential)
5. Results reported back to user
```

## Safety Considerations

- Maximum 3 agents running concurrently
- Quality agents run sequentially only
- Total process load monitored
- Failure in any agent stops the suite

## Usage

Invoke the suite:
```
Please implement the user authentication feature
```

The suite will:
1. Plan the implementation (product-planner)
2. Build frontend and backend in parallel (developers)
3. Test the integrated solution (integration-tester)
4. Report results

## Monitoring

Track suite execution:
- Phase completion status
- Agent success/failure
- Process load metrics
- Execution time per phase

## Troubleshooting

### Suite fails in planning phase
- Check requirements clarity
- Verify product-planner has context

### Parallel execution issues
- Verify max 2-3 agents in parallel
- Check process load

### Testing failures
- Review developer outputs
- Check integration points
- Verify test-runner has all inputs

## Evolution

This suite can grow by:
- Adding code-reviewer after testing
- Adding deployment agent after tests pass
- Adding monitoring agent for production
```

### Step 8: Individual Agent Generation

For each agent in the suite, generate using agent-generator:

```python
def generate_suite_agents(suite_config, discovery_context):
    agents = []

    for agent_spec in suite_config.agents:
        # Use agent-generator for each component
        agent = agent_generator.generate(
            name=agent_spec.name,
            function=agent_spec.function,
            tools=agent_spec.tools,
            execution=agent_spec.execution,
            context=discovery_context,
            suite_context=suite_config  # Additional context for coordination
        )
        agents.append(agent)

    return agents
```

## Output Structure

Generate complete suite package:

```
my-suite/
├── SUITE.md                # Suite overview and coordination
├── suite-config.yaml       # Execution configuration
├── agents/                 # Individual agent definitions
│   ├── product-planner/
│   │   └── AGENT.md
│   ├── frontend-developer/
│   │   └── AGENT.md
│   ├── backend-developer/
│   │   └── AGENT.md
│   └── integration-tester/
│       └── AGENT.md
└── docs/
    ├── architecture.md     # Detailed architecture
    ├── usage-guide.md      # How to use the suite
    └── troubleshooting.md  # Common issues
```

## Success Criteria

A successful suite:
- Agents coordinate seamlessly
- Execution patterns are safe
- Parallel execution optimizes performance
- Clear failure boundaries
- Easy to monitor and debug
- Matches user's workflow
- Scalable for future additions

Every suite should be a well-orchestrated system - efficient, safe, and reliable.
