---
name: agent-coordination
type: reference
description: Patterns and strategies for coordinating multiple agents in suites
---

# Agent Coordination - Multi-Agent Systems

Guide to coordinating multiple agents effectively and safely.

## Coordination Patterns

### Pipeline Pattern
Sequential execution with data flow:
```
[Agent A] → [Agent B] → [Agent C] → [Agent D]
```

**When to Use:**
- Clear sequential dependencies
- Each agent processes previous output
- Linear workflow
- Examples: ETL, build-test-deploy

**Coordination Strategy:**
- Wait for completion before next
- Pass data through chain
- Stop on any failure

### Fork-Join Pattern
Parallel execution with synchronization:
```
        ┌→ [Agent B] →┐
[Agent A]→→ [Agent C] →→ [Agent E]
        └→ [Agent D] →┘
```

**When to Use:**
- Independent parallel operations
- Synchronization point needed
- Performance optimization
- Examples: Multi-platform builds, parallel analysis

**Coordination Strategy:**
- Start parallel agents after trigger
- Wait for all to complete
- Aggregate results
- Continue with next phase

### Event-Driven Pattern
Reactive coordination based on events:
```
[Event Source] → [Multiple Agents React]
```

**When to Use:**
- Reactive workflows
- Loose coupling preferred
- Scalable architecture
- Examples: CI/CD, monitoring

**Coordination Strategy:**
- Agents subscribe to events
- Trigger on conditions
- Independent execution
- No direct coordination

### Hierarchical Pattern
Central coordinator manages subordinates:
```
[Coordinator]
    ├── [Worker A]
    ├── [Worker B]
    └── [Worker C]
```

**When to Use:**
- Complex decision making
- Dynamic task allocation
- Adaptive workflows
- Examples: Project management, resource allocation

**Coordination Strategy:**
- Coordinator makes decisions
- Delegates to workers
- Monitors progress
- Adjusts as needed

## Execution Patterns

### Sequential Execution
One at a time, in order:
```yaml
execution_plan:
  - phase: 1
    agents: [agent-a]
  - phase: 2
    agents: [agent-b]
  - phase: 3
    agents: [agent-c]
```

**Safety:** Highest (no conflicts)
**Performance:** Slowest
**Use When:** Dependencies or quality agents

### Coordinated Execution
Limited concurrency with coordination:
```yaml
execution_plan:
  - phase: 1
    agents: [agent-a, agent-b]
    max_concurrent: 2
```

**Safety:** Medium (managed)
**Performance:** Good
**Use When:** Some parallelism safe

### Parallel Execution
Maximum concurrency:
```yaml
execution_plan:
  - phase: 1
    agents: [agent-a, agent-b, agent-c, agent-d]
    max_concurrent: 4
```

**Safety:** Requires careful design
**Performance:** Fastest
**Use When:** Independent read-heavy operations

## Safety in Coordination

### Important Rule: Quality Agents Sequential
Avoid running quality agents in parallel:
```yaml
# Avoid - can cause instability
parallel_agents:
  - test-runner  # quality
  - code-reviewer  # quality

# CORRECT
sequential_agents:
  - test-runner
  - code-reviewer
```

### Concurrency Limits
Respect maximum concurrent agents:
- Strategic: 5 max
- Implementation: 3 max
- Quality: 1 only

### Process Load Management
Monitor total process load:
```yaml
suite:
  agents:
    - name: agent-a
      process_load: 15
    - name: agent-b
      process_load: 20
    - name: agent-c
      process_load: 18
  total_load: 53  # Warning if > 60
```

## Data Flow Strategies

### Direct Passing
Output of one becomes input of next:
```yaml
data_flow:
  - from: analyzer.results
    to: transformer.input
  - from: transformer.output
    to: reporter.data
```

### Shared Storage
Agents read/write to shared location:
```yaml
shared_storage:
  type: filesystem
  location: ./pipeline-data/
  agents_with_access: [all]
```

### Event Payloads
Data carried in events:
```yaml
events:
  - type: code_changed
    payload:
      files: [list]
      changes: [diff]
    triggers: [formatter, linter, tester]
```

## Failure Handling

### Stop-All Strategy
First failure stops everything:
```yaml
failure_strategy: stop_all
```
**Use When:** Failures invalidate later stages

### Continue-Best-Effort
Continue despite failures:
```yaml
failure_strategy: continue
```
**Use When:** Independent operations

### Retry Strategy
Automatic retry on failure:
```yaml
failure_strategy: retry
retry_config:
  max_attempts: 3
  backoff: exponential
```
**Use When:** Transient failures possible

### Fallback Strategy
Alternative agent on failure:
```yaml
failure_strategy: fallback
fallback_chain:
  primary: agent-a
  fallback: agent-b
```
**Use When:** Multiple ways to achieve goal

## Coordination Examples

### Example: Development Workflow Suite
```yaml
suite:
  pattern: fork-join
  phases:
    - phase: planning
      agents: [product-planner]
      execution: sequential

    - phase: implementation
      agents: [frontend-dev, backend-dev]
      execution: parallel
      max_concurrent: 2
      wait_for_all: true

    - phase: quality
      agents: [test-runner, code-reviewer]
      execution: sequential  # Important for stability

  data_flow:
    - from: product-planner.requirements
      to: [frontend-dev, backend-dev]
    - from: [frontend-dev.code, backend-dev.code]
      to: test-runner
```

### Example: Data Pipeline Suite
```yaml
suite:
  pattern: pipeline
  phases:
    - phase: extract
      agents: [data-extractor]
    - phase: transform
      agents: [data-transformer]
    - phase: validate
      agents: [data-validator]
    - phase: load
      agents: [data-loader]

  failure_strategy: stop_all
```

## Best Practices

1. **Clear Dependencies:** Document what depends on what
2. **Explicit Data Flow:** Define how data moves between agents
3. **Safety First:** Follow execution pattern rules
4. **Failure Boundaries:** Clear failure handling
5. **Monitor Progress:** Track execution state
6. **Limit Complexity:** Keep coordination simple
7. **Test Thoroughly:** Validate coordination logic

## Monitoring and Debugging

Track suite execution:
- Phase completion status
- Individual agent success/failure
- Process load metrics
- Execution time per phase
- Data flow verification

This guide ensures safe and effective multi-agent coordination.
