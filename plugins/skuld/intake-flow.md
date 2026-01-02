# Skuld Intake Flow

This document defines the conditional flow for asking questions during the estate planning intake. Questions are referenced by ID from `intake-registry.json` - Claude MUST read and copy exact options from the registry.

## Read-Before-Ask Protocol

**CRITICAL: Before asking ANY selection question:**
1. Read `plugins/skuld/intake-registry.json`
2. Find the question by its ID
3. Use `AskUserQuestion` with **EXACT** options from JSON
4. **NEVER** modify, invent, or "improve" the options
5. Wait for **[STOP]** before proceeding to the next question

---

## Phase 1: Discovery

### 1.1 Personal Basics

**Direct prompt (text input):**
What is your full legal name and date of birth?
(e.g., John Michael Smith, March 15, 1975)

**[STOP - Wait for response]**

Parse name and DOB. Save to: `personal.full_name`, `personal.date_of_birth`

---

### 1.2 Marital Status

**Ask:** `marital_status` (from registry)

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

**Ask:** `state_of_residence` (from registry) — C6 constraint applies

**[STOP - Wait for response]**

**[IF state == OTHER]**
**Direct prompt:**
Please type your state of residence.

**[STOP - Wait for response]**
**[/IF]**

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

**Ask:** `current_asset_titling` (from registry)

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

**Ask:** `government_benefits_status` (from registry) — multi-select, substitute `[child_name]`

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

**Ask:** `business_entity_type` (from registry)

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
