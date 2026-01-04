---
name: skuld:ask
description: Ask estate planning questions with profile-aware context. Answers educational questions using curated intelligence modules.
---

# Estate Planning Q&A

This command provides educational answers to estate planning questions using curated intelligence modules, with optional personalization from your client profile.

## Usage

```
/skuld:ask What is a pour-over will?
/skuld:ask How does step-up in basis work?
/skuld:ask Trust vs will - what's the difference?
/skuld:ask --no-context What is probate?
```

## Flags

| Flag | Effect |
|------|--------|
| `--no-context` | Answer without using profile data |

---

## Scope Boundaries

### This Command IS For (Conceptual/Educational)

- **Glossary questions**: "What is probate?", "What does per stirpes mean?"
- **How-it-works questions**: "How does step-up in basis work?"
- **Comparison questions**: "Trust vs will - what's the difference?"
- **Factor questions**: "What factors determine if I need a trust?"
- **Tax education**: "What is the estate tax exemption?" (with CPA recommendation)
- **Profile-personalized answers**: "What would this mean for my situation?"

### This Command is NOT For (Use Other Commands)

| Question Type | Redirect To |
|---------------|-------------|
| State execution requirements | `/skuld:lookup [STATE]` |
| Witness/notarization rules | `/skuld:lookup [STATE]` |
| Probate thresholds | `/skuld:lookup [STATE]` |
| Document drafting | `/skuld:estate` |
| Existing document validation | Attorney consultation |

**Routing Rule**: If question matches patterns like `"[state] requirements"`, `"how many witnesses in [state]"`, `"TN notarization rules"` → respond with:
> For state-specific execution requirements, use `/skuld:lookup [STATE]`.

---

## Profile Context Behavior

### Automatic Profile Loading

1. Check for `skuld/client_profile.json`
2. **IF exists**:
   - Validate required fields (`state`, `marital_status` at minimum)
   - **IF valid** → Use for personalization, disclose in footer
   - **IF invalid** → Answer generically, note "Profile incomplete"
3. **IF not exists** → Answer generically, offer to start `/skuld:estate`
4. **`--no-context` flag** → Skip profile entirely

### Profile Fields Used for Personalization

| Field | Personalization Effect |
|-------|----------------------|
| `state` | State-specific rules and warnings |
| `marital_status` | Joint vs individual trust considerations |
| `has_minor_children` | Guardian-related context |
| `blended_family` | Special distribution considerations |
| `has_special_needs_beneficiary` | SNT-related context |
| `net_worth_range` | Tax planning triggers |

### Disclosure Footer

Every profile-personalized response includes:
```
---
*Educational information only. Consult an attorney for your situation.*
*Profile context: [STATE] resident, [marital_status] | [--no-context to disable]*
```

---

## Answering Questions (Agent-Based)

This command uses the same agent pattern as `/skuld:estate` for reliable file access.

**DO NOT attempt direct file discovery.** The intelligence modules are bundled with the plugin installation. Agents execute within the plugin context, so relative paths resolve automatically.

### Agent Invocation Pattern

Use the Task tool to invoke skuld agents:

| Question Type | Agent to Invoke | Agent Reads |
|---------------|-----------------|-------------|
| Terminology (grantor, probate, etc.) | `skuld:estate-glossary` | `intelligence/glossary/*.md` |
| State requirements | `skuld:estate-state-lookup` | `intelligence/state-laws/[STATE].md` |
| Tax concepts | `skuld:estate-glossary` | `intelligence/glossary/tax-terms.md` |
| Specialized topics | `skuld:estate-glossary` | `intelligence/specialized/*.md` |

### How to Invoke Agents

```
Task tool with:
- subagent_type: "skuld:estate-glossary" or "skuld:estate-state-lookup"
- prompt: The user's question with context
```

The agent will:
1. Load the appropriate intelligence modules (paths resolve within plugin context)
2. Return the explanation with source citations
3. Handle caching and deduplication

