---
name: validation-framework
type: module
description: Multi-stage validation for safety, correctness, and quality
---

# Validation Framework - Safety & Quality Assurance

## Three-Stage Validation

This framework validates extensions at three critical points:
1. **Pre-Generation**: Before creating anything, verify it's safe and possible
2. **Generation-Time**: During creation, ensure correctness and safety patterns
3. **Post-Generation**: After creation, validate functionality and integration

## Pre-Generation Validation

### Conflict Detection

Check for conflicts with existing extensions:

**Name Conflicts:**
- Extension name already exists?
- Similar names that could cause confusion?
- Reserved names that shouldn't be used?

**Description Overlap (Agents):**
- For agents, similar descriptions cause auto-invoke conflicts
- Calculate semantic similarity between descriptions
- Warn if similarity > 85%

**Tool Access Conflicts:**
- Multiple agents requiring exclusive access
- Concurrent modifications to same resources
- Safety violations in tool combinations

### Safety Pattern Validation

Verify that proposed configuration is safe:

**Execution Pattern Safety:**
```
Quality operations + Parallel execution = UNSAFE
Implementation with Bash + Unrestricted parallel = RISKY
Strategic read-only + Parallel = SAFE
```

**Tool Access Safety:**
```
if agent.has_tool("Bash") and agent.parallel_safe:
    if agent.type != "strategic":
        WARNING: "Bash in parallel is risky for non-strategic agents"

if agent.type == "quality" and agent.execution != "sequential":
    ERROR: "Quality agents MUST be sequential - system stability risk"
```

**Process Load Safety:**
```
if estimated_process_load > 40:
    WARNING: "Process load may exceed safe threshold"

if agent.parallel_safe and estimated_load > 25:
    WARNING: "High process load in parallel agent"
```

### Resource Requirement Check

Ensure all dependencies are available:

**MCP Tools:**
- Check if requested MCP tools are installed
- Verify MCP tool versions if specified
- Warn about beta/experimental tools

**Python Packages:**
- Check if required packages are installed
- Suggest installation commands if missing
- Verify version compatibility

**System Dependencies:**
- Check for required system tools
- Verify file system permissions
- Check available disk space for large operations

### Dependency Analysis

Identify dependencies and potential issues:

**Cross-Extension Dependencies:**
- Does this depend on other extensions?
- Are those extensions available?
- Version compatibility checks

**System Integration:**
- Required environment variables
- File system access patterns
- Network access requirements

## Generation-Time Validation

### Syntax Validation

Ensure generated content is syntactically correct:

**YAML Frontmatter:**
```yaml
Required fields present?
- name: [kebab-case validation]
- description: [not empty, actionable for agents]
- version: [semver format]

Optional fields format:
- tools: [comma-separated, valid tool names]
- model: [sonnet|opus|haiku|inherit]
- execution_pattern: [parallel|coordinated|sequential]
```

**Markdown Structure:**
- Valid markdown syntax
- Proper header hierarchy
- Code blocks properly closed
- No malformed links

**Python Code (if present):**
- Valid Python syntax
- Import statements valid
- No obvious security issues

### Description Clarity Check (Agents)

For agents, description quality is critical for auto-invocation:

**Action-Oriented:**
- Starts with action verb?
- Clear about what it does?
- Examples: "Reviews", "Analyzes", "Generates", "Tests"

**Specificity:**
- Specific enough for reliable auto-discovery?
- Minimum 10 words for context?
- Avoids ambiguous language?

**Trigger Clarity:**
- Clear about when it should invoke?
- Examples: "when files change", "after code is written"

**Scope Definition:**
- Defines boundaries clearly?
- Specifies what it does AND doesn't do?

### Safety Rule Enforcement

Apply safety rules from intelligence layer:

**Critical Safety Rules:**
1. Quality agents MUST be sequential (never parallel)
2. Bash access in parallel agents requires explicit justification
3. Edit tool in parallel agents requires coordination
4. Maximum concurrent agents: 5 for strategic, 3 for implementation

**Tool-Specific Rules:**
- Bash: Log all commands, no arbitrary code execution
- Edit: Backup before modify, validate syntax after
- Write: Check file existence, prevent overwrites without confirmation

**Execution Pattern Rules:**
- Sequential: Only one instance runs at a time
- Coordinated: Maximum 3 concurrent instances
- Parallel: Maximum 5 concurrent instances

### Context-Appropriate Generation

Verify generated content matches user context:

**Technical Level Alignment:**
- Beginner: Simple, clear, well-commented
- Intermediate: Balanced detail and abstraction
- Expert: Efficient, advanced patterns, minimal explanation

**Domain Appropriateness:**
- Industry-specific terminology used correctly
- Compliance requirements addressed
- Standard patterns for the domain

**Complexity Calibration:**
- Matches user's technical capability
- Appropriate error handling for context
- Documentation depth matches audience

## Post-Generation Validation

### Syntax Verification

Parse and verify the generated extension:

**File Structure:**
- All required files present?
- File naming follows conventions?
- Directory structure correct?

