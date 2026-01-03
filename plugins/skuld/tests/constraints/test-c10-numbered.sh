#!/bin/bash
# Test C10: Numbered Selection for 5+ Options
# Questions with 5+ options MUST use numbered_select, not AskUserQuestion

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C10: Numbered Selection"

# Test 1: No questions with 5+ options using plain select type
violations_over=$(jq '[
  .questions | to_entries[] |
  select(.value.options != null) |
  select(.value.options | length >= 5) |
  select(.value.type == "select" or .value.type == "multi_select")
] | length' "$REGISTRY")
assert_eq "$violations_over" "0" "No 5+ option questions using plain select"

# Test 2: No numbered_select questions with fewer than 5 options
violations_under=$(jq '[
  .questions | to_entries[] |
  select(.value.type | test("numbered"; "i")) |
  select(.value.options | length < 5)
] | length' "$REGISTRY")
assert_eq "$violations_under" "0" "No numbered_select with < 5 options"

# Test 3: Known 5+ option questions use numbered_select
# marital_status (6), business_entity_type (7)
# Note: state_of_residence is now text input (C6)
for q in marital_status business_entity_type; do
  type=$(question_type "$q")
  count=$(question_option_count "$q")
  if [[ "$count" -ge 5 ]]; then
    if [[ "$type" == *"numbered"* ]]; then
      echo -e "${GREEN}✓${NC} $q ($count options) uses numbered_select"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} $q ($count options) should use numbered_select, got $type"
      FAILED=$((FAILED + 1))
    fi
  fi
done

# Test 4: Questions with exactly 4 options do NOT use numbered_select
four_option_numbered=$(jq '[
  .questions | to_entries[] |
  select(.value.options | length == 4) |
  select(.value.type | test("numbered"; "i"))
] | length' "$REGISTRY")
assert_eq "$four_option_numbered" "0" "4-option questions don't use numbered_select"

# Test 5: All numbered_select questions have C10 constraint tag
numbered_without_c10=$(jq '[
  .questions | to_entries[] |
  select(.value.type | test("numbered"; "i")) |
  select((.value.constraints // []) | contains(["C10"]) | not)
] | .[].key' "$REGISTRY" 2>/dev/null | wc -l)
assert_eq "$numbered_without_c10" "0" "All numbered_select tagged with C10"

# Test 6: SKILL.md documents C10 constraint
skill_content=$(cat "$SKILL")
assert_contains "$skill_content" "C10:" "SKILL.md documents C10 constraint"

report
