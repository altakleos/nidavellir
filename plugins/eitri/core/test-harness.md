# Test Harness Module

This module provides the sandbox testing infrastructure for Eitri-generated extensions. It enables safe simulation and validation without modifying files or executing real commands.

## Overview

The test harness:
1. Loads and parses extensions
2. Creates a mock tool environment
3. Simulates execution scenarios
4. Validates behavior against safety rules
5. Reports results with confidence scores

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Test Harness                         │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │  Extension  │  │    Mock     │  │  Scenario   │     │
│  │   Loader    │  │   Tools     │  │   Runner    │     │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘     │
│         │                │                │             │
│         ▼                ▼                ▼             │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Execution Simulator                 │   │
│  └─────────────────────────────────────────────────┘   │
│                          │                              │
│                          ▼                              │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Validation Engine                   │   │
│  └─────────────────────────────────────────────────┘   │
│                          │                              │
│                          ▼                              │
│  ┌─────────────────────────────────────────────────┐   │
│  │              Results Reporter                    │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Components

### 1. Extension Loader

Loads and parses extension files:

```python
class ExtensionLoader:
    def __init__(self, path):
        self.path = Path(path)
        self.extension = None
        self.type = None

    def load(self):
        """Load extension from path."""
        skill_file = self._find_skill_file()
        if not skill_file:
            raise ExtensionNotFoundError(f"No SKILL.md found at {self.path}")

        content = skill_file.read_text()
        self.extension = self._parse_extension(content)
        self.type = self._determine_type()

        return self.extension

    def _find_skill_file(self):
        """Find SKILL.md in path or subdirectories."""
        candidates = [
            self.path / "SKILL.md",
            self.path / ".claude-plugin" / "SKILL.md",
            self.path  # If path is directly to SKILL.md
        ]
        for candidate in candidates:
            if candidate.exists() and candidate.name == "SKILL.md":
                return candidate
        return None

    def _parse_extension(self, content):
        """Parse YAML frontmatter and body."""
        if not content.startswith("---"):
            raise InvalidExtensionError("Missing YAML frontmatter")

        parts = content.split("---", 2)
        if len(parts) < 3:
            raise InvalidExtensionError("Invalid frontmatter format")

        frontmatter = yaml.safe_load(parts[1])
        body = parts[2].strip()

        return {
            "frontmatter": frontmatter,
            "body": body,
            "name": frontmatter.get("name"),
            "description": frontmatter.get("description"),
            "allowed_tools": frontmatter.get("allowed-tools", []),
            "version": frontmatter.get("version", "1.0.0")
        }

    def _determine_type(self):
        """Determine extension type from content analysis."""
        description = self.extension.get("description", "").lower()
        body = self.extension.get("body", "").lower()

        # Check for type indicators
        if "hook" in description or "event" in body:
            return "hook"
        if "mcp" in description or "server" in description:
            return "mcp"
        if "suite" in body or "coordination" in body:
            return "suite"
        if "hybrid" in body or "orchestrat" in body:
            return "hybrid"
        if "automatically" in description or "auto-invok" in body:
            return "agent"
        return "skill"
```

### 2. Mock Tool Environment

Simulates tool behavior without side effects:

