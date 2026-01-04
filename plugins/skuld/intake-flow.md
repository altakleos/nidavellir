# Skuld Intake Flow

This document defines the conditional flow for asking questions during the estate planning intake. Questions are referenced by ID from `intake-registry.json` - Claude MUST read and copy exact options from the registry.

## Read-Before-Ask Protocol

**CRITICAL: Before asking ANY selection question:**
1. Read `plugins/skuld/intake-registry.json`
2. Find the question by its ID
3. Check the question `type`:
   - `select` / `multi_select` → Use `AskUserQuestion` (2-4 options only)
   - `numbered_select` / `numbered_multi_select` → Use numbered markdown prompt (C10)
   - `text` → Use direct markdown prompt (C8)
4. **NEVER** modify, invent, or "improve" the options
5. Wait for **[STOP]** before proceeding to the next question

### Numbered Selection Format (C10)

For `numbered_select` questions, display:
```
[Question text]

1. [Option 1]
2. [Option 2]
...
N. [Option N]

Enter a number (1-N):
```

For `numbered_multi_select`, display:
```
[Question text]

1. [Option 1]
2. [Option 2]
...
N. [Option N]

Enter numbers separated by commas (e.g., 1,3):
```

**Validation:** If invalid input, re-prompt: "Please enter a number between 1 and N"

---

## Phase 1: Discovery

### 1.1 Personal Basics

**Ask:** `personal_name_dob` (from registry, type: text — C8 applies)

Display as direct markdown prompt:
```
What is your full legal name and date of birth?
(e.g., John Michael Smith, March 15, 1975)
```

**[STOP - Wait for response]**

Parse name and DOB. Save to: `personal.full_name`, `personal.date_of_birth`

---

### 1.2 Marital Status

**Ask:** `marital_status` (from registry, type: numbered_select — C10 applies)

**[STOP - Wait for response]**

---

**[IF marital_status == married]**

**Direct prompt (C3):**
What is your spouse's full legal name (as it appears on official documents)?

**[STOP - Wait for response]**

Save to: `spouse.full_name`

**Direct prompt (C3):**
What is your spouse's date of birth?

**[STOP - Wait for response]**

Save to: `spouse.date_of_birth`

**Ask:** `spouse_citizenship` (from registry)

**[STOP - Wait for response]**

**[IF spouse_is_us_citizen == false]**
Display QDOT warning box (from SKILL.md)
Set flags: `qdot_required: true`
**[/IF]**

**[/IF]**

---

**[IF marital_status == cohabiting]**

Display unmarried partner info box (from SKILL.md)

**Ask:** `partner_included` (from registry)

**[STOP - Wait for response]**

**[IF partner_included != no]**

**Direct prompt:**
What is your partner's full legal name (as it should appear on legal documents)?
(e.g., Jane Marie Smith)

**[STOP - Wait for response]**

Save to: `partner.full_name`

**Direct prompt:**
How long have you been in this relationship?
(e.g., "5 years", "since 2019", "12 years")

**[STOP - Wait for response]**

Save to: `relationship_duration`

**Ask:** `partner_healthcare_agent` (from registry)

**[STOP - Wait for response]**

**Ask:** `partner_financial_agent` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.3 State of Residence

**Direct prompt:** `state_of_residence` (from registry, type: text — C6, C8 apply)

Which state do you reside in? (e.g., TN, CA, TX)

**[STOP - Wait for response]**

Validate the response is a 2-letter US state abbreviation.
If invalid, ask again with clarification.

Launch estate-state-lookup agent to load state requirements.

---

**[IF state == TN AND marital_status == married]**

### 1.3.1 Tennessee Community Property Trust Screening

**Ask:** `cpt_relocation_risk` (from registry)

**[STOP - Wait for response]**

**Ask:** `cpt_divorce_history` (from registry)

**[STOP - Wait for response]**

**Ask:** `cpt_separate_property` (from registry)

**[STOP - Wait for response]**

**Ask:** `cpt_liability_profession` (from registry)

**[STOP - Wait for response]**

**[IF any CPT risk flag == true]**
Display CPT considerations warning box (from SKILL.md)
**[/IF]**

**Ask:** `cpt_election` (from registry)

**[STOP - Wait for response]**

**Ask:** `current_asset_titling` (from registry, type: numbered_select — C10 applies)

**[STOP - Wait for response]**

**[/IF]**

---

### 1.4 Children

**Ask:** `has_children` (from registry) — C1 constraint applies

**[STOP - Wait for response]**

**[IF has_children == true]**

**Direct prompt:**
Please list your children, one per line, with their name and date of birth or age.
For example:
  Emma Rose Smith, March 15, 2015
  Jake Thomas Smith, age 18

