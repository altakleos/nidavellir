#!/bin/bash
# Test Scenario: TN TBE Trust Decision Framework
# Core tests for TBE home → trust decision questions and structure

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TBE Trust Decision"

flow_content=$(cat "$FLOW")
tn_md=$(cat "$REPO_ROOT/plugins/skuld/intelligence/state-laws/TN.md")

# Test 1: tbe_home_appreciation question exists
tbe_appreciation=$(jq '.questions.tbe_home_appreciation // null' "$REGISTRY")
assert_not_empty "$tbe_appreciation" "tbe_home_appreciation question exists"

# Test 2: tbe_home_appreciation has correct options
appreciation_opts=$(jq -c '[.questions.tbe_home_appreciation.options[].value] | sort' "$REGISTRY")
expected_appreciation='["minimal","moderate","significant","substantial","unsure"]'
if [[ "$appreciation_opts" == "$expected_appreciation" ]]; then
  echo -e "${GREEN}✓${NC} tbe_home_appreciation has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_home_appreciation options mismatch"
  echo "  Expected: $expected_appreciation"
  echo "  Actual:   $appreciation_opts"
  FAILED=$((FAILED + 1))
fi

# Test 3: tbe_home_appreciation is Phase 1
appreciation_phase=$(jq -r '.questions.tbe_home_appreciation.phase // ""' "$REGISTRY")
assert_eq "$appreciation_phase" "1" "tbe_home_appreciation is Phase 1"

# Test 4: tbe_home_appreciation sets high_appreciation_home flag
appreciation_flags=$(jq -r '.questions.tbe_home_appreciation.sets_flags // []' "$REGISTRY")
if [[ "$appreciation_flags" == *"high_appreciation_home"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_home_appreciation sets high_appreciation_home flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_home_appreciation should set high_appreciation_home flag"
  FAILED=$((FAILED + 1))
fi

# Test 5: tbe_blended_home_plan question exists
tbe_blended=$(jq '.questions.tbe_blended_home_plan // null' "$REGISTRY")
assert_not_empty "$tbe_blended" "tbe_blended_home_plan question exists"

# Test 6: tbe_blended_home_plan has correct options
blended_opts=$(jq -c '[.questions.tbe_blended_home_plan.options[].value] | sort' "$REGISTRY")
expected_blended='["accept_survivorship","life_estate","transfer_to_trust"]'
if [[ "$blended_opts" == "$expected_blended" ]]; then
  echo -e "${GREEN}✓${NC} tbe_blended_home_plan has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_blended_home_plan options mismatch"
  echo "  Expected: $expected_blended"
  echo "  Actual:   $blended_opts"
  FAILED=$((FAILED + 1))
fi

# Test 7: tbe_transfer_decision question exists
tbe_decision=$(jq '.questions.tbe_transfer_decision // null' "$REGISTRY")
assert_not_empty "$tbe_decision" "tbe_transfer_decision question exists"

# Test 8: tbe_transfer_decision has all 5 expected options
decision_opts=$(jq -c '[.questions.tbe_transfer_decision.options[].value] | sort' "$REGISTRY")
expected_decision='["attorney_review","keep_tbe","tbe_pourover","tod_approach","transfer_now"]'
if [[ "$decision_opts" == "$expected_decision" ]]; then
  echo -e "${GREEN}✓${NC} tbe_transfer_decision has all 5 expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_transfer_decision options mismatch"
  echo "  Expected: $expected_decision"
  echo "  Actual:   $decision_opts"
  FAILED=$((FAILED + 1))
fi

# Test 9: tbe_transfer_decision is Phase 2 (after data collection)
decision_phase=$(jq -r '.questions.tbe_transfer_decision.phase // ""' "$REGISTRY")
assert_eq "$decision_phase" "2" "tbe_transfer_decision is Phase 2"

# Test 10: tbe_home_appreciation has TN+tbe+cpt condition
appreciation_cond=$(jq -r '.questions.tbe_home_appreciation.condition // ""' "$REGISTRY")
if [[ "$appreciation_cond" == *"TN"* ]] && [[ "$appreciation_cond" == *"tbe"* ]] && [[ "$appreciation_cond" == *"cpt_election"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_home_appreciation has correct condition (TN + tbe + cpt)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_home_appreciation should require TN + tbe + cpt_election"
  echo "  Condition: $appreciation_cond"
  FAILED=$((FAILED + 1))
fi

# Test 11: tbe_blended_home_plan has TN+tbe+blended condition
blended_cond=$(jq -r '.questions.tbe_blended_home_plan.condition // ""' "$REGISTRY")
if [[ "$blended_cond" == *"TN"* ]] && [[ "$blended_cond" == *"tbe"* ]] && [[ "$blended_cond" == *"blended_family"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_blended_home_plan has correct condition (TN + tbe + blended_family)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_blended_home_plan should require TN + tbe + blended_family"
  echo "  Condition: $blended_cond"
  FAILED=$((FAILED + 1))
fi

# Test 12: tbe_transfer_decision has TN+tbe condition
decision_cond=$(jq -r '.questions.tbe_transfer_decision.condition // ""' "$REGISTRY")
if [[ "$decision_cond" == *"TN"* ]] && [[ "$decision_cond" == *"tbe"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_transfer_decision has correct condition (TN + tbe)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_transfer_decision should require TN + tbe"
  echo "  Condition: $decision_cond"
  FAILED=$((FAILED + 1))
fi

# Test 13: tbe_transfer_decision saves to real_estate
decision_save=$(jq -r '.questions.tbe_transfer_decision.save_to // ""' "$REGISTRY")
if [[ "$decision_save" == *"real_estate"* ]] && [[ "$decision_save" == *"tbe_transfer_decision"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_transfer_decision saves to real_estate"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_transfer_decision should save to real_estate path"
  echo "  Save to: $decision_save"
  FAILED=$((FAILED + 1))
fi

# Test 14: TN.md has TBE vs Trust Transfer Decision section
assert_contains "$tn_md" "TBE vs Trust Transfer Decision" "TN.md has TBE decision section"

# Test 15: TN.md has Decision Matrix
assert_contains "$tn_md" "Decision Matrix" "TN.md has Decision Matrix"

# Test 16: TN.md has Recommendation Logic
assert_contains "$tn_md" "Recommendation Logic" "TN.md has Recommendation Logic"

# Test 17: TN.md has Hybrid Strategies
assert_contains "$tn_md" "Hybrid Strategies" "TN.md has Hybrid Strategies"

# Test 18: TN.md has Attorney Review Triggers
assert_contains "$tn_md" "Attorney Review Triggers" "TN.md has Attorney Review Triggers"

# Test 19: TN.md mentions CPT+TBE mutual exclusivity
assert_contains "$tn_md" "Mutually Exclusive" "TN.md explains CPT+TBE mutual exclusivity"

# Test 20: tbe_home_appreciation has appropriate save_to
appreciation_save=$(jq -r '.questions.tbe_home_appreciation.save_to // ""' "$REGISTRY")
if [[ "$appreciation_save" == *"appreciation"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_home_appreciation saves appreciation value"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_home_appreciation should save appreciation value"
  echo "  Save to: $appreciation_save"
  FAILED=$((FAILED + 1))
fi

report
