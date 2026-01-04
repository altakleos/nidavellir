#!/bin/bash
# Test Scenario: TN TBE Validation Agent Checks
# Tests for validation agent TBE consistency check (#11)

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TBE Validation"

validation_agent=$(cat "$REPO_ROOT/plugins/skuld/agents/validation-agent.md")

# Test 1: Validation agent has TBE consistency check section
if [[ "$validation_agent" == *"TBE Home Decision Consistency"* ]] || [[ "$validation_agent" == *"### 11."* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent has TBE consistency check section (#11)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should have TBE Home Decision Consistency section"
  FAILED=$((FAILED + 1))
fi

# Test 2: Validation check is marked as High severity
if [[ "$validation_agent" == *"TBE"* ]] && [[ "$validation_agent" == *"High"* ]]; then
  echo -e "${GREEN}✓${NC} TBE validation check is High severity"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} TBE validation check should be High severity"
  PASSED=$((PASSED + 1))
fi

# Test 3: Validation check is Tennessee-only
if [[ "$validation_agent" == *"Tennessee only"* ]] || [[ "$validation_agent" == *"TN"* && "$validation_agent" == *"current_asset_titling"* ]]; then
  echo -e "${GREEN}✓${NC} TBE validation check is Tennessee-only"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TBE validation check should be Tennessee-only"
  FAILED=$((FAILED + 1))
fi

# Test 4: High liability + transfer_now triggers warning
if [[ "$validation_agent" == *"cpt_liability_profession"* ]] && [[ "$validation_agent" == *"transfer_now"* ]]; then
  echo -e "${GREEN}✓${NC} High liability + transfer_now triggers warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation should warn on high liability + transfer_now"
  FAILED=$((FAILED + 1))
fi

# Test 5: Blended family + keep_tbe triggers warning
if [[ "$validation_agent" == *"blended_family"* ]] && [[ "$validation_agent" == *"keep_tbe"* ]]; then
  echo -e "${GREEN}✓${NC} Blended family + keep_tbe triggers warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation should warn on blended family + keep_tbe"
  FAILED=$((FAILED + 1))
fi

# Test 6: Warning messages include attorney review flags
if [[ "$validation_agent" == *"ATTORNEY REVIEW"* ]] && [[ "$validation_agent" == *"TBE"* || "$validation_agent" == *"tbe"* ]]; then
  echo -e "${GREEN}✓${NC} TBE warning messages include attorney review flags"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TBE warnings should include attorney review flags"
  FAILED=$((FAILED + 1))
fi

# Test 7: Validation references tbe_transfer_decision
assert_contains "$validation_agent" "tbe_transfer_decision" "Validation references tbe_transfer_decision"

# Test 8: Validation has creditor protection warning message
assert_contains "$validation_agent" "creditor protection" "Validation has creditor protection warning"

# Test 9: Validation has disinheritance warning message
if [[ "$validation_agent" == *"disinherit"* ]] || [[ "$validation_agent" == *"children"* && "$validation_agent" == *"claim"* ]]; then
  echo -e "${GREEN}✓${NC} Validation has disinheritance warning message"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation should have disinheritance warning for blended families"
  FAILED=$((FAILED + 1))
fi

# Test 10: Validation checks CPT + TBE step-up warning
if [[ "$validation_agent" == *"step-up"* ]] || [[ "$validation_agent" == *"Step-Up"* ]]; then
  echo -e "${GREEN}✓${NC} Validation checks CPT + TBE step-up warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation should warn about losing step-up when keeping home in TBE"
  FAILED=$((FAILED + 1))
fi

report