**[STOP - Wait for response]**

Parse each line. Calculate minor/adult status. Display confirmation summary:

```
You've added [N] children:
• Emma Rose Smith (15, minor)
• Jake Thomas Smith (18, adult)
```

**Ask:** `children_confirm` (from registry)

**[STOP - Wait for response]**

**[IF children_confirm == no]**

**Direct prompt:**
What would you like to change? You can:
- Update a child's info (e.g., "Emma is actually 9")
- Add a child (e.g., "Add Michael Smith, age 5")
- Remove a child (e.g., "Remove Jake")

**[STOP - Wait for response]**

Apply changes, return to confirmation summary.
**[/IF]**

---

**[IF blended_family_detected OR marital_status IN (divorced, widowed)]**

**Ask:** `children_relationship_type` (from registry)

**[STOP - Wait for response]**

**[IF mixed_relationships == true]**

For each child:
**Ask:** `child_relationship_detail` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.4.1 Guardian Selection (for minor children)

**[IF has_minor_children == true]** — C4 constraint applies

**Direct prompt:**
If both you and your spouse were unable to care for your minor children,
who would you want to raise them?

Please provide:
- Primary guardian (name and relationship)
- Backup guardian (name and relationship)

For example:
Primary: Sarah Johnson (sister)
Backup: Michael Chen (friend)

**[STOP - Wait for response]**

Save to: `guardian_of_person`, `successor_guardian`

**[/IF]**

**[/IF]**

---

### 1.5 Special Needs Screening

**[IF has_children == true]**

**Ask:** `special_needs_screening` (from registry)

**[STOP - Wait for response]**

**[IF special_needs_beneficiary == true]**

For each child with special needs:

**Ask:** `child_age_status` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**Ask:** `government_benefits_status` (from registry, type: numbered_multi_select — C10 applies) — substitute `[child_name]`

**[STOP - Wait for response]**

**[IF is_adult_special_needs == true]**

**Ask:** `legal_capacity_status` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**[/IF]**

**Ask:** `snt_trustee` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**Ask:** `able_account_interest` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**Ask:** `letter_of_intent` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

### 1.5.4 Special Needs Housing

**Ask:** `snt_housing_provision` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**[IF snt_housing_provision IN (family_home, both)]**

Display ISM warning:
```
╔═══════════════════════════════════════════════════════════════╗
║          IMPORTANT: Housing & Government Benefits             ║
╠═══════════════════════════════════════════════════════════════╣
║ If the trust pays housing costs (rent, mortgage, taxes), it   ║
║ may reduce [child_name]'s SSI benefits under "In-Kind         ║
║ Support and Maintenance" (ISM) rules.                         ║
║                                                               ║
║ A benefits specialist can help structure payments to          ║
║ minimize impact. This is a common and manageable issue.       ║
╚═══════════════════════════════════════════════════════════════╝
```

**Ask:** `snt_housing_expenses` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**Ask:** `snt_housing_remainder` (from registry) — substitute `[child_name]`

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

**[/IF]**

---

### 1.6 Single Parent / Custody

**[IF single_parent == true]**

**Ask:** `custody_order` (from registry)

**[STOP - Wait for response]**

**[IF has_custody_order == true]**

**Ask:** `custody_order_succession` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.7 Prenuptial Agreements

**[IF blended_family == true]**

**Ask:** `prenuptial_agreement` (from registry)

**[STOP - Wait for response]**

**[IF has_prenuptial_agreement == true]**

**Ask:** `prenup_covers_death` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.8 Assets

**Ask:** `financial_assets` (from registry) — multi-select

**[STOP - Wait for response]**

**[IF has_life_insurance == true]**

**Ask:** `life_insurance_value` (from registry)

**[STOP - Wait for response]**

**Ask:** `life_insurance_beneficiary` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[IF has_retirement_accounts == true]**

**Ask:** `retirement_value` (from registry)

**[STOP - Wait for response]**

**Ask:** `retirement_beneficiaries` (from registry)

**[STOP - Wait for response]**

**[/IF]**

---

**Ask:** `other_assets` (from registry) — multi-select

**[STOP - Wait for response]**

---

### 1.9 Business Interests

**[IF has_business == true]**

**Ask:** `business_entity_type` (from registry, type: numbered_select — C10 applies)

**[STOP - Wait for response]**

**Ask:** `business_partners` (from registry)

**[STOP - Wait for response]**

**[IF has_partners == true]**

**Ask:** `buy_sell_agreement` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**Ask:** `business_succession_preferences` (from registry)

**[STOP - Wait for response]**

