---
name: test
description: Test and simulate Eitri-generated extensions in a safe sandbox environment before deployment
---

# Test Command

Test and simulate extensions in a safe sandbox environment before deployment. This command provides dry-run execution, scenario testing, and suite simulation without modifying any files or running actual commands.

## Usage

```
/forge:test [extension-path] [options]
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--scenario=<desc>` | Test scenario description | Interactive prompt |
| `--input=<file>` | Input data file (JSON/YAML) | None |
| `--mock-tools` | Use mock tool responses | `true` |
| `--trace` | Show execution trace | `false` |
| `--verbose` | Verbose output | `false` |
| `--dry-run` | Preview without execution | `false` |
| `--output=<file>` | Save test results to file | None |

## Test Modes

### 1. Single Extension Test

Test a skill or agent with a scenario:

```
/forge:test ./my-agent --scenario="user requests code review of main.py"
```

Output:

```
Extension Test Results
======================
Extension: my-agent (agent)
Scenario: user requests code review of main.py

SIMULATION TRACE:
─────────────────
1. [TRIGGER] Scenario matches agent description
   ✓ "code review" found in description
   ✓ Auto-invocation would activate

2. [TOOL ACCESS] Checking tool permissions
   ✓ Read: ALLOWED (in allowed-tools)
   ✓ Grep: ALLOWED (in allowed-tools)
   ✓ Glob: ALLOWED (in allowed-tools)
   ✗ Write: BLOCKED (not in allowed-tools)
   ✗ Bash: BLOCKED (not in allowed-tools)

3. [EXECUTION] Simulating agent behavior
   → Would read: main.py
   → Would search for: patterns, issues, bugs
   → Would generate: review report

4. [OUTPUT] Expected output type
   → Markdown report with findings
   → Categories: Critical, Warning, Suggestion

VALIDATION:
───────────
✓ Agent description clear for auto-discovery
✓ Tool restrictions appropriate for task
✓ No safety rule violations
✓ Execution pattern: sequential (correct for quality agent)

RESULT: PASS
Confidence: 92%

The extension should work correctly for this scenario.
```

### 2. Suite Simulation

Simulate multi-agent coordination:

```
/forge:test ./dev-suite --scenario="implement new feature" --trace
```

Output:

```
Suite Simulation Results
========================
Suite: dev-suite (4 agents)
Scenario: implement new feature

COORDINATION TRACE:
───────────────────
Phase 1: Planning [SEQUENTIAL]
┌─────────────────────────────────────────┐
│ Agent: requirements-analyst             │
│ Status: SIMULATED                       │
│ Input: "implement new feature"          │
│ Output: Feature specification           │
│ Duration: ~2-3 min (estimated)          │
│ Process Load: 12                        │
└─────────────────────────────────────────┘

Phase 2: Implementation [PARALLEL]
┌─────────────────────────────────────────┐
│ Agent: frontend-developer               │
│ Status: SIMULATED                       │
│ Input: Feature spec (from Phase 1)      │
│ Output: UI components                   │
│ Duration: ~5-8 min (estimated)          │
│ Process Load: 18                        │
├─────────────────────────────────────────┤
│ Agent: backend-developer    [PARALLEL]  │
│ Status: SIMULATED                       │
│ Input: Feature spec (from Phase 1)      │
│ Output: API endpoints                   │
│ Duration: ~5-8 min (estimated)          │
│ Process Load: 20                        │
└─────────────────────────────────────────┘
Combined Process Load: 38 (within safe range)

Phase 3: Quality [SEQUENTIAL]
┌─────────────────────────────────────────┐
│ Agent: test-runner                      │
│ Status: SIMULATED                       │
│ Input: Implementation (from Phase 2)    │
│ Output: Test results                    │
│ Duration: ~3-5 min (estimated)          │
│ Process Load: 15                        │
│ ⚠ Execution: SEQUENTIAL (enforced)      │
└─────────────────────────────────────────┘

SAFETY VALIDATION:
──────────────────
✓ Quality agents marked sequential
✓ Parallel agents within limit (2 ≤ 3)
✓ Total process load acceptable (max 38)
✓ No circular dependencies
✓ Handoff points well-defined

TIMING ESTIMATE:
────────────────
Phase 1: 2-3 min
Phase 2: 5-8 min (parallel)
Phase 3: 3-5 min
────────────────
Total: 10-16 min

RESULT: PASS
Suite coordination validated successfully.
```

