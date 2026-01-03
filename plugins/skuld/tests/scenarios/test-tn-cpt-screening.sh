#!/bin/bash
# Test Scenario: Tennessee Community Property Trust (CPT) Screening
# CPT questions are triggered for married couples in Tennessee

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN Community Property Trust"

flow_content=$(cat "$FLOW")

# Test 1: CPT screening section exists in flow
assert_contains "$flow_content" "Community Property Trust Screening" "Flow has CPT screening section"

# Test 2: CPT screening is conditional on TN AND married
assert_contains "$flow_content" "state == TN AND marital_status == married" "CPT requires TN + married"

# Test 3: cpt_relocation_risk question exists
cpt_reloc=$(jq '.questions.cpt_relocation_risk // null' "$REGISTRY")
assert_not_empty "$cpt_reloc" "cpt_relocation_risk question exists"

# Test 4: cpt_relocation_risk has correct condition
cond=$(jq -r '.questions.cpt_relocation_risk.condition // ""' "$REGISTRY")
assert_contains "$cond" "state == TN" "cpt_relocation_risk requires TN"
assert_contains "$cond" "married" "cpt_relocation_risk requires married"

# Test 5: cpt_divorce_history question exists
cpt_divorce=$(jq '.questions.cpt_divorce_history // null' "$REGISTRY")
assert_not_empty "$cpt_divorce" "cpt_divorce_history question exists"

# Test 6: cpt_divorce_history mentions prior marriage
text=$(jq -r '.questions.cpt_divorce_history.question_text // ""' "$REGISTRY")
if [[ "$text" == *"prior"* ]] || [[ "$text" == *"divorce"* ]] || [[ "$text" == *"previous"* ]]; then
  echo -e "${GREEN}✓${NC} cpt_divorce_history asks about prior marriages"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} cpt_divorce_history should ask about prior marriages"
  FAILED=$((FAILED + 1))
fi

# Test 7: cpt_separate_property question exists
cpt_sep=$(jq '.questions.cpt_separate_property // null' "$REGISTRY")
assert_not_empty "$cpt_sep" "cpt_separate_property question exists"

# Test 8: cpt_separate_property mentions inheritance or gifts
text=$(jq -r '.questions.cpt_separate_property.question_text // ""' "$REGISTRY")
if [[ "$text" == *"inherit"* ]] || [[ "$text" == *"gift"* ]] || [[ "$text" == *"separate"* ]]; then
  echo -e "${GREEN}✓${NC} cpt_separate_property asks about separate property"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} cpt_separate_property should ask about separate property"
  FAILED=$((FAILED + 1))
fi

# Test 9: cpt_liability_profession question exists
cpt_liab=$(jq '.questions.cpt_liability_profession // null' "$REGISTRY")
assert_not_empty "$cpt_liab" "cpt_liability_profession question exists"

# Test 10: cpt_liability_profession mentions high-risk professions
text=$(jq -r '.questions.cpt_liability_profession.question_text // ""' "$REGISTRY")
if [[ "$text" == *"profession"* ]] || [[ "$text" == *"liability"* ]] || [[ "$text" == *"lawsuit"* ]]; then
  echo -e "${GREEN}✓${NC} cpt_liability_profession asks about liability risk"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} cpt_liability_profession should ask about liability risk"
  FAILED=$((FAILED + 1))
fi

# Test 11: cpt_election question exists (the final CPT decision)
cpt_elect=$(jq '.questions.cpt_election // null' "$REGISTRY")
assert_not_empty "$cpt_elect" "cpt_election question exists"

# Test 12: cpt_election asks about structuring as CPT
text=$(jq -r '.questions.cpt_election.question_text // ""' "$REGISTRY")
assert_contains "$text" "Community Property Trust" "cpt_election asks about CPT structure"

# Test 13: All 5 CPT questions have TN condition
cpt_questions=("cpt_relocation_risk" "cpt_divorce_history" "cpt_separate_property" "cpt_liability_profession" "cpt_election")
for q in "${cpt_questions[@]}"; do
  cond=$(jq -r ".questions.$q.condition // \"\"" "$REGISTRY")
  if [[ "$cond" == *"TN"* ]]; then
    echo -e "${GREEN}✓${NC} $q requires TN state"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $q should require TN state"
    FAILED=$((FAILED + 1))
  fi
done

# Test 14: Flow shows CPT warning box trigger
assert_contains "$flow_content" "CPT risk flag" "Flow mentions CPT risk flags"

# Test 15: CPT questions set flags
flags_set=$(jq '[.questions | to_entries[] | select(.key | startswith("cpt_")) | .value.sets_flags // []] | flatten | length' "$REGISTRY")
if [[ "$flags_set" -ge 4 ]]; then
  echo -e "${GREEN}✓${NC} CPT questions set flags ($flags_set total)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} CPT questions should set flags (found $flags_set)"
  FAILED=$((FAILED + 1))
fi

report
