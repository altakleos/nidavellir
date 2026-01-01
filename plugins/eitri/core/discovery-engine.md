---
name: discovery-engine
type: module
description: Shared discovery intelligence for understanding user needs
---

# Discovery Engine - Core Intelligence Module

## Multi-Dimensional Analysis Framework

For systematic context understanding, I apply the comprehensive framework from `references/context-dimensions.md`, which analyzes needs across 10 dimensions including business maturity, technical sophistication, regulatory environment, and team structure.

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

## Domain Intelligence Research

At forge-time, I proactively research the target domain to understand domain-specific requirements, intake patterns, and conditional logic. This enables generating complete, domain-aware extensions rather than generic placeholders.

### Domain Detection

I identify the domain from user-provided input and context:

**Explicit Domain Signals:**
- Industry mentions: "estate planning", "healthcare", "real estate", "manufacturing"
- Professional context: "attorneys", "doctors", "accountants", "realtors"
- Regulatory references: "HIPAA", "GDPR", "QDOT", "SOX"
- Process terminology: "client intake", "patient onboarding", "case management"

**Domain Extraction Process:**
1. Parse user request for industry/domain keywords
2. Identify professional context and stakeholders
3. Detect regulatory and compliance signals
4. Note domain-specific terminology

### When to Research

**ALWAYS** research when a domain is detected from user input. No hard-coded domain checks.

Research triggers:
- User mentions ANY industry or domain
- Regulatory/compliance signals detected
- Domain involves sensitive data collection
- User mentions unfamiliar industry terminology
- Complex multi-step workflows described

### Research Strategy: Delegated Domain Research

To prevent context overflow from raw WebSearch results, domain research is **delegated to the `domain-researcher` agent**. This keeps raw search results in the subagent's context while returning only structured intelligence to the main forge context.

**Delegation Pattern:**

```python
# Invoke domain-researcher agent via Task tool
domain_intelligence = Task(
    subagent_type="domain-researcher",
    prompt=f"""
    Research domain intelligence for:
    - Domain: {detected_domain}
    - User request: {user_request}
    - Year: {current_year}
    - Research phases: regulatory, intake, conditional, concepts, technology

    Return structured domain_intelligence object only.
    """
)
```

**The agent executes 5 research phases:**
1. Regulatory requirements and compliance
2. Client/user intake patterns
3. Conditional screening questions
4. Industry concepts and terminology
5. Technology and integration patterns

See `agents/domain-researcher.md` for the complete research protocol.

**Why Delegation:**
- Raw WebSearch results (~3-5KB each) stay in subagent context
- Only structured `domain_intelligence` (~2-3KB) returns to main context
- Prevents context overflow before generation phase
- Consistent research quality across all domains

**Fallback Handling:**
If the domain-researcher agent fails or times out:
1. Mark `domain_intelligence.confidence` as "degraded"
2. Generate with placeholders for uncertain areas
3. Flag in validation report for user review

### Pattern Extraction

The `domain-researcher` agent performs extraction and returns structured intelligence. The extraction logic includes:

**Intake Field Extraction:**
- Required data points mentioned in multiple sources
- Fields that are conditional (depend on other answers)
- Mandatory vs optional data collection
- Field naming conventions

**Conditional Branch Extraction:**
- "If X then Y" patterns from research
- Decision points that trigger different workflows
- Conditions mapped to specific questions
- Nested conditional logic

**Handler Dependency Extraction:**
- Data needed for each operation
- Intake fields mapped to handler requirements
- Sequential dependencies between handlers
- Shared data requirements across handlers

See `agents/domain-researcher.md` for the complete extraction protocol.

### Research Output

Domain research produces structured intelligence for generation:

```python
domain_intelligence = {
    "domain_detected": "estate planning",
    "research_performed": True,
    "regulatory_requirements": [
        {"name": "state_jurisdiction", "source": "laws vary by state"},
        {"name": "witness_requirements", "source": "execution requirements"},
    ],
    "intake_patterns": [
        {
            "id": "state_of_residence",
            "question": "What state do you primarily reside in?",
            "required": True,
            "source": "estate planning requires state jurisdiction"
        },
        {
            "id": "marital_status",
            "question": "What is your current marital status?",
            "required": True,
            "source": "spousal rights vary by state"
        }
    ],
    "conditional_triggers": [
        {
            "if": "marital_status == 'married'",
            "then_ask": "spouse_citizenship",
            "reasoning": "QDOT required for non-citizen spouses"
        },
        {
            "if": "has_children == True",
            "then_ask": "special_needs_screening",
            "reasoning": "SNT planning for special needs beneficiaries"
        }
    ],
    "handler_dependencies": [
        {
            "handler": "trust-generator",
            "requires_intake": ["state_of_residence", "marital_status"]
        },
        {
            "handler": "snt-generator",
            "requires_intake": ["special_needs_status", "benefit_types"]
        }
    ]
}
```

## Intake Coordination Detection

Based on domain research AND user context, I detect whether the extension needs intake coordination (structured user data collection with conditional branching and handler mapping).

### High-Confidence Signals (from domain research)

- Domain research found "client intake form" patterns
- Domain research found "conditional screening" requirements
- Domain research found "compliance questionnaire" obligations
- Multiple handlers need shared user data
- Progressive disclosure patterns detected

### Context Signals (from user conversation)

- User mentions collecting information from users
- Multiple agents that share user data
- Conditional question patterns: "if X, then ask Y"
- Sensitive/regulated domain requiring audit trails
- Multi-phase workflow with user input at each phase

### Intake Detection Output

```python
intake_coordination = {
    "needs_intake_coordination": True,
    "intake_confidence": 0.9,
    "reasoning": "Domain research found conditional screening patterns",
    "domain_derived_questions": [
        {"id": "state_of_residence", "source": "web_research", "required": True},
        {"id": "marital_status", "source": "web_research", "required": True},
        {"id": "spouse_citizenship", "source": "web_research", "conditional": True}
    ],
    "conditional_branches": [
        {"if": "marital_status == 'married'", "then_ask": ["spouse_details"]},
        {"if": "has_children == True", "then_ask": ["special_needs_screening"]}
    ],
    "handler_requirements": {
        "trust-generator": ["state_of_residence", "marital_status"],
        "snt-generator": ["special_needs_status"]
    }
}
```

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