### 3. Hybrid Solution Test

Test skill-agent coordination:

```
/forge:test ./project-manager --scenario="create sprint tasks"
```

Output:

```
Hybrid Solution Test Results
============================
Solution: project-manager
Type: Skill (orchestrator) + 3 Agents (specialists)

ORCHESTRATION TRACE:
────────────────────
1. [SKILL] project-manager receives request
   → Analyzes: "create sprint tasks"
   → Decision: Delegate to task-creator agent

2. [DELEGATION] Skill → Agent handoff
   → Agent: task-creator
   → Context passed: sprint requirements
   → Expected output: task list

3. [AGENT] task-creator executes
   → Tools used: Read, Write
   → Creates: tasks.md
   → Returns: success + task list

4. [SKILL] Receives agent output
   → Aggregates results
   → May delegate to formatter agent
   → Returns final response to user

INTEGRATION VALIDATION:
───────────────────────
✓ Skill correctly identifies delegation scenarios
✓ Agent invocation patterns correct
✓ Context passing well-defined
✓ Result aggregation handled

RESULT: PASS
Hybrid coordination validated.
```

### 4. Hook Testing

Test hook event handling:

```
/forge:test ./pre-commit-hook --scenario="user edits sensitive file"
```

Output:

```
Hook Test Results
=================
Hook: pre-commit-hook
Event: PreToolCall (Edit)

EVENT SIMULATION:
─────────────────
Trigger: Edit tool called
File: config/secrets.yaml

Hook Response:
  Exit Code: 1 (BLOCK)
  Message: "Sensitive file detected. Please review changes."

BEHAVIOR:
─────────
✓ Hook correctly identifies sensitive files
✓ Blocks edit with appropriate message
✓ Does not modify any files
✓ Returns within timeout (5s)

RESULT: PASS
Hook behaves correctly for this scenario.
```

## Input Files

### JSON Input Format

```json
{
  "scenario": "user wants to refactor authentication module",
  "context": {
    "files": ["src/auth.py", "src/users.py"],
    "project_type": "python",
    "framework": "fastapi"
  },
  "expected": {
    "tools_used": ["Read", "Write", "Grep"],
    "output_type": "code_changes"
  }
}
```

### YAML Input Format

```yaml
scenario: user wants to refactor authentication module
context:
  files:
    - src/auth.py
    - src/users.py
  project_type: python
  framework: fastapi
expected:
  tools_used:
    - Read
    - Write
    - Grep
  output_type: code_changes
```

## Mock Tool Environment

When `--mock-tools` is enabled (default), the test command simulates tool behavior:

### Mocked Tool Responses

| Tool | Mock Behavior |
|------|---------------|
| Read | Returns placeholder file content |
| Write | Logs write intent, doesn't modify |
| Edit | Logs edit intent, doesn't modify |
| Grep | Returns simulated search results |
| Glob | Returns simulated file matches |
| Bash | Logs command, returns mock output |

### Example Mock Output

```
[MOCK] Read tool called
  Path: src/main.py
  Response: <simulated 50-line Python file>

[MOCK] Grep tool called
  Pattern: "def authenticate"
  Response: src/auth.py:15: def authenticate(user, password):

[MOCK] Write tool called
  Path: src/auth_new.py
  Action: Would create file (blocked in test mode)
```

## Execution Trace

With `--trace`, see detailed execution flow:

```
/forge:test ./code-reviewer --trace
```

Output:

