#!/bin/bash
# Test Scenario: /skuld:ask Command
# Tests for the estate planning Q&A command

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: /skuld:ask Command"

# Define paths
ASK_CMD="$REPO_ROOT/plugins/skuld/commands/ask.md"

# Test 1: Command file exists
if [[ -f "$ASK_CMD" ]]; then
  echo -e "${GREEN}✓${NC} Command file exists at commands/ask.md"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command file should exist at commands/ask.md"
  FAILED=$((FAILED + 1))
  report
  exit 1
fi

ask_content=$(cat "$ASK_CMD")
skill_content=$(cat "$SKILL")

# Test 2: Command has correct frontmatter name
if [[ "$ask_content" == *"name: skuld:ask"* ]]; then
  echo -e "${GREEN}✓${NC} Command has correct frontmatter name (skuld:ask)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should have name: skuld:ask in frontmatter"
  FAILED=$((FAILED + 1))
fi

# Test 3: Command references read-before-generate protocol
assert_contains "$ask_content" "Read-Before-Generate" "Command references read-before-generate protocol"

# Test 4: Command references profile validation
assert_contains "$ask_content" "client_profile.json" "Command references profile validation"

# Test 5: Command references glossary modules
assert_contains "$ask_content" "intelligence/glossary" "Command references glossary modules"

# Test 6: Command references tax modules
assert_contains "$ask_content" "intelligence/tax" "Command references tax modules"

# Test 7: Command references specialized topics
assert_contains "$ask_content" "intelligence/specialized" "Command references specialized topics"

# Test 8: Command has --no-context flag
assert_contains "$ask_content" "--no-context" "Command has --no-context flag"

# Test 9: Command has /lookup routing rule
if [[ "$ask_content" == *"/skuld:lookup"* ]] || [[ "$ask_content" == *"lookup"* ]]; then
  echo -e "${GREEN}✓${NC} Command has /lookup routing rule"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should reference /lookup for state requirements"
  FAILED=$((FAILED + 1))
fi

# Test 10: Command has professional boundary section
assert_contains "$ask_content" "Professional Boundaries" "Command has professional boundary section"

# Test 11: Command has disclaimer requirement
if [[ "$ask_content" == *"Educational information only"* ]] || [[ "$ask_content" == *"Consult an attorney"* ]]; then
  echo -e "${GREEN}✓${NC} Command has disclaimer requirement"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should have disclaimer requirement"
  FAILED=$((FAILED + 1))
fi

# Test 12: SKILL.md documents /skuld:ask
assert_contains "$skill_content" "/skuld:ask" "SKILL.md documents /skuld:ask"

# Test 13: SKILL.md differentiates from /lookup
if [[ "$skill_content" == *"Command Scope Boundaries"* ]] || [[ "$skill_content" == *"/skuld:ask"*"/skuld:lookup"* ]]; then
  echo -e "${GREEN}✓${NC} SKILL.md differentiates ask from lookup"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} SKILL.md should differentiate /ask from /lookup"
  FAILED=$((FAILED + 1))
fi

# Test 14: Command cites source requirement
if [[ "$ask_content" == *"CITE sources"* ]] || [[ "$ask_content" == *"Source:"* ]]; then
  echo -e "${GREEN}✓${NC} Command requires source citation"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should require source citation"
  FAILED=$((FAILED + 1))
fi

# Test 15: Command handles "Should I" questions
if [[ "$ask_content" == *"Should I"* ]] || [[ "$ask_content" == *"Decision"* ]]; then
  echo -e "${GREEN}✓${NC} Command handles decision questions"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should handle 'Should I' decision questions"
  FAILED=$((FAILED + 1))
fi

# Test 16: Command redirects drafting requests
if [[ "$ask_content" == *"/estate"* ]] || [[ "$ask_content" == *"Drafting"* ]]; then
  echo -e "${GREEN}✓${NC} Command redirects drafting requests to /estate"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should redirect drafting requests to /estate"
  FAILED=$((FAILED + 1))
fi

# Test 17: Command has state-laws module reference
assert_contains "$ask_content" "state-laws" "Command references state-laws modules"

# Test 18: Command has edge cases section
assert_contains "$ask_content" "Edge Cases" "Command has edge cases section"

# Test 19: Command profile context disclosure
assert_contains "$ask_content" "Profile context" "Command has profile context disclosure"

# Test 20: Command has plugin root discovery
if [[ "$ask_content" == *"Locate Plugin Root"* ]] || [[ "$ask_content" == *"plugin_root"* ]]; then
  echo -e "${GREEN}✓${NC} Command has plugin root discovery protocol"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should have plugin root discovery protocol"
  FAILED=$((FAILED + 1))
fi

# Test 21: Command explains Glob-based discovery
if [[ "$ask_content" == *"Glob"* ]] && [[ "$ask_content" == *"core-terms.md"* ]]; then
  echo -e "${GREEN}✓${NC} Command explains Glob-based plugin discovery"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Command should explain Glob-based plugin discovery"
  FAILED=$((FAILED + 1))
fi

# Test 22: Version consistency check
skill_version=$(grep -o 'version: [0-9.]*' "$SKILL" | head -1 | cut -d' ' -f2)
if [[ "$skill_version" == "1.3.7" ]]; then
  echo -e "${GREEN}✓${NC} SKILL.md version is 1.3.7"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} SKILL.md version should be 1.3.7, found: $skill_version"
  FAILED=$((FAILED + 1))
fi

report
