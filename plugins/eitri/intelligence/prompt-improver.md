# Prompt Improver Module

This module handles LLM-based analysis and improvement of extension prompts based on collected feedback.

## Overview

The Prompt Improver:
1. Receives pending feedback and the current prompt
2. Analyzes gaps between expected and actual behavior
3. Proposes concrete prompt modifications
4. Generates diff for user review

## Improvement Prompt Template

### Standard Extension Improvement

```markdown
# Prompt Improvement Task

## Current Prompt

{current_prompt_content}

## Pending Feedback

{feedback_entries}

## Your Task

Analyze the feedback and propose specific improvements to the prompt.

For each piece of feedback:
1. Identify what instruction is missing or unclear
2. Propose concrete additions or modifications
3. Explain why this change addresses the feedback

Rules:
- Preserve the existing structure and style
- Make minimal changes needed to address feedback
- Do not add features beyond what feedback requests
- Keep instructions clear and actionable

## Output Format

Provide your response in this JSON structure:

```json
{
  "analysis": [
    {
      "feedback_id": "fb-001",
      "root_cause": "Why this issue occurred",
      "proposed_change": "What to add or modify",
      "location": "Section name or line reference",
      "confidence": 0.0-1.0
    }
  ],
  "prompt_modifications": {
    "additions": [
      {
        "after": "Text after which to insert",
        "content": "New instruction text to add"
      }
    ],
    "modifications": [
      {
        "from": "Original text to find",
        "to": "Replacement text"
      }
    ],
    "removals": []
  },
  "changes_summary": "One-line summary of all changes",
  "overall_confidence": 0.0-1.0
}
```
```

### Eitri Component Improvement

When improving Eitri's own components, include contextual guidance:

```markdown
# Prompt Improvement Task

## Component Context

You are improving: `{component_path}`

{component_guidance}

You may modify anything if the feedback justifies it. Use your judgment.

## Current Prompt

{current_prompt_content}

## Pending Feedback

{feedback_entries}

## Your Task

[Same as standard template]
```

### Conflict Resolution Improvement

When merging after a remote update:

```markdown
# Conflict Resolution Task

## Current Prompt (after remote changes)

{current_prompt_content}

## Your Pending Feedback (not yet applied)

{pending_feedback_entries}

## Changes Made by Team Member

Version changed from {old_version} to {current_version}.
Feedback applied by them: {applied_feedback_ids}

## Your Task

The prompt was updated by a team member. Your feedback was not included.
1. Analyze if your feedback is still relevant given the new prompt
2. Propose improvements that don't conflict with recent changes
3. Skip feedback that was already addressed

[Same output format]
```

## Feedback Entry Formatting

```python
def format_feedback_entry(feedback):
    """Format a feedback entry for the improvement prompt."""
    severity = feedback.get("content", {}).get("severity", "medium")
    description = feedback.get("content", {}).get("description", "")
    context = feedback.get("content", {}).get("context", {})

    entry = f"""
### Feedback {feedback["id"]} ({severity.upper()} severity)

**Issue:** {description}
"""

    if context.get("expected"):
        entry += f"**Expected:** {context['expected']}\n"

    if context.get("actual"):
        entry += f"**Actual:** {context['actual']}\n"

    if context.get("file_analyzed"):
        entry += f"**Context file:** {context['file_analyzed']}\n"

    return entry


def format_all_feedback(feedback_list):
    """Format all feedback entries."""
    if not feedback_list:
        return "No pending feedback."

    entries = [format_feedback_entry(f) for f in feedback_list]
    return "\n".join(entries)
```

## Response Parsing

```python
class ImprovementParser:
    def parse_response(self, llm_response):
        """Parse LLM improvement response."""
        # Extract JSON from response
        json_match = re.search(r'```json\s*(.*?)\s*```', llm_response, re.DOTALL)
        if json_match:
            json_str = json_match.group(1)
        else:
            # Try to find raw JSON
            json_str = llm_response

        try:
            result = json.loads(json_str)
        except json.JSONDecodeError as e:
            return {"error": f"Failed to parse response: {e}"}

        # Validate structure
        required_fields = ["analysis", "prompt_modifications", "overall_confidence"]
        for field in required_fields:
            if field not in result:
                return {"error": f"Missing required field: {field}"}

        return result

    def apply_modifications(self, original_prompt, modifications):
        """Apply modifications to the original prompt."""
        result = original_prompt

        # Apply modifications (replacements)
        for mod in modifications.get("modifications", []):
            if mod["from"] in result:
                result = result.replace(mod["from"], mod["to"], 1)

        # Apply additions
        for add in modifications.get("additions", []):
            after_text = add["after"]
            if after_text in result:
                insert_pos = result.find(after_text) + len(after_text)
                result = result[:insert_pos] + "\n" + add["content"] + result[insert_pos:]

        # Apply removals
        for remove in modifications.get("removals", []):
            result = result.replace(remove, "")

        return result
```

## Diff Generation

```python
import difflib

class DiffGenerator:
    def generate(self, original, modified):
        """Generate a unified diff between original and modified prompts."""
        original_lines = original.splitlines(keepends=True)
        modified_lines = modified.splitlines(keepends=True)

        diff = difflib.unified_diff(
            original_lines,
            modified_lines,
            fromfile="SKILL.md (current)",
            tofile="SKILL.md (proposed)",
            lineterm=""
        )

        return "".join(diff)

    def generate_summary(self, analysis):
        """Generate a human-readable summary of changes."""
        lines = ["Identified improvements:"]

        for i, item in enumerate(analysis, 1):
            lines.append(f"  {i}. {item['proposed_change']}")
            lines.append(f"     Confidence: {item['confidence']:.0%}")

        return "\n".join(lines)
```

