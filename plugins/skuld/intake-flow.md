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

**[IF partner_healthcare_agent == help]**
Display explanation:
```
╔═══════════════════════════════════════════════════════════════════╗
║           WHAT DOES A HEALTHCARE AGENT DO?                         ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  A healthcare agent (also called healthcare proxy) can:            ║
║                                                                    ║
║  • Make medical decisions when you cannot speak for yourself       ║
║  • Access your medical records and speak with your doctors         ║
║  • Ensure your treatment wishes are followed                       ║
║  • Visit you in the hospital as an authorized decision-maker       ║
║                                                                    ║
║  For unmarried couples, this is especially important because       ║
║  partners have NO automatic medical decision-making rights.        ║
║  Without this document, your family could exclude your partner.    ║
╚═══════════════════════════════════════════════════════════════════╝
```

Re-ask `partner_healthcare_agent` (without the help option).

**[STOP - Wait for response]**

**[/IF]**

**Ask:** `partner_financial_agent` (from registry)

**[STOP - Wait for response]**

**[IF partner_financial_agent == help]**
Display explanation:
```
╔═══════════════════════════════════════════════════════════════════╗
║           WHAT DOES A FINANCIAL AGENT DO?                          ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  A financial agent (Power of Attorney) can:                        ║
║                                                                    ║
║  • Pay your bills and manage bank accounts                         ║
║  • Handle taxes and financial paperwork                            ║
║  • Manage investments and retirement accounts                      ║
║  • Deal with insurance and government benefits                     ║
║  • Handle real estate transactions                                 ║
║                                                                    ║
║  This power only works while you're alive. It ends at death.       ║
║  Without it, your partner would need court approval to help        ║
║  manage your finances if you become incapacitated.                 ║
╚═══════════════════════════════════════════════════════════════════╝
```

Re-ask `partner_financial_agent` (without the help option).

**[STOP - Wait for response]**

**[/IF]**

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

**[IF has_tn_real_estate == true]**

**Ask:** `tod_interest` (from registry)

**[STOP - Wait for response]**

**[IF tod_interest == help]**

Display TOD explanation box:
```
╔═══════════════════════════════════════════════════════════════════╗
║           WHAT IS A TRANSFER-ON-DEATH (TOD) DEED?                 ║
╠═══════════════════════════════════════════════════════════════════╣
║ A TOD deed transfers your property automatically at death,        ║
║ WITHOUT probate, while you keep full ownership during life.       ║
║                                                                    ║
║ ✅ Avoids probate ($3,000-10,000+ in Tennessee)                   ║
║ ✅ You stay in full control - can sell, refinance, change mind    ║
║ ✅ Simple and inexpensive ($50-200 to record)                     ║
║                                                                    ║
║ ⚠️ Does NOT help during incapacity (trust does)                   ║
║ ⚠️ Simple transfer only (no conditions like age requirements)     ║
║                                                                    ║
║ Tennessee TOD deeds effective July 1, 2025.                       ║
╚═══════════════════════════════════════════════════════════════════╝
```

Re-ask `tod_interest`

**[STOP - Wait for response]**

**[/IF]**

**[IF tod_interest == yes]**

**Ask:** `tod_property_count` (from registry)

**[STOP - Wait for response]**

**[IF tod_property_count == four_plus]**

Display multiple property warning:
```
╔═══════════════════════════════════════════════════════════════════╗
║   MULTIPLE PROPERTIES - TRUST MAY BE MORE EFFICIENT               ║
╠═══════════════════════════════════════════════════════════════════╣
║ With 4+ properties, each would need a separate TOD deed.          ║
║ A revocable trust may be more efficient:                          ║
║ • One trust holds all properties                                  ║
║ • One deed per property to transfer into trust                    ║
║ • Provides incapacity protection TOD deeds don't                  ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[/IF]**

**Ask:** `tod_incapacity_concern` (from registry)

**[STOP - Wait for response]**

**[IF tod_incapacity_concern == very_important]**

Display incapacity warning:
```
╔═══════════════════════════════════════════════════════════════════╗
║   ⚠️ TOD DEEDS DO NOT PROVIDE INCAPACITY PROTECTION               ║
╠═══════════════════════════════════════════════════════════════════╣
║ If incapacity planning is important, a revocable trust is better: ║
║                                                                    ║
║ TOD Deed:                                                         ║
║ ❌ If you become incapacitated, property is "stuck"               ║
║ ❌ Court-appointed conservator needed to manage/sell              ║
║                                                                    ║
║ Trust:                                                            ║
║ ✅ Successor trustee takes over seamlessly                        ║
║ ✅ Can sell, refinance, or manage without court                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[/IF]**

