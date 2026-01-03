#!/bin/bash
# Test Scenario: Residence Restrictions on Primary Home
# Tests for sale restrictions, life estate, and spendthrift clauses

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Residence Restrictions"

flow_content=$(cat "$FLOW")
trust_gen=$(cat "$REPO_ROOT/plugins/skuld/agents/trust-generator.md")

# Test 1: residence_disposition question exists
res_disp=$(jq '.questions.residence_disposition // null' "$REGISTRY")
assert_not_empty "$res_disp" "residence_disposition question exists"

# Test 2: residence_disposition is numbered_select (5 options per C10)
res_type=$(jq -r '.questions.residence_disposition.type // ""' "$REGISTRY")
assert_eq "$res_type" "numbered_select" "residence_disposition uses numbered_select"

# Test 3: residence_disposition has C10 constraint
res_constraints=$(jq -r '.questions.residence_disposition.constraints // []' "$REGISTRY")
if [[ "$res_constraints" == *"C10"* ]]; then
  echo -e "${GREEN}✓${NC} residence_disposition has C10 constraint"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} residence_disposition should have C10 constraint"
  FAILED=$((FAILED + 1))
fi

# Test 4: residence_disposition has all expected options
res_opts=$(jq -c '[.questions.residence_disposition.options[].value] | sort' "$REGISTRY")
expected_opts='["beneficiaries_outright","kept_in_trust","snt_housing","spouse_life_estate","standard"]'
if [[ "$res_opts" == "$expected_opts" ]]; then
  echo -e "${GREEN}✓${NC} residence_disposition has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} residence_disposition options mismatch"
  echo "  Expected: $expected_opts"
  echo "  Actual:   $res_opts"
  FAILED=$((FAILED + 1))
fi

# Test 5: residence_sale_restriction question exists
sale_rest=$(jq '.questions.residence_sale_restriction // null' "$REGISTRY")
assert_not_empty "$sale_rest" "residence_sale_restriction question exists"

# Test 6: residence_sale_restriction has correct options
sale_opts=$(jq -c '[.questions.residence_sale_restriction.options[].value] | sort' "$REGISTRY")
expected_sale='["consent_required","none","time_limited","trustee_discretion"]'
if [[ "$sale_opts" == "$expected_sale" ]]; then
  echo -e "${GREEN}✓${NC} residence_sale_restriction has all expected options"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} residence_sale_restriction options mismatch"
  echo "  Expected: $expected_sale"
  echo "  Actual:   $sale_opts"
  FAILED=$((FAILED + 1))
fi

# Test 7: residence_sale_restriction is conditional on disposition
sale_cond=$(jq -r '.questions.residence_sale_restriction.condition // ""' "$REGISTRY")
if [[ "$sale_cond" == *"residence_disposition"* ]]; then
  echo -e "${GREEN}✓${NC} residence_sale_restriction depends on disposition"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} residence_sale_restriction should depend on disposition"
  FAILED=$((FAILED + 1))
fi

# Test 8: spendthrift_preference question exists
spendthrift=$(jq '.questions.spendthrift_preference // null' "$REGISTRY")
assert_not_empty "$spendthrift" "spendthrift_preference question exists"

# Test 9: spendthrift_preference sets include_spendthrift_clause flag
spend_flags=$(jq -r '.questions.spendthrift_preference.sets_flags // []' "$REGISTRY")
if [[ "$spend_flags" == *"include_spendthrift_clause"* ]]; then
  echo -e "${GREEN}✓${NC} spendthrift_preference sets include_spendthrift_clause flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} spendthrift_preference should set include_spendthrift_clause flag"
  FAILED=$((FAILED + 1))
fi

# Test 10: Flow has Residence Provisions section
assert_contains "$flow_content" "Residence Provisions" "Flow has Residence Provisions section"

# Test 11: Flow has Spendthrift Protection section
assert_contains "$flow_content" "Spendthrift Protection" "Flow has Spendthrift Protection section"

# Test 12: Trust generator has Article VII-A
assert_contains "$trust_gen" "Article VII-A" "Trust generator has Article VII-A"

# Test 13: Trust generator has life estate provisions
assert_contains "$trust_gen" "Life Estate" "Trust generator has life estate provisions"

# Test 14: Trust generator has time-limited sale restriction
assert_contains "$trust_gen" "Time-Limited Sale Restriction" "Trust generator has time-limited restriction"

# Test 15: Trust generator has consent required provision
assert_contains "$trust_gen" "Unanimous Consent" "Trust generator has consent required provision"

report
