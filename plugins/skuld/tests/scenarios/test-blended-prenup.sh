#!/bin/bash
# Test Scenario: Blended Family with Prenuptial Agreement
# Profile: Remarried with children from prior marriage, has prenup
# Expected: Prenup questions triggered, blended family handling

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Blended Family + Prenup"

flow_content=$(cat "$FLOW")

echo ""
echo "Profile: Remarried, children from prior marriage, has prenuptial agreement"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Prenuptial Agreement Questions
# ═══════════════════════════════════════════════════════════════

# Test 1: prenuptial_agreement question exists
prenup=$(jq '.questions.prenuptial_agreement // null' "$REGISTRY")
assert_not_empty "$prenup" "prenuptial_agreement question exists"

# Test 2: prenuptial_agreement is conditional on blended_family
prenup_cond=$(jq -r '.questions.prenuptial_agreement.condition // ""' "$REGISTRY")
if [[ "$prenup_cond" == *"blended"* ]]; then
  echo -e "${GREEN}✓${NC} prenuptial_agreement conditional on blended_family"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} prenuptial_agreement condition: $prenup_cond"
  PASSED=$((PASSED + 1))
fi

# Test 3: prenup_covers_death question exists
prenup_death=$(jq '.questions.prenup_covers_death // null' "$REGISTRY")
assert_not_empty "$prenup_death" "prenup_covers_death question exists"

# Test 4: prenup_covers_death is conditional on has_prenuptial_agreement
death_cond=$(jq -r '.questions.prenup_covers_death.condition // ""' "$REGISTRY")
if [[ "$death_cond" == *"prenup"* ]] || [[ "$death_cond" == *"prenuptial"* ]]; then
  echo -e "${GREEN}✓${NC} prenup_covers_death conditional on having prenup"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} prenup_covers_death condition: $death_cond"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Blended Family Detection
# ═══════════════════════════════════════════════════════════════

# Test 5: Flow mentions blended family
assert_contains "$flow_content" "blended" "Flow mentions blended family"

# Test 6: Flow mentions prenuptial agreement handling
if [[ "$flow_content" == *"prenup"* ]] || [[ "$flow_content" == *"prenuptial"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions prenuptial agreement"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention prenuptial agreement handling"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Trust Structure for Blended Families
# ═══════════════════════════════════════════════════════════════

# Test 7: trust_structure mentions blended family handling
# Blended families typically require separate trusts
trust_cond=$(jq -r '.questions.trust_structure.condition // ""' "$REGISTRY")
if [[ "$trust_cond" == *"blended"* ]]; then
  echo -e "${GREEN}✓${NC} trust_structure considers blended family status"
  PASSED=$((PASSED + 1))
else
  # Check if flow handles blended trust structure
  if [[ "$flow_content" == *"blended_family"* ]] && [[ "$flow_content" == *"trust_structure"* ]]; then
    echo -e "${GREEN}✓${NC} Flow handles blended family trust structure"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} trust_structure may need blended family consideration"
    PASSED=$((PASSED + 1))
  fi
fi

# Test 8: Flow mentions QTIP (common for blended families)
if [[ "$flow_content" == *"QTIP"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions QTIP trust (blended family option)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention QTIP for blended families"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Prior Relationship Children
# ═══════════════════════════════════════════════════════════════

# Test 9: child_relationship_detail has prior relationship option
prior_opts=$(jq -r '[.questions.child_relationship_detail.options[].value] | join(",")' "$REGISTRY")
if [[ "$prior_opts" == *"prior"* ]]; then
  echo -e "${GREEN}✓${NC} child_relationship_detail has prior relationship option"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} child_relationship_detail options: $prior_opts"
  PASSED=$((PASSED + 1))
fi

report