```
EXECUTION TRACE
===============

[00:00.000] START: code-reviewer agent
[00:00.001] PARSE: Reading SKILL.md frontmatter
[00:00.002] VALIDATE: Checking tool permissions
[00:00.003] MATCH: Scenario matches description (score: 0.89)
[00:00.010] TOOL: Read(src/main.py) → [MOCK: 50 lines]
[00:00.015] TOOL: Grep("TODO|FIXME") → [MOCK: 3 matches]
[00:00.020] ANALYZE: Processing code patterns
[00:00.025] GENERATE: Creating review report
[00:00.030] OUTPUT: Markdown report (estimated 200 words)
[00:00.031] END: Agent execution complete

Total simulated time: 31ms
Estimated real time: 30-60 seconds
```

## Validation Checks

The test command validates:

### For All Extensions
- Frontmatter syntax and required fields
- Tool permissions vs actual usage
- Description clarity for auto-discovery
- Safety rule compliance

### For Agents
- Auto-invocation trigger matching
- Execution pattern appropriateness
- Process load estimation
- Tool restriction safety

### For Suites
- Agent coordination patterns
- Parallel execution safety
- Sequential enforcement for quality agents
- Dependency resolution
- Total process load

### For Hybrids
- Skill-agent delegation patterns
- Context passing completeness
- Result aggregation logic

### For Hooks
- Event type matching
- Response time estimation
- Exit code handling
- Shell script safety

## Examples

### Basic Extension Test

```
/forge:test ./my-agent
```

Interactive prompt for scenario.

### Test with Scenario

```
/forge:test ./formatter --scenario="format all Python files"
```

### Test Suite with Input File

```
/forge:test ./dev-workflow --input=test-scenarios.json
```

### Verbose Trace Output

```
/forge:test ./code-reviewer --trace --verbose
```

### Save Results

```
/forge:test ./my-suite --output=test-results.json
```

### Dry Run (Preview Only)

```
/forge:test ./my-agent --dry-run
```

## Test Result Format

### JSON Output (`--output`)

```json
{
  "extension": "code-reviewer",
  "type": "agent",
  "scenario": "review authentication changes",
  "timestamp": "2025-01-30T14:30:00Z",
  "result": "PASS",
  "confidence": 0.92,
  "validation": {
    "description_clarity": true,
    "tool_permissions": true,
    "safety_rules": true,
    "execution_pattern": true
  },
  "trace": [
    {"time": "00:00.001", "event": "START", "details": "..."},
    {"time": "00:00.010", "event": "TOOL", "details": "Read(...)"}
  ],
  "warnings": [],
  "errors": []
}
```

## Troubleshooting

### "Extension not found"

**Issue:** Can't locate the extension

**Solutions:**
1. Provide full path: `/forge:test ./plugins/eitri/my-agent`
2. Check file exists: `ls -la ./my-agent/SKILL.md`

### "Invalid scenario"

**Issue:** Scenario doesn't match extension

**Solutions:**
1. Review extension description
2. Use more specific scenario
3. Try `--verbose` for matching details

### "Safety violation detected"

**Issue:** Extension violates safety rules

**Solutions:**
1. Check execution pattern (quality agents must be sequential)
2. Review tool permissions
3. Verify process load estimates

### "Mock tool error"

**Issue:** Mock tool can't simulate behavior

**Solutions:**
1. Provide input file with expected context
2. Use `--mock-tools=false` for real execution (careful!)

## Integration

### Pre-Deployment Testing

```bash
# Test before installing
/forge:test ./my-agent

# If passes, install
/forge:install ./my-agent
```

### CI/CD Integration

```bash
# In CI pipeline
/forge:test ./my-extension --output=results.json
# Check results.json for PASS/FAIL
```

### Batch Testing

```bash
# Test all extensions in directory
for ext in ./extensions/*/; do
  /forge:test "$ext" --output="${ext}/test-results.json"
done
```

## Related Commands

| Command | Purpose |
|---------|---------|
| `/forge:validate` | Validate extension structure (no execution) |
| `/forge:test` | Test extension behavior (simulated execution) |
| `/forge:install` | Install validated extension |
| `/forge:diagram` | Visualize extension architecture |

## Philosophy

The test command embraces:

1. **Safety First:** Never modify files during testing
2. **Realistic Simulation:** Mock behavior matches real tools
3. **Comprehensive Validation:** Check all safety rules
4. **Clear Feedback:** Understand what would happen
5. **Local Only:** No network, no external services