```python
class MockToolEnvironment:
    def __init__(self):
        self.tool_calls = []
        self.mock_responses = {}

    def configure_mocks(self, config=None):
        """Configure mock responses."""
        self.mock_responses = config or self._default_mocks()

    def _default_mocks(self):
        """Default mock responses for common tools."""
        return {
            "Read": self._mock_read,
            "Write": self._mock_write,
            "Edit": self._mock_edit,
            "Grep": self._mock_grep,
            "Glob": self._mock_glob,
            "Bash": self._mock_bash
        }

    def call_tool(self, tool_name, **kwargs):
        """Simulate tool call and record it."""
        call_record = {
            "tool": tool_name,
            "args": kwargs,
            "timestamp": time.time()
        }
        self.tool_calls.append(call_record)

        if tool_name in self.mock_responses:
            return self.mock_responses[tool_name](**kwargs)
        return {"status": "mocked", "message": f"No mock for {tool_name}"}

    def _mock_read(self, file_path=None, **kwargs):
        """Mock Read tool."""
        extension = Path(file_path).suffix if file_path else ".txt"
        mock_content = self._generate_mock_content(extension)
        return {
            "status": "success",
            "content": mock_content,
            "lines": len(mock_content.split("\n")),
            "mocked": True
        }

    def _mock_write(self, file_path=None, content=None, **kwargs):
        """Mock Write tool (no actual write)."""
        return {
            "status": "blocked",
            "message": f"Would write to: {file_path}",
            "content_length": len(content) if content else 0,
            "mocked": True
        }

    def _mock_edit(self, file_path=None, old_string=None, new_string=None, **kwargs):
        """Mock Edit tool (no actual edit)."""
        return {
            "status": "blocked",
            "message": f"Would edit: {file_path}",
            "old_string": old_string[:50] + "..." if old_string and len(old_string) > 50 else old_string,
            "mocked": True
        }

    def _mock_grep(self, pattern=None, path=None, **kwargs):
        """Mock Grep tool."""
        mock_results = [
            f"{path or 'src'}/file1.py:10: match for {pattern}",
            f"{path or 'src'}/file2.py:25: another match"
        ]
        return {
            "status": "success",
            "matches": mock_results,
            "count": len(mock_results),
            "mocked": True
        }

    def _mock_glob(self, pattern=None, **kwargs):
        """Mock Glob tool."""
        mock_files = [
            "src/main.py",
            "src/utils.py",
            "tests/test_main.py"
        ]
        return {
            "status": "success",
            "files": mock_files,
            "count": len(mock_files),
            "mocked": True
        }

    def _mock_bash(self, command=None, **kwargs):
        """Mock Bash tool (no actual execution)."""
        return {
            "status": "blocked",
            "message": f"Would execute: {command}",
            "mocked": True
        }

    def _generate_mock_content(self, extension):
        """Generate mock file content based on extension."""
        templates = {
            ".py": "# Python file\ndef main():\n    pass\n\nif __name__ == '__main__':\n    main()",
            ".js": "// JavaScript file\nfunction main() {\n  console.log('Hello');\n}\n\nmain();",
            ".ts": "// TypeScript file\nfunction main(): void {\n  console.log('Hello');\n}\n\nmain();",
            ".md": "# Document\n\nThis is a mock document.\n\n## Section\n\nContent here.",
            ".json": '{\n  "name": "mock",\n  "version": "1.0.0"\n}',
            ".yaml": "name: mock\nversion: 1.0.0\n",
        }
        return templates.get(extension, "Mock file content")

    def get_call_summary(self):
        """Get summary of all tool calls."""
        summary = {}
        for call in self.tool_calls:
            tool = call["tool"]
            summary[tool] = summary.get(tool, 0) + 1
        return summary
```

### 3. Scenario Runner

Runs test scenarios against extensions:

