---
name: agent-generator
type: module
description: Sophisticated agent creation with safety patterns and auto-discovery optimization
---

# Agent Generator - Specialized Extension Creation

This module creates agents - specialized Claude Code extensions that auto-invoke based on task descriptions, run in separate contexts, and have optimized tool access for safety and performance.

## When This Generator is Used

The agent generator is invoked when the decision framework determines:
- High reusability across projects
- Clear trigger conditions (task-based invocation)
- Single, well-defined responsibility
- Benefits from tool restrictions
- Lightweight context requirements

## Agent Generation Framework

### Phase 1: Characteristic Determination

Based on discovery context, determine agent characteristics:

**Primary Function Analysis:**
- Planning/Research → Strategic characteristics
- Code/Building → Implementation characteristics
- Testing/Validation → Quality characteristics
- Orchestration → Coordination characteristics

**Tool Access Calibration:**
- Start with minimal tools (Read only)
- Add tools based on actual needs
- Apply safety restrictions for execution pattern
- Validate tool combinations

**Execution Pattern Selection:**
- Read-only + Lightweight → Parallel safe
- Writes + Moderate complexity → Coordinated (2-3 max)
- Quality/Testing operations → Sequential only (for stability)
- Orchestration → Varies based on coordination needs

**Process Load Estimation:**
- Strategic: 10-20 processes
- Implementation: 20-30 processes
- Quality: 12-18 processes
- Coordination: 10-15 processes

### Phase 2: Description Optimization

Generate a clear, actionable description for reliable auto-discovery:

**Description Formula:**
```
[Action Verb] + [Scope] + [Trigger Condition] + [Key Capabilities]
```

**Examples:**
- "Reviews code for security vulnerabilities whenever files are modified. Checks for OWASP Top 10, SQL injection, and XSS."
- "Generates comprehensive test suites for Python functions on demand. Creates unit tests, edge cases, and property-based tests."
- "Formats JavaScript and TypeScript files using Prettier when code is saved. Preserves project configuration and style guides."

**Description Quality Checks:**
- Starts with action verb ✓
- Specifies trigger condition ✓
- Defines scope clearly ✓
- Mentions key capabilities ✓
- 10+ words for context ✓
- No ambiguous language ✓

### Phase 3: Frontmatter Generation

Create comprehensive YAML frontmatter:

```yaml
---
name: [pluginname]:[agent-name]  # Example: skuld:trust-generator, eitri:validate - prefix for namespace isolation
description: [Optimized auto-discovery description]
tools: [Context-calibrated tool list]
model: [sonnet|opus|haiku based on complexity]
color: [blue|green|red|purple based on function]
field: [domain area]
expertise: [beginner|intermediate|expert based on user context]
execution_pattern: [parallel|coordinated|sequential]
process_load_estimate: [Range based on analysis]
mcp_tools: [Optional MCP integrations]
---
```

**Field Selection Logic:**

**Color (Visual categorization):**
- Blue: Strategic (planning, research, analysis)
- Green: Implementation (coding, building, creating)
- Red: Quality (testing, review, validation)
- Purple: Coordination (orchestration, workflow)
- Orange: Domain-specific or hybrid

**Model Selection:**
- Haiku: Simple, fast operations (formatting, simple checks)
- Sonnet: Standard operations (most agents)
- Opus: Complex analysis (architecture, sophisticated planning)
- Inherit: Use parent context model

**Expertise Level:**
- Reflects user's technical capability
- Affects documentation complexity
- Influences error message detail

### Phase 3b: Handler Manifest Generation (Domain-Aware)

When domain research indicates the agent needs intake coordination, I generate handler manifest fields that map to the intake graph.

**Handler Manifest Fields:**

