---
name: intake-coordination
type: reference
description: Reference documentation for intake coordination patterns in multi-handler extensions
---

# Intake Coordination Reference

This reference documents the intake coordination pattern used when generating extensions with multiple handlers that share user data through structured intake flows.

## What is Intake Coordination?

Intake coordination is the architectural pattern where:
1. A coordinator skill collects user information through structured questions
2. Questions follow conditional branching logic based on answers
3. Collected data is mapped to specific handlers that need it
4. Handlers declare their data requirements in manifests

## When Intake Coordination is Needed

**High-Confidence Indicators:**
- Domain research found "client intake form" patterns
- Domain research found "conditional screening" requirements
- Multiple handlers need shared user data
- Sensitive/regulated domain requiring audit trails
- Progressive disclosure patterns (questions depend on prior answers)

**Example Domains Requiring Intake Coordination:**
- Estate planning (state laws, marital status, children affect planning)
- Healthcare (patient history, conditions affect treatment)
- Legal services (case type, jurisdiction affect process)
- Financial planning (income, assets, goals affect recommendations)
- Insurance (coverage type, risk factors affect pricing)

## Intake Graph Structure

### Entry Points

Entry points are questions asked unconditionally at the start:

```yaml
entry_points:
  - id: state_of_residence
    question: "What state do you primarily reside in?"
    required: true
    sets_flags: [state_jurisdiction]
    source: "Domain research: laws vary by state"

  - id: marital_status
    question: "What is your current marital status?"
    required: true
    options: [single, married, divorced, widowed]
    sets_flags: [is_married, spouse_applicable]
    source: "Domain research: spousal rights vary"
```

### Conditional Questions

Conditional questions are asked only when their condition is met:

```yaml
conditional_questions:
  - id: spouse_citizenship
    condition: "is_married == true"
    question: "Is your spouse a US citizen?"
    options: [yes, no]
    sets_flags: [qdot_applicable]
    source: "Domain research: QDOT for non-citizen spouses"

  - id: special_needs_screening
    condition: "has_children == true"
    question: "Does any child or beneficiary have special needs?"
    options: [yes, no]
    sets_flags: [snt_applicable]
    source: "Domain research: SNT planning"
```

### Handler Coverage

Each handler declares what intake data it requires:

```yaml
handler_coverage:
  trust-generator:
    requires: [state_jurisdiction, marital_status]
    optional: [spouse_citizenship]
    status: covered

  snt-generator:
    requires: [snt_applicable]
    triggers_when: snt_applicable == true
    status: covered

  qdot-generator:
    requires: [qdot_applicable, spouse_citizenship]
    triggers_when: qdot_applicable == true
    status: covered
```

## Handler Manifest Fields

Handlers declare their intake requirements in frontmatter:

```yaml
---
name: trust-generator
description: Generates revocable living trust documents
requires_intake:
  - state_of_residence    # Required for this handler
  - marital_status        # Required for this handler
optional_intake:
  - spouse_citizenship    # Enhances but not required
triggers_on:
  state_of_residence: true   # Activates when collected
  marital_status: true       # Activates when collected
---
```

### Field Definitions

| Field | Type | Description |
|-------|------|-------------|
| `requires_intake` | array | Intake IDs that MUST be collected for handler to function |
| `optional_intake` | array | Intake IDs that enhance handler but aren't required |
| `triggers_on` | object | Intake IDs that activate this handler when collected |

## Intake Flow Patterns

### Sequential Flow

Simple linear progression through questions:

```
state → marital_status → has_children → asset_level
```

### Branching Flow

Questions branch based on answers:

```
state → marital_status ─┬─→ [if married] spouse_details → spouse_citizenship
                        └─→ [if single] skip to has_children

has_children ─┬─→ [if yes] child_details → special_needs_screening
              └─→ [if no] skip to assets
```

### Progressive Disclosure

Complex flows reveal questions progressively:

```
Phase 1: Basic Info
  - state_of_residence
  - marital_status
  - has_children

Phase 2: Conditional Details (based on Phase 1)
  - spouse_citizenship (if married)
  - child_details (if has_children)
  - special_needs_screening (if has_children)

Phase 3: Planning Options (based on Phase 2)
  - qdot_discussion (if non-citizen spouse)
  - snt_discussion (if special needs)
  - guardianship_discussion (if minor children)
```

## Intake ID Conventions

### Naming Convention

Use snake_case for intake IDs:
- `state_of_residence` (not `stateOfResidence`)
- `marital_status` (not `maritalStatus`)
- `has_children` (not `hasChildren`)

### Common Intake IDs

| Category | Common IDs |
|----------|------------|
| Location | `state_of_residence`, `country`, `jurisdiction` |
| Personal | `marital_status`, `has_children`, `age_range` |
| Family | `spouse_citizenship`, `child_count`, `special_needs_status` |
| Financial | `asset_level`, `income_range`, `debt_status` |
| Legal | `has_existing_will`, `trust_type`, `beneficiary_count` |

### Flag Conventions