```python
class ScenarioRunner:
    def __init__(self, extension, mock_env):
        self.extension = extension
        self.mock_env = mock_env
        self.trace = []

    def run(self, scenario):
        """Run a test scenario."""
        self._log_trace("START", f"Testing {self.extension['name']}")

        # Check if scenario matches extension
        match_score = self._check_scenario_match(scenario)
        self._log_trace("MATCH", f"Scenario match score: {match_score:.2f}")

        if match_score < 0.3:
            return {
                "result": "SKIP",
                "reason": "Scenario doesn't match extension description",
                "match_score": match_score
            }

        # Validate tool permissions
        tool_validation = self._validate_tool_access(scenario)
        self._log_trace("TOOLS", f"Tool validation: {tool_validation}")

        # Simulate execution
        execution_result = self._simulate_execution(scenario)
        self._log_trace("EXECUTE", f"Execution simulated")

        # Generate output prediction
        output_prediction = self._predict_output(scenario)
        self._log_trace("OUTPUT", f"Predicted output type: {output_prediction}")

        self._log_trace("END", "Test complete")

        return {
            "result": "PASS" if tool_validation["valid"] else "FAIL",
            "match_score": match_score,
            "tool_validation": tool_validation,
            "execution": execution_result,
            "output": output_prediction,
            "trace": self.trace
        }

    def _check_scenario_match(self, scenario):
        """Check how well scenario matches extension description."""
        description = self.extension.get("description", "").lower()
        scenario_lower = scenario.lower()

        # Simple keyword matching
        scenario_words = set(scenario_lower.split())
        description_words = set(description.split())

        common_words = scenario_words & description_words
        # Remove common stop words
        stop_words = {"the", "a", "an", "is", "are", "to", "for", "and", "or", "in", "on"}
        common_words -= stop_words

        if not scenario_words - stop_words:
            return 0.0

        return len(common_words) / len(scenario_words - stop_words)

    def _validate_tool_access(self, scenario):
        """Validate tool access for scenario."""
        allowed = set(self.extension.get("allowed_tools", []))
        predicted_tools = self._predict_tool_usage(scenario)

        valid = True
        details = []

        for tool in predicted_tools:
            if tool in allowed or not allowed:  # Empty means all allowed
                details.append({"tool": tool, "status": "ALLOWED"})
            else:
                details.append({"tool": tool, "status": "BLOCKED"})
                valid = False

        return {
            "valid": valid,
            "allowed": list(allowed),
            "predicted": predicted_tools,
            "details": details
        }

    def _predict_tool_usage(self, scenario):
        """Predict which tools would be used for scenario."""
        scenario_lower = scenario.lower()
        predicted = []

        tool_keywords = {
            "Read": ["read", "view", "show", "display", "content"],
            "Write": ["write", "create", "generate", "output"],
            "Edit": ["edit", "modify", "change", "update", "refactor"],
            "Grep": ["search", "find", "look for", "pattern"],
            "Glob": ["files", "directory", "list"],
            "Bash": ["run", "execute", "command", "test", "build"]
        }

        for tool, keywords in tool_keywords.items():
            if any(kw in scenario_lower for kw in keywords):
                predicted.append(tool)

        # Default to Read if nothing predicted
        if not predicted:
            predicted = ["Read"]

        return predicted

    def _simulate_execution(self, scenario):
        """Simulate extension execution."""
        predicted_tools = self._predict_tool_usage(scenario)
        results = []

        for tool in predicted_tools:
            result = self.mock_env.call_tool(tool, scenario=scenario)
            results.append({"tool": tool, "result": result})

        return {
            "tools_called": len(results),
            "results": results
        }

    def _predict_output(self, scenario):
        """Predict type of output extension would generate."""
        scenario_lower = scenario.lower()

        if "review" in scenario_lower:
            return "markdown_report"
        if "test" in scenario_lower:
            return "test_results"
        if "format" in scenario_lower:
            return "code_changes"
        if "generate" in scenario_lower or "create" in scenario_lower:
            return "new_files"

        return "text_response"

    def _log_trace(self, event, details):
        """Log trace event."""
        self.trace.append({
            "timestamp": time.time(),
            "event": event,
            "details": details
        })
```

### 4. Validation Engine

Validates extension behavior against rules:

