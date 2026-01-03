#!/bin/bash
# Test C4: Guardian Required for Minor Children
# If has_minor_children = true, MUST ask for guardian

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C4: Guardian Required for Minors"

flow_content=$(cat "$FLOW")

# Test 1: Flow contains primary guardian prompt
assert_contains "$flow_content" "Primary guardian" "Flow has primary guardian prompt"

# Test 2: Flow contains backup guardian prompt
assert_contains "$flow_content" "Backup guardian" "Flow has backup guardian prompt"

# Test 3: Guardian section is conditional on minor children
assert_contains "$flow_content" "has_minor_children == true" "Guardian conditional on minors"

# Test 4: guardian_preferences question exists in registry (if present)
guardian_q=$(jq '.questions.guardian_preferences // null' "$REGISTRY")
if [[ "$guardian_q" != "null" ]]; then
  cond=$(jq -r '.questions.guardian_preferences.condition // ""' "$REGISTRY")
  assert_contains "$cond" "has_minor_children" "guardian_preferences requires minor children"
else
  echo -e "${YELLOW}!${NC} guardian_preferences not in registry (uses direct prompt)"
  PASSED=$((PASSED + 1))
fi

# Test 5: SKILL.md documents C4 constraint
skill_content=$(cat "$SKILL")
assert_contains "$skill_content" "C4:" "SKILL.md documents C4 constraint"

report
