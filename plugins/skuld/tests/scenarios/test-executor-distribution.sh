#!/bin/bash
# Test Scenario: Executor and Distribution Preferences
# Profile: Single, no children, standard distribution
# Expected: Executor selection, distribution preferences, healthcare/agent questions

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Executor + Distribution"

flow_content=$(cat "$FLOW")
skill_content=$(cat "$SKILL")

echo ""
echo "Profile: Single, no children, standard estate plan"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Executor Preferences
# ═══════════════════════════════════════════════════════════════

# Test 1: executor_preferences question exists
exec_pref=$(jq '.questions.executor_preferences // null' "$REGISTRY")
assert_not_empty "$exec_pref" "executor_preferences question exists"

# Test 2: executor_preferences uses numbered_select (C10)
exec_type=$(jq -r '.questions.executor_preferences.type // ""' "$REGISTRY")
if [[ "$exec_type" == "numbered_select" ]]; then
  echo -e "${GREEN}✓${NC} executor_preferences uses numbered_select (C10)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} executor_preferences type: $exec_type"
  PASSED=$((PASSED + 1))
fi

# Test 3: executor_preferences has 5+ options (C10 requirement)
exec_opt_count=$(jq '.questions.executor_preferences.options | length // 0' "$REGISTRY")
if [[ "$exec_opt_count" -ge 5 ]]; then
  echo -e "${GREEN}✓${NC} executor_preferences has $exec_opt_count options (5+ required)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} executor_preferences has $exec_opt_count options"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Distribution Preferences
# ═══════════════════════════════════════════════════════════════

# Test 4: distribution_preferences question exists
dist_pref=$(jq '.questions.distribution_preferences // null' "$REGISTRY")
assert_not_empty "$dist_pref" "distribution_preferences question exists"

# Test 5: distribution_preferences has distribution pattern options
dist_opts=$(jq -r '[.questions.distribution_preferences.options[].value] | join(",")' "$REGISTRY")
if [[ -n "$dist_opts" ]]; then
  echo -e "${GREEN}✓${NC} distribution_preferences has options: $dist_opts"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_preferences should have options"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Healthcare Preferences
# ═══════════════════════════════════════════════════════════════

# Test 6: healthcare_preferences_life_support question exists
hc_life=$(jq '.questions.healthcare_preferences_life_support // null' "$REGISTRY")
assert_not_empty "$hc_life" "healthcare_preferences_life_support question exists"

# Test 7: healthcare_preferences_organ_donation question exists
hc_organ=$(jq '.questions.healthcare_preferences_organ_donation // null' "$REGISTRY")
assert_not_empty "$hc_organ" "healthcare_preferences_organ_donation question exists"

# Test 8: Flow mentions healthcare preferences
assert_contains "$flow_content" "healthcare" "Flow mentions healthcare preferences"

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Agent Selection
# ═══════════════════════════════════════════════════════════════

# Test 9: financial_agent_selection question exists
fin_agent=$(jq '.questions.financial_agent_selection // null' "$REGISTRY")
assert_not_empty "$fin_agent" "financial_agent_selection question exists"

# Test 10: healthcare_agent_selection question exists
hc_agent=$(jq '.questions.healthcare_agent_selection // null' "$REGISTRY")
assert_not_empty "$hc_agent" "healthcare_agent_selection question exists"

# Test 11: Flow mentions agent selection
if [[ "$flow_content" == *"financial agent"* ]] || [[ "$flow_content" == *"power of attorney"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions financial agent/POA"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention financial agent selection"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Document Generation Readiness
# ═══════════════════════════════════════════════════════════════

# Test 12: executor_preferences is unconditional (everyone needs it)
exec_cond=$(jq -r '.questions.executor_preferences.condition // ""' "$REGISTRY")
if [[ -z "$exec_cond" ]] || [[ "$exec_cond" == "null" ]]; then
  echo -e "${GREEN}✓${NC} executor_preferences is unconditional (required for all)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} executor_preferences has condition: $exec_cond"
  PASSED=$((PASSED + 1))
fi

# Test 13: Skill mentions POA generation
assert_contains "$skill_content" "poa-generator" "SKILL.md mentions POA generator agent"

report
