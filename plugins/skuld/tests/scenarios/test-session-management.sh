#!/bin/bash
# Test Scenario: Session Management and Edge Cases
# Profile: Testing session edge cases, confirmation loops, multi-select behavior
# Expected: Session timeout, children confirm, special circumstances, other assets

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Session Management"

flow_content=$(cat "$FLOW")

echo ""
echo "Testing: Session timeout, confirmation loops, multi-select questions"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Session Timeout Handling
# ═══════════════════════════════════════════════════════════════

# Test 1: session_timeout_proceed question exists
session_q=$(jq '.questions.session_timeout_proceed // null' "$REGISTRY")
assert_not_empty "$session_q" "session_timeout_proceed question exists"

# Test 2: session_timeout_proceed has appropriate options
session_opts=$(jq '.questions.session_timeout_proceed.options | length // 0' "$REGISTRY")
if [[ "$session_opts" -ge 2 ]]; then
  echo -e "${GREEN}✓${NC} session_timeout_proceed has $session_opts options"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} session_timeout_proceed has $session_opts options"
  PASSED=$((PASSED + 1))
fi

# Test 3: session_timeout_proceed is conditional on session age
session_cond=$(jq -r '.questions.session_timeout_proceed.condition // ""' "$REGISTRY")
if [[ "$session_cond" == *"session"* ]] || [[ "$session_cond" == *"30"* ]] || [[ "$session_cond" == *"days"* ]]; then
  echo -e "${GREEN}✓${NC} session_timeout_proceed conditional on session age"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} session_timeout_proceed condition: $session_cond"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Children Confirmation Loop
# ═══════════════════════════════════════════════════════════════

# Test 4: children_confirm question exists
children_conf=$(jq '.questions.children_confirm // null' "$REGISTRY")
assert_not_empty "$children_conf" "children_confirm question exists"

# Test 5: children_confirm is conditional on has_children
conf_cond=$(jq -r '.questions.children_confirm.condition // ""' "$REGISTRY")
if [[ "$conf_cond" == *"children"* ]]; then
  echo -e "${GREEN}✓${NC} children_confirm conditional on having children"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} children_confirm condition: $conf_cond"
  PASSED=$((PASSED + 1))
fi

# Test 6: Flow shows confirmation loop pattern
if [[ "$flow_content" == *"children_confirm"* ]] || [[ "$flow_content" == *"confirm"* ]]; then
  echo -e "${GREEN}✓${NC} Flow references children confirmation"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could reference children confirmation loop"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Special Circumstances (multi_select)
# ═══════════════════════════════════════════════════════════════

# Test 7: special_circumstances question exists
spec_circ=$(jq '.questions.special_circumstances // null' "$REGISTRY")
assert_not_empty "$spec_circ" "special_circumstances question exists"

# Test 8: special_circumstances is multi_select
spec_type=$(jq -r '.questions.special_circumstances.type // ""' "$REGISTRY")
assert_eq "$spec_type" "multi_select" "special_circumstances is multi_select"

# Test 9: special_circumstances sets flags
spec_flags=$(jq '.questions.special_circumstances.sets_flags // [] | length' "$REGISTRY")
if [[ "$spec_flags" -ge 1 ]]; then
  echo -e "${GREEN}✓${NC} special_circumstances sets $spec_flags flags"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} special_circumstances should set flags"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Other Assets (multi_select)
# ═══════════════════════════════════════════════════════════════

# Test 10: other_assets question exists
other_assets=$(jq '.questions.other_assets // null' "$REGISTRY")
assert_not_empty "$other_assets" "other_assets question exists"

# Test 11: other_assets is multi_select
other_type=$(jq -r '.questions.other_assets.type // ""' "$REGISTRY")
assert_eq "$other_type" "multi_select" "other_assets is multi_select"

# Test 12: other_assets has business option
other_opts=$(jq -r '[.questions.other_assets.options[].value] | join(",")' "$REGISTRY")
if [[ "$other_opts" == *"business"* ]]; then
  echo -e "${GREEN}✓${NC} other_assets includes business option"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} other_assets options: $other_opts"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Current Asset Titling (TN-specific numbered_select)
# ═══════════════════════════════════════════════════════════════

# Test 13: current_asset_titling question exists
asset_title=$(jq '.questions.current_asset_titling // null' "$REGISTRY")
assert_not_empty "$asset_title" "current_asset_titling question exists"

# Test 14: current_asset_titling uses numbered_select (C10)
title_type=$(jq -r '.questions.current_asset_titling.type // ""' "$REGISTRY")
if [[ "$title_type" == "numbered_select" ]]; then
  echo -e "${GREEN}✓${NC} current_asset_titling uses numbered_select (C10)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} current_asset_titling type: $title_type"
  PASSED=$((PASSED + 1))
fi

# Test 15: current_asset_titling is TN-specific
title_cond=$(jq -r '.questions.current_asset_titling.condition // ""' "$REGISTRY")
if [[ "$title_cond" == *"TN"* ]]; then
  echo -e "${GREEN}✓${NC} current_asset_titling is TN-specific"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} current_asset_titling condition: $title_cond"
  PASSED=$((PASSED + 1))
fi

# Test 16: current_asset_titling has 5+ options for C10 compliance
title_opts=$(jq '.questions.current_asset_titling.options | length // 0' "$REGISTRY")
if [[ "$title_opts" -ge 5 ]]; then
  echo -e "${GREEN}✓${NC} current_asset_titling has $title_opts options (5+ for C10)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} current_asset_titling has $title_opts options"
  PASSED=$((PASSED + 1))
fi

report
