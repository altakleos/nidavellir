#!/bin/bash
# Skuld Test Helpers
# Shared assertions and utilities for skuld plugin tests

set -euo pipefail

# Paths (relative to repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REGISTRY="$REPO_ROOT/plugins/skuld/intake-registry.json"
FLOW="$REPO_ROOT/plugins/skuld/intake-flow.md"
SKILL="$REPO_ROOT/plugins/skuld/SKILL.md"

# Counters
PASSED=0
FAILED=0

# Colors (if terminal supports them)
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
else
  GREEN=''
  RED=''
  YELLOW=''
  NC=''
fi

# Assert two values are equal
assert_eq() {
  local actual="$1"
  local expected="$2"
  local msg="$3"

  if [[ "$actual" == "$expected" ]]; then
    echo -e "${GREEN}✓${NC} $msg"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $msg"
    echo "  Expected: $expected"
    echo "  Actual:   $actual"
    FAILED=$((FAILED + 1))
  fi
}

# Assert haystack contains needle
assert_contains() {
  local haystack="$1"
  local needle="$2"
  local msg="$3"

  if [[ "$haystack" == *"$needle"* ]]; then
    echo -e "${GREEN}✓${NC} $msg"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $msg: '$needle' not found"
    FAILED=$((FAILED + 1))
  fi
}

# Assert a value is not empty
assert_not_empty() {
  local value="$1"
  local msg="$2"

  if [[ -n "$value" ]]; then
    echo -e "${GREEN}✓${NC} $msg"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} $msg: value is empty"
    FAILED=$((FAILED + 1))
  fi
}

# Get question type from registry
question_type() {
  local question_id="$1"
  jq -r ".questions.$question_id.type // \"null\"" "$REGISTRY"
}

# Get question option count from registry
question_option_count() {
  local question_id="$1"
  jq ".questions.$question_id.options | length // 0" "$REGISTRY"
}

# Get question option values as sorted JSON array (compact)
question_option_values() {
  local question_id="$1"
  jq -c "[.questions.$question_id.options[].value] | sort" "$REGISTRY"
}

# Check if question has a specific constraint
question_has_constraint() {
  local question_id="$1"
  local constraint="$2"
  jq -r ".questions.$question_id.constraints // [] | contains([\"$constraint\"])" "$REGISTRY"
}

# Print test report and exit with appropriate code
report() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [[ $FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${NC} ($PASSED passed)"
    exit 0
  else
    echo -e "${RED}Tests failed!${NC} ($PASSED passed, $FAILED failed)"
    exit 1
  fi
}

# Print test header
test_header() {
  local name="$1"
  echo ""
  echo -e "${YELLOW}━━━ $name ━━━${NC}"
}
