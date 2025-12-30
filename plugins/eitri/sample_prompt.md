# Sample Prompts for Eitri

## Quick Start

The simplest way to begin:

```
/forge
```

Then just have a natural conversation about what you need. Eitri will automatically determine whether to create a skill, agent, suite, or hybrid solution based on your requirements.

**Don't worry about choosing!** Just describe your needs and I'll figure out the best type of extension for you.

## Specific Use Cases

### Use Case 1: Small Business Automation

```
/forge

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
/forge

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
/forge

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
/forge

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
/forge

I'm a financial advisor managing portfolios for high net worth clients. Need to analyze portfolio performance, rebalancing opportunities, and tax implications. Must be extremely accurate and create professional reports. Currently using Excel but it's getting unwieldy.
```

This shows:
- Financial services domain
- High stakes (HNW clients)
- Accuracy critical
- Professional output needed
- Excel replacement need

### Use Case 6: Agent - Code Formatter (Auto-Invocation)

```
/forge

I want something that automatically formats my code whenever I make changes. Should work across all my projects - Python, JavaScript, whatever. Just keep my code clean without me having to think about it.
```

**Why Agent:** Generic task, reusable across projects, auto-triggered
**Eitri will create:** Agent with auto-invocation, tool restrictions for safety

This indicates:
- Reusable across all projects
- Auto-invocation desired ("automatically")
- Generic operation (formatting is standard)
- No project-specific logic needed

### Use Case 7: Agent Suite - Development Workflow

```
/forge

I need a complete development workflow: first analyze requirements and create technical specs, then build the frontend and backend in parallel, run comprehensive tests, and finally do a code review. Everything should be automated and coordinated.
```

**Why Suite:** Multiple distinct operations, parallel + sequential execution
**Eitri will create:** Coordinated suite of 5 agents with safety enforcement

This reveals:
- Multiple distinct roles (analyst, developers, tester, reviewer)
- Sequential phases (analyze → develop → test → review)
- Parallel opportunities (frontend + backend)
- Coordination needed between agents
- Quality operations must be sequential (safety-critical)

### Use Case 8: Hybrid - Project Management with Automations

```
/forge

Help me manage our custom project workflow. When I finish a feature, I want it to automatically format the code, run our test suite, and generate a commit message based on the changes. But I also need to track project context, milestones, and team assignments manually.
```

**Why Hybrid:** Custom orchestration + generic automations
**Eitri will create:** Skill (orchestrator) + 3 agents (specialists)

This shows:
- Custom workflow needs (skill for orchestration)
- Generic automations (agents for format/test/commit)
- Mix of automated and manual operations
- Context management (project state, team info)
- Reusable utilities (format, test, commit)

### Use Case 9: Agent - Test Runner (On-Demand)

```
/forge

I want to run my comprehensive test suite whenever I ask. Should run all unit tests, integration tests, check coverage, and give me a detailed report. Reusable across any project I work on.
```

**Why Agent:** Generic task, reusable, on-demand invocation
**Eitri will create:** Quality agent with sequential execution (safety-critical)

This indicates:
- On-demand invocation (not auto-triggered)
- Quality operation (testing)
- Reusable across projects
- Must be sequential (CRITICAL safety rule)

### Use Case 10: Agent Suite - Security Audit Pipeline

```
/forge

Security audit workflow: scan dependencies for vulnerabilities, analyze code for security issues, check configuration files for exposed secrets, and generate a comprehensive security report. Everything should run sequentially because each step builds on the previous results.
```

**Why Suite:** Multiple security operations, sequential execution
**Eitri will create:** Pipeline of 4 agents with sequential coordination

This reveals:
- Multiple security operations
- Sequential dependencies (each step uses previous results)
- Quality/security focus (must be sequential for safety)
- Coordinated workflow with handoffs
- Comprehensive reporting at the end

## Different Interaction Styles

### Conversational Style

```
/forge

Hey, I need help with something. We're drowning in customer support tickets and I think there's got to be a better way to handle the common questions automatically. What can you do for me?
```

### Technical Style

```
/forge

Need a skill for ETL pipeline: PostgreSQL -> transformation layer with business logic -> export to S3 in parquet format. Daily runs, incremental updates, full snapshot weekly. Handle ~10GB daily volume. Include data quality checks and alerting on failures.
```

### Business-Focused Style

```
/forge

Our customer churn rate is killing us. We need to identify at-risk customers before they leave. We have purchase history, support tickets, and engagement metrics. Want predictive analytics and actionable recommendations for our customer success team.
```

## Requesting Specific Architectures

### Single Comprehensive Skill

```
/forge

I want everything in one skill - data collection, processing, and reporting. Keep it simple, I don't want to manage multiple components.
```

### Modular Suite

```
/forge

I prefer modular architecture - separate skills for each major function so different teams can use what they need. We're planning to scale this across the organization.
```

### Evolutionary Design

```
/forge

Start simple but design it to grow. We're in MVP stage now but will need enterprise features within 6 months.
```