```yaml
---
name: [pluginname]:[agent-name]  # Use pluginname: prefix for namespace isolation
description: [description]
# ... standard fields ...

# Handler Manifest (from domain research)
requires_intake:
  - state_of_residence    # Required for this handler to function
  - marital_status        # Required for this handler to function
optional_intake:
  - special_needs_status  # Enhances handler but not required
triggers_on:
  state_of_residence: true   # Handler activates when this intake is collected
  marital_status: true       # Handler activates when this intake is collected
---
```

**Field Population from Domain Research:**

Using the `domain_intelligence` output from the discovery engine:

```python
def generate_handler_manifest(agent_name, domain_intelligence, agent_responsibilities):
    """Generate handler manifest from domain research."""

    manifest = {
        "requires_intake": [],
        "optional_intake": [],
        "triggers_on": {}
    }

    # Match agent responsibilities to domain-derived handler dependencies
    for dep in domain_intelligence.get("handler_dependencies", []):
        if matches_agent_responsibility(dep["handler"], agent_responsibilities):
            # These intake fields are REQUIRED for this handler
            for field in dep.get("requires_intake", []):
                if field not in manifest["requires_intake"]:
                    manifest["requires_intake"].append(field)

    # Add optional fields from conditional triggers
    for trigger in domain_intelligence.get("conditional_triggers", []):
        field = trigger.get("then_ask")
        if relevant_to_agent(field, agent_responsibilities):
            if field not in manifest["optional_intake"]:
                manifest["optional_intake"].append(field)

    # Set trigger conditions (when handler should activate)
    for field in manifest["requires_intake"]:
        manifest["triggers_on"][field] = True

    return manifest
```

**Example: Estate Planning Trust Generator**

Given domain research findings:
- Trust generator needs state jurisdiction (laws vary by state)
- Trust generator needs marital status (spousal rights vary)
- Special needs provisions enhance trust but aren't required

Generated manifest:

```yaml
---
name: trust-generator
description: Generates revocable living trust documents based on client profile
requires_intake:
  - state_of_residence    # From: "estate planning requires state jurisdiction"
  - marital_status        # From: "spousal rights vary by state"
optional_intake:
  - special_needs_status  # From: "SNT provisions enhance trust"
  - spouse_citizenship    # From: "QDOT considerations for non-citizen"
triggers_on:
  state_of_residence: true
  marital_status: true
---
```

**Handler Manifest Validation:**

Before finalizing, validate that:
- All `requires_intake` fields have corresponding intake graph questions
- `triggers_on` conditions reference valid intake IDs
- No circular dependencies between handlers
- Optional fields are truly optional (handler works without them)

### Phase 4: System Prompt Generation

Create sophisticated, context-aware system prompt:

**Prompt Structure:**

```markdown
# [Agent Name]

You are a specialized agent focused on [specific capability].

## Your Primary Responsibility
[Clear, focused description of core responsibility]

## Activation Context
You are invoked when: [Specific trigger conditions]

## Approach

### [Step 1]
[Clear instruction on first step]

### [Step 2]
[Clear instruction on second step]

[Continue for all key steps...]

## Key Capabilities
- [Capability 1]: [Description]
- [Capability 2]: [Description]
- [Capability 3]: [Description]

## Success Criteria
- [Criterion 1]
- [Criterion 2]
- [Criterion 3]

## Quality Standards
[Context-appropriate quality expectations]

## Common Patterns
[Relevant patterns from pattern library]

## Error Handling
[Context-appropriate error handling approach]

## Integration Points
[How this works with other agents/skills]

## Performance Considerations
[Efficiency and optimization guidance]

## Safety Notes
[Any safety-specific guidance for this agent type]

## Question Handling
Agents do NOT ask questions directly. If additional information is needed:
1. Return a `needs_user_input` object in your response with question details
2. The coordinator will ask the user via `AskUserQuestion` tool
3. Never output questions as inline text
```

**Context Adaptation:**

**Beginner User Context:**
- Simple, clear instructions
- Step-by-step guidance
- Detailed error messages
- Examples throughout

**Intermediate User Context:**
- Balanced detail and autonomy
- Best practices focus
- Reasonable error handling
- Key examples

