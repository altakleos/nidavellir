# Hybrid Solution Example: Project Management with Automations

## Overview
This example demonstrates a hybrid solution combining a skill (for context-rich project management) with specialized agents (for reusable automations).

## Hybrid Architecture

**Pattern:** Orchestrator + Specialists

**Components:**
- **Skill:** `project-workflow-manager` (Orchestrator)
- **Agents:**
  - `code-formatter` (Utility)
  - `comprehensive-test-runner` (Quality)
  - `commit-message-generator` (Utility)

## How It Works

### The Skill (Orchestrator)

The `project-workflow-manager` skill:
- Understands your project context
- Manages workflow state and progress
- Coordinates agent invocations
- Provides conversational interface
- Adapts to project-specific needs

### The Agents (Specialists)

Each agent handles a reusable, specific task:
- **code-formatter**: Formats code automatically
- **comprehensive-test-runner**: Runs tests on demand
- **commit-message-generator**: Creates commit messages

## Integration Example

```
User: "I've finished the authentication feature"

Skill: [Analyzes context, understands project state]
  1. Invokes code-formatter agent → formats code
  2. Invokes test-runner agent → runs tests
  3. If tests pass:
     - Invokes commit-message-generator → creates message
     - Presents commit for approval
  4. If tests fail:
     - Reports failures
     - Suggests fixes
     - Offers to re-run after fixes

User receives: Formatted code, test results, commit message
```

## Benefits of Hybrid Approach

**From Skill (Context & Conversation):**
- Understands your specific project
- Remembers previous interactions
- Adapts to your workflow
- Handles complex decision-making
- Conversational interface

**From Agents (Reusability & Auto-Invocation):**
- Reusable across all projects
- Auto-invoke when needed
- Safe tool restrictions
- Independent operation
- Focused responsibilities

## Data Flow

```
Skill maintains:
- Project context
- Workflow state
- User preferences
- History

Skill provides to agents:
- code-formatter: files to format
- test-runner: test scope
- commit-message-generator: diff and context

Agents return:
- code-formatter: formatted code status
- test-runner: test results
- commit-message-generator: commit message
```

## Evolution Path

This hybrid can evolve:

**Phase 1 (Current):**
- Skill orchestrates 3 agents

**Phase 2 (Add specialists):**
- Add deployment agent
- Add documentation generator

**Phase 3 (Extract more):**
- Extract project tracking to agent
- Extract reporting to agent
- Skill focuses on coordination

## Configuration

```yaml
hybrid:
  name: project-management-with-automations
  version: 1.0.0

  skill:
    name: project-workflow-manager
    role: orchestrator
    maintains:
      - project_context
      - workflow_state
      - user_preferences

  agents:
    - name: code-formatter
      invoked_by: skill
      reusable: true
      auto_invoke: true

    - name: comprehensive-test-runner
      invoked_by: skill
      reusable: true
      auto_invoke: false  # On-demand

    - name: commit-message-generator
      invoked_by: skill
      reusable: true
      auto_invoke: false  # On-demand
```

## Usage

Conversational with automatic agent delegation:

```
User: "Format the code and run tests"

Skill:
1. Invokes code-formatter (auto or explicit)
2. Waits for completion
3. Invokes test-runner
4. Aggregates and presents results

User: "Create a commit message"

Skill:
1. Generates diff
2. Invokes commit-message-generator with context
3. Presents message for approval
```

## Best Practices

1. **Clear Boundaries:** Skill handles context, agents handle tasks
2. **Explicit Invocation:** Skill explicitly invokes agents when needed
3. **Data Contracts:** Clear input/output formats
4. **Failure Handling:** Skill manages agent failures
5. **State Management:** Only skill maintains state

This hybrid approach provides the best of both worlds - contextual intelligence with reusable automation.