**[/IF]**

---

### 1.10 Special Circumstances

**Ask:** `special_circumstances` (from registry) — multi-select

**[STOP - Wait for response]**

---

### 1.11 Healthcare Preferences

**Ask:** `healthcare_preferences_life_support` (from registry)

**[STOP - Wait for response]**

**Ask:** `healthcare_preferences_organ_donation` (from registry)

**[STOP - Wait for response]**

---

### 1.12 Tennessee Real Estate (if applicable)

**[IF state == TN]**

**Ask:** `tn_real_estate_details` (from registry)

**[STOP - Wait for response]**

**[IF wants_tod_deed == true]**

**Ask:** `tod_beneficiary_selection` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.12.1 Tennessee TBE Home Strategy

**[IF state == TN AND marital_status == married AND current_asset_titling == tbe]**

Display TBE context box:
```
╔═══════════════════════════════════════════════════════════════════╗
║           YOUR HOME IS TITLED AS TENANCY BY ENTIRETY              ║
╠═══════════════════════════════════════════════════════════════════╣
║ This provides:                                                     ║
║ ✅ Strongest creditor protection from individual debts            ║
║ ✅ Automatic survivorship (avoids probate on first death)         ║
║                                                                    ║
║ But TBE does NOT:                                                 ║
║ ❌ Provide incapacity planning (trust does)                       ║
║ ❌ Avoid probate on second death (trust or TOD deed does)         ║
║ ❌ Provide double step-up in basis (CPT does, but loses TBE)      ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[IF cpt_liability_profession == yes]**

Display liability warning:
```
╔═══════════════════════════════════════════════════════════════════╗
║        ⚠️ HIGH LIABILITY PROFESSION - TBE IS VALUABLE             ║
╠═══════════════════════════════════════════════════════════════════╣
║ You indicated high liability exposure (doctor/attorney/business). ║
║                                                                    ║
║ TBE protects your home from YOUR individual creditors.            ║
║ If you transfer to trust, this protection may be lost.            ║
║                                                                    ║
║ RECOMMENDATION: Consider keeping TBE during your lives.           ║
║                                                                    ║
║ [[ ATTORNEY REVIEW: Evaluate TBE vs trust for liability ]]        ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[/IF]**

**[IF blended_family == true]**

