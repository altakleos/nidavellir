---
name: safety-rules
type: module
description: Critical safety rules and enforcement mechanisms for extension generation
---

# Safety Rules - Protection and Stability

This module defines critical safety rules that QuickStart enforces to ensure system stability and data protection.

## Critical Safety Rules

### Rule 1: Sequential Quality Agents (CRITICAL)
**Severity:** CRITICAL - System Stability
**Description:** Quality agents MUST NEVER run in parallel
**Reason:** Parallel quality agent execution causes system crashes
**Enforcement:** Strict - Generation fails if violated
**Detection:** Check execution_pattern for all agents with function="quality"
**Fix:** Set execution_pattern="sequential" for all quality agents

```yaml
# CORRECT
name: test-runner
function: quality
execution_pattern: sequential  # REQUIRED

# WRONG - Will crash system
name: test-runner
function: quality
execution_pattern: parallel  # NEVER!
```

### Rule 2: Bash Tool Restrictions
**Severity:** HIGH - Security and Stability
**Description:** Bash tool in parallel non-strategic agents is risky
**Reason:** Race conditions, resource conflicts, security risks
**Enforcement:** Warning - Generation proceeds with warning
**Detection:** Check for Bash tool + parallel execution + non-strategic function
**Fix:** Either remove Bash, change to coordinated execution, or make strategic

```yaml
# SAFE
name: analyzer
function: strategic
tools: Read, Write, Bash
execution_pattern: parallel

# RISKY (Warning issued)
name: builder
function: implementation
tools: Read, Write, Bash
execution_pattern: parallel  # Risky!
```

### Rule 3: Maximum Concurrency Limits
**Severity:** HIGH - Performance and Stability
**Description:** Enforce maximum concurrent agents
**Limits:**
- Strategic (parallel): 5 max
- Implementation (coordinated): 3 max
- Quality (sequential): 1 only
**Enforcement:** Strict - Suite generation validates
**Detection:** Count concurrent agents in execution plan
**Fix:** Reduce concurrency or change execution pattern

### Rule 4: Process Load Thresholds
**Severity:** MEDIUM - Performance
**Description:** Total process load should stay under safe limits
**Limits:**
- Warning threshold: 40 processes
- Critical threshold: 60 processes
**Enforcement:** Warning at 40, Error at 60
**Detection:** Sum estimated process loads
**Fix:** Reduce complexity, split into phases, or optimize agents

### Rule 5: Tool Access Validation
**Severity:** MEDIUM - Security
**Description:** Agents only get tools they actually need
**Reason:** Principle of least privilege
**Enforcement:** Validation - Check tool usage matches specification
**Detection:** Parse content for tool usage, compare to declared tools
**Fix:** Add missing tools or remove unused tool declarations

### Rule 6: Description Clarity (Agents)
**Severity:** MEDIUM - Functionality
**Description:** Agent descriptions must be clear for reliable auto-invocation
**Requirements:**
- Starts with action verb
- 10+ words
- Specifies trigger
- No ambiguous language
**Enforcement:** Validation with warnings
**Detection:** Parse description structure
**Fix:** Rewrite description following formula

### Rule 7: No Circular Dependencies
**Severity:** HIGH - Functionality
**Description:** Suites must not have circular dependencies
**Reason:** Deadlock prevention
**Enforcement:** Strict - Suite generation validates
**Detection:** Dependency graph analysis
**Fix:** Restructure dependencies or split agents

### Rule 8: Unique Names
**Severity:** MEDIUM - Functionality
**Description:** Extension names must be unique
**Reason:** Prevents conflicts
**Enforcement:** Strict - Pre-generation validation
**Detection:** Check against existing extensions
**Fix:** Choose different name

### Rule 9: Description Uniqueness (Agents)
**Severity:** MEDIUM - Functionality
**Description:** Agent descriptions should not overlap significantly
**Reason:** Auto-invocation disambiguation
**Threshold:** 85% similarity
**Enforcement:** Warning - User can override
**Detection:** Semantic similarity calculation
**Fix:** Make descriptions more specific

### Rule 10: Failure Boundary Clarity
**Severity:** LOW - Maintainability
**Description:** Clear failure boundaries in suites
**Reason:** Better debugging and recovery
**Enforcement:** Best practice recommendation
**Detection:** Analyze error handling in suite
**Fix:** Add explicit failure handling

## Enforcement Levels

**Strict:** Generation fails if rule violated
**Warning:** Generation proceeds with clear warning
**Best Practice:** Recommendation only

## Safety Validation Process

1. **Pre-Generation:** Check rules 8, 9, 3, 7
2. **Generation-Time:** Enforce rules 1, 2, 5, 6
3. **Post-Generation:** Validate rules 4, 10
4. **Runtime:** Monitor rule 3, 4

## Override Protocol

Some rules can be overridden with explicit user acknowledgment:
- Rule 2 (Bash restrictions): If user explicitly needs it
- Rule 4 (Process load): If user accepts risk
- Rule 6 (Description clarity): If user prefers different style
- Rule 9 (Description uniqueness): If intentionally similar

**Never override:**
- Rule 1 (Sequential quality agents): CRITICAL
- Rule 3 (Max concurrency): System stability
- Rule 7 (No circular deps): Deadlock prevention

## Learning from Safety Violations

Track safety rule violations to improve generation:

```python
safety_violation = {
    "rule": "Rule 2 - Bash in parallel",
    "extension": "my-agent",
    "user_overrode": False,
    "outcome": "Warning issued, generation proceeded",
    "issues_encountered": None
}
```

This data helps refine safety rules and improve generation quality.
