# Skuld

> **Prepare your estate documents with confidence—guided every step of the way.**

A comprehensive estate planning assistant that walks you through creating wills, trusts, powers of attorney, and healthcare directives. Get state-specific guidance, understand complex concepts in plain English, and leave with draft documents ready for attorney review.

---

## Quick Start

**Install:**
```bash
/plugin install skuld@altakleos
```

**Begin planning:**
```
/estate
```

That's it. The assistant guides you from there—no legal knowledge required.

---

## What You'll Create

| Document | Purpose |
|----------|---------|
| **Revocable Living Trust** | Avoid probate and manage assets during incapacity |
| **Pour-Over Will** | Catch assets outside your trust, name guardians for children |
| **Financial Power of Attorney** | Authorize someone to manage your finances if you can't |
| **Healthcare Directive** | Living will + healthcare proxy + HIPAA authorization |

**For complex situations, also:**
- Special Needs Trust (preserve government benefits for disabled beneficiaries)
- QTIP Trust provisions (blended families)
- A-B Trust provisions (estates over $13.99M)

---

## Who This Is For

| Your Situation | How This Helps |
|----------------|----------------|
| **New parents** | Name guardians, protect children's inheritance until they're ready |
| **Recently married** | Coordinate assets, ensure spouse is protected |
| **Blended family** | Balance current spouse's security with children from prior marriage |
| **Caring for disabled family member** | Create special needs trust that preserves their benefits |
| **Business owner** | Ensure smooth succession, protect business assets |
| **Approaching retirement** | Get your affairs in order, make incapacity plans |

---

## How It Works

The assistant guides you through 5 phases:

```
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 1    PHASE 2      PHASE 3     PHASE 4     PHASE 5       │
│ Discovery → Selection → Drafting → Execution → Funding         │
│                                                                 │
│ Answer      Choose       Review      Get signing  Transfer     │
│ questions   documents    drafts      instructions assets       │
└─────────────────────────────────────────────────────────────────┘
```

**Resume anytime**: Your progress is saved. Come back tomorrow, next week—pick up where you left off.

---

## Example Session

Here's what a typical session looks like:

```
You: /estate

╔══════════════════════════════════════════════════════════════════╗
║                    EDUCATIONAL INFORMATION                       ║
╠══════════════════════════════════════════════════════════════════╣
║ I provide educational information about estate planning to help  ║
║ you understand your options and prepare for working with an      ║
║ attorney.                                                        ║
║                                                                  ║
║ All documents generated are DRAFTS intended for attorney review. ║
╚══════════════════════════════════════════════════════════════════╝

Let's start with some basic information. What's your full legal name?

You: Sarah Chen

Great, Sarah. What state do you live in?

You: California

Got it—California is a community property state, which affects how
married couples own assets. I've loaded California's specific
requirements for wills, trusts, and other documents.

Are you currently married, single, divorced, or widowed?

You: Married, with two kids

Wonderful. I'll need a bit more information about your family...

[Interview continues through family, assets, and goals]

---

Based on what you've shared, I recommend these documents:

✓ Revocable Living Trust (joint, for you and your spouse)
✓ Pour-Over Will (one for each of you)
✓ Financial Power of Attorney (one for each)
✓ Healthcare Directive Package (one for each)
✓ Trust Funding Checklist

Would you like me to explain any of these, or shall we proceed
to drafting?
```

---

## Coverage

| Category | What's Included |
|----------|-----------------|
| **States** | All 50 states + DC with specific execution requirements |
| **Concepts** | 12 glossary categories explaining legal terms in plain English |
| **Situations** | Blended families, special needs, high net worth, digital assets, business succession |
| **Tax info** | Federal exemptions ($13.99M for 2025), state estate/inheritance taxes |

---

## Commands

| Command | What It Does |
|---------|--------------|
| `/estate` | Start the full estate planning workflow |
| `/estate:lookup CA` | Quick lookup of California's requirements |
| `/estate:lookup NY tax` | Look up New York's estate tax info |

---

## What Makes This Different

**Educational-first**: Don't know what a "revocable trust" is? The assistant explains concepts automatically when they come up—no need to ask.

**State-aware**: California community property rules differ from New York common law. Texas has different witness requirements than Florida. The assistant applies your state's specific rules automatically.

**Privacy-focused**: Your information stays on your machine. No personal data is transmitted anywhere.

**Handles complexity**: Blended family with children from a prior marriage? Disabled child receiving SSI? Business with partners? The assistant recognizes these situations and adapts its recommendations.

---

## Frequently Asked Questions

<details>
<summary><strong>Is this legal advice?</strong></summary>

No. This assistant provides educational information and generates draft documents. All documents should be reviewed by a licensed attorney before signing. The assistant will remind you of this throughout the process.

</details>

<details>
<summary><strong>Which states are covered?</strong></summary>

All 50 US states plus Washington DC. Each state has specific requirements for:
- Number of witnesses for wills
- Notarization requirements
- Healthcare directive forms
- Power of attorney rules

The assistant automatically applies your state's requirements.

</details>

<details>
<summary><strong>What about Louisiana?</strong></summary>

Louisiana operates under civil law (derived from French/Spanish law), not common law like the other 49 states. Estate planning documents valid elsewhere may not be valid in Louisiana. If you're a Louisiana resident, the assistant will provide Louisiana-specific guidance and strongly recommend working with a Louisiana-licensed attorney.

</details>

<details>
<summary><strong>How long does it take?</strong></summary>

Most people complete the discovery phase (answering questions about their situation) in 15-30 minutes. Document drafting takes another 30-60 minutes depending on complexity. But there's no rush—your progress is saved, and you can resume anytime.

</details>

<details>
<summary><strong>What if my situation is complicated?</strong></summary>

The assistant handles many complex situations directly:
- Blended families with children from prior marriages
- Disabled beneficiaries receiving government benefits
- Business owners with succession planning needs
- Property in multiple states

For very complex situations (estates over $13.99M, non-US citizen spouse, active litigation), the assistant provides educational guidance and recommends consulting specialists.

</details>

---

## Under the Hood

For developers and curious users:

| Component | Count | Purpose |
|-----------|-------|---------|
| Specialized agents | 8 | Glossary, state lookup, document generators, validation |
| Intelligence files | 95+ | State laws, templates, tax info, specialized scenarios |
| State jurisdictions | 51 | All 50 states + DC with execution requirements |
| Document templates | 8 | Core legal document frameworks |

**Architecture:**
```
skuld/
├── SKILL.md                 # Main orchestrator
├── commands/                # /estate, /estate:lookup
├── agents/                  # 8 specialized agents
└── intelligence/
    ├── glossary/            # 12 term categories
    ├── state-laws/          # 51 jurisdictions
    ├── templates/           # Document frameworks
    ├── concepts/            # Property law systems
    ├── specialized/         # Complex scenarios
    └── tax/                 # Federal and state tax data
```

---

## Important Notices

**Educational Purpose Only**: All documents generated are drafts intended for attorney review. This plugin does not provide legal advice.

**Professional Review Required**: Before signing any document, have it reviewed by a licensed attorney in your state.

**Louisiana Civil Law**: Louisiana uses civil law, not common law. Estate documents from other states are often invalid in Louisiana. Louisiana residents must work with a Louisiana-licensed attorney.

---

**Version:** 1.0.0 | **Data:** 2025-12 | **Federal Exemption:** $13.99M (2025)
