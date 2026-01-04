#!/bin/bash
# Test Scenario: Phase 4/5 Agent Validation
# Validates execution-guidance-agent.md and funding-checklist-agent.md structure

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Phase 4/5 Agent Validation"

# Define agent files
EXEC_AGENT="$REPO_ROOT/plugins/skuld/agents/execution-guidance-agent.md"
FUND_AGENT="$REPO_ROOT/plugins/skuld/agents/funding-checklist-agent.md"

# Required frontmatter fields for skuld agents
REQUIRED_FRONTMATTER=(
  "name:"
  "description:"
  "model:"
  "allowed-tools:"
  "output_path_pattern:"
)

# Test execution-guidance-agent.md
test_header "Execution Guidance Agent"

if [[ -f "$EXEC_AGENT" ]]; then
  echo -e "${GREEN}✓${NC} execution-guidance-agent.md exists"
  PASSED=$((PASSED + 1))

  exec_content=$(cat "$EXEC_AGENT")

  # Extract frontmatter (between first two ---)
  exec_frontmatter=$(sed -n '/^---$/,/^---$/p' "$EXEC_AGENT" | head -50)

  # Check required frontmatter fields
  for field in "${REQUIRED_FRONTMATTER[@]}"; do
    if [[ "$exec_frontmatter" == *"$field"* ]]; then
      echo -e "${GREEN}✓${NC} execution-guidance-agent has frontmatter: $field"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} execution-guidance-agent missing frontmatter: $field"
      FAILED=$((FAILED + 1))
    fi
  done

  # Verify specific values
  assert_contains "$exec_frontmatter" "name: execution-guidance" "Agent name is 'execution-guidance'"
  assert_contains "$exec_frontmatter" "skuld/execution/" "Output path includes skuld/execution/"
  assert_contains "$exec_frontmatter" "Read" "Agent has Read tool access"
  assert_contains "$exec_frontmatter" "Write" "Agent has Write tool access"

  # Verify agent loads state file (progressive disclosure)
  assert_contains "$exec_content" "intelligence/state-laws" "Agent loads state intelligence files"
  assert_contains "$exec_content" "state_of_residence" "Agent references client state"

  # Verify key checklist sections documented
  assert_contains "$exec_content" "Quick Summary" "Agent generates Quick Summary section"
  assert_contains "$exec_content" "Pre-Signing" "Agent generates Pre-Signing section"
  assert_contains "$exec_content" "Signing Ceremony" "Agent generates Signing Ceremony section"
  assert_contains "$exec_content" "Post-Signing" "Agent generates Post-Signing section"

  # Verify agent handles witness requirements
  assert_contains "$exec_content" "witness" "Agent addresses witness requirements"
  assert_contains "$exec_content" "notary" "Agent addresses notarization"

  # Verify metadata output format
  assert_contains "$exec_content" "status: success" "Agent returns success status in metadata"
  assert_contains "$exec_content" "line_count" "Agent returns line count in metadata"
else
  echo -e "${RED}✗${NC} execution-guidance-agent.md does not exist"
  FAILED=$((FAILED + 1))
fi

# Test funding-checklist-agent.md
test_header "Funding Checklist Agent"

