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

Add source signal detection to existing discovery (both local files AND MCPs):

```markdown
### Source Signal Detection

During conversation, detect indicators that sources would help:

**Local File Indicators:** (confidence modifiers)
- "our existing [code|patterns|conventions]" → +0.3
- "based on current [implementation|structure]" → +0.3
- "similar to what we have" → +0.2
- References to specific file types (.env, config, schema) → +0.4
- Explicit: "check my files" → +0.5

**MCP Indicators:** (confidence modifiers)
- "database schema" → +0.4
- "GitHub [issues|PRs|repo]" → +0.4
- "Notion [docs|pages]" → +0.3
- "Slack [channels|messages]" → +0.3
- Explicit: "query my database" → +0.5

**Base confidence:** 0.5 (requires modifiers to reach 0.75 threshold)

**When detected:** Add to `discovery_context.potential_sources[]` with:
- source_type: local_file | mcp
- detected_signal: the phrase that triggered detection
- confidence: calculated confidence score
- mcp_tool: (if MCP) the specific tool needed (mcp__postgres, mcp__github, etc.)
```

**Deliverables:**
- [ ] Source signal detection patterns (local + MCP)
- [ ] Confidence scoring algorithm
- [ ] `potential_sources` array in discovery context
- [ ] MCP availability check (is the tool configured?)

---

### Phase 2: Source Offer Mechanism (Week 2-3)

**File:** `core/discovery-engine.md` (continued)

Add targeted source offers with diminishing frequency:

```markdown
### Targeted Source Offers

When `potential_sources` is non-empty and confidence >= threshold, offer specific checks:

**Offer Pattern:**
"I notice you mentioned [indicator]. Should I check your [specific source]
to understand [what it helps with], or would you prefer to describe it?"

**Diminishing Frequency Rules:**
- Offers 1-2: Threshold = 0.75 (standard high-confidence)
- Offers 3+: Threshold = 0.90 (only very explicit signals)
- Never exceed ~4 offers total per conversation

**Additional Rules:**
- Only offer if source is likely accessible (MCP configured, path exists)
- Accept "no" gracefully and continue
- Don't offer again for same source type
- If user says "stop offering" → disable for session

**MCP-Specific:**
- Before offering MCP source, verify tool is available
- If MCP not configured: Skip offer (don't ask user to set up MCP mid-flow)
```

**Deliverables:**
- [ ] Source offer templates (local + MCP variants)
- [ ] Diminishing threshold logic
- [ ] MCP availability pre-check
- [ ] User response handling ("yes", "no", "stop asking")

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
| MCP complexity | Graceful fallbacks, 10s timeouts, clear error messages |
| User confusion | Clear, specific offers (not vague) |
| Performance | Async source reading, timeouts |
| Breaking existing | Additive only, no required changes |

---

## Design Decisions (Confirmed)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Offer frequency** | Diminishing | First 2 offers freely, then only high-confidence (>0.75). Balances coverage with UX. |
| **MCP scope** | Included from Phase 1 | MCPs are where the real value is. Handle complexity with graceful fallbacks. |
| **Default behavior** | High-confidence only | Only offer when signal strength >0.75. Reduces noise, users can mention sources explicitly. |
| **Persistence** | None initially | Keep it simple. No state management in v1. Users repeat preferences per session. |

### Signal Confidence Thresholds

| Signal Type | Example | Confidence | Action |
|-------------|---------|------------|--------|
| Explicit mention | "check my database schema" | 0.95 | Always offer |
| Strong indicator | "our existing patterns" | 0.80 | Offer (within limit) |
| Weak indicator | "similar to before" | 0.50 | Don't offer |
| Ambiguous | "the usual way" | 0.30 | Don't offer |

### Offer Frequency Logic

```
offers_made = 0
confidence_threshold = 0.75

for signal in detected_signals:
    if offers_made < 2:
        # First 2 offers: use standard threshold
        if signal.confidence >= confidence_threshold:
            make_offer(signal)
            offers_made++
    else:
        # After 2 offers: only very high confidence
        if signal.confidence >= 0.90:
            make_offer(signal)
            offers_made++
```

---

## Summary

This plan transforms "Data Source Awareness" from a form-based Phase 0.5 into a conversational enhancement. Eitri detects when sources would help, offers to check them, respects user decisions, and gracefully handles failures.

**Confirmed Design:**
- Diminishing offer frequency (2 free, then high-confidence only)
- MCPs included from Phase 1
- High-confidence threshold (0.75) for offers
- No persistence (stateless per session)

**The approach:**
- Preserves Eitri's conversational UX
- Keeps users in control
- Reduces unnecessary questions
- Adds no mandatory steps
- Degrades gracefully

**Status:** Ready for implementation.
