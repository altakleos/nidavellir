# Data Source Awareness - Implementation Plan

## Executive Summary

Add **contextual source awareness** to Eitri's discovery engine. Rather than a separate Phase 0.5 that asks users to enumerate sources upfront, integrate source detection into the natural conversation flow.

**Core Principle:** Eitri detects when sources would help and offers to check them. Users remain in control. No form-filling.

---

## Problem Statement

Generated extensions sometimes ask users questions when the answers exist in:
- Local files (README, config, docs)
- Connected MCPs (databases, APIs)
- Project structure

**Goal:** Reduce unnecessary questions by hydrating context from available sources.

**Constraint:** Do not sacrifice Eitri's conversational UX or shift cognitive load onto users.

---

## Approach: Contextual Source Offers

### Instead of This (Rejected)
```
/forge
→ Phase 0.5: "Where should I look for context?"
→ User enumerates sources
→ Continue
```

### Do This (Approved)
```
/forge
→ Natural conversation begins
→ Eitri detects source indicators in user's description
→ Eitri offers: "Should I check [specific source] for that?"
→ User approves or declines
→ If approved: Eitri reads source, enriches context
→ Continue conversation with richer understanding
```

---

## Key Design Decisions

### 1. Source Detection, Not Source Enumeration

Eitri detects sources from conversation signals:

| Signal | Detected Source | Offer |
|--------|-----------------|-------|
| "our database schema" | MCP postgres | "Should I query your schema?" |
| "existing patterns" | Local codebase | "Should I scan your src/?" |
| "team conventions" | Local docs | "Should I check your docs/?" |
| "GitHub issues" | MCP github | "Should I look at open issues?" |

### 2. User Controls Access

Every source access requires user approval:
- "Yes, check that"
- "No, I'll describe it"
- "Check X but not Y"

This addresses the adversarial concern about false confidence.

### 3. Graceful Degradation

If source access fails:
- Don't block generation
- Fall back to asking the user
- Log for future improvement

### 4. Optional for All Users

- Experts can decline all source checks
- Novices get guidance on what sources exist
- No mandatory steps added

---

## Implementation Phases

### Phase 1: Source Detection in Discovery Engine (Week 1-2)

**File:** `core/discovery-engine.md`

Add source signal detection to existing discovery:

```markdown
### Source Signal Detection

During conversation, detect indicators that sources would help:

**Local File Indicators:**
- "our existing [code|patterns|conventions]"
- "based on current [implementation|structure]"
- "similar to what we have"
- References to specific file types (.env, config, schema)

**MCP Indicators:**
- "database schema"
- "GitHub [issues|PRs|repo]"
- "Notion [docs|pages]"
- "Slack [channels|messages]"

**When detected:** Add to `discovery_context.potential_sources[]`
```

**Deliverables:**
- [ ] Source signal detection patterns
- [ ] `potential_sources` array in discovery context
- [ ] No changes to discovery flow yet

---

### Phase 2: Source Offer Mechanism (Week 2-3)

**File:** `core/discovery-engine.md` (continued)

Add targeted source offers:

```markdown
### Targeted Source Offers

When `potential_sources` is non-empty, offer specific checks:

**Pattern:**
"I notice you mentioned [indicator]. Would you like me to:
1. Check your [specific source] for [specific info]
2. Have you describe it instead

This helps me understand [what it helps with]."

**Rules:**
- Maximum 2 source offers per conversation
- Only offer sources that are likely accessible
- Accept "no" gracefully and continue
- Don't offer again for same source type
```

**Deliverables:**
- [ ] Source offer templates
- [ ] Offer limit enforcement
- [ ] User response handling

---

### Phase 3: Source Hydration Logic (Week 3-4)

**New File:** `core/source-hydrator.md`

Create lightweight source reading capability:

```markdown
# Source Hydrator

## Purpose
Read from approved sources and add to discovery context.

## Supported Source Types

### Local Files
- Read via Glob + Read tools
- Respect max line limits (500 lines default)
- Focus on relevant sections

### MCP Sources
- Check if MCP tool available
- Execute simple queries
- Handle timeouts gracefully (10s default)

### Direct Questions (Fallback)
- When source unavailable
- When user declines source access
- Natural conversation continues

## Error Handling

**Source unavailable:**
"I couldn't access [source]. Let me ask you directly instead:
[targeted question about the information we needed]"

**Source incomplete:**
"I found [what we found], but I'm not seeing [what's missing].
Could you tell me about [specific gap]?"
```

**Deliverables:**
- [ ] Local file reading with limits
- [ ] MCP query execution
- [ ] Fallback to questions
- [ ] Timeout handling

