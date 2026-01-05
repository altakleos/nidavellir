#!/bin/bash
# Test Scenario: TOD Deed Evaluation Flow
# Tests: TOD evaluation questions in intake-registry.json and intake-flow.md
# Expected: Complete evaluation flow with recommendation logic

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TOD Deed Evaluation Flow"

flow_content=$(cat "$FLOW")

echo ""
echo "Testing TOD deed evaluation flow"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: TOD Interest Question (Entry Point)
# ═══════════════════════════════════════════════════════════════

# Test 1: tod_interest question exists
tod_interest=$(jq '.questions.tod_interest // null' "$REGISTRY")
assert_not_empty "$tod_interest" "tod_interest question exists"

# Test 2: tod_interest has proper condition
tod_int_cond=$(jq -r '.questions.tod_interest.condition // ""' "$REGISTRY")
if [[ "$tod_int_cond" == *"TN"* ]] && [[ "$tod_int_cond" == *"has_tn_real_estate"* ]]; then
  echo -e "${GREEN}✓${NC} tod_interest has TN + real estate condition"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod_interest should require TN state and real estate"
  echo "  Actual: $tod_int_cond"
  FAILED=$((FAILED + 1))
fi

# Test 3: tod_interest has yes/no/help options
tod_int_opts=$(jq -r '[.questions.tod_interest.options[].value] | join(",")' "$REGISTRY")
assert_contains "$tod_int_opts" "yes" "tod_interest includes yes option"
assert_contains "$tod_int_opts" "no" "tod_interest includes no option"
assert_contains "$tod_int_opts" "help" "tod_interest includes help option"

# Test 4: tod_interest sets wants_tod_evaluation flag
tod_int_flags=$(jq -r '.questions.tod_interest.sets_flags // [] | join(",")' "$REGISTRY")
assert_contains "$tod_int_flags" "wants_tod_evaluation" "tod_interest sets wants_tod_evaluation flag"

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Property Count Question
# ═══════════════════════════════════════════════════════════════

# Test 5: tod_property_count question exists
tod_prop=$(jq '.questions.tod_property_count // null' "$REGISTRY")
assert_not_empty "$tod_prop" "tod_property_count question exists"

# Test 6: tod_property_count is conditional on wants_tod_evaluation
tod_prop_cond=$(jq -r '.questions.tod_property_count.condition // ""' "$REGISTRY")
if [[ "$tod_prop_cond" == *"wants_tod_evaluation"* ]]; then
  echo -e "${GREEN}✓${NC} tod_property_count requires wants_tod_evaluation"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod_property_count should require wants_tod_evaluation"
  FAILED=$((FAILED + 1))
fi

# Test 7: tod_property_count has one/two_three/four_plus options
tod_prop_opts=$(jq -r '[.questions.tod_property_count.options[].value] | join(",")' "$REGISTRY")
assert_contains "$tod_prop_opts" "one" "tod_property_count includes one option"
assert_contains "$tod_prop_opts" "four_plus" "tod_property_count includes four_plus option"

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Incapacity Concern Question
# ═══════════════════════════════════════════════════════════════

# Test 8: tod_incapacity_concern question exists
tod_inc=$(jq '.questions.tod_incapacity_concern // null' "$REGISTRY")
assert_not_empty "$tod_inc" "tod_incapacity_concern question exists"

# Test 9: tod_incapacity_concern has very_important option
tod_inc_opts=$(jq -r '[.questions.tod_incapacity_concern.options[].value] | join(",")' "$REGISTRY")
assert_contains "$tod_inc_opts" "very_important" "tod_incapacity_concern includes very_important option"

# Test 10: tod_incapacity_concern is conditional on wants_tod_evaluation
tod_inc_cond=$(jq -r '.questions.tod_incapacity_concern.condition // ""' "$REGISTRY")
if [[ "$tod_inc_cond" == *"wants_tod_evaluation"* ]]; then
  echo -e "${GREEN}✓${NC} tod_incapacity_concern requires wants_tod_evaluation"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod_incapacity_concern should require wants_tod_evaluation"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Distribution Complexity Question
# ═══════════════════════════════════════════════════════════════

# Test 11: tod_distribution_complexity question exists
tod_dist=$(jq '.questions.tod_distribution_complexity // null' "$REGISTRY")
assert_not_empty "$tod_dist" "tod_distribution_complexity question exists"

# Test 12: tod_distribution_complexity has simple/conditional/snt options
tod_dist_opts=$(jq -r '[.questions.tod_distribution_complexity.options[].value] | join(",")' "$REGISTRY")
assert_contains "$tod_dist_opts" "simple" "tod_distribution_complexity includes simple option"
assert_contains "$tod_dist_opts" "conditional" "tod_distribution_complexity includes conditional option"
assert_contains "$tod_dist_opts" "snt" "tod_distribution_complexity includes snt option"

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Phase 2 TOD Proceed Question
# ═══════════════════════════════════════════════════════════════

# Test 13: tod_proceed question exists
tod_proceed=$(jq '.questions.tod_proceed // null' "$REGISTRY")
assert_not_empty "$tod_proceed" "tod_proceed question exists"

# Test 14: tod_proceed is phase 2
tod_proceed_phase=$(jq -r '.questions.tod_proceed.phase // 0' "$REGISTRY")
if [[ "$tod_proceed_phase" == "2" ]]; then
  echo -e "${GREEN}✓${NC} tod_proceed is phase 2 question"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod_proceed should be phase 2 (actual: $tod_proceed_phase)"
  FAILED=$((FAILED + 1))