```python
class ValidationEngine:
    def __init__(self, extension, extension_type):
        self.extension = extension
        self.type = extension_type
        self.violations = []
        self.warnings = []

    def validate(self):
        """Run all validations."""
        self._validate_frontmatter()
        self._validate_description()
        self._validate_tools()
        self._validate_safety_rules()
        self._validate_type_specific()

        return {
            "valid": len(self.violations) == 0,
            "violations": self.violations,
            "warnings": self.warnings,
            "checks_passed": self._count_passed()
        }

    def _validate_frontmatter(self):
        """Validate required frontmatter fields."""
        fm = self.extension.get("frontmatter", {})

        if not fm.get("name"):
            self.violations.append("Missing required field: name")
        if not fm.get("description"):
            self.violations.append("Missing required field: description")

        # Check name format
        name = fm.get("name", "")
        if not re.match(r'^[a-z0-9-]+$', name):
            self.violations.append(f"Invalid name format: {name}")

        # Check description length
        desc = fm.get("description", "")
        if len(desc) > 1024:
            self.warnings.append("Description exceeds 1024 characters")

    def _validate_description(self):
        """Validate description for auto-discovery."""
        desc = self.extension.get("description", "")

        # Check for action verbs
        action_verbs = ["reviews", "generates", "formats", "tests", "validates",
                        "creates", "analyzes", "monitors", "deploys"]
        has_action = any(verb in desc.lower() for verb in action_verbs)

        if not has_action and self.type == "agent":
            self.warnings.append("Agent description should start with action verb")

        # Check for trigger context
        trigger_words = ["when", "whenever", "after", "before", "on"]
        has_trigger = any(word in desc.lower() for word in trigger_words)

        if not has_trigger and self.type == "agent":
            self.warnings.append("Agent description should include trigger context")

    def _validate_tools(self):
        """Validate tool configuration."""
        allowed = self.extension.get("allowed_tools", [])

        # Valid tools list
        valid_tools = ["Read", "Write", "Edit", "Grep", "Glob", "Bash",
                       "Task", "WebFetch", "WebSearch", "TodoWrite"]

        for tool in allowed:
            if tool not in valid_tools:
                self.violations.append(f"Invalid tool: {tool}")

        # Check for risky combinations
        if "Bash" in allowed and self.type == "agent":
            self.warnings.append("Bash tool in agent may cause issues in parallel execution")

    def _validate_safety_rules(self):
        """Validate against safety rules."""
        body = self.extension.get("body", "").lower()
        allowed = self.extension.get("allowed_tools", [])

        # Quality agents must be sequential
        quality_indicators = ["test", "review", "validate", "quality", "audit"]
        is_quality = any(ind in body for ind in quality_indicators)

        if is_quality and "parallel" in body:
            self.violations.append("Quality agents must use sequential execution")

        # Check for process load mentions
        if "process_load" not in body and self.type in ["agent", "suite"]:
            self.warnings.append("Consider documenting process load estimate")

    def _validate_type_specific(self):
        """Type-specific validations."""
        if self.type == "suite":
            self._validate_suite()
        elif self.type == "hybrid":
            self._validate_hybrid()
        elif self.type == "hook":
            self._validate_hook()

    def _validate_suite(self):
        """Suite-specific validations."""
        body = self.extension.get("body", "").lower()

        # Check for coordination pattern
        patterns = ["pipeline", "fork-join", "event-driven", "hierarchical"]
        has_pattern = any(p in body for p in patterns)

        if not has_pattern:
            self.warnings.append("Suite should specify coordination pattern")

    def _validate_hybrid(self):
        """Hybrid-specific validations."""
        body = self.extension.get("body", "").lower()

        # Check for orchestrator mention
        if "orchestrat" not in body and "coordinat" not in body:
            self.warnings.append("Hybrid should define orchestrator role")

    def _validate_hook(self):
        """Hook-specific validations."""
        body = self.extension.get("body", "").lower()

        # Check for event type
        events = ["pretoolcall", "posttoolcall", "notification", "stop",
                  "sessionstart", "sessionend", "subagentstop"]
        has_event = any(e in body for e in events)

        if not has_event:
            self.warnings.append("Hook should specify event type")

    def _count_passed(self):
        """Count passed validation checks."""
        total_checks = 10  # Approximate number of checks
        failed = len(self.violations)
        return total_checks - failed
```

### 5. Results Reporter

Formats and outputs test results:

```python
class ResultsReporter:
    def __init__(self):
        self.results = {}

    def generate_report(self, scenario_result, validation_result, extension_info):
        """Generate comprehensive test report."""
        self.results = {
            "extension": extension_info["name"],
            "type": extension_info["type"],
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "scenario": scenario_result,
            "validation": validation_result,
            "overall": self._calculate_overall(scenario_result, validation_result)
        }
        return self.results

    def _calculate_overall(self, scenario, validation):
        """Calculate overall result."""
        if not validation["valid"]:
            return {"result": "FAIL", "confidence": 0.0}

        if scenario["result"] == "SKIP":
            return {"result": "SKIP", "confidence": 0.0}

        # Calculate confidence based on match score and validation
        base_confidence = scenario["match_score"]
        warning_penalty = len(validation["warnings"]) * 0.05
        confidence = max(0.0, min(1.0, base_confidence - warning_penalty))

        result = "PASS" if confidence > 0.5 else "WARN"

        return {
            "result": result,
            "confidence": round(confidence, 2)
        }

    def format_console(self):
        """Format results for console output."""
        r = self.results
        output = []

        output.append(f"Extension Test Results")
        output.append("=" * 50)
        output.append(f"Extension: {r['extension']} ({r['type']})")
        output.append("")

        # Overall result
        overall = r["overall"]
        result_symbol = {"PASS": "✓", "FAIL": "✗", "WARN": "⚠", "SKIP": "○"}
        output.append(f"RESULT: {result_symbol.get(overall['result'], '?')} {overall['result']}")
        output.append(f"Confidence: {overall['confidence'] * 100:.0f}%")
        output.append("")

        # Validation details
        v = r["validation"]
        output.append("VALIDATION:")
        output.append("-" * 30)
        for check in ["frontmatter", "description", "tools", "safety"]:
            passed = not any(check in str(viol).lower() for viol in v.get("violations", []))
            output.append(f"  {'✓' if passed else '✗'} {check.title()}")

        # Warnings
        if v.get("warnings"):
            output.append("")
            output.append("WARNINGS:")
            for w in v["warnings"]:
                output.append(f"  ⚠ {w}")

        # Violations
        if v.get("violations"):
            output.append("")
            output.append("VIOLATIONS:")
            for viol in v["violations"]:
                output.append(f"  ✗ {viol}")

        return "\n".join(output)

    def format_json(self):
        """Format results as JSON."""
        return json.dumps(self.results, indent=2)
```

