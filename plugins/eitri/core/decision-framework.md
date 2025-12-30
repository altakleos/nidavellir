---
name: decision-framework
type: module
description: Intelligent decision logic for skill vs agent vs suite vs hybrid
---

# Decision Framework - Extension Type Selection

## Core Decision Matrix

### When to Create a Skill

**Strong Indicators (3+ means skill):**
- Heavy context dependency (deeply integrated with specific workflow)
- One-time custom solution (not reusable across projects)
- Tightly coupled operations (everything depends on everything)
- Complex state management (needs persistent context)
- User-specific adaptation (changes based on who's using it)
- Natural conversation flow (part of ongoing dialogue)
- Requires full tool access (no benefit from restrictions)

**Example Scenarios:**
- Custom business workflow automation
- Organization-specific reporting system
- Integrated data pipeline with unique rules
- Context-heavy analysis with multiple dependencies

### When to Create an Agent

**Strong Indicators (3+ means agent):**
- Clear, single responsibility (does one thing well)
- Reusable across projects (same agent, many uses)
- Task-triggered invocation (auto-runs on condition)
- Benefits from tool restrictions (safety through limitation)
- Stateless operation (doesn't need memory between runs)
- Clear success criteria (easy to verify completion)
- Works independently (minimal coordination needs)

**Example Scenarios:**
- Code formatter/linter
- Security scanner
- Test runner
- Documentation generator
- Commit message writer

### When to Create Agent Suite

**Strong Indicators (3+ means suite):**
- Multiple distinct responsibilities
- Different tool requirements per component
- Clear handoff points between operations
- Benefits from parallel execution
- Different expertise levels per component
- Separate failure boundaries
- Team-based workflow (different roles)

**Example Scenarios:**
- Full development workflow (plan → code → test → review)
- Data pipeline (extract → transform → analyze → report)
- Content creation (research → write → edit → publish)
- DevOps workflow (build → test → deploy → monitor)

### When to Create Hybrid Solution

**Strong Indicators (2+ means consider hybrid):**
- Central orchestration with specialized components
- Some parts reusable, others custom
- Mix of conversation-driven and task-triggered
- Complex coordination with simple executors
- Gradual automation (start integrated, extract agents over time)

**Example Scenarios:**
- Project management system (skill) + specialized automations (agents)
- Custom workflow (skill) + generic validators (agents)
- Business logic (skill) + utility functions (agents)

## Scoring Algorithm

I analyze the discovery result across multiple dimensions and score each extension type:

### Reusability Dimension (Weight: 8)
- High reusability → Agent +8, Suite +6
- Medium reusability → Hybrid +7
- Low reusability → Skill +8

### Invocation Pattern Dimension (Weight: 9)
- Task-triggered → Agent +9, Suite +7
- Conversation-driven → Skill +9
- Mixed → Hybrid +8

### Coupling Dimension (Weight: 10)
- Tight coupling (3-4 dimensions) → Skill +10
- Medium coupling (2 dimensions) → Hybrid +8
- Loose coupling (0-1 dimensions) → Agent +8, Suite +10

### Context Dependency Dimension (Weight: 9)
- Heavy context → Skill +9, Hybrid +6
- Medium context → Skill +5, Hybrid +5
- Light context → Agent +8, Suite +7

### Tool Safety Dimension (Weight: 8)
- Benefits from restrictions → Agent +8, Suite +8
- Needs full access → Skill +7
- Mixed needs → Hybrid +6

### Multiple Roles Dimension (Weight: 9)
- Multiple distinct roles → Suite +9, Hybrid +6
- Single role → Skill +5, Agent +8
- Coordinating role → Hybrid +7

### Complexity Dimension (Weight: 6)
- High complexity → Skill +7 (unless multiple roles → Suite +8)
- Medium complexity → Any type viable
- Low complexity → Agent +6 (simplicity favors focused agents)

## Decision Transparency

I present my analysis with clear scoring:

```
Extension Type Analysis:
┌─────────────────────────────────────────┐
│ Factor              │ Skill │ Agent │ Suite │
├─────────────────────┼───────┼───────┼───────┤
│ Reusability         │   2   │   8   │   6   │
│ Auto-invoke benefit │   3   │   9   │   7   │
│ Context dependency  │   9   │   3   │   5   │
│ Tool restrictions   │   4   │   8   │   8   │
│ Multiple roles      │   2   │   5   │   9   │
│ Coupling level      │   8   │   3   │   4   │
├─────────────────────┼───────┼───────┼───────┤
│ TOTAL              │  28   │  36   │  39   │
└─────────────────────────────────────────┘

Recommendation: Agent Suite
Confidence: 85%

Reasoning: Your requirements involve multiple distinct roles (frontend,
backend, testing) that benefit from separation. Each component has
different tool needs and can work in parallel for efficiency. The
loose coupling between components makes a suite ideal.

Would you like me to proceed with creating an agent suite, or would
you prefer a different approach?
```

## Confidence Calculation

Confidence is based on:
1. Score margin (how much the winner beats second place)
2. Clarity of requirements (fewer ambiguities = higher confidence)
3. Pattern match (similarity to known successful patterns)

```python
def calculate_confidence(scores, discovery_result):
    sorted_scores = sorted(scores.values(), reverse=True)
    margin = (sorted_scores[0] - sorted_scores[1]) / sorted_scores[0]

    clarity_score = 1.0 - (len(discovery_result["ambiguities"]) * 0.1)
    pattern_match = discovery_result.get("pattern_similarity", 0.5)

    confidence = (margin * 0.5) + (clarity_score * 0.3) + (pattern_match * 0.2)

    return min(confidence, 0.99)  # Cap at 99%
```

## Context-Adaptive Types

Rather than rigid agent type classification (strategic/implementation/quality/coordination), I determine characteristics contextually:

### Agent Characteristics Analysis

**For each potential agent, I determine:**

1. **Primary Function**
   - Planning & Research → strategic characteristics
   - Code & Building → implementation characteristics
   - Testing & Validation → quality characteristics
   - Orchestration → coordination characteristics

2. **Tool Access (context-based)**
   - What tools are minimally necessary?
   - What restrictions improve safety?
   - What access patterns match the function?

3. **Execution Pattern (safety-based)**
   - Can run in parallel safely?
   - Needs coordination with others?
   - Must run sequentially (quality/critical operations)?

4. **Process Load (complexity-based)**
   - Lightweight operations: 10-15 processes
   - Medium operations: 15-25 processes
   - Heavy operations: 25-35 processes

## Override Handling

When users disagree with recommendation:

```markdown
User: "Actually, I think this should be a skill"

Framework: I understand. Let me adjust for a skill approach.
This means:
- Tighter integration with your workflow
- More context-aware behavior
- Custom implementation for your specific needs
- All operations in one cohesive unit

The trade-off is less reusability across projects and no auto-invocation.

I'll also note your preference. If you find the skill approach works better,
I'll learn from this for similar future requests.

Shall I proceed with skill creation?
```

## Learning from Decisions

I track decision outcomes (with permission) to improve recommendations over time. See `intelligence/learning-engine.md` for full details.

### Integration with Learning Engine

```python
# When making a recommendation
def get_personalized_recommendation(discovery_result):
    # Load learning engine
    learning = LearningEngine()

    # Get personalized weights (base + user adjustments)
    weights = learning.get_effective_weights()

    # Calculate scores with personalized weights
    scores = calculate_scores(discovery_result, weights)

    # Check for matching override patterns
    pattern = learning.find_matching_pattern(discovery_result)
    if pattern and pattern["confidence"] > 0.8:
        scores = apply_pattern_boost(scores, pattern)

    return {
        "type": max(scores, key=scores.get),
        "scores": scores,
        "personalized": learning.has_adjustments()
    }
```

### Decision Outcome Tracking

```python
decision_outcome = {
    "recommendation": "agent",
    "user_choice": "skill",
    "reasoning": "User preferred tighter integration",
    "satisfaction": 0.92,  # Collected via /forge:feedback
    "context": {
        "coupling": "high",
        "reusability": "medium",
        "domain": "development"
    },
    "learn_from": True
}
```

### Personalized Display

When personalization is active, show indicator:

```
Extension Type Analysis:
┌─────────────────────────────────────────┐
│ Factor              │ Skill │ Agent │
├─────────────────────┼───────┼───────┤
│ Reusability         │   2   │   7*  │ ← *Adjusted
│ Coupling level      │  12*  │   4   │ ← *Adjusted
├─────────────────────┼───────┼───────┤
│ TOTAL              │  28   │  24   │
└─────────────────────────────────────────┘

Recommendation: Skill
Confidence: 82%
[📊 Personalized based on your feedback]
```

### Feedback Collection Points

1. **Implicit:** When user accepts/overrides recommendation
2. **Explicit:** Via `/forge:feedback` command
3. **Success:** Extension created and used successfully
4. **Issue:** Problems reported with extension

This feeds into the pattern learning system to improve future recommendations.

## Edge Case Handling

### Equal Scores
When multiple types score equally:
- Present all viable options
- Explain trade-offs clearly
- Let user preferences guide decision
- Default to simpler option (Skill > Agent > Suite)

### Low Confidence (<60%)
- Acknowledge uncertainty
- Present multiple options
- Ask clarifying questions
- Suggest starting simple and evolving

### Unclear Requirements
- Request more information
- Use discovery engine to probe deeper
- Suggest prototype approach
- Can always refactor later

## Output to Generators

Once decision is made, I pass structured information to the appropriate generator:

```python
generation_spec = {
    "type": "agent_suite",
    "confidence": 0.87,
    "discovery_context": {...},  # Full discovery result
    "generation_parameters": {
        "agents": [
            {
                "name": "frontend-developer",
                "function": "implementation",
                "tools": ["Read", "Write", "Edit", "Bash"],
                "execution": "coordinated",
                "parallel_with": ["backend-developer"]
            },
            {
                "name": "backend-developer",
                "function": "implementation",
                "tools": ["Read", "Write", "Edit", "Bash"],
                "execution": "coordinated",
                "parallel_with": ["frontend-developer"]
            },
            {
                "name": "test-runner",
                "function": "quality",
                "tools": ["Read", "Write", "Bash", "Grep"],
                "execution": "sequential",
                "depends_on": ["frontend-developer", "backend-developer"]
            }
        ],
        "suite_pattern": "fork-join",
        "coordination_strategy": "workflow"
    }
}
```

This structured spec enables the generators to create precisely tailored extensions.
