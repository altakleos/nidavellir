#!/bin/bash
# Test Scenario: State File Required Sections
# Validates that state files (TN.md, CA.md pilot) have all 4 required sections
# for Phase 4/5 execution and funding guidance

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: State File Required Sections"

# Define state files to test
TN_STATE="$REPO_ROOT/plugins/skuld/intelligence/state-laws/TN.md"
CA_STATE="$REPO_ROOT/plugins/skuld/intelligence/state-laws/CA.md"

# Required sections for Phase 4/5 support
REQUIRED_SECTIONS=(
  "## Attorney Requirements by Document"
  "## Recording and Filing Requirements"
  "## Recording Offices and Fees"
  "## State-Specific Forms Required"
)

# Test Tennessee state file
test_header "Tennessee (TN.md)"

if [[ -f "$TN_STATE" ]]; then
  echo -e "${GREEN}✓${NC} TN.md file exists"
  PASSED=$((PASSED + 1))

  tn_content=$(cat "$TN_STATE")

  # Check all required sections exist
  for section in "${REQUIRED_SECTIONS[@]}"; do
    if [[ "$tn_content" == *"$section"* ]]; then
      echo -e "${GREEN}✓${NC} TN.md has section: $section"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} TN.md missing section: $section"
      FAILED=$((FAILED + 1))
    fi
  done

  # TN-specific validations
  assert_contains "$tn_content" "TOD Deed" "TN.md includes TOD Deed information"
  assert_contains "$tn_content" "County Register of Deeds" "TN.md uses correct TN recording office name"
  assert_contains "$tn_content" "Davidson" "TN.md includes Davidson County (Nashville)"
  assert_contains "$tn_content" "Shelby" "TN.md includes Shelby County (Memphis)"
  assert_contains "$tn_content" "Advance Care Plan" "TN.md mentions TN statutory healthcare form"
  assert_contains "$tn_content" "T.C.A." "TN.md cites Tennessee Code Annotated"
else
  echo -e "${RED}✗${NC} TN.md file does not exist"
  FAILED=$((FAILED + 1))
fi

# Test California state file
test_header "California (CA.md)"

if [[ -f "$CA_STATE" ]]; then
  echo -e "${GREEN}✓${NC} CA.md file exists"
  PASSED=$((PASSED + 1))

  ca_content=$(cat "$CA_STATE")

  # Check all required sections exist
  for section in "${REQUIRED_SECTIONS[@]}"; do
    if [[ "$ca_content" == *"$section"* ]]; then
      echo -e "${GREEN}✓${NC} CA.md has section: $section"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} CA.md missing section: $section"
      FAILED=$((FAILED + 1))
    fi
  done

  # CA-specific validations
  assert_contains "$ca_content" "BOE-502-A" "CA.md includes critical BOE-502-A form"
  assert_contains "$ca_content" "Prop 19" "CA.md addresses Prop 19 implications"
  assert_contains "$ca_content" "County Recorder" "CA.md uses correct CA recording office name"
  assert_contains "$ca_content" "Los Angeles" "CA.md includes Los Angeles County"
  assert_contains "$ca_content" "San Francisco" "CA.md includes San Francisco County"
  assert_contains "$ca_content" "Documentary transfer tax" "CA.md mentions CA transfer tax"
  assert_contains "$ca_content" "Probate Code" "CA.md cites California Probate Code"

  # Critical CA requirement: BOE-502-A deadline
  assert_contains "$ca_content" "90 days" "CA.md specifies 90-day BOE-502-A deadline"
else
  echo -e "${RED}✗${NC} CA.md file does not exist"
  FAILED=$((FAILED + 1))
fi

# Test section ordering (Recording Offices should come after Recording Requirements)
test_header "Section Ordering"

for state_file in "$TN_STATE" "$CA_STATE"; do
  if [[ -f "$state_file" ]]; then
    state_name=$(basename "$state_file" .md)

    recording_req_line=$(grep -n "## Recording and Filing Requirements" "$state_file" | head -1 | cut -d: -f1)
    recording_office_line=$(grep -n "## Recording Offices and Fees" "$state_file" | head -1 | cut -d: -f1)

    if [[ -n "$recording_req_line" && -n "$recording_office_line" ]]; then
      if [[ "$recording_office_line" -gt "$recording_req_line" ]]; then
        echo -e "${GREEN}✓${NC} $state_name: Recording Offices section comes after Recording Requirements"
        PASSED=$((PASSED + 1))
      else
        echo -e "${RED}✗${NC} $state_name: Recording Offices section should come after Recording Requirements"
        FAILED=$((FAILED + 1))
      fi
    fi
  fi
done

# Test that sections have table content
test_header "Section Content Tables"

for state_file in "$TN_STATE" "$CA_STATE"; do
  if [[ -f "$state_file" ]]; then
    state_name=$(basename "$state_file" .md)
    state_content=$(cat "$state_file")

    # Attorney Requirements should have document types in table
    if [[ "$state_content" == *"| Will |"* ]] && [[ "$state_content" == *"| Trust |"* ]]; then
      echo -e "${GREEN}✓${NC} $state_name: Attorney Requirements table has document types"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} $state_name: Attorney Requirements table missing document types"
      FAILED=$((FAILED + 1))
    fi

    # Recording Requirements should have fee ranges
    if [[ "$state_content" == *"\$"* ]]; then
      echo -e "${GREEN}✓${NC} $state_name: Recording section includes fee information"
      PASSED=$((PASSED + 1))
    else
      echo -e "${RED}✗${NC} $state_name: Recording section missing fee information"
      FAILED=$((FAILED + 1))
    fi
  fi
done

report