Flags are boolean indicators derived from intake:
- `is_married` (from marital_status == married)
- `has_children` (from child_count > 0)
- `snt_applicable` (from special_needs_status == true)
- `qdot_applicable` (from spouse_citizenship == non-citizen)

## Coverage Validation

### Validation Rules

1. **Every handler requirement has a source**: All `requires_intake` fields must have corresponding intake questions
2. **Conditional questions are reachable**: Every conditional question's condition can be triggered
3. **No orphaned questions**: Every intake question maps to at least one handler
4. **Flags are consistent**: Flags set by questions match flags consumed by handlers

### Coverage Report

```markdown
## Intake Coverage Report

| Handler | Required Fields | Status |
|---------|-----------------|--------|
| trust-generator | state_of_residence, marital_status | ✅ Covered |
| snt-generator | special_needs_status | ✅ Covered |
| qdot-generator | qdot_applicable | ✅ Covered |

### Coverage Score: 100% (6/6 fields covered)
```

### Gap Resolution

When gaps are detected:

```
⚠️ COVERAGE GAP: `special_needs_status` required by `snt-generator`

Suggested resolution:
1. Add conditional question:
   condition: has_children == true
   question: "Does any beneficiary have special needs?"
   sets_flags: [snt_applicable]

2. Or mark handler as optional:
   snt-generator: optional if special_needs_status not collected
```

## SKILL.md Intake Section Template

```markdown
## Intake Flow

### Entry Questions

<!-- intake_id: state_of_residence -->
**State of Residence**: What state do you primarily reside in?
- *Source*: Estate planning requires state jurisdiction

<!-- intake_id: marital_status -->
**Marital Status**: What is your current marital status?
- *Source*: Spousal rights vary by state

### Conditional Screening

<!-- intake_id: spouse_citizenship -->
**IF** client is married:
> Is your spouse a US citizen?
> *Triggers*: QDOT planning if non-citizen

<!-- intake_id: special_needs_screening -->
**IF** client has children:
> Does any beneficiary have special needs?
> *Triggers*: SNT handler activation

### Handler Dependencies

| Handler | Required Intake | Status |
|---------|-----------------|--------|
| `trust-generator` | state_of_residence, marital_status | ✅ |
| `snt-generator` | snt_applicable | ✅ |
```

## Integration with AskUserQuestion

Intake questions are asked using the `AskUserQuestion` tool:

```yaml
# Entry point question
AskUserQuestion:
  questions:
    - question: "What state do you primarily reside in?"
      header: "State"
      options:
        - label: "California"
          description: "Community property state"
        - label: "Texas"
          description: "Community property state"
        - label: "New York"
          description: "Common law state"
        - label: "Florida"
          description: "Common law state"
      multiSelect: false

# Conditional question (only if married)
AskUserQuestion:
  questions:
    - question: "Is your spouse a US citizen?"
      header: "Spouse"
      options:
        - label: "Yes"
          description: "Standard planning applies"
        - label: "No"
          description: "May require QDOT planning"
      multiSelect: false
```

## Example: Complete Estate Planning Intake

```yaml
intake_graph:
  metadata:
    domain: "estate planning"
    version: "1.0.0"
    generated_from: "domain_research"

  entry_points:
    - id: state_of_residence
      question: "What state do you primarily reside in?"
      required: true
      sets_flags: [state_jurisdiction]

    - id: marital_status
      question: "What is your current marital status?"
      required: true
      options: [single, married, divorced, widowed]
      sets_flags: [is_married]

    - id: has_children
      question: "Do you have any children?"
      required: true
      options: [yes, no]
      sets_flags: [has_children]

  conditional_questions:
    - id: spouse_citizenship
      condition: "is_married == true"
      question: "Is your spouse a US citizen?"
      options: [yes, no]
      sets_flags: [qdot_applicable]

    - id: special_needs_screening
      condition: "has_children == true"
      question: "Does any child or beneficiary have special needs?"
      options: [yes, no]
      sets_flags: [snt_applicable]

    - id: minor_children
      condition: "has_children == true"
      question: "Are any of your children under 18?"
      options: [yes, no]
      sets_flags: [guardian_applicable]

  handler_coverage:
    trust-generator:
      requires: [state_jurisdiction, is_married]
      status: covered
    will-generator:
      requires: [state_jurisdiction, has_children]
      status: covered
    snt-generator:
      requires: [snt_applicable]
      triggers_when: snt_applicable == true
      status: covered
    qdot-generator:
      requires: [qdot_applicable]
      triggers_when: qdot_applicable == true
      status: covered
    guardian-generator:
      requires: [guardian_applicable]
      triggers_when: guardian_applicable == true
      status: covered
```

## Related Documentation

- `core/discovery-engine.md` - Domain detection and intake signal detection
- `generators/agent-generator.md` - Handler manifest generation
- `generators/suite-coordinator.md` - Intake graph generation
- `core/validation-framework.md` - Coverage validation
- `intelligence/domain-intelligence.md` - Dynamic domain research
