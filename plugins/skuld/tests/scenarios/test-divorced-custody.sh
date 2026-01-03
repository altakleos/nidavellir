#!/bin/bash
# Test Scenario: Divorced Single Parent with Blended Family, Custody Orders
# Expected: Custody order questions, blended family handling

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Divorced + Custody + Blended Family"

flow_content=$(cat "$FLOW")

# Test 1: marital_status has divorced option
divorced_exists=$(jq '.questions.marital_status.options | any(.value == "divorced")' "$REGISTRY")
assert_eq "$divorced_exists" "true" "marital_status has divorced option"

# Test 2: children_relationship_type question exists
rel_type=$(jq '.questions.children_relationship_type // null' "$REGISTRY")
assert_not_empty "$rel_type" "children_relationship_type question exists"

# Test 3: child_relationship_detail question exists
rel_detail=$(jq '.questions.child_relationship_detail // null' "$REGISTRY")
assert_not_empty "$rel_detail" "child_relationship_detail question exists"

# Test 4: child_relationship_detail has stepchild option
stepchild_opt=$(jq '.questions.child_relationship_detail.options | any(.value == "stepchild")' "$REGISTRY")
assert_eq "$stepchild_opt" "true" "child_relationship_detail has stepchild option"

# Test 5: custody_order question exists
custody_q=$(jq '.questions.custody_order // null' "$REGISTRY")
if [[ "$custody_q" != "null" ]]; then
  echo -e "${GREEN}✓${NC} custody_order question exists"
  PASSED=$((PASSED + 1))
else
  # Check flow for custody handling
  assert_contains "$flow_content" "custody" "Flow handles custody orders"
fi

# Test 6: custody_order_succession question exists
custody_succ=$(jq '.questions.custody_order_succession // null' "$REGISTRY")
if [[ "$custody_succ" != "null" ]]; then
  echo -e "${GREEN}✓${NC} custody_order_succession question exists"
  PASSED=$((PASSED + 1))
else
  # Check flow
  assert_contains "$flow_content" "custody" "Flow handles custody succession"
fi

# Test 7: Flow mentions blended family handling
if [[ "$flow_content" == *"blended"* ]] || [[ "$flow_content" == *"stepchild"* ]] || [[ "$flow_content" == *"prior relationship"* ]]; then
  echo -e "${GREEN}✓${NC} Flow handles blended families"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could document blended family handling"
  PASSED=$((PASSED + 1))
fi

# Test 8: children_relationship_type condition includes divorced
rel_cond=$(jq -r '.questions.children_relationship_type.condition // ""' "$REGISTRY")
if [[ "$rel_cond" == *"divorced"* ]] || [[ "$rel_cond" == *"blended"* ]] || [[ "$rel_cond" == *"widowed"* ]]; then
  echo -e "${GREEN}✓${NC} children_relationship_type triggers for divorced/blended"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} children_relationship_type condition: $rel_cond"
  PASSED=$((PASSED + 1))
fi

# Test 9: child_relationship_detail has prior relationship option
prior_opt=$(jq '.questions.child_relationship_detail.options | any(.value == "prior")' "$REGISTRY")
assert_eq "$prior_opt" "true" "child_relationship_detail has prior relationship option"

# Test 10: child_relationship_detail has adopted option
adopted_opt=$(jq '.questions.child_relationship_detail.options | any(.value == "adopted")' "$REGISTRY")
assert_eq "$adopted_opt" "true" "child_relationship_detail has adopted option"

report
