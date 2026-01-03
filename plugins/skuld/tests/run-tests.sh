#!/bin/bash
# Skuld Test Runner
# Runs all constraint and scenario tests

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  GREEN=''
  RED=''
  YELLOW=''
  BLUE=''
  NC=''
fi

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Skuld Plugin Test Suite            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

TOTAL_PASSED=0
TOTAL_FAILED=0
FAILED_TESTS=()

# Run a test file and capture results
run_test() {
  local test_file="$1"
  local test_name
  test_name=$(basename "$test_file" .sh)

  echo -e "${YELLOW}Running:${NC} $test_name"

  if bash "$test_file"; then
    TOTAL_PASSED=$((TOTAL_PASSED + 1))
  else
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    FAILED_TESTS+=("$test_name")
  fi
}

# Run constraint tests
echo -e "${BLUE}━━━ Constraint Tests ━━━${NC}"
for test_file in "$SCRIPT_DIR"/constraints/test-*.sh; do
  if [[ -f "$test_file" ]]; then
    run_test "$test_file"
  fi
done

# Run scenario tests if they exist
if compgen -G "$SCRIPT_DIR/scenarios/test-*.sh" > /dev/null; then
  echo ""
  echo -e "${BLUE}━━━ Scenario Tests ━━━${NC}"
  for test_file in "$SCRIPT_DIR"/scenarios/test-*.sh; do
    if [[ -f "$test_file" ]]; then
      run_test "$test_file"
    fi
  done
fi

# Final summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║               Test Summary                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
echo ""

if [[ $TOTAL_FAILED -eq 0 ]]; then
  echo -e "${GREEN}All test suites passed!${NC} ($TOTAL_PASSED suites)"
  exit 0
else
  echo -e "${RED}Some tests failed!${NC} ($TOTAL_PASSED passed, $TOTAL_FAILED failed)"
  echo ""
  echo "Failed tests:"
  for failed in "${FAILED_TESTS[@]}"; do
    echo -e "  ${RED}✗${NC} $failed"
  done
  exit 1
fi