## Test Scenarios

### Predefined Scenarios

The test harness includes common scenarios:

```python
PREDEFINED_SCENARIOS = {
    "code_review": {
        "description": "user requests code review",
        "expected_tools": ["Read", "Grep", "Glob"],
        "expected_output": "markdown_report"
    },
    "format_code": {
        "description": "format all Python files",
        "expected_tools": ["Read", "Write", "Glob"],
        "expected_output": "code_changes"
    },
    "run_tests": {
        "description": "run test suite",
        "expected_tools": ["Bash", "Read"],
        "expected_output": "test_results"
    },
    "generate_docs": {
        "description": "generate documentation",
        "expected_tools": ["Read", "Write", "Glob"],
        "expected_output": "new_files"
    }
}
```

### Custom Scenarios

Users can define custom scenarios:

```yaml
# test-scenario.yaml
scenario: review authentication module for security issues
context:
  files:
    - src/auth.py
    - src/session.py
  focus: security
expected:
  tools: [Read, Grep]
  output: security_report
  categories: [critical, warning, info]
```

## Integration Points

### With /forge:test Command

```python
def handle_test_command(args):
    """Handle /forge:test command."""
    # Load extension
    loader = ExtensionLoader(args.path)
    extension = loader.load()
    extension_type = loader.type

    # Create mock environment
    mock_env = MockToolEnvironment()
    if args.mock_tools:
        mock_env.configure_mocks()

    # Run scenario
    runner = ScenarioRunner(extension, mock_env)
    scenario_result = runner.run(args.scenario)

    # Validate
    validator = ValidationEngine(extension, extension_type)
    validation_result = validator.validate()

    # Report
    reporter = ResultsReporter()
    report = reporter.generate_report(
        scenario_result,
        validation_result,
        {"name": extension["name"], "type": extension_type}
    )

    if args.output:
        Path(args.output).write_text(reporter.format_json())

    return reporter.format_console()
```

### With CI/CD Systems

```yaml
# .github/workflows/test-extensions.yml
name: Test Extensions
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Test Extensions
        run: |
          for ext in ./extensions/*/; do
            /forge:test "$ext" --output="${ext}/test-results.json"
          done
      - name: Check Results
        run: |
          python scripts/check_test_results.py
```

## Performance Considerations

### Caching

```python
class TestCache:
    """Cache test results to avoid redundant testing."""

    def __init__(self, cache_dir=".cache/eitri-tests"):
        self.cache_dir = Path(cache_dir)
        self.cache_dir.mkdir(parents=True, exist_ok=True)

    def get_cached(self, extension_path, scenario_hash):
        """Get cached result if extension unchanged."""
        cache_key = self._compute_key(extension_path, scenario_hash)
        cache_file = self.cache_dir / f"{cache_key}.json"

        if cache_file.exists():
            cached = json.loads(cache_file.read_text())
            if self._is_valid(cached, extension_path):
                return cached["result"]

        return None

    def cache_result(self, extension_path, scenario_hash, result):
        """Cache test result."""
        cache_key = self._compute_key(extension_path, scenario_hash)
        cache_file = self.cache_dir / f"{cache_key}.json"

        cache_entry = {
            "extension_hash": self._hash_extension(extension_path),
            "timestamp": time.time(),
            "result": result
        }
        cache_file.write_text(json.dumps(cache_entry))
```

### Parallel Testing

```python
def test_multiple_extensions(extension_paths, scenarios):
    """Test multiple extensions in parallel."""
    from concurrent.futures import ThreadPoolExecutor

    results = []

    with ThreadPoolExecutor(max_workers=4) as executor:
        futures = []
        for path in extension_paths:
            for scenario in scenarios:
                future = executor.submit(test_extension, path, scenario)
                futures.append((path, scenario, future))

        for path, scenario, future in futures:
            result = future.result()
            results.append({
                "extension": path,
                "scenario": scenario,
                "result": result
            })

    return results
```

## Future Enhancements

Potential improvements:

1. **Interactive Mode:** Step-through execution with breakpoints
2. **Coverage Analysis:** Track which extension paths are tested
3. **Regression Testing:** Compare results across versions
4. **Performance Profiling:** Estimate real execution time
5. **Fuzzing:** Generate random scenarios to find edge cases