---

### Phase 4: Generator Integration (Week 4-5)

**Files:** All generators

Pass hydrated context to generators:

```markdown
### Discovery Context with Sources

Generators receive enriched context:

discovery_context:
  # Existing fields...
  hydrated_sources:
    - source_id: "local_schema"
      type: "local_file"
      content: "[truncated content]"
      confidence: 0.8
    - source_id: "database_schema"
      type: "mcp"
      content: "[query result]"
      confidence: 0.9
  source_gaps:
    - "deployment process" # User declined, needs question
```

**Generator behavior:**
- Use hydrated sources to inform generation
- Ask targeted questions for `source_gaps`
- Don't ask questions for hydrated information
- Document what sources informed the extension

**Deliverables:**
- [ ] Context schema update
- [ ] Generator consumption of hydrated sources
- [ ] Gap-based questioning in generated extensions

---

### Phase 5: Validation & Testing (Week 5-6)

**File:** `core/validation-framework.md`

Add source-related validation:

```markdown
### Source Hydration Validation

**Pre-generation:**
- Verify hydrated sources are actually used
- Check for stale source references
- Validate MCP availability if referenced

**Post-generation:**
- Verify generated extension doesn't ask for hydrated info
- Check source references are accurate
- Validate fallback behavior documented
```

**Test Scenarios:**
1. User approves source → info used correctly
2. User declines source → falls back to questions
3. Source unavailable → graceful degradation
4. Source partial → targeted follow-up questions
5. Multiple sources → correct prioritization

**Deliverables:**
- [ ] Validation rules
- [ ] Test scenarios
- [ ] Example extensions with source awareness

---

## Files to Modify

| File | Change | Priority |
|------|--------|----------|
| `core/discovery-engine.md` | Add source detection + offers | High |
| `core/source-hydrator.md` | New file - hydration logic | High |
| `generators/agent-generator.md` | Consume hydrated context | Medium |
| `generators/skill-generator.md` | Consume hydrated context | Medium |
| `generators/suite-coordinator.md` | Consume hydrated context | Medium |
| `core/validation-framework.md` | Add source validation | Medium |
| `SKILL.md` | Document capability | Low |

---

## Files NOT to Modify

| File | Reason |
|------|--------|
| `core/decision-framework.md` | Source complexity scoring rejected (arbitrary) |
| Main generation phases | Keep existing flow intact |
| User-facing commands | No new commands needed |

---

## What This Approach Avoids

Based on adversarial review:

| Risk | How Avoided |
|------|-------------|
| Users don't know what matters | Eitri detects, doesn't ask to enumerate |
| Cognitive load shift | Users approve/decline, don't specify |
| False confidence | Sources supplement, don't replace discovery |
| Form-filling UX | Remains conversational |
| MCP complexity | Graceful fallback to questions |
| Expert friction | Can decline all source offers |
| Scope creep | Limited to detection + offer pattern |

---

## Success Criteria

1. **Fewer redundant questions:** Extensions ask 30-50% fewer questions about information available in sources
2. **No UX regression:** Time to first meaningful interaction unchanged
3. **Graceful failures:** 100% of source failures fall back cleanly to questions
4. **User control:** Users can decline any/all source access
5. **Expert approval:** Power users don't feel slowed down

---

## Out of Scope (Explicit)

These are NOT part of this feature:

- [ ] Automatic source discovery without user approval
- [ ] Source caching across sessions
- [ ] Source priority/weighting configuration
- [ ] Mandatory source specification
- [ ] New slash commands for source management
- [ ] Source configuration persistence
- [ ] Breaking changes to existing extensions

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Feature creep | Strict scope defined above |
| Overcomplication | Start with local files only, add MCP later |
| User confusion | Clear, specific offers (not vague) |
| Performance | Async source reading, timeouts |
| Breaking existing | Additive only, no required changes |

---

## Decision Points for Review

Before implementation, confirm:

1. **Offer frequency:** Max 2 source offers per conversation? Or dynamic?
2. **MCP scope:** Include in Phase 1 or defer to Phase 2?
3. **Default behavior:** Offer sources by default or only when high-confidence signals?
4. **Persistence:** Remember user preferences across sessions? (Currently: No)

---

## Summary

This plan transforms "Data Source Awareness" from a form-based Phase 0.5 into a conversational enhancement. Eitri detects when sources would help, offers to check them, respects user decisions, and gracefully handles failures.

The approach:
- Preserves Eitri's conversational UX
- Keeps users in control
- Reduces unnecessary questions
- Adds no mandatory steps
- Degrades gracefully

**Next step:** Review this plan and confirm decision points before implementation.