**Expert User Context:**
- Efficient, advanced patterns
- Assume knowledge
- Minimal hand-holding
- Edge case handling

### Phase 5: Tool Access Implementation

Configure tool access with safety awareness. For detailed guidance on safe tool configuration, I follow the guidelines in `references/tool-restrictions.md`, which defines risk levels per tool, recommended configurations by agent type, and execution pattern safety rules.

**Tool Calibration Algorithm:**

```python
def calibrate_tools(needs, function_type, execution_pattern):
    tools = ["Read"]  # Always start with Read

    # Add tools based on needs
    if needs.creates_files:
        tools.append("Write")

    if needs.modifies_files:
        tools.append("Edit")
        # Edit requires careful consideration

    if needs.searches_code:
        tools.append("Grep")

    if needs.finds_files:
        tools.append("Glob")

    if needs.runs_commands:
        if execution_pattern == "parallel" and function_type != "strategic":
            # WARNING: Bash in parallel is risky
            warn("Bash access in parallel non-strategic agent is risky")
        tools.append("Bash")

    # Apply safety restrictions
    if function_type == "quality":
        # Quality agents get full tools but should be sequential
        if execution_pattern != "sequential":
            error("Quality agents should be sequential for stability")

    if execution_pattern == "parallel":
        # Remove dangerous tools for parallel execution
        dangerous_in_parallel = ["Bash", "Edit"]
        if function_type != "strategic":
            tools = [t for t in tools if t not in dangerous_in_parallel]

    return tools
```

### Phase 6: Execution Pattern Enforcement

Ensure safe execution patterns:

**Safety Guidelines:**

1. **Quality Agents Run Sequentially**
   Quality agents should run sequentially to maintain system stability.
   ```yaml
   # Recommended pattern
   name: test-runner
   color: red
   execution_pattern: sequential

   # Avoid - can cause instability
   name: test-runner
   color: red
   execution_pattern: parallel
   ```

2. **Parallel Agents Should Be Lightweight**
   Parallel agents work best with read-only tools.
   ```yaml
   # Safe pattern
   name: code-analyzer
   tools: Read, Grep
   execution_pattern: parallel

   # Use with caution
   name: code-modifier
   tools: Read, Edit, Bash
   execution_pattern: parallel
   ```

3. **Maximum Concurrency Limits**
   - Strategic (parallel): 5 max concurrent
   - Implementation (coordinated): 3 max concurrent
   - Quality (sequential): 1 only
   - Coordination: Varies

4. **Parallel Tool Calling Optimization**
   For Claude 4.5 compatibility, include guidance for efficient parallel operations:
   ```markdown
   ## Tool Calling Efficiency

   If you intend to call multiple tools and there are no dependencies
   between the tool calls, make all of the independent calls in parallel.

   Examples:
   - Reading multiple files → call Read for all files in parallel
   - Searching multiple patterns → call Grep for all patterns in parallel
   - Analyzing multiple directories → call Glob for all patterns in parallel

   Only call tools sequentially when outputs depend on previous results.
   ```

### Phase 7: Examples and Documentation

Generate agent-specific examples:

**Usage Examples:**
```markdown
## Example Usage

### Automatic Invocation
This agent automatically activates when:
- [Specific trigger 1]
- [Specific trigger 2]

### Manual Invocation
You can also explicitly call this agent:
"[Example user request]"

### Expected Output
When invoked, this agent will:
1. [Action 1]
2. [Action 2]
3. [Result]

### Coordination
Works well with:
- [other-agent-1]: Runs after this agent completes
- [other-agent-2]: Can run in parallel safely
```

**Integration Documentation:**
```markdown
## Integration with Other Agents

### Prerequisites
- [Required agent or condition]

### Provides To
- [What this agent outputs for others]

### Depends On
- [What this agent needs from others]

### Coordination Pattern
[How this fits into larger workflows]
```

### Phase 8: Safety Validation

Before finalizing, validate safety:

**Critical Checks:**
- Quality agent + sequential pattern ✓
- Parallel agent + safe tools only ✓
- Process load within limits ✓
- No conflicting tool combinations ✓
- Execution pattern matches function ✓

**Safety Warnings:**
- Bash in parallel non-strategic agent
- Edit in parallel agent
- High process load estimate
- Multiple quality agents could conflict

## Context-Adaptive Agent Types

Rather than rigid categories, I adapt characteristics to context:

**Strategic-Like Agent:**
- Lightweight operations
- Read, Write, Grep tools typically
- Parallel-safe execution
- Planning, research, analysis focus
- Can run 4-5 concurrently

**Implementation-Like Agent:**
- Full tool access typically
- May include Bash for builds
- Coordinated execution (2-3 max)
- Code writing, building focus
- Moderate process load

**Quality-Like Agent:**
- Full tool access for thorough checks
- Sequential execution recommended
- Testing, review, validation focus
- Higher process load acceptable
- Avoid running in parallel with other quality agents

**Coordination-Like Agent:**
- Lightweight tool access
- Orchestrates other agents
- Manages workflows
- Decision-making and delegation

## MCP Tool Integration

When relevant MCP tools are available:

```yaml
---
name: github-pr-reviewer
description: Reviews GitHub pull requests for code quality and completeness
tools: Read, Grep
mcp_tools: mcp__github
---

# GitHub PR Reviewer

## MCP Integration

This agent uses the `mcp__github` tool to:
- Fetch PR details and diff
- Review previous comments
- Check CI/CD status
- Post review comments

## Approach

1. Use `mcp__github` to fetch PR context
2. Analyze code changes for quality
3. Check against project standards
4. Post structured review feedback
```

## Version Management

Start with version 1.0.0 for new agents:

```yaml
---
name: my-new-agent
version: 1.0.0  # Initial release
---
```

Future updates:
- Patch (1.0.1): Bug fixes, minor improvements
- Minor (1.1.0): New features, backward compatible
- Major (2.0.0): Breaking changes

## Output Structure

Generate complete agent package:

```
my-new-agent/
├── AGENT.md                # Main agent definition
├── README.md               # Usage and integration guide
└── test_scenarios.md       # Test cases for validation
```

## Failure Handling

Define clear failure boundaries and recovery strategies:

**Validation Failures:**
- If frontmatter validation fails, provide specific error and guidance
- If tool configuration is invalid, suggest corrections
- If execution pattern conflicts with function type, warn and correct

**Generation Failures:**
- If description optimization fails, use simple format
- If tool calibration fails, default to minimal tools
- If context is insufficient, request additional information

**Recovery Strategies:**
- Allow partial agent generation with warnings
- Provide rollback guidance for failed integrations
- Document known limitations and workarounds

## Pattern Application

I apply relevant patterns from `references/patterns.md` based on the agent's purpose, including data transformation, analysis, and integration patterns that help structure agent capabilities consistently.

## Learning and Improvement

Track successful agent patterns:

```python
agent_pattern = {
    "function": "code_formatting",
    "tools": ["Read", "Write"],
    "execution": "parallel",
    "success_rate": 0.96,
    "typical_use_cases": [...],
    "learned_optimizations": [...]
}
```

Feed this back to pattern learning system for continuous improvement.

## Related Modules

- **Decision Framework**: See `core/decision-framework.md` for type selection logic
- **Validation**: See `core/validation-framework.md` for validation rules
- **Other Generators**:
  - Skills: `generators/skill-generator.md`
  - Suites: `generators/suite-coordinator.md`
  - Hybrids: `generators/hybrid-architect.md`

## Success Criteria

A successful agent:
- Auto-invokes reliably on correct triggers
- Operates safely within defined boundaries
- Provides clear, actionable output
- Integrates well with other extensions
- Matches user's technical context
- Performs efficiently within process limits

Each agent should be a precision tool - narrowly focused, highly reliable, and contextually optimized.