**Ask:** `tod_distribution_complexity` (from registry)

**[STOP - Wait for response]**

**[IF tod_distribution_complexity == snt]**

Display SNT warning and skip TOD:
```
╔═══════════════════════════════════════════════════════════════════╗
║   🚫 TOD NOT RECOMMENDED - SPECIAL NEEDS BENEFICIARY              ║
╠═══════════════════════════════════════════════════════════════════╣
║ Direct transfer via TOD could disqualify beneficiary from         ║
║ government benefits (SSI, Medicaid).                              ║
║                                                                    ║
║ Use Special Needs Trust instead - protects benefits while         ║
║ providing for your loved one.                                     ║
╚═══════════════════════════════════════════════════════════════════╝
```

Set: `tod_recommendation: not_recommended`

**[ELSE IF tod_distribution_complexity == conditional]**

Display complexity warning:
```
╔═══════════════════════════════════════════════════════════════════╗
║   COMPLEX DISTRIBUTION - TRUST RECOMMENDED                        ║
╠═══════════════════════════════════════════════════════════════════╣
║ TOD deeds provide simple transfers: property to beneficiary.      ║
║                                                                    ║
║ Your distribution wishes require a trust because:                 ║
║ • Life estates ("spouse for life, then children") need trust      ║
║ • Age restrictions need trust language                            ║
║ • Complex conditions need trust provisions                        ║
╚═══════════════════════════════════════════════════════════════════╝
```

Set: `tod_recommendation: not_recommended`

**[ELSE]**

Evaluate TOD recommendation based on collected answers:

**[IF tod_property_count == one AND tod_incapacity_concern != very_important AND creating_trust != true]**

Set: `tod_recommendation: recommended`

**[ELSE IF creating_trust == true]**

Set: `tod_recommendation: optional`

**[ELSE]**

Set: `tod_recommendation: optional`

**[/IF]**

**[/IF]**

**[/IF]**

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

**[IF question.preamble exists]**
Display preamble: "Spendthrift clauses protect inheritances from creditors and lawsuits. Most attorneys recommend including this protection."
**[/IF]**

**Ask:** `spendthrift_preference` (from registry)

**[STOP - Wait for response]**

**[IF spendthrift_preference == discuss]**
Set flag: `spendthrift_deferred: true`
Display: "I've noted this for attorney review. We'll mark your trust as needing attorney guidance on spendthrift provisions. Let's continue."
Continue to next question.
**[/IF]**

---

### 1.15 Distribution Preferences

**[IF has_children == true]**

**Ask:** `distribution_preferences` (from registry)

**[STOP - Wait for response]**

**[IF distribution.pattern IN (all_at_once, staggered)]**

**Ask:** `distribution_age_schedule` (from registry, type: numbered_select — C10 applies)

**[STOP - Wait for response]**

**[IF distribution.age_schedule == custom]**

**Ask:** `distribution_custom_ages` (from registry, type: text)

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

**[IF children_count > 1]**

**[IF question.preamble exists]**
Display preamble: "Equal shares reduce family conflict. Unequal may suit special circumstances (special needs, prior gifts, caregiver compensation)."
**[/IF]**

**Ask:** `distribution_equality` (from registry)

**[STOP - Wait for response]**

