#!/bin/bash
# Test Scenario: Phase 4/5 Workflow Integration
# Validates Phase 4/5 definitions in SKILL.md and intake-flow.md

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Phase 4/5 Workflow Integration"

skill_content=$(cat "$SKILL")
flow_content=$(cat "$FLOW")

# Test Phase 4 definition in SKILL.md
test_header "Phase 4 in SKILL.md"

assert_contains "$skill_content" "### Phase 4: Execution Guidance" "SKILL.md has Phase 4 section"
assert_contains "$skill_content" "execution-guidance" "SKILL.md references execution-guidance agent"
assert_contains "$skill_content" "execution-guidance-agent.md" "SKILL.md references agent file"
assert_contains "$skill_content" "skuld/execution/" "SKILL.md specifies Phase 4 output path"

# Verify Phase 4 triggers
assert_contains "$skill_content" "Phase 3B validation" "Phase 4 triggers after Phase 3B validation"

# Verify Phase 4 inputs documented
assert_contains "$skill_content" "document_metadata" "Phase 4 inputs include document_metadata"
assert_contains "$skill_content" "complexity_flags" "Phase 4 inputs include complexity_flags"

# Test Phase 5 definition in SKILL.md
test_header "Phase 5 in SKILL.md"

assert_contains "$skill_content" "### Phase 5: Funding" "SKILL.md has Phase 5 section"
assert_contains "$skill_content" "funding-checklist" "SKILL.md references funding-checklist agent"
assert_contains "$skill_content" "funding-checklist-agent.md" "SKILL.md references agent file"
assert_contains "$skill_content" "skuld/funding/" "SKILL.md specifies Phase 5 output path"

# Verify Phase 5 conditional trigger
assert_contains "$skill_content" "trust was generated" "Phase 5 conditional on trust generation"
assert_contains "$skill_content" "trust_funding_needs" "Phase 5 respects trust_funding_needs flag"

# Verify Phase 5 inputs documented
assert_contains "$skill_content" "trust_metadata" "Phase 5 inputs include trust_metadata"

# Test Agent Orchestration section includes Phase 4/5 agents
test_header "Agent Orchestration Table"

assert_contains "$skill_content" "### Execution & Funding Agents" "SKILL.md has Phase 4/5 agent section"
assert_contains "$skill_content" "**execution-guidance**" "Agent table includes execution-guidance"
assert_contains "$skill_content" "**funding-checklist**" "Agent table includes funding-checklist"

# Test Phase 4 in intake-flow.md
test_header "Phase 4 in intake-flow.md"

assert_contains "$flow_content" "## Phase 4: Execution Guidance" "intake-flow.md has Phase 4 section"
assert_contains "$flow_content" "No intake questions required" "Phase 4 clarifies no new intake"
assert_contains "$flow_content" "INVOKE execution-guidance-agent" "Flow invokes execution-guidance-agent"

# Verify Phase 4 conditional logic documented
assert_contains "$flow_content" "validation_status" "Phase 4 checks validation status"
assert_contains "$flow_content" "warnings_only" "Phase 4 proceeds on warnings_only status"

# Test Phase 5 in intake-flow.md
test_header "Phase 5 in intake-flow.md"

assert_contains "$flow_content" "## Phase 5: Funding" "intake-flow.md has Phase 5 section"
assert_contains "$flow_content" "Conditional invocation" "Phase 5 is conditionally invoked"
assert_contains "$flow_content" "INVOKE funding-checklist-agent" "Flow invokes funding-checklist-agent"

# Verify Phase 5 skip conditions documented
assert_contains "$flow_content" "Skip Phase 5 when" "Flow documents Phase 5 skip conditions"
assert_contains "$flow_content" "will-only estate plan" "Skip condition: will-only plan"

# Verify asset types listed
assert_contains "$flow_content" "financial_assets" "Flow references financial_assets"
assert_contains "$flow_content" "Real estate" "Flow mentions real estate workflow"
assert_contains "$flow_content" "Retirement" "Flow mentions retirement workflow"

# Test Phase ordering
test_header "Phase Ordering"

# Find line numbers to verify Phase 4 comes before Phase 5
phase4_line=$(grep -n "## Phase 4:" "$FLOW" | head -1 | cut -d: -f1)
phase5_line=$(grep -n "## Phase 5:" "$FLOW" | head -1 | cut -d: -f1)

if [[ -n "$phase4_line" && -n "$phase5_line" ]]; then
  if [[ "$phase5_line" -gt "$phase4_line" ]]; then
    echo -e "${GREEN}✓${NC} Phase 5 (line $phase5_line) comes after Phase 4 (line $phase4_line)"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} Phase 5 should come after Phase 4"
    FAILED=$((FAILED + 1))
  fi
else
  echo -e "${RED}✗${NC} Could not find Phase 4 or Phase 5 in flow"
  FAILED=$((FAILED + 1))
fi

# Verify Phase 3 exists and comes before Phase 4
phase3_line=$(grep -n "## Phase 3:" "$FLOW" | head -1 | cut -d: -f1)
if [[ -n "$phase3_line" && -n "$phase4_line" ]]; then
  if [[ "$phase4_line" -gt "$phase3_line" ]]; then
    echo -e "${GREEN}✓${NC} Phase 4 (line $phase4_line) comes after Phase 3 (line $phase3_line)"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} Phase 4 should come after Phase 3"
    FAILED=$((FAILED + 1))
  fi
fi

# Test progressive disclosure pattern
test_header "Progressive Disclosure Pattern"

# Phase 4/5 should reference loading state file, not centralized matrix
assert_contains "$skill_content" "Load state file" "SKILL.md describes progressive state loading in Phase 4"
assert_contains "$flow_content" "State-specific variations handled by agent" "Flow delegates state specifics to agent"

# Verify no centralized matrix reference
if [[ "$skill_content" != *"centralized matrix"* ]] && [[ "$skill_content" != *"all states"* ]]; then
  echo -e "${GREEN}✓${NC} SKILL.md follows progressive disclosure (no centralized data)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}⚠${NC} SKILL.md may reference centralized state data"
fi

# Test coordinator display guidance
test_header "Coordinator Display Guidance"

# Phase 4 display guidance
if [[ "$skill_content" == *"Coordinator displays"* ]]; then
  echo -e "${GREEN}✓${NC} SKILL.md includes coordinator display guidance"
  PASSED=$((PASSED + 1))

  # Verify display elements documented
  assert_contains "$skill_content" "signing requirements" "Display guidance includes signing requirements"
  assert_contains "$skill_content" "assets to fund" "Display guidance includes assets to fund"
fi

report
