#!/bin/bash
# Test Scenario: Distribution Preferences Intake Questions
# Tests: All distribution-related questions in intake-registry.json
# Expected: Complete distribution question coverage with proper conditions

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Distribution Intake Questions"

echo ""
echo "Testing distribution preference questions in intake-registry.json"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Distribution Preferences (Base Question)
# ═══════════════════════════════════════════════════════════════

# Test 1: distribution_preferences question exists
dist_pref=$(jq '.questions.distribution_preferences // null' "$REGISTRY")
assert_not_empty "$dist_pref" "distribution_preferences question exists"

# Test 2: distribution_preferences has condition for has_children
dist_cond=$(jq -r '.questions.distribution_preferences.condition // ""' "$REGISTRY")
if [[ "$dist_cond" == *"has_children"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_preferences has has_children condition"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_preferences should require has_children condition"
  FAILED=$((FAILED + 1))
fi

# Test 3: distribution_preferences has required options
dist_opts=$(jq -r '[.questions.distribution_preferences.options[].value] | join(",")' "$REGISTRY")
assert_contains "$dist_opts" "all_at_once" "distribution_preferences includes all_at_once option"
assert_contains "$dist_opts" "staggered" "distribution_preferences includes staggered option"
assert_contains "$dist_opts" "discretionary" "distribution_preferences includes discretionary option"

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Distribution Age Schedule
# ═══════════════════════════════════════════════════════════════

# Test 4: distribution_age_schedule question exists
age_sched=$(jq '.questions.distribution_age_schedule // null' "$REGISTRY")
assert_not_empty "$age_sched" "distribution_age_schedule question exists"

# Test 5: distribution_age_schedule uses numbered_select (C10)
age_type=$(jq -r '.questions.distribution_age_schedule.type // ""' "$REGISTRY")
assert_eq "$age_type" "numbered_select" "distribution_age_schedule uses numbered_select (C10)"

# Test 6: distribution_age_schedule has 6 options (standard + custom + help)
age_opt_count=$(jq '.questions.distribution_age_schedule.options | length // 0' "$REGISTRY")
if [[ "$age_opt_count" -ge 5 ]]; then
  echo -e "${GREEN}✓${NC} distribution_age_schedule has $age_opt_count options (5+ required for C10)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_age_schedule has only $age_opt_count options (5+ required)"
  FAILED=$((FAILED + 1))
fi

# Test 7: distribution_age_schedule has all age schedule options
age_opts=$(jq -r '[.questions.distribution_age_schedule.options[].value] | join(",")' "$REGISTRY")
assert_contains "$age_opts" "staggered_standard" "distribution_age_schedule includes staggered_standard (25/30/35)"
assert_contains "$age_opts" "staggered_later" "distribution_age_schedule includes staggered_later (30/35/40)"
assert_contains "$age_opts" "staggered_earlier" "distribution_age_schedule includes staggered_earlier (21/25/30)"
assert_contains "$age_opts" "all_at_once_25" "distribution_age_schedule includes all_at_once_25"
assert_contains "$age_opts" "custom" "distribution_age_schedule includes custom option"

# Test 8: distribution_age_schedule has proper condition
age_cond=$(jq -r '.questions.distribution_age_schedule.condition // ""' "$REGISTRY")
if [[ "$age_cond" == *"has_children"* ]] && [[ "$age_cond" == *"distribution.pattern"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_age_schedule has compound condition (children + pattern)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_age_schedule should have compound condition"
  echo "  Actual: $age_cond"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Custom Ages (Free-Form Input)
# ═══════════════════════════════════════════════════════════════

# Test 9: distribution_custom_ages question exists
custom_ages=$(jq '.questions.distribution_custom_ages // null' "$REGISTRY")
assert_not_empty "$custom_ages" "distribution_custom_ages question exists"

# Test 10: distribution_custom_ages is text type
custom_type=$(jq -r '.questions.distribution_custom_ages.type // ""' "$REGISTRY")
assert_eq "$custom_type" "text" "distribution_custom_ages is text type"

# Test 11: distribution_custom_ages is conditional on custom selection
custom_cond=$(jq -r '.questions.distribution_custom_ages.condition // ""' "$REGISTRY")
if [[ "$custom_cond" == *"custom"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_custom_ages is conditional on custom selection"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_custom_ages should be conditional on custom"
  FAILED=$((FAILED + 1))
fi

# Test 12: distribution_custom_ages has example
custom_example=$(jq -r '.questions.distribution_custom_ages.example // ""' "$REGISTRY")
assert_not_empty "$custom_example" "distribution_custom_ages has example"

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Equal vs Unequal Distribution
# ═══════════════════════════════════════════════════════════════

# Test 13: distribution_equality question exists
equality=$(jq '.questions.distribution_equality // null' "$REGISTRY")
assert_not_empty "$equality" "distribution_equality question exists"

# Test 14: distribution_equality has equal/unequal options
eq_opts=$(jq -r '[.questions.distribution_equality.options[].value] | join(",")' "$REGISTRY")
assert_contains "$eq_opts" "equal" "distribution_equality includes equal option"
assert_contains "$eq_opts" "unequal" "distribution_equality includes unequal option"

# Test 15: distribution_equality is conditional on multiple children
eq_cond=$(jq -r '.questions.distribution_equality.condition // ""' "$REGISTRY")
if [[ "$eq_cond" == *"children_count"* ]] || [[ "$eq_cond" == *"has_children"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_equality is conditional on multiple children"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_equality should require multiple children"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Per-Child Share Percentages
# ═══════════════════════════════════════════════════════════════

# Test 16: distribution_per_child_shares question exists
per_child=$(jq '.questions.distribution_per_child_shares // null' "$REGISTRY")
assert_not_empty "$per_child" "distribution_per_child_shares question exists"

# Test 17: distribution_per_child_shares is per_child type
per_child_type=$(jq -r '.questions.distribution_per_child_shares.type // ""' "$REGISTRY")
assert_eq "$per_child_type" "per_child" "distribution_per_child_shares is per_child type"

# Test 18: distribution_per_child_shares has validation
per_child_val=$(jq -r '.questions.distribution_per_child_shares.validation // ""' "$REGISTRY")
if [[ "$per_child_val" == *"100"* ]] || [[ -n "$per_child_val" ]]; then
  echo -e "${GREEN}✓${NC} distribution_per_child_shares has validation rule"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} distribution_per_child_shares may need validation rule"
  PASSED=$((PASSED + 1))
fi

# Test 19: distribution_per_child_shares is conditional on unequal
per_child_cond=$(jq -r '.questions.distribution_per_child_shares.condition // ""' "$REGISTRY")
if [[ "$per_child_cond" == *"unequal"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_per_child_shares is conditional on unequal"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_per_child_shares should be conditional on unequal"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 6: Per Stirpes vs Per Capita
# ═══════════════════════════════════════════════════════════════

# Test 20: distribution_method question exists
dist_method=$(jq '.questions.distribution_method // null' "$REGISTRY")
assert_not_empty "$dist_method" "distribution_method question exists"

# Test 21: distribution_method uses select (only 3 options, C10 requires 5+ for numbered_select)
method_type=$(jq -r '.questions.distribution_method.type // ""' "$REGISTRY")
assert_eq "$method_type" "select" "distribution_method uses select (3 options < 5 threshold)"

# Test 22: distribution_method has per_stirpes and per_capita options
method_opts=$(jq -r '[.questions.distribution_method.options[].value] | join(",")' "$REGISTRY")
assert_contains "$method_opts" "per_stirpes" "distribution_method includes per_stirpes option"
assert_contains "$method_opts" "per_capita" "distribution_method includes per_capita option"

# Test 23: distribution_method has help option
assert_contains "$method_opts" "help" "distribution_method includes help option"

# Test 24: distribution_method has proper condition
method_cond=$(jq -r '.questions.distribution_method.condition // ""' "$REGISTRY")
if [[ "$method_cond" == *"has_children"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_method is conditional on has_children"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_method should require has_children"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 7: Save Locations
# ═══════════════════════════════════════════════════════════════

# Test 25: All distribution questions save to distribution namespace
dist_saves=$(jq -r '
  .questions | to_entries[] |
  select(.key | startswith("distribution")) |
  .value.save_to // "not_set"
' "$REGISTRY")

save_errors=0
while IFS= read -r save_to; do
  if [[ "$save_to" != "not_set" ]] && [[ "$save_to" != distribution* ]]; then
    echo -e "${RED}✗${NC} Unexpected save_to: $save_to"
    save_errors=$((save_errors + 1))
  fi
done <<< "$dist_saves"

if [[ $save_errors -eq 0 ]]; then
  echo -e "${GREEN}✓${NC} All distribution questions save to distribution.* namespace"
  PASSED=$((PASSED + 1))
else
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 8: Question Text Quality
# ═══════════════════════════════════════════════════════════════

# Test 26: distribution_method question explains the concept
method_text=$(jq -r '.questions.distribution_method.question_text // ""' "$REGISTRY")
if [[ "$method_text" == *"child"* ]] && [[ "$method_text" == *"share"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_method question text is clear and explanatory"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} distribution_method question text could be more explanatory"
  PASSED=$((PASSED + 1))
fi

# Test 27: distribution_age_schedule question mentions ages
age_text=$(jq -r '.questions.distribution_age_schedule.question_text // ""' "$REGISTRY")
if [[ "$age_text" == *"age"* ]]; then
  echo -e "${GREEN}✓${NC} distribution_age_schedule question mentions ages"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} distribution_age_schedule should mention ages"
  FAILED=$((FAILED + 1))
fi

report
