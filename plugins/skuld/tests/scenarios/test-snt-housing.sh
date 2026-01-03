#!/bin/bash
# Test Scenario: Special Needs Trust Housing Provisions
# Tests for SNT housing, ISM warnings, and expense allocation

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: SNT Housing Provisions"

flow_content=$(cat "$FLOW")
snt_gen=$(cat "$REPO_ROOT/plugins/skuld/agents/snt-generator.md")

# Test 1: snt_housing_provision question exists
snt_housing=$(jq '.questions.snt_housing_provision // null' "$REGISTRY")
assert_not_empty "$snt_housing" "snt_housing_provision question exists"

# Test 2: snt_housing_provision has expected options
housing_opts=$(jq -c '[.questions.snt_housing_provision.options[].value] | sort' "$REGISTRY")
expected_opts='["both","family_home","housing_fund","trustee_discretion"]'
if [[ "$housing_opts" == "$expected_opts" ]]; then
  echo -e "${GREEN}✓${NC} snt_housing_provision has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} snt_housing_provision options mismatch"
  echo "  Expected: $expected_opts"
  echo "  Actual:   $housing_opts"
  FAILED=$((FAILED + 1))
fi

# Test 3: snt_housing_provision is conditional on special needs
housing_cond=$(jq -r '.questions.snt_housing_provision.condition // ""' "$REGISTRY")
if [[ "$housing_cond" == *"special_needs"* ]]; then
  echo -e "${GREEN}✓${NC} snt_housing_provision is conditional on special needs"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} snt_housing_provision should be conditional on special needs"
  FAILED=$((FAILED + 1))
fi

# Test 4: snt_housing_expenses question exists
snt_expenses=$(jq '.questions.snt_housing_expenses // null' "$REGISTRY")
assert_not_empty "$snt_expenses" "snt_housing_expenses question exists"

# Test 5: snt_housing_expenses has expected options (including ISM warning in SNT option)
exp_opts=$(jq -c '[.questions.snt_housing_expenses.options[].value] | sort' "$REGISTRY")
expected_exp='["main_trust","remaindermen","snt"]'
if [[ "$exp_opts" == "$expected_exp" ]]; then
  echo -e "${GREEN}✓${NC} snt_housing_expenses has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} snt_housing_expenses options mismatch"
  echo "  Expected: $expected_exp"
  echo "  Actual:   $exp_opts"
  FAILED=$((FAILED + 1))
fi

# Test 6: snt_housing_expenses has ISM note
exp_note=$(jq -r '.questions.snt_housing_expenses.note // ""' "$REGISTRY")
if [[ "$exp_note" == *"ISM"* ]] || [[ "$exp_note" == *"SSI"* ]]; then
  echo -e "${GREEN}✓${NC} snt_housing_expenses has ISM/SSI note"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} snt_housing_expenses should have ISM/SSI warning note"
  FAILED=$((FAILED + 1))
fi

# Test 7: snt_housing_remainder question exists
snt_remainder=$(jq '.questions.snt_housing_remainder // null' "$REGISTRY")
assert_not_empty "$snt_remainder" "snt_housing_remainder question exists"

# Test 8: snt_housing_remainder has expected options
rem_opts=$(jq -c '[.questions.snt_housing_remainder.options[].value] | sort' "$REGISTRY")
expected_rem='["sell_distribute","siblings","snt_remaindermen"]'
if [[ "$rem_opts" == "$expected_rem" ]]; then
  echo -e "${GREEN}✓${NC} snt_housing_remainder has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} snt_housing_remainder options mismatch"
  echo "  Expected: $expected_rem"
  echo "  Actual:   $rem_opts"
  FAILED=$((FAILED + 1))
fi

# Test 9: Flow has Special Needs Housing section
assert_contains "$flow_content" "Special Needs Housing" "Flow has Special Needs Housing section"

# Test 10: Flow has ISM warning (check for ISM abbreviation or In-Kind)
if [[ "$flow_content" == *"ISM"* ]] || [[ "$flow_content" == *"In-Kind"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has ISM warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have ISM warning"
  FAILED=$((FAILED + 1))
fi

# Test 11: Flow has SSI benefits mention
assert_contains "$flow_content" "SSI benefits" "Flow mentions SSI benefits"

# Test 12: SNT generator has Article IV-A
assert_contains "$snt_gen" "Article IV-A" "SNT generator has Article IV-A"

# Test 13: SNT generator has Right of Occupancy
assert_contains "$snt_gen" "Right of Occupancy" "SNT generator has Right of Occupancy"

# Test 14: SNT generator has Housing Fund Authorization
assert_contains "$snt_gen" "Housing Fund Authorization" "SNT generator has Housing Fund Authorization"

# Test 15: SNT generator has ISM awareness section
assert_contains "$snt_gen" "ISM Awareness" "SNT generator has ISM awareness section"

# Test 16: SNT generator has expense allocation options
assert_contains "$snt_gen" "snt_housing_expenses" "SNT generator handles expense allocation"

# Test 17: SNT generator has remainder distribution for housing
assert_contains "$snt_gen" "snt_housing_remainder" "SNT generator handles remainder distribution"

report