### Response Flow

1. Parse user question for topic markers
2. **Invoke appropriate agent** via Task tool
3. Agent returns explanation with citations
4. Add profile personalization (if available)
5. Format response with disclaimer footer

### Glossary Module Index (for agent context)

When invoking `estate-glossary`, include relevant topic hints:

| Topic Area | Hint to Include |
|------------|-----------------|
| Core concepts (trust, will, probate) | "core terms" |
| Trust-specific terms | "trust terms" |
| Beneficiary designations | "beneficiary terms" |
| POA terms | "power of attorney" |
| Healthcare directive terms | "healthcare terms" |
| Property/titling terms | "property terms" |
| Tax terms | "tax concepts" |
| Special needs terms | "special needs" |

---

## Question Categories & Handling

| Category | Example | Handling |
|----------|---------|----------|
| **Glossary** | "What is probate?" | Load term from glossary, explain in plain language, cite source |
| **State-specific** | "TN witness count?" | Redirect: "Use `/skuld:lookup TN` for state requirements." |
| **Tax Education** | "Estate tax exemption?" | Load tax module, cite year, recommend CPA for strategy |
| **Comparison** | "Trust vs will?" | Load both concepts, present table format, cite sources |
| **Decision** | "Should I get a trust?" | Explain factors, **DO NOT recommend** - say "Consider these factors with an attorney" |
| **Situational** | "For my situation?" | Use profile context, heavy disclaimers, cite sources |
| **Drafting** | "Create my trust" | Redirect: "Run `/skuld:estate` for personalized documents." |
| **Legal advice** | "Is my trust valid?" | Decline: "I cannot evaluate existing documents. Please consult an attorney." |

---

## Professional Boundaries

### Educational Questions (ANSWER)

- "What is X?"
- "How does X work?"
- "What are the differences between X and Y?"
- "What factors should I consider for X?"
- "Explain X in simple terms"

### Boundary Questions (REDIRECT/DECLINE)

| Question Pattern | Response |
|------------------|----------|
| "Should I do X?" | "Here are factors to consider: [list]. Discuss with an attorney for personalized advice." |
| "Is my document valid?" | "I cannot evaluate existing legal documents. Please consult an attorney." |
| "Draft my X" | "Run `/skuld:estate` for the personalized document workflow." |
| "What tax strategy should I use?" | "Explain [concept]. For tax strategy, consult a CPA or tax attorney." |
| "Am I liable for X?" | "I cannot provide legal liability assessments. Please consult an attorney." |

---

## Response Pattern

### Standard Response Format

```
**[Term or Concept]**

[Plain-language explanation from intelligence module]

[If profile context available:]
**Based on your profile** ([state], [marital_status]):
- [Personalized consideration 1]
- [Personalized consideration 2]
- [Personalized consideration 3]

Source: [intelligence/path/to/file.md]

---
*Educational information only. Consult an attorney for your situation.*
*Profile context: [STATE] resident, [status] | [--no-context to disable]*
```

### Comparison Response Format

```
**[Concept A] vs [Concept B]**

| Aspect | [A] | [B] |
|--------|-----|-----|
| [Aspect 1] | [A detail] | [B detail] |
| [Aspect 2] | [A detail] | [B detail] |
| [Aspect 3] | [A detail] | [B detail] |

**Key Differences**:
- [Difference 1]
- [Difference 2]

**Based on your profile** ([context]):
- [Which might be more relevant and why]

Sources: [file1.md], [file2.md]

---
*Educational information only. Consult an attorney for your situation.*
```

---

## Edge Cases