if [[ -f "$FUND_AGENT" ]]; then
  echo -e "${GREEN}✓${NC} funding-checklist-agent.md exists"
  PASSED=$((PASSED + 1))

  fund_content=$(cat "$FUND_AGENT")

  # Extract frontmatter
  fund_frontmatter=$(sed -n '/^---$/,/^---$/p' "$FUND_AGENT" | head -50)

  # Check required frontmatter fields
  for field in "${REQUIRED_FRONTMATTER[@]}"; do
    if [[ "$fund_frontmatter" == *"$field"* ]]; then
      echo -e "${GREEN}✓${NC} funding-checklist-agent has frontmatter: $field"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} funding-checklist-agent missing frontmatter: $field"
      FAILED=$((FAILED + 1))
    fi
  done

  # Verify specific values
  assert_contains "$fund_frontmatter" "name: funding-checklist" "Agent name is 'funding-checklist'"
  assert_contains "$fund_frontmatter" "skuld/funding/" "Output path includes skuld/funding/"
  assert_contains "$fund_frontmatter" "Read" "Agent has Read tool access"
  assert_contains "$fund_frontmatter" "Write" "Agent has Write tool access"

  # Verify agent loads state file (progressive disclosure)
  assert_contains "$fund_content" "intelligence/state-laws" "Agent loads state intelligence files"

  # Verify asset-type workflows documented
  assert_contains "$fund_content" "Real Estate" "Agent handles real estate funding"
  assert_contains "$fund_content" "Bank" "Agent handles bank account funding"
  assert_contains "$fund_content" "Retirement" "Agent handles retirement accounts"
  assert_contains "$fund_content" "Life Insurance" "Agent handles life insurance"
  assert_contains "$fund_content" "Business" "Agent handles business interests"

  # Verify retirement accounts NOT transferred (critical rule)
  assert_contains "$fund_content" "DO NOT transfer" "Agent warns against retirement title transfer"
  assert_contains "$fund_content" "beneficiary designation" "Agent recommends beneficiary designation for retirement"

  # Verify real estate workflow includes recording
  assert_contains "$fund_content" "recording" "Agent includes recording process for real estate"
  assert_contains "$fund_content" "deed" "Agent addresses deed preparation"

  # Verify metadata output format
  assert_contains "$fund_content" "status: success" "Agent returns success status in metadata"
  assert_contains "$fund_content" "assets_to_fund" "Agent returns asset count in metadata"
else
  echo -e "${RED}✗${NC} funding-checklist-agent.md does not exist"
  FAILED=$((FAILED + 1))
fi

# Test that both agents use coordinator data pattern (not intake)
test_header "Agent Data Flow Pattern"

for agent_file in "$EXEC_AGENT" "$FUND_AGENT"; do
  if [[ -f "$agent_file" ]]; then
    agent_name=$(basename "$agent_file" .md)
    agent_frontmatter=$(sed -n '/^---$/,/^---$/p' "$agent_file" | head -50)

    # Verify requires_coordinator_data is used for non-intake data
    if [[ "$agent_frontmatter" == *"requires_coordinator_data:"* ]]; then
      echo -e "${GREEN}✓${NC} $agent_name uses requires_coordinator_data pattern"
      PASSED=$((PASSED + 1))
    else
      echo -e "${YELLOW}⚠${NC} $agent_name may not use requires_coordinator_data pattern"
      # Not failing - might be valid without it
    fi

    # Verify requires_intake only has actual intake IDs
    if [[ "$agent_frontmatter" == *"requires_intake:"* ]]; then
      # state_of_residence is a valid intake ID
      if [[ "$agent_frontmatter" == *"state_of_residence"* ]]; then
        echo -e "${GREEN}✓${NC} $agent_name requires valid intake: state_of_residence"
        PASSED=$((PASSED + 1))
      fi
    fi
  fi
done

# Test agent file sizes (sanity check for completeness)
test_header "Agent Completeness"

if [[ -f "$EXEC_AGENT" ]]; then
  exec_lines=$(wc -l < "$EXEC_AGENT")
  if [[ "$exec_lines" -ge 300 ]]; then
    echo -e "${GREEN}✓${NC} execution-guidance-agent.md has $exec_lines lines (>= 300)"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} execution-guidance-agent.md has only $exec_lines lines (expected >= 300)"
    FAILED=$((FAILED + 1))
  fi
fi

if [[ -f "$FUND_AGENT" ]]; then
  fund_lines=$(wc -l < "$FUND_AGENT")
  if [[ "$fund_lines" -ge 400 ]]; then
    echo -e "${GREEN}✓${NC} funding-checklist-agent.md has $fund_lines lines (>= 400)"
    PASSED=$((PASSED + 1))
  else
    echo -e "${RED}✗${NC} funding-checklist-agent.md has only $fund_lines lines (expected >= 400)"
    FAILED=$((FAILED + 1))
  fi
fi

report