Display blended family warning:
```
╔═══════════════════════════════════════════════════════════════════╗
║        ⚠️ BLENDED FAMILY - TBE SURVIVORSHIP WARNING               ║
╠═══════════════════════════════════════════════════════════════════╣
║ With TBE, when one spouse dies, the other owns the home 100%.     ║
║                                                                    ║
║ The surviving spouse can leave it to ANYONE - potentially         ║
║ excluding the first-to-die's children entirely.                   ║
║                                                                    ║
║ If you want to protect your children's inheritance:               ║
║ • Consider transferring to trust with life estate provisions      ║
║ • Or use life insurance to compensate                             ║
║                                                                    ║
║ [[ ATTORNEY REVIEW: Blended family home protection ]]             ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Ask:** `tbe_blended_home_plan` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[IF cpt_election == yes]**

Display CPT/TBE interaction:
```
╔═══════════════════════════════════════════════════════════════════╗
║           CPT + TBE ARE MUTUALLY EXCLUSIVE                        ║
╠═══════════════════════════════════════════════════════════════════╣
║ You elected Community Property Trust for the double step-up.      ║
║                                                                    ║
║ For your home, you must choose:                                   ║
║                                                                    ║
║ KEEP TBE:                                                         ║
║ ✅ Creditor protection       ❌ Only 50% step-up at death         ║
║                                                                    ║
║ TRANSFER TO CPT:                                                  ║
║ ✅ 100% step-up at death     ❌ Loses TBE creditor protection     ║
║                                                                    ║
║ HYBRID: Keep home in TBE, put other assets in CPT                 ║
║ ✅ Creditor protection for home                                   ║
║ ✅ Double step-up on investments                                  ║
╚═══════════════════════════════════════════════════════════════════╝
```

**Ask:** `tbe_home_appreciation` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.13 Residence Provisions

**[IF has_real_estate == true]**

**Ask:** `residence_disposition` (from registry, type: numbered_select — C10 applies)

**[STOP - Wait for response]**

**[IF residence_disposition IN (beneficiaries_outright, kept_in_trust)]**

**Ask:** `residence_sale_restriction` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 1.14 Spendthrift Protection

**Ask:** `spendthrift_preference` (from registry)

**[STOP - Wait for response]**

---

## Phase 2: Document Selection

### 2.1 Present Recommendations

Display recommendations table based on collected profile data.
Include brief explanations of each document's purpose.

**Educational boxes to display based on flags:**
- `[IF retirement_heavy_estate]` → Display beneficiary coordination warning
- `[IF special_needs_beneficiary]` → Display SNT beneficiary warning
- `[IF state == TN]` → Display Trust vs TOD Deed comparison

---

### 2.2 Document Acceptance — C7 constraint applies

**CRITICAL: This question MUST be asked SEPARATELY before any trust structure question.**

**Ask:** `document_acceptance` (from registry)

**[STOP - Wait for response]**

**[IF document_acceptance == questions]**
Answer user's questions about documents.
Then re-ask `document_acceptance`.
**[/IF]**

**[IF document_acceptance == customize]**
Present document list with checkboxes.
Let user select which to include.
**[/IF]**

---

### 2.3 Trust Structure (if applicable) — C7 constraint applies

**CRITICAL: This question MUST be asked SEPARATELY after document acceptance.**

**[IF marital_status == married AND blended_family != true]**

**Ask:** `trust_structure` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[IF blended_family == true]**

Auto-set: `trust_structure = separate`

Display QTIP explanation box:
```
For blended families, we recommend separate trusts for each spouse.
This allows each spouse to provide for their own children while
also providing for the surviving spouse through QTIP provisions.
```

**[/IF]**

---

### 2.4 Conditional Follow-up Questions

**[IF state == TN AND current_asset_titling == tbe]**

Display recommendation based on collected data:

**[IF cpt_liability_profession == yes AND blended_family != true]**
```
╔═══════════════════════════════════════════════════════════════════╗
║        RECOMMENDATION: KEEP HOME IN TBE                           ║
╠═══════════════════════════════════════════════════════════════════╣
║ Based on your liability exposure, we recommend keeping your home  ║
║ in Tenancy by Entirety for creditor protection.                   ║
║                                                                    ║
║ For probate avoidance at second death, consider:                  ║
║ • Pour-over will (home transfers to trust at death)               ║
║ • Surviving spouse uses TOD deed                                  ║
╚═══════════════════════════════════════════════════════════════════╝
```
**[/IF]**

**[IF blended_family == true AND tbe_blended_home_plan == transfer_to_trust]**
```
╔═══════════════════════════════════════════════════════════════════╗
║        RECOMMENDATION: TRANSFER HOME TO TRUST                     ║
╠═══════════════════════════════════════════════════════════════════╣
║ To protect your children's inheritance in your blended family,    ║
║ we recommend transferring your home to the trust.                 ║
║                                                                    ║
║ This allows you to specify life estate for surviving spouse       ║
║ with remainder to your children.                                  ║
╚═══════════════════════════════════════════════════════════════════╝
```
**[/IF]**

**[IF cpt_election == yes AND high_appreciation_home == true AND cpt_liability_profession != yes]**
```
╔═══════════════════════════════════════════════════════════════════╗
║        RECOMMENDATION: TRANSFER HOME TO CPT TRUST                 ║
╠═══════════════════════════════════════════════════════════════════╣
║ Your home has significant appreciation and you elected CPT.       ║
║ Transferring to your Community Property Trust provides the        ║
║ double step-up in basis, potentially saving substantial           ║
║ capital gains tax for your heirs.                                 ║
╚═══════════════════════════════════════════════════════════════════╝
```
**[/IF]**

**Ask:** `tbe_transfer_decision` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[IF state == TN AND creating_trust == true]**

**Ask:** `trust_funding_needs` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[IF retirement_heavy_estate == true]**

**Ask:** `beneficiary_coordination_checklist` (from registry)

**[STOP - Wait for response]**

**[/IF]**

---

## Phase 3: Document Drafting

See SKILL.md for Phase 3 (Generation, Validation, Review) workflow.
This phase does not involve intake questions from the registry.

---

## Phase 4: Execution Guidance

See SKILL.md for Phase 4 workflow.
This phase does not involve intake questions from the registry.

---

## Phase 5: Funding & Next Steps

See SKILL.md for Phase 5 workflow.
This phase does not involve intake questions from the registry.

---

## Session Resume Flow

**[IF session_age > 30 days]**

Display session timeout warning box.

**Ask:** `session_timeout_proceed` (from registry)

**[STOP - Wait for response]**

**[/IF]**

---

## Question Handling Reminders

1. **One question at a time** — Never bundle multiple questions
2. **Read registry before asking** — Copy exact options, don't interpret
3. **Wait for [STOP]** — Each question needs a response before proceeding
4. **Handle "Other" as question detection** — Check if user is asking a clarifying question
5. **Multi-select uses `multiSelect: true`** — Questions marked as `multi_select` type in registry