fi

# Test 15: tod_proceed sets wants_tod_deed flag
tod_proceed_flags=$(jq -r '.questions.tod_proceed.sets_flags // [] | join(",")' "$REGISTRY")
assert_contains "$tod_proceed_flags" "wants_tod_deed" "tod_proceed sets wants_tod_deed flag"

# Test 16: tod_proceed has yes/no/more_info options
tod_proceed_opts=$(jq -r '[.questions.tod_proceed.options[].value] | join(",")' "$REGISTRY")
assert_contains "$tod_proceed_opts" "yes" "tod_proceed includes yes option"
assert_contains "$tod_proceed_opts" "more_info" "tod_proceed includes more_info option"

# ═══════════════════════════════════════════════════════════════
# SECTION 6: Flow Integration - Phase 1
# ═══════════════════════════════════════════════════════════════

# Test 17: Flow references tod_interest
assert_contains "$flow_content" "tod_interest" "Flow references tod_interest question"

# Test 18: Flow has TOD explanation box
if [[ "$flow_content" == *"WHAT IS A TRANSFER-ON-DEATH"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has TOD explanation box for help option"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have TOD explanation box"
  FAILED=$((FAILED + 1))
fi

# Test 19: Flow has multiple property warning
if [[ "$flow_content" == *"MULTIPLE PROPERTIES"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has multiple property warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have multiple property warning"
  FAILED=$((FAILED + 1))
fi

# Test 20: Flow has incapacity warning
if [[ "$flow_content" == *"INCAPACITY PROTECTION"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has incapacity protection warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have incapacity protection warning"
  FAILED=$((FAILED + 1))
fi

# Test 21: Flow has SNT warning
if [[ "$flow_content" == *"SPECIAL NEEDS BENEFICIARY"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has special needs beneficiary warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have special needs beneficiary warning"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 7: Flow Integration - Phase 2
# ═══════════════════════════════════════════════════════════════

# Test 22: Flow has Phase 2 TOD decision section
if [[ "$flow_content" == *"2.2.1 TOD Deed Decision"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has section 2.2.1 TOD Deed Decision"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have section 2.2.1 TOD Deed Decision"
  FAILED=$((FAILED + 1))
fi

# Test 23: Flow has recommended display
if [[ "$flow_content" == *"RECOMMENDED: TOD DEED FOR YOUR SITUATION"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has recommended TOD display"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have recommended TOD display"
  FAILED=$((FAILED + 1))
fi

# Test 24: Flow has optional display for trust creators
if [[ "$flow_content" == *"TOD DEED OR TRUST FUNDING"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has TOD vs trust funding comparison"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have TOD vs trust funding comparison"
  FAILED=$((FAILED + 1))
fi

# Test 25: Flow references tod_proceed
assert_contains "$flow_content" "tod_proceed" "Flow references tod_proceed question"

# ═══════════════════════════════════════════════════════════════
# SECTION 8: Recommendation Logic
# ═══════════════════════════════════════════════════════════════

# Test 26: Flow sets tod_recommendation to recommended
if [[ "$flow_content" == *"tod_recommendation: recommended"* ]]; then
  echo -e "${GREEN}✓${NC} Flow sets tod_recommendation: recommended"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should set tod_recommendation: recommended"
  FAILED=$((FAILED + 1))
fi

# Test 27: Flow sets tod_recommendation to optional
if [[ "$flow_content" == *"tod_recommendation: optional"* ]]; then
  echo -e "${GREEN}✓${NC} Flow sets tod_recommendation: optional"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should set tod_recommendation: optional"
  FAILED=$((FAILED + 1))
fi

# Test 28: Flow sets tod_recommendation to not_recommended
if [[ "$flow_content" == *"tod_recommendation: not_recommended"* ]]; then
  echo -e "${GREEN}✓${NC} Flow sets tod_recommendation: not_recommended"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should set tod_recommendation: not_recommended"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 9: TOD Generator Integration
# ═══════════════════════════════════════════════════════════════

# Test 29: TOD generator exists
TOD_GEN="$REPO_ROOT/plugins/skuld/agents/tod-generator.md"
if [[ -f "$TOD_GEN" ]]; then
  echo -e "${GREEN}✓${NC} tod-generator.md agent exists"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod-generator.md agent not found"
  FAILED=$((FAILED + 1))
fi

# Test 30: TOD generator requires wants_tod_deed
gen_content=$(cat "$TOD_GEN")
if [[ "$gen_content" == *"wants_tod_deed: true"* ]]; then
  echo -e "${GREEN}✓${NC} tod-generator triggers on wants_tod_deed"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod-generator should trigger on wants_tod_deed"
  FAILED=$((FAILED + 1))
fi

# Test 31: TOD generator requires tod_interest
if [[ "$gen_content" == *"tod_interest"* ]]; then
  echo -e "${GREEN}✓${NC} tod-generator requires tod_interest"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod-generator should require tod_interest"
  FAILED=$((FAILED + 1))
fi

# Test 32: TOD generator has optional intake for evaluation questions
if [[ "$gen_content" == *"tod_property_count"* ]] && [[ "$gen_content" == *"tod_incapacity_concern"* ]]; then
  echo -e "${GREEN}✓${NC} tod-generator has optional intake for evaluation questions"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tod-generator should have optional intake for evaluation questions"
  FAILED=$((FAILED + 1))
fi

report
