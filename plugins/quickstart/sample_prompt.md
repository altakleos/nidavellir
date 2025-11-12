# Sample Prompts for QuickStart

## Quick Start

The simplest way to begin:

```
/create-skill
```

Then just have a natural conversation about what you need.

## Specific Use Cases

### Use Case 1: Small Business Automation

```
/create-skill

I run a small marketing agency with 5 people. We spend way too much time creating client reports every week - pulling data from Google Analytics, social media platforms, and our project management tool. We need something to automate this but we're not very technical.
```

This gives me context about:
- Business type (marketing agency)
- Team size (small, 5 people)
- Pain point (manual report creation)
- Technical level (not very technical)
- Data sources (GA, social, PM tool)

### Use Case 2: Enterprise Integration

```
/create-skill

We're the data team at a Fortune 500 retailer. Need to build a skill that integrates our inventory management system with our e-commerce platform, handles about 50,000 SKUs, updates in real-time, and needs to comply with SOC 2 requirements. We have a technical team that can handle complex implementations.
```

This tells me:
- Enterprise context
- Technical team available
- Scale requirements (50k SKUs)
- Real-time needs
- Compliance requirements
- Integration focus

### Use Case 3: Startup Growth

```
/create-skill

I'm a solo founder of a SaaS startup. Right now I manually calculate MRR, churn, and other metrics every month for investor updates. Takes me half a day. I need to automate this and make it look professional. Using Stripe for payments and Mixpanel for analytics.
```

This indicates:
- Solo founder (need simplicity)
- SaaS metrics focus
- Investor reporting need
- Specific tools (Stripe, Mixpanel)
- Time pressure

### Use Case 4: Healthcare Compliance

```
/create-skill

I work at a medical clinic. We need to track patient appointment no-shows and send follow-up reminders, but everything needs to be HIPAA compliant. We have about 200 patients per week. Our staff isn't technical but they're good at following procedures.
```

This reveals:
- Healthcare domain
- HIPAA compliance critical
- Specific workflow (no-shows, reminders)
- Scale (200 patients/week)
- Non-technical users
- Process-oriented team

### Use Case 5: Financial Analysis

```
/create-skill

I'm a financial advisor managing portfolios for high net worth clients. Need to analyze portfolio performance, rebalancing opportunities, and tax implications. Must be extremely accurate and create professional reports. Currently using Excel but it's getting unwieldy.
```

This shows:
- Financial services domain
- High stakes (HNW clients)
- Accuracy critical
- Professional output needed
- Excel replacement need

## Different Interaction Styles

### Conversational Style

```
/create-skill

Hey, I need help with something. We're drowning in customer support tickets and I think there's got to be a better way to handle the common questions automatically. What can you do for me?
```

### Technical Style

```
/create-skill

Need a skill for ETL pipeline: PostgreSQL -> transformation layer with business logic -> export to S3 in parquet format. Daily runs, incremental updates, full snapshot weekly. Handle ~10GB daily volume. Include data quality checks and alerting on failures.
```

### Business-Focused Style

```
/create-skill

Our customer churn rate is killing us. We need to identify at-risk customers before they leave. We have purchase history, support tickets, and engagement metrics. Want predictive analytics and actionable recommendations for our customer success team.
```

## Requesting Specific Architectures

### Single Comprehensive Skill

```
/create-skill

I want everything in one skill - data collection, processing, and reporting. Keep it simple, I don't want to manage multiple components.
```

### Modular Suite

```
/create-skill

I prefer modular architecture - separate skills for each major function so different teams can use what they need. We're planning to scale this across the organization.
```

### Evolutionary Design

```
/create-skill

Start simple but design it to grow. We're in MVP stage now but will need enterprise features within 6 months.
```

## Specifying Constraints

### Time Constraint

```
/create-skill

I need something working by end of day. Doesn't have to be perfect, just functional. We can improve it later.
```

### Technical Constraint

```
/create-skill

Our IT department requires everything to run on-premise, no cloud services. Also needs to work with our existing Active Directory for authentication.
```

### Budget Constraint

```
/create-skill

We're bootstrapped so need to use free tools only. No paid APIs or services. Open source is fine.
```

## Advanced Requests

### Industry-Specific

```
/create-skill

I work in pharmaceutical manufacturing. Need GMP compliance, 21 CFR Part 11 electronic signatures, and full audit trails. This is for batch record review and release.
```

### Multi-Language Support

```
/create-skill

Our team is global - need the skill to work in English, Spanish, and Mandarin. Especially the user-facing documentation and error messages.
```

### Integration-Heavy

```
/create-skill

This needs to integrate with Salesforce, Slack, Jira, and our custom ERP system. Should sync bidirectionally and handle conflicts gracefully.
```

## Iteration Requests

### After Initial Creation

```
Actually, can we add a dashboard view to this? Our executives want to see real-time metrics without running reports.
```

### Refinement

```
This is great but it's a bit too complex for our junior staff. Can you simplify the interface while keeping the advanced features available for power users?
```

### Feature Addition

```
Working perfectly! Now can we add automated email notifications when certain thresholds are hit?
```

## Tips for Best Results

1. **Be specific about your context** - The more I understand your situation, the better the skill

2. **Share real examples** - "Our data looks like this..." helps me create accurate solutions

3. **Mention your constraints upfront** - Technical limitations, compliance needs, time pressures

4. **Describe your ideal outcome** - What would success look like?

5. **Don't worry about technical details** - I'll figure out the implementation based on your needs

## What Not to Say

### Too Vague
❌ "I need a skill for my business"

### Too Technical Without Context
❌ "Build a REST API with JWT auth and GraphQL subscriptions"

### Missing Critical Information
❌ "Make a report generator" (What kind of reports? For whom? From what data?)

## The Best Prompt

The best prompt is honest and conversational:

```
/create-skill

Here's my situation: [describe your context]
Here's my problem: [what you're trying to solve]
Here's what I've tried: [current approach if any]
Here's what I need: [ideal outcome]
Here are my constraints: [limitations if any]
```

Remember: I'm not just generating from templates - I'm understanding your unique situation and creating something specifically for you. The more context you provide, the better the result!