## Confidence Calculation

```python
class ConfidenceCalculator:
    def calculate(self, analysis_result):
        """Calculate overall confidence in the improvement."""
        if not analysis_result.get("analysis"):
            return 0.0

        # Weight by severity
        severity_weights = {
            "critical": 1.5,
            "high": 1.2,
            "medium": 1.0,
            "low": 0.8
        }

        total_confidence = 0
        total_weight = 0

        for item in analysis_result["analysis"]:
            confidence = item.get("confidence", 0.5)
            severity = item.get("severity", "medium")
            weight = severity_weights.get(severity, 1.0)

            total_confidence += confidence * weight
            total_weight += weight

        if total_weight == 0:
            return 0.0

        return total_confidence / total_weight

    def should_apply(self, confidence, threshold=0.5):
        """Determine if improvement should be suggested."""
        return confidence >= threshold
```

## Integration with Optimization Engine

```python
class PromptImprover:
    def __init__(self):
        self.parser = ImprovementParser()
        self.diff_gen = DiffGenerator()
        self.confidence = ConfidenceCalculator()

    def improve(self, extension, pending_feedback, component_guidance=None):
        """Run the improvement process."""
        # Build prompt
        prompt = self._build_prompt(
            extension["prompt_content"],
            pending_feedback,
            component_guidance
        )

        # Call LLM (placeholder - actual implementation uses Claude)
        llm_response = self._call_llm(prompt)

        # Parse response
        analysis = self.parser.parse_response(llm_response)
        if "error" in analysis:
            return {"success": False, "error": analysis["error"]}

        # Apply modifications
        modified_prompt = self.parser.apply_modifications(
            extension["prompt_content"],
            analysis["prompt_modifications"]
        )

        # Generate diff
        diff = self.diff_gen.generate(extension["prompt_content"], modified_prompt)
        summary = self.diff_gen.generate_summary(analysis["analysis"])

        # Calculate confidence
        confidence = analysis.get("overall_confidence", 0.0)

        return {
            "success": True,
            "analysis": analysis,
            "modified_prompt": modified_prompt,
            "diff": diff,
            "summary": summary,
            "confidence": confidence,
            "changes_summary": analysis.get("changes_summary", "")
        }

    def _build_prompt(self, prompt_content, feedback, guidance):
        """Build the improvement prompt."""
        template = self._get_template(guidance is not None)

        formatted_feedback = format_all_feedback(feedback)

        prompt = template.format(
            current_prompt_content=prompt_content,
            feedback_entries=formatted_feedback,
            component_guidance=guidance or ""
        )

        return prompt

    def _get_template(self, is_eitri_component):
        """Get appropriate template."""
        if is_eitri_component:
            return EITRI_COMPONENT_TEMPLATE
        return STANDARD_TEMPLATE

    def _call_llm(self, prompt):
        """Call LLM for improvement suggestions."""
        # This is handled by the enclosing Claude context
        # The prompt is designed to be used directly in conversation
        raise NotImplementedError("LLM call is handled by parent context")
```

## User Confirmation Flow

```python
class ConfirmationFlow:
    def present(self, improvement_result):
        """Present improvement for user confirmation."""
        if not improvement_result["success"]:
            return f"Error: {improvement_result['error']}"

        output = f"""
Step 3: LLM Analysis
────────────────────────────────────────────
{improvement_result['summary']}

Confidence: {improvement_result['confidence']:.0%}

Step 4: Proposed Changes
────────────────────────────────────────────
{improvement_result['diff']}

Step 5: Confirmation
────────────────────────────────────────────
Apply these changes? [y/n/edit]:
"""
        return output

    def handle_response(self, response, improvement_result):
        """Handle user response."""
        if response.lower() == 'y':
            return {"action": "apply", "prompt": improvement_result["modified_prompt"]}
        elif response.lower() == 'n':
            return {"action": "cancel"}
        elif response.lower() == 'edit':
            return {"action": "edit", "prompt": improvement_result["modified_prompt"]}
        else:
            return {"action": "unknown"}
```

## Prompt Injection Awareness

When including feedback in the improvement prompt, clearly delineate user-provided content:

```python
def format_feedback_safely(feedback):
    """Format feedback with clear boundaries to prevent injection."""
    description = feedback.get("content", {}).get("description", "")

    # Wrap in clear delimiters
    safe_description = f"""
<user-feedback>
{description}
</user-feedback>
"""
    return safe_description
```

The LLM is instructed to treat content within `<user-feedback>` tags as data, not instructions.

## Statistics Integration

Track improvement success rates:

```python
def update_improvement_stats(extension_name, applied, verified=None):
    """Update improvement statistics."""
    stats_file = Path.home() / ".claude/eitri/learning/improvement-stats.json"

    if stats_file.exists():
        stats = json.loads(stats_file.read_text())
    else:
        stats = {}

    if extension_name not in stats:
        stats[extension_name] = {
            "improvements_applied": 0,
            "improvements_verified": 0,
            "improvements_reopened": 0
        }

    if applied:
        stats[extension_name]["improvements_applied"] += 1

    if verified is True:
        stats[extension_name]["improvements_verified"] += 1
    elif verified is False:
        stats[extension_name]["improvements_reopened"] += 1

    stats_file.write_text(json.dumps(stats, indent=2))
```