**[IF distribution.equality == discuss]**
Display guidance:
```
╔═══════════════════════════════════════════════════════════════════╗
║           GUIDANCE: EQUAL VS. UNEQUAL SHARES                       ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  EQUAL SHARES are most common and minimize family conflict.        ║
║                                                                    ║
║  UNEQUAL SHARES may be appropriate when:                           ║
║  • One child has special needs requiring ongoing support           ║
║  • You've already given significant gifts to one child             ║
║  • One child serves as your primary caregiver                      ║
║  • One child has much greater financial need                       ║
║                                                                    ║
║  Note: You can always explain your reasoning in a separate         ║
║  letter to your children (not part of the legal documents).        ║
╚═══════════════════════════════════════════════════════════════════╝
```

Re-ask `distribution_equality` (without the discuss option if already seen guidance).

**[STOP - Wait for response]**

**[/IF]**

**[IF distribution.equality == unequal]**

**Ask:** `distribution_per_child_shares` (from registry, type: per_child)

For each child, prompt:
```
What percentage should [child_name] receive?
```

Validate that all percentages total exactly 100%.

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

**Ask:** `distribution_method` (from registry, type: numbered_select — C10 applies)

**[STOP - Wait for response]**

**[IF distribution.method == help]**

Display per stirpes vs per capita explanation:
```
╔═══════════════════════════════════════════════════════════════════╗
║        PER STIRPES vs. PER CAPITA DISTRIBUTION                     ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  PER STIRPES ("by the branch"):                                    ║
║  If a child predeceases you, their share goes to THEIR children    ║
║  (your grandchildren).                                             ║
║                                                                    ║
║  Example: You have 3 children. Child A dies before you, leaving    ║
║  2 grandchildren. Result:                                          ║
║  • Child B: 1/3                                                    ║
║  • Child C: 1/3                                                    ║
║  • Grandchild 1: 1/6 (half of Child A's share)                     ║
║  • Grandchild 2: 1/6 (half of Child A's share)                     ║
║                                                                    ║
║  PER CAPITA ("by the head"):                                       ║
║  If a child predeceases you, their share is divided among the      ║
║  SURVIVING children only. Grandchildren receive nothing.           ║
║                                                                    ║
║  Example: Same scenario. Result:                                   ║
║  • Child B: 1/2                                                    ║
║  • Child C: 1/2                                                    ║
║  • Grandchild 1: Nothing                                           ║
║  • Grandchild 2: Nothing                                           ║
║                                                                    ║
║  MOST COMMON: Per stirpes is chosen by ~85% of families.           ║
╚═══════════════════════════════════════════════════════════════════╝
```

Re-ask `distribution_method` after explanation.

**[/IF]**

**[/IF]**

---

## Phase 2: Document Selection

### Decision Support Resources

Before presenting recommendations, the coordinator should be prepared to answer comparison questions. Reference these decision support modules:

| Question Type | Resource |
|--------------|----------|
| "Should I get a trust or just a will?" | `intelligence/decision-support/trust-vs-will.md` |
| "Joint trust vs. separate trusts?" | `intelligence/decision-support/joint-vs-separate-trust.md` |
| "TOD deed vs. trust funding for property?" | `intelligence/decision-support/tod-deed-vs-trust-funding.md` |
| "What happens if I don't do this?" | `intelligence/decision-support/consequences-of-inaction.md` |
| "Which documents matter most for me?" | `intelligence/decision-support/document-priority-matrix.md` |
| "At what ages should my children inherit?" | `intelligence/decision-support/distribution-strategy.md` |
| "Should all children get equal shares?" | `intelligence/decision-support/distribution-strategy.md` |
| "What is per stirpes vs per capita?" | `intelligence/decision-support/distribution-strategy.md` |

**When user asks comparison questions:**
1. Load the relevant decision support file
2. Use the comparison matrix to explain trade-offs
3. Personalize based on user's profile (state, family situation, assets)
4. Don't recommend - present options and let user decide

---

### 2.1 Present Recommendations

**CRITICAL: Display document preview box BEFORE asking acceptance question.**

Based on collected profile data, display the following box:

