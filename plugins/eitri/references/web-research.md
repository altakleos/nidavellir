# Web Research Integration Guide

This reference guides when and how to use web research capabilities when forging extensions.

## Two Research Tools

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `WebFetch` | Fetch known URLs | Official docs, specific API documentation |
| `WebSearch` | Search the web | Domain research, current regulations, unfamiliar fields |

---

## WebFetch - Official Documentation

### When to Use

- Fetching official Claude Code documentation for latest specs
- Known API documentation (Stripe, Twilio, AWS, etc.)
- GitHub repositories for examples

### Authoritative Sources

| Source | URL | Use Case |
|--------|-----|----------|
| Skills Docs | https://code.claude.com/docs/en/skills | SKILL.md frontmatter spec |
| Plugin Docs | https://code.claude.com/docs/en/plugins | Plugin structure |
| Official Skills | https://github.com/anthropics/skills | Examples and patterns |
| Best Practices | https://code.claude.com/docs/en/best-practices | Recommended patterns |

### Usage Pattern

```
When specification accuracy is critical:
1. Identify the specific documentation needed
2. Fetch from authoritative URL
3. Extract relevant specification details
4. Apply to extension being forged
```

---

## WebSearch - Domain Research

### When to Use

Use WebSearch when the domain is:
- NOT covered in `intelligence/domain-intelligence.md`
- Time-sensitive (current year regulations, tax rules)
- Unfamiliar industry with specific terminology
- User explicitly requests current/latest practices
- Niche field (genomics, real estate, education, etc.)

### Covered Domains (Use Internal Knowledge First)

The following domains are well-documented in `intelligence/domain-intelligence.md`:
- Healthcare (HIPAA, PHI, audit trails)
- Financial Services (SOX, PCI DSS, precision math)
- E-Commerce (inventory, payments, customer data)
- SaaS/Startup (rapid iteration, MVP, growth metrics)
- DevOps (CI/CD, IaC, monitoring)

For these domains, use internal knowledge first, then WebFetch for specific APIs if needed.

### Domains Requiring WebSearch

Examples of domains that benefit from web research:
- Accounting and bookkeeping
- Tax preparation (especially current year rules)
- Legal and compliance (varies by jurisdiction)
- Real estate and property management
- Education and curriculum
- Medical billing and insurance
- Government and public sector
- Non-profit and grant management
- Agriculture and farming
- Manufacturing and supply chain

### Search Strategy

1. **Include current year** when relevant
   - Good: "2025 IRS tax filing requirements small business"
   - Bad: "tax filing requirements" (may return outdated info)

2. **Target authoritative sources**
   - Government sites (.gov)
   - Professional associations
   - Industry standards bodies
   - Official documentation

3. **Search for specifics**
   - Domain-specific terminology
   - Compliance requirements
   - Industry best practices
   - Common workflows

### Example Searches

| Domain | Example Search Query |
|--------|---------------------|
| Tax | "2025 IRS tax filing requirements small business" |
| Accounting | "GAAP accounting standards inventory valuation" |
| Real Estate | "real estate transaction compliance checklist" |
| Medical | "medical billing CPT codes best practices" |
| Legal | "contract management compliance requirements" |
| Education | "student data privacy FERPA requirements" |

### When NOT to Use WebSearch

- Domain already well-covered in internal knowledge
- Technical patterns documented in `references/patterns.md`
- General programming questions
- Claude Code specification questions (use WebFetch instead)

---

## Integration Pattern

When forging an extension:

```
1. ANALYZE the domain
   - Is it in domain-intelligence.md? → Use internal knowledge
   - Is it unfamiliar or niche? → Plan to use WebSearch
   - Is it time-sensitive? → Include current year in search

2. CHECK internal knowledge first
   - references/patterns.md for technical patterns
   - intelligence/domain-intelligence.md for known domains
   - intelligence/safety-rules.md for safety requirements

3. RESEARCH as needed
   - Unknown domain → WebSearch for domain knowledge
   - Specific API mentioned → WebFetch official docs
   - Specification validation → WebFetch Claude Code docs

4. VALIDATE generated extension
   - Frontmatter against current spec
   - Domain logic against researched requirements
   - Safety rules compliance

5. CITE sources
   - Note when domain knowledge came from web research
   - Suggest user verify critical domain-specific details
```

---

## Error Handling

### If WebFetch Fails
- Proceed with internal knowledge
- Note that latest spec could not be verified
- Suggest user check official documentation

### If WebSearch Returns Poor Results
- Try more specific search terms
- Proceed with general best practices
- Clearly note knowledge limitations in delivery

### Always
- Note any knowledge gaps in the delivery phase
- Suggest user verify domain-specific compliance requirements
- Recommend professional consultation for regulated domains

---

## Security Considerations

### For WebFetch
- Only fetch from trusted, known domains
- Handle timeouts gracefully (network issues happen)
- Validate that response content is expected format

### For WebSearch
- Be skeptical of unofficial sources
- Cross-reference critical information
- Prefer authoritative sources over blog posts
- Note source reliability in citations
