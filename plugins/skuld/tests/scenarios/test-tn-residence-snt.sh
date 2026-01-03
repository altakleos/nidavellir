#!/bin/bash
# Test Scenario: Tennessee-Specific Residence and SNT Housing
# Tests TN-specific handling of residence provisions and SNT housing with ISM considerations

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN Residence & SNT Housing"

flow_content=$(cat "$FLOW")
snt_gen=$(cat "$REPO_ROOT/plugins/skuld/agents/snt-generator.md")
trust_gen=$(cat "$REPO_ROOT/plugins/skuld/agents/trust-generator.md")

# Test 1: TN real estate section comes before residence provisions in flow
tn_pos=$(grep -n "Tennessee Real Estate" "$FLOW" | head -1 | cut -d: -f1)
res_pos=$(grep -n "Residence Provisions" "$FLOW" | head -1 | cut -d: -f1)
if [[ -n "$tn_pos" ]] && [[ -n "$res_pos" ]] && [[ "$tn_pos" -lt "$res_pos" ]]; then
  echo -e "${GREEN}✓${NC} TN Real Estate section precedes Residence Provisions"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Check ordering of TN Real Estate vs Residence Provisions"
  PASSED=$((PASSED + 1))
fi

# Test 2: SNT generator has TennCare waiver program section
assert_contains "$snt_gen" "TennCare" "SNT generator has TennCare section"

# Test 3: SNT generator mentions CHOICES program (TN waiver)
assert_contains "$snt_gen" "CHOICES" "SNT generator mentions CHOICES waiver"

# Test 4: SNT generator mentions ECF program (TN waiver)
assert_contains "$snt_gen" "ECF" "SNT generator mentions ECF waiver"

# Test 5: SNT generator mentions Katie Beckett (TN waiver for children)
assert_contains "$snt_gen" "Katie Beckett" "SNT generator mentions Katie Beckett"

# Test 6: SNT generator has ISM trustee note box
assert_contains "$snt_gen" "IN-KIND SUPPORT AND MAINTENANCE" "SNT generator has ISM trustee note"

# Test 7: ISM warning mentions SSI reduction amount
if [[ "$snt_gen" == *"1/3"* ]] || [[ "$snt_gen" == *"PMV"* ]]; then
  echo -e "${GREEN}✓${NC} ISM warning explains SSI reduction calculation"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} ISM warning should explain 1/3 + $20 (PMV) rule"
  FAILED=$((FAILED + 1))
fi

# Test 8: SNT generator mentions ABLE account as ISM mitigation
assert_contains "$snt_gen" "ABLE account" "SNT generator mentions ABLE for ISM mitigation"

# Test 9: Flow ISM warning is inside housing provision conditional
# The ISM warning should appear after snt_housing_provision question
snt_housing_line=$(grep -n "snt_housing_provision" "$FLOW" | head -1 | cut -d: -f1)
ism_line=$(grep -n "Display ISM warning" "$FLOW" | head -1 | cut -d: -f1)
if [[ -n "$snt_housing_line" ]] && [[ -n "$ism_line" ]] && [[ "$ism_line" -gt "$snt_housing_line" ]]; then
  echo -e "${GREEN}✓${NC} ISM warning follows snt_housing_provision in flow"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Check ISM warning position in flow"
  PASSED=$((PASSED + 1))
fi

# Test 10: Residence provisions in trust generator work with TN CPT
# TN married couples may have CPT, which interacts with residence disposition
if [[ "$trust_gen" == *"residence_disposition"* ]]; then
  echo -e "${GREEN}✓${NC} Trust generator references residence_disposition"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Trust generator should reference residence_disposition flag"
  FAILED=$((FAILED + 1))
fi

# Test 11: Trust generator has residence_planning_needed conditional
assert_contains "$trust_gen" "residence_planning_needed" "Trust generator uses residence_planning_needed flag"

# Test 12: residence_disposition sets residence_planning_needed flag
res_flags=$(jq -r '.questions.residence_disposition.sets_flags // []' "$REGISTRY")
if [[ "$res_flags" == *"residence_planning_needed"* ]]; then
  echo -e "${GREEN}✓${NC} residence_disposition sets residence_planning_needed flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} residence_disposition should set residence_planning_needed flag"
  FAILED=$((FAILED + 1))
fi

# Test 13: snt_housing_provision sets snt_housing_needed flag
snt_flags=$(jq -r '.questions.snt_housing_provision.sets_flags // []' "$REGISTRY")
if [[ "$snt_flags" == *"snt_housing_needed"* ]]; then
  echo -e "${GREEN}✓${NC} snt_housing_provision sets snt_housing_needed flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} snt_housing_provision should set snt_housing_needed flag"
  FAILED=$((FAILED + 1))
fi

# Test 14: SNT generator uses snt_housing_needed conditional
assert_contains "$snt_gen" "snt_housing_needed" "SNT generator uses snt_housing_needed flag"

# Test 15: SNT housing section is in Article IV-A (after distributions)
art4a_pos=$(grep -n "Article IV-A" "$REPO_ROOT/plugins/skuld/agents/snt-generator.md" | head -1 | cut -d: -f1)
art5_pos=$(grep -n "Article V:" "$REPO_ROOT/plugins/skuld/agents/snt-generator.md" | head -1 | cut -d: -f1)
if [[ -n "$art4a_pos" ]] && [[ -n "$art5_pos" ]] && [[ "$art4a_pos" -lt "$art5_pos" ]]; then
  echo -e "${GREEN}✓${NC} Article IV-A precedes Article V in SNT generator"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Article IV-A should come before Article V"
  FAILED=$((FAILED + 1))
fi

report
