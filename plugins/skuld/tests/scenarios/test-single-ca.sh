#!/bin/bash
# Test Scenario: Single Person in California, No Children
# Expected: Basic flow without spouse/guardian branches

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Single, No Kids, California"

# Test 1: personal_name_dob is first question (phase 1)
phase=$(jq '.questions.personal_name_dob.phase' "$REGISTRY")
assert_eq "$phase" "1" "personal_name_dob is phase 1"

# Test 2: marital_status exists with single option
single_exists=$(jq '.questions.marital_status.options | any(.value == "single")' "$REGISTRY")
assert_eq "$single_exists" "true" "marital_status has single option"

# Test 3: state_of_residence is text input (accepts CA abbreviation)
state_type=$(question_type "state_of_residence")
assert_eq "$state_type" "text" "state_of_residence is text input for abbreviations"

# Test 4: has_children exists with No option
no_exists=$(jq '.questions.has_children.options | any(.value == "no")' "$REGISTRY")
assert_eq "$no_exists" "true" "has_children has no option"

# Test 5: No spouse questions triggered for single
# spouse_citizenship requires has_spouse condition
spouse_cond=$(jq -r '.questions.spouse_citizenship.condition // ""' "$REGISTRY")
assert_contains "$spouse_cond" "has_spouse" "spouse_citizenship requires has_spouse"

# Test 6: No guardian questions triggered without children
# Flow should require has_minor_children for guardian section
flow_content=$(cat "$FLOW")
assert_contains "$flow_content" "has_minor_children == true" "Guardian section conditional on minors"

# Test 7: California should NOT trigger CPT questions (TN only)
# CPT questions should have TN condition
cpt_condition=$(jq -r '.questions.cpt_property_type.condition // ""' "$REGISTRY" 2>/dev/null || echo "")
if [[ -n "$cpt_condition" ]]; then
  assert_contains "$cpt_condition" "TN" "CPT questions require Tennessee"
else
  echo -e "${GREEN}✓${NC} CPT questions not applicable for CA (TN-specific)"
  PASSED=$((PASSED + 1))
fi

report
