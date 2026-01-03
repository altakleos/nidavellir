#!/bin/bash
# Test C8: Text Input Uses Direct Markdown Prompting ONLY
# Free-form text questions MUST use type=text, NOT AskUserQuestion with fake options

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C8: Text Input Handling"

# Test 1: personal_name_dob is type=text
type=$(question_type "personal_name_dob")
assert_eq "$type" "text" "personal_name_dob is type text"

# Test 2: personal_name_dob has no options field
has_options=$(jq '.questions.personal_name_dob | has("options")' "$REGISTRY")
assert_eq "$has_options" "false" "personal_name_dob has no options"

# Test 3: personal_name_dob has C8 constraint tag
has_c8=$(question_has_constraint "personal_name_dob" "C8")
assert_eq "$has_c8" "true" "personal_name_dob tagged with C8"

# Test 4: No select questions have fake text option patterns
# Check for patterns like "I'll type", "Skip for now" in non-OTHER options
# Note: "I'll type my state" in an OTHER option is legitimate (leads to follow-up)
fake_count=$(jq '[
  .questions | to_entries[] |
  select(.value.options != null) |
  .value.options[] |
  select(.value != "OTHER") |
  select(.label | test("I.ll type|Skip for now|Enter my own|Type my"; "i"))
] | length' "$REGISTRY")
assert_eq "$fake_count" "0" "No fake text options in non-OTHER select options"

# Test 5: Flow shows text questions use direct markdown
flow_content=$(cat "$FLOW")
assert_contains "$flow_content" "type: text" "Flow documents text type questions"

# Test 6: SKILL.md documents C8 constraint
skill_content=$(cat "$SKILL")
assert_contains "$skill_content" "C8:" "SKILL.md documents C8 constraint"
assert_contains "$skill_content" "Direct markdown prompt" "SKILL.md explains direct prompting"

report
