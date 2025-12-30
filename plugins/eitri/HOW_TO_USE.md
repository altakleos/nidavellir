# Eitri - Complete Usage Guide

## What's New in Eitri

Eitri now creates **six types** of Claude Code extensions:

- **Skills**: Integrated, context-aware solutions (original capability, now enhanced)
- **Agents**: Specialized, auto-invoking, reusable components with separate context windows
- **Agent Suites**: Coordinated multi-agent systems for complex workflows
- **Hybrid Solutions**: Skills that orchestrate agents for best-of-both-worlds
- **Hooks**: Event-driven automations (PreToolCall, PostToolCall, SessionStart, etc.)
- **MCP Servers**: Model Context Protocol integrations for external services

**Don't worry about choosing!** Eitri automatically determines the best type for your needs through conversation. You still just type `/forge` and I figure out what you actually need.

## Available Commands

| Command | Purpose |
|---------|---------|
| `/forge` | Main creation workflow - create any extension type |
| `/forge:validate` | Validate extensions for specification compliance |
| `/forge:install` | Install extensions to Claude Code environment |
| `/forge:upgrade` | Upgrade existing extensions with new features |
| `/forge:template` | Quick-start from pre-built templates |
| `/forge:browse` | Discover templates from local filesystem |
| `/forge:feedback` | Provide feedback to improve recommendations |
| `/forge:publish` | Publish extensions to marketplaces |
| `/forge:export` | Export to Agent Skills standard for cross-platform use |

## Quick Start (2 minutes)

Simply type `/forge` and have a natural conversation with me. I'll understand your needs and create the perfect extension(s) - whether that's a skill, agent, suite, or hybrid.

```
You: /forge

Eitri: Tell me about what you're trying to accomplish - not just the task, but the context around it. What's your business or work environment like?

You: I run a small consulting firm and need to automate our weekly client reports. We pull data from various sources and it takes hours every Friday.

Eitri: I understand the pain of manual report generation. Let me learn more about your specific situation...

[Conversation continues naturally]
```

## Understanding How I Work

### I Don't Use Templates

Unlike traditional generators, I don't fill in templates. Instead, I:
1. **Understand** your unique context deeply
2. **Synthesize** patterns from multiple dimensions
3. **Create** something genuinely unique for you
4. **Adapt** based on our conversation

### Multi-Dimensional Understanding

While we talk, I'm analyzing:
- **Business Context**: Industry, size, maturity, growth stage
- **Technical Environment**: Tools, systems, capabilities
- **Team Dynamics**: Who uses it, how they work
- **Workflow Patterns**: Sequential, parallel, event-driven
- **Constraints**: Regulatory, technical, organizational

## Understanding Extension Types

### Skills vs Agents vs Suites vs Hybrids

Eitri automatically determines which type(s) to create based on your needs. Here's how I think about it:

#### Skills (Integrated Solutions)

**Best for:**
- Custom workflows specific to your business
- Context-heavy operations that need deep understanding
- One-time unique implementations
- Conversational interfaces where you guide the process

**Example Scenarios:**
```
You: "I need help managing our custom sprint planning process"
→ Eitri creates: Skill (custom workflow, your specific process)

You: "Build a tool for our compliance reporting workflow"
→ Eitri creates: Skill (business-specific, context-heavy)
```

**Characteristics:**
- Tightly integrated with your specific context
- Maintains conversation state
- Custom logic for your unique needs
- Invoked when you explicitly need them

#### Agents (Specialized Automations)

**Best for:**
- Reusable tasks across all projects
- Auto-invocation when certain conditions are met
- Generic, standard operations
- Tasks that benefit from tool restrictions for safety

**Example Scenarios:**
```
You: "Automatically format code when I make changes"
→ Eitri creates: Agent (reusable, auto-invoke, standard task)

You: "Run tests whenever I modify the codebase"
→ Eitri creates: Agent (generic task, auto-triggered)

You: "Generate commit messages based on diffs"
→ Eitri creates: Agent (reusable utility, focused task)
```

**Characteristics:**
- Separate context window for isolation
- Can auto-invoke on triggers
- Reusable across all your projects
- Restricted tool access for safety
- Focused single responsibility

