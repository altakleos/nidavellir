#!/bin/bash
# Test C1: Children Question Format
# The children question MUST have exactly 2 options: Yes, No
# DO NOT add age categories (minor/adult/both)

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C1: Children Question Format"

# Test 1: has_children must have exactly 2 options
count=$(question_option_count "has_children")
assert_eq "$count" "2" "has_children has exactly 2 options"

# Test 2: Options must be exactly "yes" and "no"
values=$(question_option_values "has_children")
assert_eq "$values" '["no","yes"]' "has_children options are yes/no only"

# Test 3: Labels should be simple Yes/No (no age categories)
labels=$(jq '[.questions.has_children.options[].label]' "$REGISTRY")
assert_contains "$labels" "Yes" "has Yes label"
assert_contains "$labels" "No" "has No label"

# Test 4: No age-related words in labels
labels_text=$(jq -r '.questions.has_children.options[].label' "$REGISTRY")
if [[ "$labels_text" == *"minor"* ]] || [[ "$labels_text" == *"adult"* ]] || [[ "$labels_text" == *"age"* ]]; then
  echo -e "${RED}✗${NC} Labels should not contain age categories"
  FAILED=$((FAILED + 1))
else
  echo -e "${GREEN}✓${NC} Labels do not contain age categories"
  PASSED=$((PASSED + 1))
fi

# Test 5: Question has C1 constraint tag
has_c1=$(question_has_constraint "has_children" "C1")
assert_eq "$has_c1" "true" "has_children is tagged with C1 constraint"

report
