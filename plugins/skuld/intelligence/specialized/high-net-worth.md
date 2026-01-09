# High Net Worth Estate Planning

## ⚠️ ESTATE TAX THRESHOLD ALERT

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                    HIGH NET WORTH ESTATE PLANNING NOTICE                     ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║ Your estimated net worth exceeds $13.99 million, which is above the 2025    ║
║ federal estate tax exemption.                                                ║
║                                                                              ║
║ Without proper planning, your estate could owe SIGNIFICANT estate taxes:    ║
║                                                                              ║
║   Estate Value    Potential Tax (40% rate)    After Exemption               ║
║   $15 million     ~$400,000                   (on $1M over exemption)       ║
║   $20 million     ~$2,400,000                 (on $6M over exemption)       ║
║   $30 million     ~$6,400,000                 (on $16M over exemption)      ║
║                                                                              ║
║ The strategies in this document can help LEGALLY MINIMIZE estate taxes.     ║
║ However, advanced planning requires specialized legal and tax counsel.      ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

## Current Exemption Levels (2025)

| Tax | Individual Exemption | Married (Portable) | Tax Rate |
|-----|---------------------|-------------------|----------|
| Federal Estate Tax | $13.99 million | $27.98 million | 40% |
| Federal Gift Tax | $13.99 million (unified) | $27.98 million | 40% |
| GST Tax | $13.99 million | $27.98 million | 40% |

**Note:** Exemption is scheduled to decrease to ~$7 million in 2026 unless extended by Congress.

## Key Concepts

### Unified Credit System
- Estate tax and gift tax share the same lifetime exemption
- Gifts during lifetime reduce amount available at death
- Annual exclusion gifts ($18,000/person in 2025) do NOT count against lifetime exemption

### Portability
- Surviving spouse can use deceased spouse's unused exemption (DSUE)
- Must elect on Form 706 even if no tax is due
- First spouse's exemption amount is "frozen" at their death
- Second spouse's exemption is indexed for inflation

### Generation-Skipping Transfer (GST) Tax
- Additional 40% tax on transfers to grandchildren or lower generations
- Separate $13.99 million exemption
- Can be allocated to trusts for multi-generational benefit

## Tax Minimization Strategies

### 1. A-B Trust (Credit Shelter / Bypass Trust)

