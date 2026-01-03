#!/bin/bash
# Test Scenario: Cohabiting Partner, No Kids, OTHER State, Business Owner
# Expected: Partner flow, OTHER state handling, business succession questions

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Cohabiting + Business + OTHER State"

flow_content=$(cat "$FLOW")

# Test 1: marital_status has cohabiting option
cohabit_exists=$(jq '.questions.marital_status.options | any(.value == "cohabiting")' "$REGISTRY")
assert_eq "$cohabit_exists" "true" "marital_status has cohabiting option"

# Test 2: state_of_residence is text input (accepts any state abbreviation)
state_type=$(question_type "state_of_residence")
assert_eq "$state_type" "text" "state_of_residence is text input"

# Test 3: state_of_residence example shows abbreviation format
example=$(jq -r '.questions.state_of_residence.example // ""' "$REGISTRY")
assert_contains "$example" "TX" "Example shows state abbreviation format"

# Test 4: partner_included question exists for cohabiting
partner_q=$(jq '.questions.partner_included // null' "$REGISTRY")
if [[ "$partner_q" != "null" ]]; then
  echo -e "${GREEN}✓${NC} partner_included question exists"
  PASSED=$((PASSED + 1))
else
  # Check flow for partner handling
  assert_contains "$flow_content" "partner" "Flow handles partner for cohabiting"
fi

# Test 5: partner_healthcare_agent question exists
healthcare_agent=$(jq '.questions.partner_healthcare_agent // null' "$REGISTRY")
if [[ "$healthcare_agent" != "null" ]]; then
  echo -e "${GREEN}✓${NC} partner_healthcare_agent question exists"
  PASSED=$((PASSED + 1))
else
  # Check flow
  assert_contains "$flow_content" "healthcare" "Flow mentions healthcare agent"
fi

# Test 6: partner_financial_agent question exists
financial_agent=$(jq '.questions.partner_financial_agent // null' "$REGISTRY")
if [[ "$financial_agent" != "null" ]]; then
  echo -e "${GREEN}✓${NC} partner_financial_agent question exists"
  PASSED=$((PASSED + 1))
else
  # Check flow
  assert_contains "$flow_content" "financial" "Flow mentions financial agent"
fi

# Test 7: business_entity_type question exists
biz_type=$(jq '.questions.business_entity_type // null' "$REGISTRY")
assert_not_empty "$biz_type" "business_entity_type question exists"

# Test 8: business_entity_type uses numbered_select (C10 - 5+ options)
biz_type_q=$(question_type "business_entity_type")
if [[ "$biz_type_q" == *"numbered"* ]]; then
  echo -e "${GREEN}✓${NC} business_entity_type uses numbered_select (C10)"
  PASSED=$((PASSED + 1))
else
  count=$(question_option_count "business_entity_type")
  if [[ "$count" -ge 5 ]]; then
    echo -e "${RED}✗${NC} business_entity_type ($count options) should use numbered_select"
    FAILED=$((FAILED + 1))
  else
    echo -e "${GREEN}✓${NC} business_entity_type has $count options (select ok)"
    PASSED=$((PASSED + 1))
  fi
fi

# Test 9: business_partners question exists
biz_partners=$(jq '.questions.business_partners // null' "$REGISTRY")
if [[ "$biz_partners" != "null" ]]; then
  echo -e "${GREEN}✓${NC} business_partners question exists"
  PASSED=$((PASSED + 1))
else
  # Check flow
  assert_contains "$flow_content" "partner" "Flow handles business partners"
fi

# Test 10: Flow validates state input
assert_contains "$flow_content" "Validate" "Flow validates state abbreviation"

report