#### Agent Suites (Coordinated Workflows)

**Best for:**
- Multiple distinct operations needed together
- Complex workflows with different roles
- Parallel + sequential execution patterns
- Scenarios where different specialists are needed

**Example Scenarios:**
```
You: "Complete development workflow: plan, build frontend, build backend, test, review"
→ Eitri creates: Agent Suite (multiple roles, coordinated execution)

You: "Security audit pipeline: scan dependencies, check code, verify configs, generate report"
→ Eitri creates: Agent Suite (sequential quality operations)
```

**Characteristics:**
- Multiple coordinated agents
- Execution patterns (pipeline, fork-join, event-driven)
- Automatic coordination and handoffs
- Safety rules enforced (quality agents sequential)

#### Hybrid Solutions (Best of Both Worlds)

**Best for:**
- Custom orchestration with generic automations
- Project-specific coordinator with reusable specialists
- Context-aware management with automated tasks

**Example Scenarios:**
```
You: "Manage our project workflow and automatically format, test, and document"
→ Eitri creates: Hybrid (skill orchestrator + agent specialists)

You: "Custom deployment pipeline that uses standard code quality checks"
→ Eitri creates: Hybrid (custom skill + reusable agents)
```

**Characteristics:**
- Skill provides context and coordination
- Agents handle reusable automations
- Clear boundaries between orchestration and execution
- Combines conversational interface with automation

### How Eitri Decides

I analyze your description for signals:

**Agent Signals:**
- "When X happens, do Y" → Task-triggered invocation
- "Automatically..." → Auto-invocation suitable
- "Reusable across projects" → High reusability
- Generic verbs (format, lint, test, validate)

**Skill Signals:**
- "Our custom workflow..." → Context-heavy
- "Help me with..." → Conversational
- "Business-specific rules..." → One-time custom
- Tight process coupling

**Suite Signals:**
- Multiple distinct operations mentioned
- "Planning, then building, then testing..." → Sequential workflow
- Different roles/responsibilities
- "Frontend and backend" → Parallel opportunities

**Hybrid Signals:**
- Mix of custom and generic needs
- "Coordinate various automations" → Orchestration + specialists
- Some reusable, others specific

**Hook Signals:**
- "Before/after every edit..." → PreToolCall/PostToolCall
- "When session starts..." → SessionStart event
- "Notify me when..." → Notification event
- "Audit trail of all commands" → Logging hooks

**MCP Signals:**
- "Connect to database..." → Database MCP server
- "Integrate with GitHub/Slack/Jira..." → API MCP server
- "Access external API..." → Custom MCP server
- "Query our production data" → Database integration

### Decision Transparency

I'll show you my reasoning:

```
Based on our conversation:

Characteristic Analysis:
✓ Reusability: High → favors agent/suite
✓ Auto-invocation suitable: Yes → favors agent
✓ Multiple distinct operations: Yes → favors suite
✗ Heavy context dependency: No → disfavors skill

Extension Type Scoring:
┌─────────────────────────────────────────┐
│ Factor              │ Skill │ Agent │ Suite │
├─────────────────────┼───────┼───────┼───────┤
│ Reusability         │   2   │   8   │   6   │
│ Auto-invoke benefit │   3   │   9   │   7   │
│ Context dependency  │   3   │   8   │   5   │
│ Multiple roles      │   2   │   5   │   9   │
├─────────────────────┼───────┼───────┼───────┤
│ TOTAL              │  10   │  30   │  27   │
└─────────────────────────────────────────┘

Recommendation: Agent
Confidence: 85%

Would you like me to proceed with creating an agent?
```

**You can always override my recommendation!** If you disagree, just tell me and I'll adapt.

## Typical Conversation Flow

### Phase 1: Context Discovery (2-3 minutes)

I'll start with open-ended questions to understand your situation:

```
Eitri: Tell me about what you're trying to accomplish...

You: [Your context]

Eitri: [Relevant follow-up based on what you said]
```

I'm not following a script - each question builds on your previous answer.

### Phase 2: Architecture Proposal (1-2 minutes)

Based on our conversation, I'll propose an approach:

