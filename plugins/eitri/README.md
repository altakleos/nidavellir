# ⚒️ Eitri

> **Stop writing prompts. Start forging extensions.**

Eitri is an intelligent Claude Code extension forge that creates precisely optimized skills, agents, and automation through natural conversation.

Named after the legendary Norse dwarf smith who forged Thor's hammer Mjolnir.

---

## ⚡ Quick Start

**Install:**
```bash
/plugin install eitri@altakleos
```

**Create your first extension:**
```
/forge
```

That's it. Describe what you need, and Eitri handles the rest.

---

## 🎯 What You Can Create

| Type | What It Does | Example Use Case |
|------|--------------|------------------|
| **Skills** | Context-aware workflows | Custom sprint planning for your team |
| **Agents** | Auto-invoking automations | Format code on every save |
| **Agent Suites** | Coordinated pipelines | Plan → Build → Test → Review |
| **Hybrids** | Orchestrated specialists | Project manager + auto-formatters |
| **Hooks** | Event-driven triggers | Validate before every commit |
| **MCP Servers** | External integrations | Query your production database |

---

## 🧠 How Eitri Thinks

Just describe what you need. Eitri detects patterns:

| You Say | Eitri Creates |
|---------|---------------|
| "Automatically format when..." | Agent |
| "Our custom workflow..." | Skill |
| "Plan, then build, then test..." | Agent Suite |
| "Before every edit..." | Hook |
| "Connect to our database..." | MCP Server |

Don't worry about choosing—Eitri recommends, you approve.

---

## 📦 Commands

| Command | Purpose |
|---------|---------|
| `/forge` | Create any extension type |
| `/forge:template` | Start from pre-built templates |
| `/forge:validate` | Check specification compliance |
| `/forge:test` | Sandbox testing before deployment |
| `/forge:feedback` | Report issues for improvement |
| `/forge:improve` | Apply feedback to optimize prompts |
| `/forge:diagram` | Visualize architecture |

<details>
<summary>More commands...</summary>

| Command | Purpose |
|---------|---------|
| `/forge:install` | Install to Claude Code |
| `/forge:upgrade` | Add features to existing |
| `/forge:browse` | Discover local templates |
| `/forge:publish` | Publish to marketplaces |
| `/forge:export` | Export to Agent Skills standard |

</details>

---

## 🏢 Industry-Aware

Eitri adapts to your domain:

- **Healthcare** → HIPAA compliance, audit trails, PHI protection
- **Finance** → SOX compliance, precision calculations
- **E-commerce** → Inventory, payments, customer data
- **DevOps** → CI/CD pipelines, infrastructure automation
- **Education** → FERPA considerations, student data

---

## 🔧 Troubleshooting

<details>
<summary>Agent not auto-invoking?</summary>

- Check description clarity: "when X" should be explicit
- Verify trigger condition is met
- Check agent naming (no conflicts)

</details>

<details>
<summary>Quality agent safety warnings?</summary>

Quality agents (test, review, validation) MUST run sequentially.
This is enforced for system stability.

</details>

<details>
<summary>Suite coordination issues?</summary>

- Check phase configuration
- Verify max_concurrent settings
- Ensure quality agents are sequential

</details>

---

## 📚 Documentation

For detailed command documentation, see the `commands/` directory.

- [sample_prompt.md](sample_prompt.md) — Copy-paste example prompts

---

**Version:** 1.9.0 | **License:** MIT | **Author:** [AltaKleos](mailto:hello@altakleos.com)
