#!/bin/bash
# Test C6: State Input as Text Abbreviation
# State uses text input for 2-letter abbreviations, not selection

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C6: State Text Input"

# Test 1: state_of_residence is type=text
type=$(question_type "state_of_residence")
assert_eq "$type" "text" "state_of_residence is type text"

# Test 2: state_of_residence has no options (text input)
has_options=$(jq '.questions.state_of_residence | has("options")' "$REGISTRY")
assert_eq "$has_options" "false" "state_of_residence has no options"

# Test 3: state_of_residence has example showing abbreviations
example=$(jq -r '.questions.state_of_residence.example // ""' "$REGISTRY")
assert_contains "$example" "TN" "Example includes TN abbreviation"

# Test 4: Question has C8 constraint (text input)
has_c8=$(question_has_constraint "state_of_residence" "C8")
assert_eq "$has_c8" "true" "state_of_residence tagged with C8 (text input)"

# Test 5: Note mentions validation and TN
note=$(jq -r '.questions.state_of_residence.note // ""' "$REGISTRY")
assert_contains "$note" "TN" "Note mentions TN for CPT"

# Test 6: SKILL.md documents C6 as text abbreviation
skill_content=$(cat "$SKILL")
assert_contains "$skill_content" "C6:" "SKILL.md documents C6 constraint"
assert_contains "$skill_content" "text input" "SKILL.md explains text input"

# Test 7: Flow shows text prompt for state
flow_content=$(cat "$FLOW")
assert_contains "$flow_content" "type: text" "Flow shows state as text type"

report