**How it works:**
- At first death, estate splits into "A" trust (survivor's) and "B" trust (bypass)
- B trust uses deceased spouse's exemption
- Assets in B trust grow outside surviving spouse's estate
- Surviving spouse can receive income from B trust

**Benefits:**
- Shelters appreciation from estate tax
- Works even if exemption decreases
- Provides asset protection for surviving spouse

**When to use:**
- Estates expecting significant growth
- Concerns about future exemption reduction
- Want asset protection for surviving spouse
- State has estate tax with lower exemption

### 2. Irrevocable Life Insurance Trust (ILIT)

**How it works:**
- Trust owns life insurance policy
- Premiums paid with annual exclusion gifts
- Death benefit paid to trust, not estate
- Beneficiaries receive proceeds estate-tax-free

**Benefits:**
- Removes life insurance from taxable estate
- Death benefit can provide estate tax liquidity
- Can provide for family without tax erosion

**Requirements:**
- Must be irrevocable
- Insured cannot be trustee
- "Crummey" notices for gift tax exclusion
- 3-year rule for transferred policies

### 3. Dynasty Trust

**How it works:**
- Trust designed to last multiple generations
- GST exemption allocated to shield from GST tax
- Assets grow and distribute tax-free for descendants

**Benefits:**
- Multi-generational wealth transfer
- Avoids estate tax at each generation
- Asset protection from creditors and divorce

**State-Specific Duration:**
- Tennessee: 360 years
- South Dakota: Perpetual
- Delaware: Perpetual
- Nevada: 365 years
- Many states: 90-150 years (traditional RAP)

### 4. Grantor Retained Annuity Trust (GRAT)

**How it works:**
- Transfer appreciating assets to irrevocable trust
- Grantor receives fixed annuity payments for term
- Remainder passes to beneficiaries at end of term

**Benefits:**
- If assets outperform IRS assumed rate (Section 7520), excess passes tax-free
- Can be "zeroed out" (no gift tax on initial transfer)
- Effective for assets expected to appreciate

**Risks:**
- If grantor dies during term, assets included in estate
- Works best with appreciating assets
- Must survive the GRAT term

### 5. Qualified Personal Residence Trust (QPRT)

**How it works:**
- Transfer home to irrevocable trust
- Retain right to live in home for term of years
- At end of term, home passes to beneficiaries

**Benefits:**
- Removes home (and appreciation) from estate
- Gift value discounted based on retained interest
- Can continue living in home during term

**Considerations:**
- Must survive the term
- At term end, must pay rent if staying in home
- Less effective with low interest rates

### 6. Family Limited Partnership (FLP) / Family LLC

**How it works:**
- Transfer assets to entity
- Retain general partnership interest (control)
- Gift limited partnership interests to heirs

**Benefits:**
- Valuation discounts (lack of marketability, minority interest)
- Maintain control over assets
- Asset protection from creditors

**IRS Scrutiny:**
- Must have legitimate business purpose
- Formalities must be followed
- Death-bed transfers scrutinized
- "2036 risk" if too much control retained

### 7. Charitable Strategies

**Charitable Remainder Trust (CRT):**
- Income stream to donor for life or term
- Remainder to charity
- Immediate charitable deduction
- No capital gains on appreciated asset sale

**Charitable Lead Trust (CLT):**
- Income stream to charity for term
- Remainder to family
- Can be "zeroed out" like GRAT

**Private Foundation:**
- Ongoing family philanthropy
- Employment for family members
- 5% annual distribution requirement

## State Estate Tax Considerations

Some states have estate taxes with LOWER exemptions than federal:

| State | Exemption (2025) | Top Rate |
|-------|------------------|----------|
| Oregon | $1 million | 16% |
| Massachusetts | $2 million | 16% |
| Washington | $2.193 million | 20% |
| Minnesota | $3 million | 16% |
| New York | $6.94 million | 16% |
| Connecticut | $13.61 million | 12% |

**Planning implications:**
- May owe state tax even if under federal exemption
- A-B trust may still be valuable for state tax planning
- Residence planning may be worthwhile

## Form 706 Estate Tax Return

**When required:**
- Gross estate + adjusted taxable gifts > exemption
- Electing portability (even if no tax due)
- Due 9 months after death (6-month extension available)

**Key schedules:**
- Schedule A: Real Estate
- Schedule B: Stocks and Bonds
- Schedule C: Mortgages, Notes, Cash
- Schedule D: Life Insurance
- Schedule E: Joint Interests
- Schedule F: Other Miscellaneous Property
- Schedule G: Transfers During Life
- Schedule M: Marital Deduction
- Schedule O: Charitable Deduction

## Plugin Behavior for High Net Worth

When the `high_net_worth` flag is set, the estate planning plugin will:

### During Discovery (Phase 1)
1. Display the Estate Tax Threshold Alert
2. Ask about existing advanced planning (ILITs, GRATs, FLPs)
3. Collect more detailed asset information
4. Ask about charitable giving intentions
5. Note state of residence for state estate tax

### During Document Selection (Phase 2)
1. Recommend consulting estate tax specialist
2. Suggest A-B trust provisions in revocable trust
3. Note that irrevocable trusts are beyond scope but important
4. Recommend Form 706 executor guidance document

### During Drafting (Phase 3)
1. Include A-B trust provisions in revocable trust
2. Add GST tax allocation language
3. Include formula clause for exemption amount
4. Add flexibility for portability election
5. Note need for ILIT review if life insurance exists

### Validation Checks
1. Verify A-B provisions if estate over exemption
2. Check if GST provisions needed for grandchildren beneficiaries
3. Confirm executor understands Form 706 requirements
4. Note state estate tax if applicable

### Documents Generated
- **Revocable Trust with A-B Provisions** (core document)
- **Pour-Over Will** (standard)
- **Form 706 Executor Guidance** (specialized checklist)

### Documents Recommended (Not Generated)
- **ILIT** - Requires irrevocable trust specialist
- **GRAT** - Requires valuation and actuarial calculations
- **FLP/LLC** - Requires business entity formation
- **CRT/CLT** - Requires charitable planning specialist

## Common Mistakes

1. **Relying solely on portability** - Doesn't capture appreciation, no asset protection
2. **Ignoring state estate tax** - Many states have lower exemptions
3. **Not filing Form 706 for portability** - Must affirmatively elect
4. **Transferred policies within 3 years** - Still in estate (ILIT rule)
5. **FLP without substance** - IRS attacks entities lacking business purpose
6. **Not updating for exemption changes** - Plans become stale
7. **Ignoring liquidity** - Estate tax due in 9 months, may force asset sales

## Annual Gifting Program

Maximum annual exclusion gifts (2025):
- $18,000 per recipient
- Married couple: $36,000 per recipient (gift splitting)
- Unlimited for tuition paid directly to school
- Unlimited for medical expenses paid directly to provider

**Example:** Married couple with 3 children and 6 grandchildren can transfer $324,000/year ($36,000 × 9 recipients) without using any lifetime exemption.

## Timeline Considerations

| Timeframe | Actions |
|-----------|---------|
| Immediately | Review current estate size vs. exemption |
| Within 6 months | Implement basic trust structure |
| Within 1 year | Consider ILIT if significant life insurance |
| Ongoing | Annual gifting program |
| Annually | Review for law changes |
| At first death | File Form 706 for portability |

## When to Refer to Specialists

This plugin can help with basic probate avoidance, but refer to specialists for:
- Estates significantly over exemption ($20M+)
- Complex business interests
- International assets
- Charitable planning vehicles
- Advanced irrevocable trust strategies
- Valuation discount planning

---

## Cross-References

**Advanced Strategy Modules:**
- **IDGT (Intentionally Defective Grantor Trust):** `intelligence/specialized/idgt.md` - Estate freeze technique for appreciating assets
- **SLAT (Spousal Lifetime Access Trust):** `intelligence/specialized/slat.md` - Irrevocable trust with indirect spousal access
- **Business Succession:** `intelligence/specialized/business-succession.md` - Planning for business owners

**Tax Education Modules:**
- **Valuation Discounts:** `intelligence/tax/valuation-discounts.md` - DLOM, minority interest discounts for FLP/LLC
- **Tax Allocation:** `intelligence/tax/tax-allocation.md` - Who bears estate tax burden
- **Basis and Step-Up:** `intelligence/tax/basis-and-step-up.md` - Capital gains elimination at death
- **Federal Estate and Gift Tax:** `intelligence/tax/federal-estate-gift-tax.md` - Exemptions and rates
- **State Death Taxes:** `intelligence/tax/state-death-taxes.md` - State-by-state coverage

**State-Specific Planning:**
- **Tennessee:** `intelligence/state-laws/TN.md` - Dynasty trusts, CPT, DAPT advantages

**Forms and Guidance:**
- **Form 706 Guidance:** `intelligence/forms/form-706-guidance.md` - Estate tax return requirements

**Glossary:**
- **Tax Terms:** `intelligence/glossary/tax-terms.md` - IDGT, SLAT, DLOM, AFR definitions