**Content Parsing:**
- YAML frontmatter parses correctly?
- Markdown renders properly?
- Code blocks execute without syntax errors?

### Functional Testing

Create and run validation tests:

**For Skills:**
- Loads without errors
- Core functionality accessible
- Example prompts work as expected

**For Agents:**
- Loads without errors
- Auto-invocation description is effective
- Tool access works as configured
- Execution pattern enforced

**For Suites:**
- All agents load successfully
- Coordination logic is correct
- Handoffs work properly
- Parallel/sequential execution as designed

### Safety Verification

Confirm safety patterns are correctly implemented:

**Tool Access Verification:**
```python
def verify_tool_access(extension):
    """Verify tool access matches specification"""
    configured_tools = extension.frontmatter.get('tools', '').split(',')

    for tool in configured_tools:
        tool = tool.strip()
        if not can_access_tool(extension, tool):
            return Error(f"Cannot access tool: {tool}")

    # Verify no unauthorized tools used
    used_tools = extract_tools_from_content(extension.content)
    for tool in used_tools:
        if tool not in configured_tools:
            return Error(f"Unauthorized tool usage: {tool}")

    return Success()
```

**Execution Pattern Verification:**
```python
def verify_execution_pattern(agent):
    """Verify execution pattern is safe"""

    if agent.type == "quality" and agent.execution != "sequential":
        return CriticalError("Quality agent must be sequential")

    if agent.execution == "parallel" and "Bash" in agent.tools:
        if agent.type != "strategic":
            return Warning("Bash in parallel non-strategic agent is risky")

    return Success()
```

### Integration Testing

Test how the extension integrates with the system:

**Loading Test:**
```python
try:
    extension = load_extension(path)
    status = "passed"
except Exception as e:
    status = "failed"
    error = str(e)
```

**Invocation Test (Agents):**
```python
# Test auto-invocation with sample scenarios
test_scenarios = generate_test_scenarios(agent.description)

for scenario in test_scenarios:
    invoked = test_auto_invocation(scenario, agent)
    results.append({
        "scenario": scenario,
        "invoked": invoked,
        "expected": True
    })
```

**Coordination Test (Suites):**
```python
# Test agent coordination
for agent in suite.agents:
    # Verify dependencies are met
    for dep in agent.dependencies:
        assert dep in suite.agents

    # Verify execution order
    if agent.execution == "sequential":
        assert no_parallel_execution_with(agent)
```

### Performance Verification

Ensure performance is acceptable:

**Process Load Measurement:**
- Measure actual process count during execution
- Compare to estimated load
- Flag if exceeds safe threshold

**Execution Time:**
- Measure time for typical operations
- Flag if unexpectedly slow
- Suggest optimizations if needed

**Resource Usage:**
- Monitor memory consumption
- Check disk space usage
- Track network requests

## Validation Reporting

Generate comprehensive validation report:

```markdown
Extension Validation Report
==========================

Extension: my-new-agent
Type: agent
Generated: 2024-11-12

PRE-GENERATION CHECKS:
✓ No naming conflicts
✓ No description overlap
✓ Resources available
✓ Safety patterns appropriate
✓ No dependency issues

GENERATION-TIME CHECKS:
✓ Syntax valid (YAML + Markdown)
✓ Description clear for auto-discovery
✓ Safety rules enforced
✓ Tool restrictions applied correctly
✓ Context-appropriate complexity

POST-GENERATION CHECKS:
✓ Extension loads successfully
✓ Auto-invocation works correctly
✓ Tool access verified
✓ Execution pattern enforced
✓ Integration tests passed

PERFORMANCE:
✓ Process load: 14 (within safe range 12-18)
✓ Execution time: 1.2s (acceptable)
✓ Resource usage: normal

WARNINGS:
⚠ Process load near threshold in parallel scenarios
  → Consider rate limiting if used with other agents

OVERALL STATUS: PASSED
Confidence Score: 94%

Ready for use!

Test Command:
python scripts/validate_agent.py my-new-agent/
```

## Continuous Validation

Provide tools for ongoing validation:

**validate_agent.py script:**
- Validates existing agent after modifications
- Checks for safety regressions
- Verifies continued compatibility

**Health Checks:**
- Periodic validation of active extensions
- Detection of configuration drift
- Compatibility updates

## Error Recovery

When validation fails:

**Clear Error Messages:**
- What failed and why
- Specific fix suggestions
- Examples of correct configuration

**Automatic Fixes (when possible):**
- Add missing fields with defaults
- Correct common formatting issues
- Suggest safe tool alternatives

**Graceful Degradation:**
- If non-critical issues, warn but proceed
- If critical issues, fail safely with clear next steps
- Always provide path to resolution

## Learning from Validation

Track validation outcomes to improve:

```python
validation_outcome = {
    "extension_type": "agent",
    "validation_stage": "post_generation",
    "issues_found": ["process_load_high"],
    "auto_fixed": 0,
    "required_manual_fix": 0,
    "passed": True,
    "improvements_suggested": ["rate_limiting"]
}
```

This data helps improve generation quality over time by identifying common issues and refining generation logic.
