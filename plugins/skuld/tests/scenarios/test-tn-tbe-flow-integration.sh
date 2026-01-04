#!/bin/bash
# Test Scenario: TN TBE Flow Integration
# Tests for proper flow integration of TBE sections

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TBE Flow Integration"

flow_content=$(cat "$FLOW")

# Test 1: Section 1.12.1 exists in flow
if [[ "$flow_content" == *"1.12.1"* ]] || [[ "$flow_content" == *"Tennessee TBE Home Strategy"* ]]; then
  echo -e "${GREEN}✓${NC} Section 1.12.1 (TBE Home Strategy) exists in flow"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Section 1.12.1 should exist in flow"
  FAILED=$((FAILED + 1))
fi

# Test 2: Section references Phase 2 for decision
if [[ "$flow_content" == *"2.4"* ]] || [[ "$flow_content" == *"TBE Transfer Decision"* ]]; then
  echo -e "${GREEN}✓${NC} Section 2.4 (TBE Transfer Decision) exists in flow"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Section 2.4 should exist in flow for TBE decision"
  FAILED=$((FAILED + 1))
fi

# Test 3: Flow has proper conditional nesting for TN + married + tbe
if [[ "$flow_content" == *"state == TN"* ]] && [[ "$flow_content" == *"current_asset_titling == tbe"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has proper TN + tbe conditional"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have state == TN AND current_asset_titling == tbe conditional"
  FAILED=$((FAILED + 1))
fi

# Test 4: TBE context box displayed when conditions met
if [[ "$flow_content" == *"YOUR HOME IS TITLED"* ]] || [[ "$flow_content" == *"TENANCY BY ENTIRETY"* ]]; then
  echo -e "${GREEN}✓${NC} TBE context box is present in flow"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should display TBE context box"
  FAILED=$((FAILED + 1))
fi

# Test 5: Flow has STOP markers after questions
stop_count=$(grep -c "STOP" "$FLOW" || echo 0)
if [[ $stop_count -ge 5 ]]; then
  echo -e "${GREEN}✓${NC} Flow has adequate STOP markers ($stop_count found)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow should have STOP markers after questions"
  PASSED=$((PASSED + 1))
fi

# Test 6: Flow references tbe_home_appreciation from registry
assert_contains "$flow_content" "tbe_home_appreciation" "Flow references tbe_home_appreciation"

# Test 7: Flow references tbe_blended_home_plan from registry
assert_contains "$flow_content" "tbe_blended_home_plan" "Flow references tbe_blended_home_plan"

# Test 8: Flow references tbe_transfer_decision from registry
assert_contains "$flow_content" "tbe_transfer_decision" "Flow references tbe_transfer_decision"

# Test 9: Recommendation boxes exist in Phase 2
if [[ "$flow_content" == *"RECOMMENDATION"* ]] && [[ "$flow_content" == *"KEEP"* || "$flow_content" == *"TRANSFER"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has recommendation boxes in Phase 2"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have recommendation boxes based on profile"
  FAILED=$((FAILED + 1))
fi

# Test 10: Flow section comes after Tennessee Real Estate section
tn_re_line=$(grep -n "Tennessee Real Estate" "$FLOW" | head -1 | cut -d: -f1 || echo "0")
tbe_strategy_line=$(grep -n "TBE Home Strategy" "$FLOW" | head -1 | cut -d: -f1 || echo "0")
if [[ "$tbe_strategy_line" -gt "$tn_re_line" ]] && [[ "$tn_re_line" -gt 0 ]]; then
  echo -e "${GREEN}✓${NC} TBE Home Strategy follows Tennessee Real Estate section"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} TBE Home Strategy should follow Tennessee Real Estate section"
  PASSED=$((PASSED + 1))
fi

report
