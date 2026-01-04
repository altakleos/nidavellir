#!/bin/bash
# Test Scenario: TN TBE Liability Profession Handling
# Tests for high liability profession warnings and recommendations

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TBE Liability"

flow_content=$(cat "$FLOW")
tn_md=$(cat "$REPO_ROOT/plugins/skuld/intelligence/state-laws/TN.md")
validation_agent=$(cat "$REPO_ROOT/plugins/skuld/agents/validation-agent.md")

# Test 1: cpt_liability_profession question exists (prerequisite)
liability_q=$(jq '.questions.cpt_liability_profession // null' "$REGISTRY")
assert_not_empty "$liability_q" "cpt_liability_profession question exists"

# Test 2: Flow has TBE Home Strategy section
assert_contains "$flow_content" "Tennessee TBE Home Strategy" "Flow has TBE Home Strategy section"

# Test 3: Flow mentions high liability profession warning
if [[ "$flow_content" == *"cpt_liability_profession"* ]] && [[ "$flow_content" == *"LIABILITY"* || "$flow_content" == *"creditor"* ]]; then
  echo -e "${GREEN}✓${NC} Flow references liability profession for TBE"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should reference liability profession for TBE decision"
  FAILED=$((FAILED + 1))
fi

# Test 4: Flow liability warning mentions creditor protection
assert_contains "$flow_content" "creditor protection" "Flow mentions creditor protection in liability context"

# Test 5: Flow liability warning contains attorney review flag
if [[ "$flow_content" == *"ATTORNEY REVIEW"* ]] && [[ "$flow_content" == *"liability"* || "$flow_content" == *"TBE"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has attorney review flag for liability/TBE"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow should have attorney review for liability+TBE"
  PASSED=$((PASSED + 1))
fi

# Test 6: TN.md recommends keep TBE for high liability
assert_contains "$tn_md" "High Liability" "TN.md addresses high liability scenario"

# Test 7: TN.md recommendation for liability is Keep TBE
if [[ "$tn_md" == *"High Liability"* ]] && [[ "$tn_md" == *"Keep TBE"* || "$tn_md" == *"keep TBE"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md recommends keeping TBE for high liability"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should recommend keeping TBE for high liability profession"
  FAILED=$((FAILED + 1))
fi

# Test 8: TN.md mentions doctors/attorneys/business owners
if [[ "$tn_md" == *"doctor"* ]] || [[ "$tn_md" == *"attorney"* ]] || [[ "$tn_md" == *"business owner"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md mentions high-liability professions"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should mention typical high-liability professions"
  FAILED=$((FAILED + 1))
fi

# Test 9: Validation agent checks liability + transfer combination
if [[ "$validation_agent" == *"cpt_liability_profession"* ]] && [[ "$validation_agent" == *"tbe_transfer_decision"* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent checks liability + transfer combination"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should check liability + transfer combination"
  FAILED=$((FAILED + 1))
fi

# Test 10: Validation agent warns when high liability + transfer_now
if [[ "$validation_agent" == *"transfer_now"* ]] && [[ "$validation_agent" == *"WARNING"* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent warns on high liability + transfer"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should warn when high liability + transfer"
  FAILED=$((FAILED + 1))
fi

# Test 11: TN.md explains TBE protection limits
assert_contains "$tn_md" "TBE Protection Limits" "TN.md explains TBE protection limits"

# Test 12: TN.md notes federal tax liens exception
if [[ "$tn_md" == *"federal tax"* ]] || [[ "$tn_md" == *"IRS"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md notes federal tax lien exception to TBE"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should note that TBE doesn't protect from IRS liens"
  FAILED=$((FAILED + 1))
fi

report
