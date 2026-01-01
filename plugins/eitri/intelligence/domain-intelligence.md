---
name: domain-intelligence
type: module
description: Dynamic domain research strategy for discovering industry-specific requirements at forge-time
---

# Domain Intelligence - Dynamic Research Strategy

This module defines HOW to research any domain at forge-time, not WHAT domains exist. Rather than maintaining a static list of hard-coded domains (which can never be comprehensive), Eitri dynamically discovers domain-specific requirements through web research.

## Design Philosophy

**Old Approach (DEPRECATED):**
- 6 hard-coded domains (Healthcare, Financial, E-Commerce, SaaS, DevOps, Data Science)
- New domains required manual addition to this file
- Estate planning, legal, real estate, manufacturing, etc. were NOT covered
- Generic placeholders generated for unknown domains

**New Approach (ACTIVE):**
- Domain detected from user context at forge-time
- WebSearch used to discover domain requirements
- Intake patterns extracted from research results
- ANY domain can be researched dynamically

## Domain Detection

I identify domains from user-provided input, not from a pre-defined list.

### Domain Signal Recognition

**Explicit Industry Signals:**
- Direct mentions: "estate planning", "healthcare", "real estate", "manufacturing"
- Professional contexts: "attorneys", "doctors", "accountants", "realtors"
- Business types: "law firm", "medical practice", "accounting firm"

**Regulatory/Compliance Signals:**
- Regulatory references: "HIPAA", "GDPR", "QDOT", "SOX", "PCI-DSS"
- Compliance mentions: "compliant", "regulated", "audit trail"
- Legal frameworks: "civil law", "common law", "state-specific"

**Process/Workflow Signals:**
- Intake patterns: "client intake", "patient onboarding", "case management"
- Domain workflows: "trust administration", "claims processing", "underwriting"
- Industry terminology that indicates specialized processes

### Domain Extraction Process

```python
def extract_domain_from_context(user_request, conversation_history):
    """Extract domain from user context - no hard-coded domain checks."""

    signals = {
        "industry_mentions": [],
        "professional_context": [],
        "regulatory_signals": [],
        "process_terminology": [],
        "confidence": 0.0
    }

    # Parse user request for domain signals
    signals["industry_mentions"] = find_industry_keywords(user_request)
    signals["professional_context"] = find_professional_context(user_request)
    signals["regulatory_signals"] = find_regulatory_mentions(user_request)
    signals["process_terminology"] = find_process_terms(user_request)

    # Calculate confidence and determine primary domain
    if signals["industry_mentions"]:
        primary_domain = signals["industry_mentions"][0]
        signals["confidence"] = 0.9
    elif signals["professional_context"]:
        primary_domain = infer_domain_from_profession(signals["professional_context"][0])
        signals["confidence"] = 0.8
    elif signals["regulatory_signals"]:
        primary_domain = infer_domain_from_regulation(signals["regulatory_signals"][0])
        signals["confidence"] = 0.7
    else:
        primary_domain = None
        signals["confidence"] = 0.0

    return {
        "detected_domain": primary_domain,
        "signals": signals,
        "requires_research": primary_domain is not None
    }
```

## Research Protocol

When a domain is detected, I execute a standardized research protocol to gather intelligence.

### When to Research

**ALWAYS** research when a domain is detected from user input. No hard-coded domain checks.

Research is triggered when:
- User mentions ANY industry or domain
- Regulatory/compliance signals detected
- Domain involves sensitive data collection
- User mentions unfamiliar industry terminology
- Complex multi-step workflows described

### Research Execution

**Phase 1: Regulatory Requirements**
```
WebSearch "{domain} {current_year} compliance requirements"
WebSearch "{domain} regulatory framework"
WebSearch "{domain} legal requirements"
```

**Phase 2: Client/User Intake Patterns**
```
WebSearch "{domain} client intake questionnaire best practices"
WebSearch "{domain} client onboarding workflow"
WebSearch "{domain} required client information"
```

**Phase 3: Conditional Screening Questions**
```
WebSearch "{domain} conditional screening questions"
WebSearch "{domain} intake branching logic"
WebSearch "{domain} decision tree client questions"
```

**Phase 4: Industry Concepts and Terminology**
```
WebSearch "{domain} key concepts terminology"
WebSearch "{domain} common scenarios edge cases"
WebSearch "{domain} professional standards"
```

**Phase 5: Technology and Integration**
```
WebSearch "{domain} common software tools"
WebSearch "{domain} integration requirements"
WebSearch "{domain} data exchange standards"
```

### Research Result Processing