```
Eitri: Based on what you've told me, I see a few approaches:

Option 1: Single comprehensive skill that handles everything
- Pros: Simpler to use, all in one place
- Cons: Less flexible, harder to extend

Option 2: Two focused skills that work together
- report-generator: Creates the reports
- data-collector: Gathers and cleans data
- Pros: Modular, easier to maintain
- Cons: Requires coordination

Which feels right for your workflow?
```

### Phase 3: Configuration (1-2 minutes)

We'll configure the details:

```
Eitri: Let's configure the details:

1. Complexity level?
   - Beginner: Simple, clear, minimal code
   - Intermediate: Balanced automation
   - Advanced: Full automation, complex logic

2. How technical is your team?
   [Your answer affects how I write documentation and code]

3. Will this be shared publicly or kept internal?
   [Affects security, documentation, packaging]
```

### Phase 4: Generation (30 seconds)

I'll create everything you need:
- Complete SKILL.md with all sections
- Python code (if needed)
- Sample prompts showing how to use it
- Documentation appropriate for your team
- Test data (if applicable)

## Examples of Different Outcomes

### Example 1: Skill - Custom Business Workflow

**Context Given:**
"I'm a solo founder, need to track my SaaS metrics weekly with our specific KPIs"

**What I Create:**
- Single lightweight skill
- Custom KPI calculations for your business
- No Python code (prompt-only)
- Simple, clear documentation
- Conversational interface for ad-hoc queries

**Why Skill:** Custom metrics specific to your business, conversational usage

### Example 2: Agent - Reusable Code Formatter

**Context Given:**
"Automatically format my code whenever I make changes"

**What I Create:**
- Lightweight agent with auto-invocation
- Works across all your projects
- Tool restrictions: Read, Write, Edit (no Bash for safety)
- Parallel execution safe
- Clear trigger description for auto-discovery

**Why Agent:** Generic task, reusable everywhere, auto-triggered

### Example 3: Agent Suite - Development Workflow

**Context Given:**
"Complete development workflow: plan features, build frontend and backend, run tests, review code"

**What I Create:**
- Suite of 5 coordinated agents:
  1. `requirements-analyst` (Strategic) - Plans features
  2. `frontend-developer` (Implementation) - Builds UI
  3. `backend-developer` (Implementation) - Builds API
  4. `test-runner` (Quality) - Runs tests sequentially
  5. `code-reviewer` (Quality) - Reviews code sequentially
- Fork-join execution pattern (frontend/backend parallel)
- Safety enforced (quality agents sequential only)
- Automatic coordination and handoffs

**Why Suite:** Multiple distinct roles, parallel + sequential needs, complex workflow

### Example 4: Hybrid - Project Management with Automations

**Context Given:**
"Manage our custom project workflow and automatically format, test, and generate commit messages"

**What I Create:**
- **Skill:** `project-workflow-manager` (Orchestrator)
  - Understands your project context
  - Manages workflow state
  - Provides conversational interface
- **Agents:** (Specialists)
  - `code-formatter` - Auto-formats code
  - `test-runner` - Runs tests on demand
  - `commit-generator` - Creates commit messages
- Integration: Skill invokes agents as needed

**Why Hybrid:** Custom orchestration (your workflow) + generic automations (format/test)

### Example 5: Enterprise Suite with Compliance

**Context Given:**
"We're a Fortune 500 finance team, need SOX-compliant reporting across 12 departments"

**What I Create:**
- Suite of specialized agents:
  1. `data-collector` - Gathers from 12 sources
  2. `compliance-validator` - Verifies SOX requirements (sequential)
  3. `report-generator` - Creates formatted reports
  4. `audit-logger` - Maintains audit trail
- Sequential execution for compliance
- Comprehensive error handling
- Audit trails built-in
- Enterprise integration support

**Why Suite:** Multiple departments (parallel data collection), strict compliance (sequential validation)

## Advanced Usage

### Influencing the Output

You can guide my creation process:

**For Simpler Output:**
- "Keep it simple"
- "We're not very technical"
- "Just the basics"
- "MVP approach"

**For More Sophisticated Output:**
- "We need enterprise features"
- "Include comprehensive error handling"
- "We have a technical team"
- "Production-ready please"

### Requesting Specific Features