```
╔═══════════════════════════════════════════════════════════════════╗
║           YOUR RECOMMENDED ESTATE PLAN DOCUMENTS                  ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  Based on your situation, I recommend these documents:            ║
║                                                                   ║
║  CORE DOCUMENTS:                                                  ║
║  ┌─────────────────────────────────────────────────────────────┐  ║
║  │ 1. Revocable Living Trust                                   │  ║
║  │    Avoids probate, provides incapacity protection           │  ║
║  │                                                              │  ║
║  │ 2. Pour-Over Will                                           │  ║
║  │    Names guardian for minor children, catches assets        │  ║
║  │    not in the trust                                         │  ║
║  │                                                              │  ║
║  │ 3. Financial Power of Attorney                              │  ║
║  │    Allows trusted person to manage finances if you're       │  ║
║  │    incapacitated                                            │  ║
║  │                                                              │  ║
║  │ 4. Healthcare Directive                                     │  ║
║  │    States your medical wishes, names healthcare agent       │  ║
║  └─────────────────────────────────────────────────────────────┘  ║
║                                                                   ║
║  [IF state == TN AND creating_trust == true]                      ║
║  ┌─────────────────────────────────────────────────────────────┐  ║
║  │ 5. Certificate of Trust                                     │  ║
║  │    Summary document for banks/title companies               │  ║
║  └─────────────────────────────────────────────────────────────┘  ║
║  [/IF]                                                            ║
║                                                                   ║
║  [IF special_needs_beneficiary == true]                           ║
║  SPECIALIZED DOCUMENTS:                                           ║
║  ┌─────────────────────────────────────────────────────────────┐  ║
║  │ Special Needs Trust for [child_name]                        │  ║
║  │ Preserves government benefits while providing for           │  ║
║  │ your loved one                                              │  ║
║  └─────────────────────────────────────────────────────────────┘  ║
║  [/IF]                                                            ║
║                                                                   ║
║  [IF state == TN AND has_tn_real_estate == true AND              ║
║      tod_recommendation IN (recommended, optional)]               ║
║  OPTIONAL:                                                        ║
║  ┌─────────────────────────────────────────────────────────────┐  ║
║  │ Transfer-on-Death Deed                                      │  ║
║  │ Transfers property at death without probate                 │  ║
║  └─────────────────────────────────────────────────────────────┘  ║
║  [/IF]                                                            ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[PAUSE - Allow user to read the recommendations]**

**Educational boxes to display based on flags (after document list):**
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

### 2.2.1 TOD Deed Decision (if applicable)

**[IF state == TN AND has_tn_real_estate == true AND tod_recommendation != not_recommended]**

**[IF tod_recommendation == recommended]**

Display recommendation:
```
╔═══════════════════════════════════════════════════════════════════╗
║   ✅ RECOMMENDED: TOD DEED FOR YOUR SITUATION                     ║
╠═══════════════════════════════════════════════════════════════════╣
║ Based on your answers:                                            ║
║ • Single property                                                 ║
║ • Simple distribution to spouse/children                          ║
║ • No trust being created                                          ║
║                                                                    ║
║ A TOD deed is a good fit:                                         ║
║ ✅ Avoids probate on your property                                ║
║ ✅ You keep full control during your lifetime                     ║
║ ✅ Simpler and less expensive than creating a trust               ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[/IF]**

**[IF tod_recommendation == optional AND creating_trust == true]**

Display comparison:
```
╔═══════════════════════════════════════════════════════════════════╗
║   OPTION: TOD DEED OR TRUST FUNDING                               ║
╠═══════════════════════════════════════════════════════════════════╣
║ Since you're creating a trust, you have two options:              ║
║                                                                    ║
║ OPTION 1: Fund property TO your trust (recommended)               ║
║ ✅ Trust provides incapacity protection                           ║
║ ✅ All assets under one coordinated plan                          ║
║                                                                    ║
║ OPTION 2: Use TOD deed (property stays in your name)              ║
║ ✅ No lender notification needed                                  ║
║ ✅ Easy to record                                                 ║
║ ❌ No incapacity protection for this property                     ║
║                                                                    ║
║ Most attorneys recommend trust funding.                           ║
╚═══════════════════════════════════════════════════════════════════╝
```