| Scenario | Response |
|----------|----------|
| No profile exists | Generic answer + "Run `/skuld:estate` to create a profile for personalized guidance." |
| Profile incomplete | Use available fields, note: "Some personalization unavailable due to incomplete profile." |
| Profile stale (30+ days) | Answer normally, gentle note: "Consider reviewing your profile if circumstances have changed." |
| State mismatch (profile vs question) | Answer for asked state, note: "Note: Your profile indicates [STATE], but answering for [OTHER_STATE]." |
| Multi-state question | Load both state modules, explain differences, recommend: "Multi-state situations benefit from attorney guidance." |
| Follow-up question | Maintain context from previous answer in session |
| Louisiana | Include civil law warning: "Louisiana uses civil law traditions, which differ significantly from other states." |
| High net worth detected | Include: "Estate tax planning may apply. Consult a tax professional." |

---

## Examples

### Example 1: Basic Glossary Question

**Input**: `/skuld:ask What is a pour-over will?`

**Process**:
1. Detect term: "pour-over will"
2. Load: `intelligence/glossary/core-terms.md`
3. Check for profile
4. Generate response with citation

**Output**:
```
**Pour-Over Will**

A pour-over will is a type of will that works together with a revocable
living trust. It "catches" any assets that weren't transferred to the
trust during your lifetime and directs them into the trust at death.

Think of it as a safety net - if you forget to retitle an asset to your
trust, the pour-over will ensures it still ends up there, though it will
go through probate first.

**Based on your profile** (Tennessee, married):
- Requires 2 witnesses under TN law
- Your joint trust should be named as the beneficiary
- Assets that pour over will go through TN probate (threshold: $50,000)

Source: intelligence/glossary/core-terms.md

---
*Educational information only. Consult an attorney for your situation.*
*Profile context: TN resident, married | [--no-context to disable]*
```

### Example 2: Decision Question (Boundary)

**Input**: `/skuld:ask Should I get a trust?`

**Output**:
```
**Factors to Consider for Trust Planning**

Whether a trust makes sense depends on several factors:

**Factors favoring a trust:**
- Owning real estate (avoids probate, which is public and can be costly)
- Privacy concerns (trusts aren't public record)
- Potential incapacity planning (trustee can manage assets seamlessly)
- Minor or special needs beneficiaries
- Blended family situations

**Factors where a will may suffice:**
- Limited assets below your state's probate threshold
- Simple family structure
- All assets already have beneficiary designations

**Based on your profile** (Tennessee, married, owns real estate):
- TN probate threshold is $50,000 for small estates
- Real estate typically benefits from trust ownership
- Your marital status allows for joint trust planning

This is an educational overview. **Discuss your specific situation with
an estate planning attorney** to determine the right approach.

Sources: intelligence/glossary/core-terms.md, intelligence/glossary/trust-terms.md

---
*Educational information only. Consult an attorney for your situation.*
*Profile context: TN resident, married | [--no-context to disable]*
```

### Example 3: Tax Question

**Input**: `/skuld:ask What is the estate tax exemption?`

**Output**:
```
**Federal Estate Tax Exemption**

The federal estate tax exemption is the amount you can pass to heirs
without owing federal estate tax.

**2024 Exemption**: $13.61 million per person ($27.22 million for married
couples with portability)

**Key Points:**
- Amounts above the exemption are taxed at 40%
- "Portability" allows a surviving spouse to use the deceased spouse's
  unused exemption
- The current high exemption is scheduled to sunset in 2026, potentially
  dropping to ~$6-7 million

**Based on your profile** (Tennessee):
- Tennessee has no state estate tax
- Only federal estate tax applies

**Important**: For estate tax planning strategies, consult a CPA or tax
attorney. This is educational information only.

Source: intelligence/tax/federal-estate-gift-tax.md

---
*Educational information only. Consult an attorney for your situation.*
*Profile context: TN resident, married | [--no-context to disable]*
```

### Example 4: State-Specific Redirect

**Input**: `/skuld:ask How many witnesses does California require?`

**Output**:
```
For state-specific execution requirements like witness counts, use:

`/skuld:lookup CA`

This will give you California's complete requirements for wills, trusts,
POAs, and healthcare directives.
```
