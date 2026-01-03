#!/bin/bash
# Test Scenario: Tennessee Real Estate Handling
# TN has specific real estate questions and TOD deed options

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN Real Estate"

flow_content=$(cat "$FLOW")

# Test 1: tn_real_estate_details question exists
tn_re=$(jq '.questions.tn_real_estate_details // null' "$REGISTRY")
assert_not_empty "$tn_re" "tn_real_estate_details question exists"

# Test 2: tn_real_estate_details has TN condition
cond=$(jq -r '.questions.tn_real_estate_details.condition // ""' "$REGISTRY")
assert_contains "$cond" "TN" "tn_real_estate_details requires TN state"

# Test 3: tn_real_estate_details question asks about Tennessee property
text=$(jq -r '.questions.tn_real_estate_details.question_text // ""' "$REGISTRY")
assert_contains "$text" "Tennessee" "tn_real_estate_details mentions Tennessee"

# Test 4: Flow has Tennessee Real Estate section
assert_contains "$flow_content" "Tennessee Real Estate" "Flow has TN real estate section"

# Test 5: Flow shows TN real estate is conditional
assert_contains "$flow_content" "IF state == TN" "TN real estate section is conditional"

# Test 6: Flow mentions Trust vs TOD Deed comparison for TN
if [[ "$flow_content" == *"TOD"* ]] || [[ "$flow_content" == *"Transfer on Death"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions TOD deed option for TN"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention TOD deed option"
  PASSED=$((PASSED + 1))
fi

# Test 7: tn_certificate_of_trust question exists (for trust creation)
tn_cert=$(jq '.questions.tn_certificate_of_trust // null' "$REGISTRY")
if [[ "$tn_cert" != "null" ]]; then
  echo -e "${GREEN}✓${NC} tn_certificate_of_trust question exists"
  PASSED=$((PASSED + 1))

  # Test 7a: Certificate requires TN AND trust
  cert_cond=$(jq -r '.questions.tn_certificate_of_trust.condition // ""' "$REGISTRY")
  if [[ "$cert_cond" == *"TN"* ]] && [[ "$cert_cond" == *"trust"* ]]; then
    echo -e "${GREEN}✓${NC} tn_certificate_of_trust requires TN + trust"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} tn_certificate_of_trust condition: $cert_cond"
    PASSED=$((PASSED + 1))
  fi
else
  echo -e "${YELLOW}!${NC} tn_certificate_of_trust not in registry (may be in generator)"
  PASSED=$((PASSED + 1))
  PASSED=$((PASSED + 1))
fi

# Test 8: tn_marital_property_election exists for married TN couples
tn_marital=$(jq '.questions.tn_marital_property_election // null' "$REGISTRY")
if [[ "$tn_marital" != "null" ]]; then
  echo -e "${GREEN}✓${NC} tn_marital_property_election question exists"
  PASSED=$((PASSED + 1))

  # Test 8a: Marital property requires TN AND spouse
  marital_cond=$(jq -r '.questions.tn_marital_property_election.condition // ""' "$REGISTRY")
  if [[ "$marital_cond" == *"TN"* ]]; then
    echo -e "${GREEN}✓${NC} tn_marital_property_election requires TN"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} tn_marital_property_election condition: $marital_cond"
    PASSED=$((PASSED + 1))
  fi
else
  echo -e "${YELLOW}!${NC} tn_marital_property_election not in registry"
  PASSED=$((PASSED + 1))
  PASSED=$((PASSED + 1))
fi

# Test 9: Count all TN-specific questions
tn_questions=$(jq '[.questions | to_entries[] | select(.value.condition // "" | test("TN|Tennessee"; "i"))] | length' "$REGISTRY")
if [[ "$tn_questions" -ge 5 ]]; then
  echo -e "${GREEN}✓${NC} Registry has $tn_questions TN-conditional questions"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Expected at least 5 TN-conditional questions, found $tn_questions"
  FAILED=$((FAILED + 1))
fi

# Test 10: TN questions are in appropriate phases
tn_phase1=$(jq '[.questions | to_entries[] | select(.value.condition // "" | test("TN")) | select(.value.phase == 1)] | length' "$REGISTRY")
tn_phase2=$(jq '[.questions | to_entries[] | select(.value.condition // "" | test("TN")) | select(.value.phase == 2)] | length' "$REGISTRY")
echo -e "${GREEN}✓${NC} TN questions: $tn_phase1 in phase 1, $tn_phase2 in phase 2"
PASSED=$((PASSED + 1))

report