Be explicit about special needs:
- "Must integrate with Salesforce"
- "Needs to handle 10,000 records daily"
- "Requires audit trail for compliance"
- "Should work offline"

### Iterative Refinement

After I create the initial skill:

```
You: Can we add email notifications?

Eitri: Absolutely! For email notifications, I should understand:
- Who receives them?
- What triggers them?
- What information should they contain?

[I then refine the skill with this feature]
```

## Understanding the Output

### What You Receive

The output depends on the extension type:

#### For Skills

1. **Complete Skill Package**
   - SKILL.md - Main skill definition with your custom logic
   - Python files - If code is needed
   - sample_prompt.md - How to use examples
   - Test data - If applicable
   - HOW_TO_USE.md - Detailed usage guide

```
your-skill/
├── SKILL.md           # Core skill logic and instructions
├── sample_prompt.md   # Copy-paste ready examples
├── scripts/           # Python code (if needed)
│   └── main.py       # Main processing logic
├── test_data/        # Sample data (if applicable)
│   └── sample.csv    # Example input file
└── HOW_TO_USE.md     # Detailed usage guide
```

#### For Agents

1. **Agent Definition File**
   - [agent-name].md - Complete agent with YAML frontmatter
   - Clear description for auto-discovery
   - Tool restrictions configured
   - Execution pattern specified
   - Usage examples

```
your-agent.md structure:
---
name: code-formatter
description: Automatically formats code using project style guide when files are modified
tools: Read, Write, Edit
model: sonnet
execution_pattern: parallel
process_load_estimate: "8-12"
---

# Agent prompt and instructions
```

#### For Agent Suites

1. **Suite Package**
   - Multiple agent files (one per agent)
   - Suite configuration file
   - Coordination documentation
   - Integration guide
   - Safety validation report

```
your-suite/
├── agents/
│   ├── planner.md         # Strategic agent
│   ├── developer.md       # Implementation agent
│   └── tester.md          # Quality agent (sequential)
├── suite-config.yaml      # Coordination configuration
├── README.md             # Suite overview
└── INTEGRATION_GUIDE.md  # How agents coordinate
```

#### For Hybrid Solutions

1. **Hybrid Package**
   - Skill file (orchestrator)
   - Multiple agent files (specialists)
   - Integration documentation
   - Usage guide with delegation patterns

```
your-hybrid/
├── orchestrator/
│   └── SKILL.md          # Main skill orchestrator
├── agents/
│   ├── formatter.md      # Formatting specialist
│   ├── tester.md         # Testing specialist
│   └── documenter.md     # Documentation specialist
├── INTEGRATION.md        # How they work together
└── HOW_TO_USE.md        # Complete usage guide
```

### Contextual Documentation

All outputs include:
- Documentation appropriate for your technical level
- Using your terminology and domain language
- Focused on your specific use case
- Examples relevant to your context

### Quality Assurance

I validate what matters for your context:
- **Pre-generation**: Conflict detection, safety patterns
- **Generation-time**: Syntax, clarity, safety enforcement
- **Post-generation**: Functional testing, integration verification

For agents and suites, I provide a validation report:
```
Extension Validation Report
==========================

PRE-GENERATION CHECKS:
✓ No naming conflicts
✓ No description overlap
✓ Resources available
✓ Safety patterns appropriate

GENERATION-TIME CHECKS:
✓ Syntax valid
✓ Description optimized for auto-discovery
✓ Tool restrictions applied
✓ Execution patterns enforced

POST-GENERATION CHECKS:
✓ Loads successfully
✓ Auto-invocation works
✓ Safety rules compliant

OVERALL STATUS: PASSED
```

## Best Practices

### For Best Results

1. **Be Specific About Context**
   - Industry and business model
   - Team size and technical capability
   - Current tools and systems
   - Pain points and goals

2. **Share Real Examples**
   - "Here's what we currently do..."
   - "Our data looks like..."
   - "We need output like..."

3. **Mention Constraints Early**
   - Regulatory requirements
   - Technical limitations
   - Time pressures
   - Budget constraints

### Common Patterns