## Requesting Specific Extension Types

### Requesting an Agent

```
/forge

Create an agent that automatically runs prettier on my code whenever I save files. Should be reusable across all my JavaScript projects.
```

**Keywords that signal agent:** "automatically", "whenever", "reusable", generic task name

### Requesting an Agent Suite

```
/forge

I need a coordinated suite for deployment: first run tests, then build the application, then push to staging, and finally deploy to production. Each step depends on the previous one succeeding.
```

**Keywords that signal suite:** "coordinated", "first...then...", multiple distinct operations, "each step"

### Requesting a Hybrid Solution

```
/forge

Help me orchestrate our release process. The overall workflow is custom to our team, but I want to use standard agents for code formatting, testing, and documentation generation.
```

**Keywords that signal hybrid:** "orchestrate", "custom workflow" + "standard operations", "coordinate"

### Letting Eitri Decide (Recommended)

```
/forge

Every week I need to analyze our customer data, identify trends, create visualizations, and send a report to stakeholders. Currently doing this manually and it takes forever.
```

**No explicit type mentioned** - Eitri will analyze and recommend the best approach with transparent reasoning.

## Specifying Constraints

### Time Constraint

```
/forge

I need something working by end of day. Doesn't have to be perfect, just functional. We can improve it later.
```

### Technical Constraint

```
/forge

Our IT department requires everything to run on-premise, no cloud services. Also needs to work with our existing Active Directory for authentication.
```

### Budget Constraint

```
/forge

We're bootstrapped so need to use free tools only. No paid APIs or services. Open source is fine.
```

## Advanced Requests

### Industry-Specific

```
/forge

I work in pharmaceutical manufacturing. Need GMP compliance, 21 CFR Part 11 electronic signatures, and full audit trails. This is for batch record review and release.
```

### Multi-Language Support

```
/forge

Our team is global - need the skill to work in English, Spanish, and Mandarin. Especially the user-facing documentation and error messages.
```

### Integration-Heavy

```
/forge

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

1. **Be specific about your context** - The more I understand your situation, the better the extension

2. **Share real examples** - "Our data looks like this..." helps me create accurate solutions

3. **Mention your constraints upfront** - Technical limitations, compliance needs, time pressures

4. **Describe your ideal outcome** - What would success look like?

5. **Don't worry about technical details** - I'll figure out the implementation based on your needs

6. **Trust Eitri's recommendation** - I'll show you transparent reasoning for skill vs agent vs suite vs hybrid

7. **Use trigger words naturally** - "Automatically", "whenever", "reusable" help me understand auto-invocation needs

8. **Mention coordination needs** - "First...then...", "in parallel", "coordinate" help me understand workflow patterns

## What Not to Say

### Too Vague
❌ "I need a skill for my business"
✓ Better: "I need to automate weekly customer reports for my 10-person marketing agency"

### Too Technical Without Context
❌ "Build a REST API with JWT auth and GraphQL subscriptions"
✓ Better: "I need secure user authentication for my SaaS app with 1000 users"

### Missing Critical Information
❌ "Make a report generator"
✓ Better: "Generate weekly sales reports from our CRM for executive team, must be PDF format"

### Assuming Extension Type Without Reasoning
❌ "Create an agent" (without explaining why agent is needed)
✓ Better: "Automatically format code across all my projects" (signals agent naturally)

## Extension Type Examples at a Glance

**→ Skill (Custom, Context-Heavy)**
- "Our unique sprint planning process..."
- "Custom business rules for our industry..."
- "Help me manage [project-specific workflow]..."

**→ Agent (Generic, Reusable, Auto-Invoke)**
- "Automatically format code when I save..."
- "Run tests whenever I make changes..."
- "Generate commit messages from diffs..."

**→ Suite (Multiple Roles, Coordinated)**
- "First plan, then build frontend and backend, then test, then review..."
- "Coordinated security audit: scan → analyze → report..."
- "Development pipeline with multiple specialists..."

**→ Hybrid (Custom Orchestration + Generic Automation)**
- "Manage our custom workflow and automatically format/test/document..."
- "Orchestrate our release process with standard quality checks..."
- "Project coordinator that delegates to reusable specialists..."

## The Best Prompt

The best prompt is honest and conversational:

```
/forge

Here's my situation: [describe your context]
Here's my problem: [what you're trying to solve]
Here's what I've tried: [current approach if any]
Here's what I need: [ideal outcome]
Here are my constraints: [limitations if any]
```

**Eitri 2.0 will:**
1. Analyze your needs across multiple dimensions
2. Determine the optimal extension type (skill/agent/suite/hybrid)
3. Show you transparent reasoning with confidence score
4. Create exactly what you need with full validation

Remember: I'm not just generating from templates - I'm understanding your unique situation and creating something specifically for you. Whether that's a skill, agent, suite, or hybrid doesn't matter - what matters is that it solves your problem perfectly. The more context you provide, the better the result!