**[/IF]**

**Ask:** `tod_proceed` (from registry)

**[STOP - Wait for response]**

**[IF tod_proceed == yes]**

Set: `wants_tod_deed: true`

**Ask:** `tod_beneficiary_selection` (from registry)

**[STOP - Wait for response]**

**[/IF]**

**[IF tod_proceed == more_info]**

Load `intelligence/decision-support/tod-deed-vs-trust-funding.md`

Display condensed comparison including:
- Quick answer table
- Cost comparison
- Decision framework

Re-ask `tod_proceed`

**[STOP - Wait for response]**

**[/IF]**

**[/IF]**

---

### 2.3 Trust Structure (if applicable) — C7 constraint applies

**CRITICAL: This question MUST be asked SEPARATELY after document acceptance.**

**[IF marital_status == married AND blended_family != true]**

**[IF question.preamble exists]**
Display preamble: "Joint trusts are simpler to manage. Separate trusts offer more control over individual assets."
**[/IF]**

**Ask:** `trust_structure` (from registry)

**[STOP - Wait for response]**

**[IF trust_structure == help]**
Display explanation:
```
╔═══════════════════════════════════════════════════════════════════╗
║        JOINT TRUST vs. SEPARATE TRUSTS                             ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  JOINT TRUST (both spouses as co-grantors):                        ║
║  ✅ Simpler - one document, one set of accounts                    ║
║  ✅ All assets pooled together                                     ║
║  ✅ Either spouse can manage the trust                             ║
║  ✅ Typical for first marriages with shared assets                 ║
║                                                                    ║
║  SEPARATE TRUSTS (each spouse has their own):                      ║
║  ✅ Each spouse controls their own assets                          ║
║  ✅ Clearer separation for estate tax planning                     ║
║  ✅ Better for blended families or significant separate property   ║
║  ✅ More control over where YOUR assets go                         ║
║                                                                    ║
║  RECOMMENDATION: Most first-marriage couples choose joint trusts   ║
║  for simplicity. Separate trusts are better for blended families,  ║
║  significant separate assets, or couples who want more autonomy.   ║
╚═══════════════════════════════════════════════════════════════════╝
```

Re-ask `trust_structure` (without the help option).

**[STOP - Wait for response]**

**[/IF]**

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

**[IF question.preamble exists]**
Display preamble: "This checklist helps ensure your retirement accounts and life insurance coordinate with your estate plan."
**[/IF]**

**Ask:** `beneficiary_coordination_checklist` (from registry)

**[STOP - Wait for response]**

**[IF beneficiary_coordination_checklist == later]**
Set flag: `beneficiary_checklist_deferred: true`
Display: "I've noted this for later. You can generate the checklist anytime after we complete your documents."
Continue to next section.
**[/IF]**

**[/IF]**

---

## Phase 3: Document Drafting

See SKILL.md for Phase 3 (Generation, Validation, Review) workflow.
This phase does not involve intake questions from the registry.

---

## Phase 4: Execution Guidance

**No intake questions required** - Phase 4 uses data already collected.

**Automatic invocation** after successful Phase 3B validation:

```
IF validation_status == "success" OR validation_status == "warnings_only":
  INVOKE execution-guidance-agent
    WITH client_profile
    WITH document_metadata (all generated documents)
    WITH complexity_flags

  DISPLAY to user:
    - Signing requirements summary
    - Witness count needed
    - Notarization requirements
    - Estimated signing duration
    - Link to full checklist
```

**State-specific variations handled by agent** (not intake):
- Witness requirements per document type
- Notarization vs self-proving options
- Recording requirements for deeds
- Attorney consultation triggers

---

## Phase 5: Funding & Next Steps

**Conditional invocation** based on intake data:

```
IF trust_generated == true
   AND trust_funding_needs IN ["real_estate", "accounts", "both"]:

  INVOKE funding-checklist-agent
    WITH client_profile
    WITH trust_metadata
    WITH asset_inventory:
      - financial_assets
      - other_assets
      - life_insurance_value (if provided)
      - retirement_value (if provided)
      - business_entity_type (if provided)

  DISPLAY to user:
    - Assets to fund summary
    - Recording requirements (if real estate)
    - Timeline estimate
    - Link to full checklist
```

**Skip Phase 5 when**:
- No trust generated (will-only estate plan)
- `trust_funding_needs` == "later"
- User explicitly declines funding guidance

**Asset-type specific flows** (handled by agent):
- Real estate: Deed prep → lender contact → recording → forms
- Bank accounts: Certificate of Trust → re-titling
- Retirement: Beneficiary designation only (NO title transfer)
- Life insurance: Beneficiary form update
- Business: Buy-sell review, operating agreement

---

## Progress Tracking Display

After completing each phase, display progress to user. This helps them understand where they are in the process and what remains.

### Progress Display Template

```
┌─────────────────────────────────────────────────┐
│  Estate Plan Progress                           │
├─────────────────────────────────────────────────┤
│  {progress_bar}                                 │
│                                                 │
│  {phase_status_list}                            │
│                                                 │
│  Documents: {completed}/{total}                 │
│  Estimated remaining: {time_estimate}           │
└─────────────────────────────────────────────────┘
```

### Phase Status Indicators

| Symbol | Meaning |
|--------|---------|
| ✓ | Phase complete |
| → | Current phase (in progress) |
| ◷ | Pending (not started) |
| • | Document within phase |

### Example Progress Display (After Phase 2)

```
┌─────────────────────────────────────────────────┐
│  Estate Plan Progress: ████████░░░░ 40%         │
├─────────────────────────────────────────────────┤
│  ✓ Phase 1: Discovery (complete)                │
│  ✓ Phase 2: Document Selection (complete)       │
│  → Phase 3: Document Drafting                   │
│    • Trust: ◷ Pending                           │
│    • Will: ◷ Pending                            │
│    • POA: ◷ Pending                             │
│    • Healthcare: ◷ Pending                      │
│  ○ Phase 4: Execution Guidance                  │
│  ○ Phase 5: Funding Checklist                   │
│                                                 │
│  Documents: 0/4 drafted                         │
│  Estimated remaining: 10-15 minutes             │
└─────────────────────────────────────────────────┘
```

### Example Progress Display (After Phase 3)

```
┌─────────────────────────────────────────────────┐
│  Estate Plan Progress: ████████████░░ 80%       │
├─────────────────────────────────────────────────┤
│  ✓ Phase 1: Discovery (complete)                │
│  ✓ Phase 2: Document Selection (complete)       │
│  ✓ Phase 3: Document Drafting (complete)        │
│    • Trust: ✓ Generated                         │
│    • Will: ✓ Generated                          │
│    • POA: ✓ Generated                           │
│    • Healthcare: ✓ Generated                    │
│  → Phase 4: Execution Guidance                  │
│  ○ Phase 5: Funding Checklist                   │
│                                                 │
│  Documents: 4/4 drafted                         │
│  Estimated remaining: 2-3 minutes               │
└─────────────────────────────────────────────────┘
```

### When to Display Progress

Display progress summary:
- After completing Phase 1 (Discovery)
- After completing Phase 2 (Document Selection)
- After each document is generated in Phase 3
- After Phase 3 validation completes
- After Phase 4 (Execution Guidance) completes
- After Phase 5 (Funding Checklist) completes

### Progress State Variables

Track these values in `client_profile.json` under `progress` key:

```json
{
  "progress": {
    "phase": 3,
    "phase_1_complete": true,
    "phase_2_complete": true,
    "phase_3_complete": false,
    "documents_selected": ["trust", "will", "poa", "healthcare"],
    "documents_generated": ["trust", "will"],
    "documents_validated": false,
    "phase_4_complete": false,
    "phase_5_complete": false
  }
}
```

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