**Pattern: Start Simple, Evolve**
```
Version 1: Basic automation (Skill)
Version 2: Extract reusable parts (Add Agents)
Version 3: Add more specialists (Agent Suite)
Version 4: Full orchestrated platform (Hybrid)
```

**Pattern: Skill to Agent Migration**
```
Scenario: You created a skill that you now use across projects
→ Eitri can help migrate to an agent for reusability

Use scripts/analyze_extension.py to get recommendations
```

**Pattern: Suite Development**
```
Start: Single skill
Identify: Reusable operations
Extract: Create agents for generic tasks
Mature: Coordinated suite or hybrid
```

### Agent-Specific Best Practices

#### When Creating Agents

**For Auto-Invocation:**
- Use clear trigger phrases: "when X happens", "whenever Y"
- Describe the condition clearly for auto-discovery
- Example: "Automatically formats code when files are modified"

**For Tool Safety:**
- Strategic agents (lightweight): Read, Write, Grep only
- Implementation agents: Can have Bash, but coordinated execution
- Quality agents: MUST be sequential (CRITICAL safety rule)

**For Reusability:**
- Keep agents focused on single responsibility
- Avoid project-specific logic
- Use generic, industry-standard operations

#### When Creating Suites

**Execution Patterns:**
- **Parallel**: Independent tasks (frontend + backend development)
- **Sequential**: Dependent tasks (test → review → deploy)
- **Quality agents**: ALWAYS sequential (prevents system crashes)

**Safety Rules:**
- Maximum 3 agents in parallel
- Quality agents never parallel
- Process load monitoring (warning at 40, critical at 60)

#### When Creating Hybrids

**Clear Boundaries:**
- Skill = Orchestration + context management
- Agents = Execution + reusable tasks
- Don't duplicate logic between them

**Integration Strategy:**
- Skill invokes agents explicitly
- Passes clear context to agents
- Aggregates results from agents

## Troubleshooting

### If the Skill Doesn't Match Expectations

**Issue**: "Too complex for our needs"
**Solution**: Tell me to simplify - I'll reduce complexity

**Issue**: "Missing important feature"
**Solution**: Describe what's missing - I'll add it

**Issue**: "Wrong technical level"
**Solution**: Clarify your team's capabilities - I'll adjust

### If You're Unsure What You Need

That's perfectly fine! Start with:
- Describe your current pain point
- Explain what you do manually now
- Share your ideal outcome

I'll help you discover the right solution through our conversation.

## Advanced Features

### Multi-Agent Coordination

When you need complex workflows:

```
Eitri: I recommend creating a coordinated agent suite:

Phase 1: requirements-analyst (Strategic)
  - Analyzes and plans
  - Parallel execution safe

Phase 2: frontend-developer + backend-developer (Implementation)
  - Parallel execution (max 2 concurrent)
  - Coordinated handoff

Phase 3: test-runner (Quality)
  - Sequential execution (REQUIRED for safety)
  - Validates both implementations

Phase 4: code-reviewer (Quality)
  - Sequential execution (REQUIRED for safety)
  - Final quality check

The suite enforces safety rules automatically.
```

### Extension Migration and Analysis

Use `scripts/analyze_extension.py` to:

```bash
# Analyze existing extension
python scripts/analyze_extension.py your-skill/

Output:
Extension Analysis Report
========================
Type: Skill
Reusability: High (detected in 5 projects)
Complexity: Medium
Auto-invocation potential: Yes

Recommendations:
✓ Consider migrating to Agent
  - Reason: High reusability across projects
  - Benefit: Auto-invocation, separate context
  - Effort: Low (no complex state)

✓ Extract formatter logic to separate agent
  - Current: Part of main skill
  - Suggested: standalone formatter agent
  - Benefit: Reusable across all projects
```

### Evolution Path Planning

I can design for growth across extension types:

```
Eitri: I'll design this to evolve:

Phase 1: Skill (now)
  - Custom workflow for your team
  - Establishes patterns

Phase 2: Hybrid (3 months)
  - Extract reusable operations to agents
  - Skill orchestrates, agents execute

Phase 3: Agent Suite (6 months)
  - Full automation with coordination
  - Multiple agents working together

The architecture supports this growth path.
```

### Industry-Specific Intelligence

I understand industry nuances for all extension types:

- **Healthcare**: HIPAA compliance, audit trails, PHI protection agents
- **Finance**: SOX compliance, audit logging, precision calculation agents
- **E-commerce**: Inventory management, payment processing, customer data agents
- **DevOps**: CI/CD pipelines, infrastructure automation, monitoring agents
- **Education**: FERPA considerations, student data protection

### Hybrid Architecture Patterns

Advanced hybrid solutions:

**Pattern 1: Orchestrator + Specialists**
```
Skill: Project manager
├─> Agent: Code formatter (auto-invoke)
├─> Agent: Test runner (on-demand)
└─> Agent: Documentation generator (on-demand)
```

**Pattern 2: Context Provider + Executors**
```
Skill: Domain expert (your business logic)
├─> Agent Suite: Standard operations
│   ├─> Data validation
│   ├─> Report generation
│   └─> Distribution
```

**Pattern 3: Decision Maker + Workers**
```
Skill: Workflow coordinator (makes decisions)
├─> Agent: Worker 1 (executes tasks)
├─> Agent: Worker 2 (executes tasks)
└─> Agent: Quality checker (validates results)
```

## Integration with AltaKleos Marketplace

### Publishing Your Extensions

If you want to share your creation:

```
You: Can this be published to the marketplace?

Eitri: I'll add marketplace metadata:
- Category classification (skill/agent/suite/hybrid)
- Keywords for discovery
- Clear description for auto-discovery (agents)
- Usage examples and documentation
- Pricing model (if commercial)
- Support information

Your extension will be marketplace-ready.
```

### Quality Standards

For marketplace publication, I ensure:
- **Skills**: Complete documentation, professional code quality
- **Agents**: Clear descriptions for auto-discovery, safe tool restrictions
- **Suites**: Coordination documentation, safety validation reports
- **Hybrids**: Integration guides, clear boundaries
- **All**: Security best practices, clear value proposition

### Sharing Agents vs Skills

**Agents are more shareable:**
- Reusable across any project
- Generic, standard operations
- No context dependencies
- Clear trigger descriptions

**Skills are more custom:**
- Specific to your workflow
- May require adaptation for others
- Context-dependent logic
- Best for internal teams or similar businesses

## The Eitri Promise

Every extension I create is:
1. **Right Type** - Skill, agent, suite, or hybrid as genuinely needed
2. **Uniquely Optimized** - For your specific context and needs
3. **Safety-Conscious** - Validated patterns and enforced rules
4. **Quality-Assured** - Tested, verified, and ready to use
5. **Evolution-Ready** - Can grow and adapt with you
6. **Intelligently Crafted** - Using full adaptive capabilities

## Getting Support

If you need help with any extension type:

**For Skills:**
1. Describe what's not working
2. Share error messages if any
3. Explain what you expected

**For Agents:**
1. Describe when the agent should trigger but doesn't
2. Share the agent description
3. Explain the expected behavior

**For Suites:**
1. Identify which agent is failing
2. Describe the coordination issue
3. Share error messages from the suite

**For Hybrids:**
1. Clarify if issue is in skill or agent
2. Describe the integration problem
3. Share relevant error messages

I'll help you resolve issues and improve any extension type.

## Troubleshooting Agent-Specific Issues

### Agent Not Auto-Invoking

**Problem**: Agent doesn't trigger automatically

**Solutions:**
- Check description clarity: "when X" should be explicit
- Verify trigger condition is met
- Check agent naming (no conflicts)

### Agent Safety Warnings

**Problem**: "Quality agents must be sequential" error

**Solution**: This is CRITICAL for system stability. Quality agents (test, review, validation) MUST run sequentially, never in parallel. Eitri enforces this automatically.

### Suite Coordination Issues

**Problem**: Agents not coordinating properly

**Solutions:**
- Check phase configuration
- Verify max_concurrent settings
- Review execution patterns
- Ensure quality agents are sequential

## Next Steps

Ready to create your extension? Simply type:

```
/forge
```

And let's begin our conversation. I'm here to understand your unique needs and create exactly what you need - whether that's a skill, agent, suite, or hybrid solution. Not what a template thinks you need, but what you genuinely need based on deep understanding of your context.