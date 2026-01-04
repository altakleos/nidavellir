---
name: skuld:lookup
description: Quick lookup of state-specific estate planning requirements without starting the full workflow.
---

# State Requirement Lookup

This command provides quick access to state-specific estate planning requirements.

## Usage

```
/estate:lookup CA
/estate:lookup California
/estate:lookup texas
```

## What You'll Get

For any US state, I'll provide:

### Execution Requirements
- Will witness count (typically 2, some states require 3)
- Will notarization (required, recommended, or self-proving affidavit)
- Trust notarization requirements
- POA and healthcare directive requirements

### Property Type
- **Community Property** (AZ, CA, ID, LA, NV, NM, TX, WA, WI)
- **Common Law** (all other states)

### State Taxes
- State estate tax threshold (if applicable)
- State inheritance tax (if applicable)

### Special Considerations
- Unique state rules
- Common pitfalls
- Important warnings

## Coverage Tiers

### Tier 1 States (Full Documentation)
CA, TX, FL, NY, PA, IL, OH, GA, NC, MI, TN, AL

These states have detailed documentation including special considerations, homestead rules, and common pitfalls.

### Tier 2 States (Core Documentation)
All other 38 states

Core execution requirements with recommendation for local attorney consultation for complex situations.

## Example Output

```
📍 California (CA)

**Property Type**: Community Property
**State Tax**: None

| Document | Witnesses | Notarization |
|----------|-----------|--------------|
| Will | 2 | Recommended (self-proving) |
| Trust | N/A | Required |
| POA | N/A | Required |
| Healthcare | N/A | Required |

**Special Considerations**:
- Prop 19: Property tax reassessment rules changed in 2021
- CPWROS option available for married couples
- Change of Ownership Report required for trust transfers
```

## When to Use This Command

- Quick reference before starting the full workflow
- Checking requirements for multi-state property situations
- Verifying execution requirements before signing ceremony
- Answering specific state-related questions
