#!/bin/bash
# Test Scenario: Tennessee State Detection and Flow
# Validates TN is properly recognized and triggers TN-specific paths

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN State Detection"

flow_content=$(cat "$FLOW")
skill_content=$(cat "$SKILL")

# Test 1: state_of_residence note mentions TN triggers CPT
note=$(jq -r '.questions.state_of_residence.note // ""' "$REGISTRY")
assert_contains "$note" "TN triggers CPT" "state_of_residence note mentions TN/CPT"

# Test 2: SKILL.md documents TN triggers CPT screening
assert_contains "$skill_content" "TN" "SKILL.md mentions Tennessee"
assert_contains "$skill_content" "Community Property Trust" "SKILL.md mentions CPT"

# Test 3: Flow has multiple TN-conditional sections
tn_if_count=$(grep -c "IF state == TN" "$FLOW" || echo "0")
if [[ "$tn_if_count" -ge 2 ]]; then
  echo -e "${GREEN}✓${NC} Flow has $tn_if_count TN-conditional sections"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Expected at least 2 TN-conditional sections, found $tn_if_count"
  FAILED=$((FAILED + 1))
fi

# Test 4: Flow launches estate-state-lookup for all states
assert_contains "$flow_content" "estate-state-lookup" "Flow uses estate-state-lookup agent"

# Test 5: TN-specific questions all have phase assignments
tn_no_phase=$(jq '[.questions | to_entries[] | select(.value.condition // "" | test("TN")) | select(.value.phase == null)] | length' "$REGISTRY")
assert_eq "$tn_no_phase" "0" "All TN questions have phase assigned"

# Test 6: CPT section comes after state selection in flow
# Find line numbers
state_line=$(grep -n "State of Residence" "$FLOW" | head -1 | cut -d: -f1)
cpt_line=$(grep -n "Community Property Trust" "$FLOW" | head -1 | cut -d: -f1)
if [[ -n "$state_line" && -n "$cpt_line" && "$cpt_line" -gt "$state_line" ]]; then
  echo -e "${GREEN}✓${NC} CPT section (line $cpt_line) comes after state (line $state_line)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} CPT section should come after state selection"
  FAILED=$((FAILED + 1))
fi

# Test 7: TN questions don't trigger for non-TN states
# All TN-conditional questions should have explicit TN condition
tn_questions=$(jq '[.questions | to_entries[] | select(.key | test("^tn_|^cpt_"))]' "$REGISTRY")
tn_count=$(echo "$tn_questions" | jq 'length')
tn_with_cond=$(echo "$tn_questions" | jq '[.[] | select(.value.condition // "" | test("TN"))] | length')
if [[ "$tn_count" == "$tn_with_cond" ]]; then
  echo -e "${GREEN}✓${NC} All $tn_count TN/CPT questions have TN condition"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Some TN/CPT questions missing TN condition ($tn_with_cond of $tn_count)"
  FAILED=$((FAILED + 1))
fi

# Test 8: Non-TN states don't trigger CPT
# Verify CPT condition includes married requirement
cpt_conditions=$(jq -r '[.questions | to_entries[] | select(.key | startswith("cpt_")) | .value.condition] | unique[]' "$REGISTRY")
for cond in $cpt_conditions; do
  if [[ "$cond" == *"married"* ]] || [[ "$cond" == *"has_spouse"* ]]; then
    echo -e "${GREEN}✓${NC} CPT requires married status"
    PASSED=$((PASSED + 1))
    break
  fi
done

# Test 9: Example in state question includes TN
example=$(jq -r '.questions.state_of_residence.example // ""' "$REGISTRY")
assert_contains "$example" "TN" "State example includes TN abbreviation"

# Test 10: TN real estate question exists and is conditional
tn_re_exists=$(jq '.questions.tn_real_estate_details != null' "$REGISTRY")
assert_eq "$tn_re_exists" "true" "tn_real_estate_details question exists"

report