```python
def process_research_results(search_results, domain):
    """Extract structured intelligence from research results."""

    intelligence = {
        "domain": domain,
        "research_performed": True,
        "regulatory_requirements": [],
        "intake_patterns": [],
        "conditional_triggers": [],
        "handler_dependencies": [],
        "key_concepts": [],
        "technology_stack": []
    }

    for result in search_results:
        # Extract regulatory requirements
        if contains_regulatory_info(result):
            intelligence["regulatory_requirements"].extend(
                extract_requirements(result)
            )

        # Extract intake patterns
        if contains_intake_patterns(result):
            intelligence["intake_patterns"].extend(
                extract_intake_fields(result)
            )

        # Extract conditional logic
        if contains_conditional_logic(result):
            intelligence["conditional_triggers"].extend(
                extract_conditionals(result)
            )

    return intelligence
```

## Pattern Extraction

### Intake Field Extraction

From research results, I identify intake fields:

**Required Field Indicators:**
- "must collect", "required information", "mandatory"
- Appears in multiple sources
- Regulatory language suggests necessity

**Optional Field Indicators:**
- "may collect", "recommended", "helpful"
- Single source mention
- Enhancement rather than requirement

**Conditional Field Indicators:**
- "if X, then ask Y"
- "when X applies, collect Y"
- Branching language patterns

### Conditional Branch Extraction

From research, I identify decision points:

```python
def extract_conditional_branches(research_text):
    """Extract conditional logic from research text."""

    branches = []

    # Pattern: "if [condition], then [action]"
    if_then_patterns = find_if_then_patterns(research_text)
    for pattern in if_then_patterns:
        branches.append({
            "condition": pattern.condition,
            "then_ask": pattern.action,
            "source": "research_pattern"
        })

    # Pattern: "when [trigger], [requirement]"
    when_patterns = find_when_patterns(research_text)
    for pattern in when_patterns:
        branches.append({
            "condition": pattern.trigger,
            "then_ask": pattern.requirement,
            "source": "research_pattern"
        })

    return branches
```

## Research Output Format

Domain research produces structured intelligence:

```python
domain_intelligence = {
    "domain_detected": "estate planning",  # From user context, NOT hard-coded list
    "research_performed": True,
    "research_timestamp": "2025-01-01T12:00:00Z",
    "search_queries_executed": [
        "estate planning 2025 compliance requirements",
        "estate planning client intake questionnaire best practices",
        "estate planning conditional screening questions"
    ],
    "regulatory_requirements": [
        {"name": "state_jurisdiction", "source": "laws vary by state"},
        {"name": "witness_requirements", "source": "execution requirements"}
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
    ],
    "key_concepts": [
        {"term": "QDOT", "meaning": "Qualified Domestic Trust for non-citizen spouses"},
        {"term": "SNT", "meaning": "Special Needs Trust for disabled beneficiaries"},
        {"term": "Pour-over will", "meaning": "Will that directs assets to trust"}
    ],
    "confidence_score": 0.85
}
```

## Example: Estate Planning Domain Research

When user requests: "I need an estate planning tool for attorneys"

**Step 1: Domain Detection**
- Industry mention: "estate planning"
- Professional context: "attorneys"
- Domain detected: "estate planning"
- Confidence: 0.9

**Step 2: Research Execution**
```
WebSearch "estate planning 2025 compliance requirements"
→ Finds: State-specific laws, witness requirements, notarization rules

WebSearch "estate planning client intake questionnaire best practices"
→ Finds: State of residence, marital status, children, assets

WebSearch "estate planning conditional screening questions"
→ Finds: QDOT for non-citizen spouses, SNT for special needs, guardianship for minors
```

**Step 3: Pattern Extraction**
- Required: state_of_residence, marital_status, has_children
- Conditional: spouse_citizenship (if married), special_needs_screening (if has children)
- Handler mapping: trust-generator needs state + marital, snt-generator needs special_needs

**Step 4: Output**
- Complete `domain_intelligence` object with discovered patterns
- Intake graph with entry points and conditional branches
- Handler manifests with `requires_intake` populated

## Integration with Other Modules

This module feeds into:
- **Discovery Engine**: Provides domain context for analysis
- **Agent Generator**: Informs handler manifest generation
- **Suite Coordinator**: Enables intake graph generation
- **Validation Framework**: Enables coverage validation

## Limitations and Fallbacks

**When Research Yields Insufficient Results:**
- Flag low confidence score
- Request user clarification
- Fall back to generic intake patterns
- Generate placeholders with clear "[USER: Define...]" markers

**When Domain is Ambiguous:**
- Research multiple possible domains
- Present options to user via AskUserQuestion
- Allow user to refine domain context

This dynamic approach ensures Eitri can intelligently handle ANY domain, not just the few that were previously hard-coded.
