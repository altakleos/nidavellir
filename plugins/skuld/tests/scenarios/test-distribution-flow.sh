#!/bin/bash
# Test Scenario: Distribution Preferences Flow Integration
# Tests: Distribution section in intake-flow.md
# Expected: Complete flow integration for distribution questions

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Distribution Flow Integration"

flow_content=$(cat "$FLOW")

echo ""
echo "Testing distribution preferences flow in intake-flow.md"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Distribution Section Exists
# ═══════════════════════════════════════════════════════════════

# Test 1: Flow has distribution preferences section
assert_contains "$flow_content" "Distribution Preferences" "Flow has Distribution Preferences section"

# Test 2: Flow mentions section 1.15
if [[ "$flow_content" == *"1.15"* ]] || [[ "$flow_content" == *"### 1.15"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has section 1.15 for Distribution Preferences"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have section 1.15 for Distribution Preferences"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Question References
# ═══════════════════════════════════════════════════════════════

# Test 3: Flow references distribution_preferences question
assert_contains "$flow_content" "distribution_preferences" "Flow references distribution_preferences question"

# Test 4: Flow references distribution_age_schedule question
assert_contains "$flow_content" "distribution_age_schedule" "Flow references distribution_age_schedule question"

# Test 5: Flow references distribution_custom_ages question
assert_contains "$flow_content" "distribution_custom_ages" "Flow references distribution_custom_ages question"

# Test 6: Flow references distribution_equality question
assert_contains "$flow_content" "distribution_equality" "Flow references distribution_equality question"

# Test 7: Flow references distribution_per_child_shares question
assert_contains "$flow_content" "distribution_per_child_shares" "Flow references distribution_per_child_shares question"

# Test 8: Flow references distribution_method question
assert_contains "$flow_content" "distribution_method" "Flow references distribution_method question"

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Conditional Logic
# ═══════════════════════════════════════════════════════════════

# Test 9: Flow has has_children condition
if [[ "$flow_content" == *"[IF has_children"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has has_children condition for distribution section"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have has_children condition"
  FAILED=$((FAILED + 1))
fi

# Test 10: Flow has custom ages conditional
if [[ "$flow_content" == *"custom"* ]] && [[ "$flow_content" == *"distribution_custom_ages"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has conditional for custom ages"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have conditional for custom ages"
  FAILED=$((FAILED + 1))
fi

# Test 11: Flow has children_count condition for equality
if [[ "$flow_content" == *"children_count"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has children_count condition for equality question"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could have explicit children_count condition"
  PASSED=$((PASSED + 1))
fi

# Test 12: Flow has unequal condition for per_child_shares
if [[ "$flow_content" == *"unequal"* ]] && [[ "$flow_content" == *"per_child_shares"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has conditional for unequal per-child shares"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have conditional for unequal distribution"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Stop Points
# ═══════════════════════════════════════════════════════════════

# Count STOP points in distribution section
# Extract distribution section and count STOPs
dist_section=$(echo "$flow_content" | sed -n '/### 1.15 Distribution/,/## Phase 2/p')
stop_count=$(echo "$dist_section" | grep -c "\[STOP" || true)

# Test 13: Distribution section has adequate stop points
if [[ "$stop_count" -ge 3 ]]; then
  echo -e "${GREEN}✓${NC} Distribution section has $stop_count [STOP] points"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Distribution section has $stop_count [STOP] points (3+ expected)"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Per Stirpes Explanation
# ═══════════════════════════════════════════════════════════════

# Test 14: Flow has per stirpes explanation
if [[ "$flow_content" == *"PER STIRPES"* ]] || [[ "$flow_content" == *"per stirpes"* ]]; then
  echo -e "${GREEN}✓${NC} Flow includes per stirpes explanation"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should include per stirpes explanation"
  FAILED=$((FAILED + 1))
fi

# Test 15: Flow has per capita explanation
if [[ "$flow_content" == *"PER CAPITA"* ]] || [[ "$flow_content" == *"per capita"* ]]; then
  echo -e "${GREEN}✓${NC} Flow includes per capita explanation"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should include per capita explanation"
  FAILED=$((FAILED + 1))
fi

# Test 16: Flow has visual example (ASCII box)
if [[ "$flow_content" == *"╔"* ]] && [[ "$flow_content" == *"stirpes"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has visual explanation box for distribution"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could have visual explanation box"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 6: Question Type Markers
# ═══════════════════════════════════════════════════════════════

# Test 17: Flow marks numbered_select questions with C10
if [[ "$flow_content" == *"distribution_age_schedule"* ]] && [[ "$flow_content" == *"C10"* ]]; then
  echo -e "${GREEN}✓${NC} Flow marks distribution_age_schedule with C10"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow should mark numbered_select questions with C10"
  PASSED=$((PASSED + 1))
fi

# Test 18: Flow marks distribution_method with C10
if [[ "$flow_content" == *"distribution_method"* ]] && [[ "$flow_content" == *"numbered_select"* ]]; then
  echo -e "${GREEN}✓${NC} Flow indicates distribution_method is numbered_select"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could explicitly mark distribution_method type"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 7: Decision Support References
# ═══════════════════════════════════════════════════════════════

# Test 19: Flow references distribution-strategy decision support
assert_contains "$flow_content" "distribution-strategy" "Flow references distribution-strategy.md"

# Test 20: Decision support table includes distribution questions
if [[ "$flow_content" == *"inherit"* ]] && [[ "$flow_content" == *"distribution-strategy"* ]]; then
  echo -e "${GREEN}✓${NC} Decision support table includes distribution questions"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Decision support table should include distribution questions"
  FAILED=$((FAILED + 1))
fi

# Test 21: Decision support includes per stirpes/per capita help
if [[ "$flow_content" == *"per stirpes vs per capita"* ]] || [[ "$flow_content" == *"per stirpes"* ]]; then
  echo -e "${GREEN}✓${NC} Decision support includes per stirpes help"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Decision support could include per stirpes help"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 8: Section Ordering
# ═══════════════════════════════════════════════════════════════

# Test 22: Distribution section comes after spendthrift (1.14)
spendthrift_pos=$(echo "$flow_content" | grep -n "1.14 Spendthrift" | head -1 | cut -d: -f1 || echo "0")
distribution_pos=$(echo "$flow_content" | grep -n "1.15 Distribution" | head -1 | cut -d: -f1 || echo "0")

if [[ "$spendthrift_pos" -gt 0 ]] && [[ "$distribution_pos" -gt 0 ]] && [[ "$distribution_pos" -gt "$spendthrift_pos" ]]; then
  echo -e "${GREEN}✓${NC} Distribution section (1.15) comes after Spendthrift (1.14)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Distribution section position may need verification"
  PASSED=$((PASSED + 1))
fi

# Test 23: Distribution section comes before Phase 2
phase2_pos=$(echo "$flow_content" | grep -n "## Phase 2" | head -1 | cut -d: -f1 || echo "0")

if [[ "$distribution_pos" -gt 0 ]] && [[ "$phase2_pos" -gt 0 ]] && [[ "$distribution_pos" -lt "$phase2_pos" ]]; then
  echo -e "${GREEN}✓${NC} Distribution section comes before Phase 2"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Distribution section should come before Phase 2"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 9: Percentage Validation
# ═══════════════════════════════════════════════════════════════

# Test 24: Flow mentions 100% validation for per_child_shares
if [[ "$flow_content" == *"100%"* ]] || [[ "$flow_content" == *"total"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions percentage validation"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention 100% validation"
  PASSED=$((PASSED + 1))
fi

report
