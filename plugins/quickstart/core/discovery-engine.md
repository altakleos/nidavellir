---
name: discovery-engine
type: module
description: Shared discovery intelligence for understanding user needs
---

# Discovery Engine - Core Intelligence Module

## Multi-Dimensional Analysis Framework

### Surface Layer Analysis
I extract explicit requirements through natural conversation:
- Stated goals and outcomes
- Mentioned tools and systems
- Explicit constraints and requirements
- Domain terminology and jargon

### Pattern Detection Layer
I identify implicit patterns in how you describe your needs:

**Workflow Patterns:**
- Sequential: "first X, then Y" → ordered processing
- Parallel: "while X, also Y" → concurrent operations
- Conditional: "if X then Y else Z" → decision trees
- Iterative: "for each X, do Y" → batch processing
- Event-driven: "when X happens" → reactive architecture

**Linguistic Patterns:**
- Verbs reveal intent: convert/transform → data processing
- Adjectives reveal requirements: critical/optional → priority
- Temporal words reveal timing: always/sometimes → automation level
- Quantifiers reveal scale: few/many/massive → architecture needs

### Context Depth Analysis
I progressively deepen understanding through layers:

Level 1: What (surface need)
Level 2: Why (business driver)
Level 3: Who (stakeholders)
Level 4: How (current process)
Level 5: When (timing/triggers)
Level 6: Where (systems/integration)

### Constraint Detection
I identify both stated and unstated constraints:

**Explicit Constraints:**
- "Must be HIPAA compliant"
- "Needs to run in 5 minutes"
- "Can't use external APIs"

**Implicit Constraints (inferred):**
- Healthcare + patient data → HIPAA requirements
- Financial + reporting → audit trails needed
- Startup + "move fast" → flexibility over robustness
- Enterprise + "governance" → approval workflows

### Anti-Pattern Recognition
I watch for problematic patterns and address them:

**Common Anti-Patterns:**
- XY Problem: Asking for Y when real need is X
- Premature Optimization: Complex solution for simple problem
- Coupling Confusion: Forcing together what should be separate
- Over-Engineering: Enterprise solution for startup need

When detected, I gently probe:
"I notice you're asking for [Y], but it sounds like you're trying to achieve [X].
Let's talk about [X] - there might be a simpler approach."

## Discovery Conversation Techniques

### Opening Gambits
Based on initial keywords, I choose appropriate opening:

**Technical Keywords Detected:**
"I see you're working with [technology]. Tell me about your current architecture
and where this fits in."

**Business Keywords Detected:**
"You mentioned [business process]. Walk me through how this currently works
and what you'd like to improve."

**Problem Keywords Detected:**
"You're dealing with [problem]. What's the impact of this issue, and what
would success look like?"

### Depth Exploration Techniques

**Branching Questions:**
```
User mentions "reporting"
  ├→ "What kind of reports?" (type discovery)
  ├→ "Who uses these reports?" (stakeholder discovery)
  ├→ "How often are they generated?" (timing discovery)
  └→ "What decisions do they drive?" (importance discovery)
```

**Cross-Functional Probes:**
"Does this [process] connect to other systems?"
"Who else would use this besides you?"
"What happens before/after this step?"
"How does this change during busy periods?"

### Calibration Checkpoints
Throughout conversation, I validate understanding:

"Based on what you've told me, I understand:
- [Key requirement 1]
- [Key requirement 2]
- [Key constraint]
Is this accurate? What am I missing?"

## Reusability Assessment

I analyze multiple dimensions to determine if the solution is:
- Project-specific (one-time custom)
- Cross-project (reusable utility)
- Domain-specific (industry standard)
- Universal (works everywhere)

**High Reusability Signals:**
- Generic verbs: "format", "lint", "test", "validate"
- No project-specific references
- Standard industry patterns
- Clear, narrow scope

**Low Reusability Signals:**
- "Our", "my", "custom", "proprietary"
- Business-specific logic
- Heavy customization needs
- Tight integration requirements

## Invocation Pattern Analysis

I determine optimal invocation method:

**Task-Triggered (Auto-Invoke):**
- "when X happens"
- "whenever Y changes"
- "automatically Z"
- Clear trigger conditions

**Conversation-Driven (Manual):**
- "help me with X"
- "I need to Y"
- Requires context and dialogue
- Decision points throughout

**Hybrid:**
- Can auto-invoke OR be called manually
- Benefits from both approaches

## Coupling Analysis

I examine multiple coupling dimensions:

**Data Coupling:**
- Shared data structures
- Common databases
- Interdependent models
→ Tight coupling suggests single skill

**Temporal Coupling:**
- Must happen in sequence
- Timing dependencies
- Order matters
→ Medium coupling, could be skill or coordinated agents

**User Coupling:**
- Same person uses everything
- Single workflow
- Unified mental model
→ Suggests single skill

**Change Coupling:**
- Changes together frequently
- Shared business rules
- Common requirements
→ Tight coupling suggests single skill

**Failure Boundaries:**
- Should fail independently
- Separate recovery strategies
- Different SLAs
→ Loose coupling suggests separate agents

## Tool Requirements Analysis

I assess what tools are truly needed:

**Read-Only Needs:**
- Analysis tasks
- Reporting
- Scanning
→ Minimal tool access (Read, Grep)

**File Creation:**
- Generating output
- Creating reports
- Producing artifacts
→ Add Write tool

**File Modification:**
- Code formatting
- Refactoring
- Editing
→ Add Edit tool (requires careful safety)

**Command Execution:**
- Running tests
- Building projects
- System operations
→ Add Bash (highest risk, careful evaluation)

## Safety Characteristics Detection

I identify safety-relevant characteristics:

**Parallel-Safe Indicators:**
- Read-only operations
- No shared state
- Independent execution
- Idempotent operations

**Sequential-Only Indicators:**
- Modifies shared resources
- Quality/validation operations
- State management
- Critical operations

**Tool Restriction Benefits:**
- Limited scope operations
- High reusability
- Security-sensitive
- Lightweight operations

## Output Interface

This module provides to other modules:

```python
discovery_result = {
    "explicit_requirements": [...],
    "workflow_patterns": ["sequential", "event_driven"],
    "stakeholder_profile": {
        "team_size": "small",
        "technical_level": "intermediate",
        "industry": "healthcare"
    },
    "constraints": {
        "regulatory": ["HIPAA"],
        "technical": ["no external APIs"],
        "organizational": ["needs approval"]
    },
    "scale_indicators": "medium",
    "coupling_analysis": {
        "data": "tight",
        "temporal": "loose",
        "user": "single",
        "change": "coupled"
    },
    "reusability_level": "high",
    "invocation_pattern": "task_triggered",
    "tool_requirements": ["Read", "Write", "Grep"],
    "safety_characteristics": {
        "parallel_safe": True,
        "benefits_from_restrictions": True
    },
    "anti_patterns_detected": [],
    "confidence_score": 0.89
}
```

## Integration with Decision Framework

The discovery engine feeds directly into the decision framework, which uses this rich context to determine the optimal extension type (skill, agent, suite, or hybrid).
