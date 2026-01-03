#!/bin/bash
# Test Scenario: Married Couple in Tennessee with Minor Children
# Expected: Full spouse flow, TN CPT questions, guardian selection

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Married, 2 Kids, Tennessee"

flow_content=$(cat "$FLOW")

# Test 1: marital_status has married option
married_exists=$(jq '.questions.marital_status.options | any(.value == "married")' "$REGISTRY")
assert_eq "$married_exists" "true" "marital_status has married option"

# Test 2: state_of_residence is text input (accepts TN abbreviation)
state_type=$(question_type "state_of_residence")
assert_eq "$state_type" "text" "state_of_residence is text input for TN"

# Test 3: spouse_citizenship question exists
spouse_q=$(jq '.questions.spouse_citizenship // null' "$REGISTRY")
assert_not_empty "$spouse_q" "spouse_citizenship question exists"

# Test 4: spouse_citizenship requires has_spouse condition
spouse_cond=$(jq -r '.questions.spouse_citizenship.condition // ""' "$REGISTRY")
assert_contains "$spouse_cond" "has_spouse" "spouse_citizenship conditional on has_spouse"

# Test 5: Flow mentions spouse name/DOB prompts
assert_contains "$flow_content" "spouse" "Flow mentions spouse"

# Test 6: CPT questions exist for Tennessee
# Check for CPT-related questions in registry or flow
cpt_exists=$(jq '[.questions | to_entries[] | select(.key | test("^cpt_"))] | length' "$REGISTRY")
if [[ "$cpt_exists" -gt 0 ]]; then
  echo -e "${GREEN}✓${NC} CPT questions exist in registry ($cpt_exists questions)"
  PASSED=$((PASSED + 1))
else
  # CPT might be handled in flow only
  assert_contains "$flow_content" "CPT" "Flow mentions CPT"
fi

# Test 7: Guardian selection exists in flow
assert_contains "$flow_content" "Primary guardian" "Primary guardian prompt exists"
assert_contains "$flow_content" "Backup guardian" "Backup guardian prompt exists"

# Test 8: Guardian conditional on minor children
assert_contains "$flow_content" "has_minor_children == true" "Guardian requires minor children"

# Test 9: has_children question in phase 1
children_phase=$(jq '.questions.has_children.phase' "$REGISTRY")
assert_eq "$children_phase" "1" "has_children in phase 1"

# Test 10: Verify flow has structure for married path
assert_contains "$flow_content" "marital_status" "Flow references marital_status"

report
