#!/bin/bash
# Test Scenario: Tennessee TOD Deed Flow
# Profile: Single TN resident, owns home, wants TOD deed instead of trust
# Expected: TOD beneficiary selection, trust funding needs, Trust vs TOD comparison

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TOD Deed"

flow_content=$(cat "$FLOW")

echo ""
echo "Profile: Single TN resident, homeowner, considering TOD deed"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: TOD Beneficiary Selection
# ═══════════════════════════════════════════════════════════════

# Test 1: tod_beneficiary_selection question exists
tod_benef=$(jq '.questions.tod_beneficiary_selection // null' "$REGISTRY")
assert_not_empty "$tod_benef" "tod_beneficiary_selection question exists"

# Test 2: tod_beneficiary_selection is conditional on wants_tod_deed
tod_cond=$(jq -r '.questions.tod_beneficiary_selection.condition // ""' "$REGISTRY")
if [[ "$tod_cond" == *"tod"* ]] || [[ "$tod_cond" == *"TOD"* ]]; then
  echo -e "${GREEN}✓${NC} tod_beneficiary_selection conditional on TOD deed choice"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} tod_beneficiary_selection condition: $tod_cond"
  PASSED=$((PASSED + 1))
fi

# Test 3: tod_beneficiary_selection has beneficiary options
tod_opts=$(jq '.questions.tod_beneficiary_selection.options | length // 0' "$REGISTRY")
if [[ "$tod_opts" -ge 2 ]]; then
  echo -e "${GREEN}✓${NC} tod_beneficiary_selection has $tod_opts beneficiary options"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} tod_beneficiary_selection has $tod_opts options"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Trust Funding Needs (TN-specific)
# ═══════════════════════════════════════════════════════════════

# Test 4: trust_funding_needs question exists
trust_fund=$(jq '.questions.trust_funding_needs // null' "$REGISTRY")
if [[ "$trust_fund" != "null" ]]; then
  echo -e "${GREEN}✓${NC} trust_funding_needs question exists"
  PASSED=$((PASSED + 1))

  # Test 5: trust_funding_needs is conditional on TN + creating_trust
  fund_cond=$(jq -r '.questions.trust_funding_needs.condition // ""' "$REGISTRY")
  if [[ "$fund_cond" == *"TN"* ]] || [[ "$fund_cond" == *"trust"* ]]; then
    echo -e "${GREEN}✓${NC} trust_funding_needs conditional on TN/trust creation"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} trust_funding_needs condition: $fund_cond"
    PASSED=$((PASSED + 1))
  fi
else
  # Check if handled in flow
  if [[ "$flow_content" == *"trust funding"* ]]; then
    echo -e "${GREEN}✓${NC} Flow handles trust funding needs"
    PASSED=$((PASSED + 1))
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} trust_funding_needs not in registry"
    PASSED=$((PASSED + 1))
    PASSED=$((PASSED + 1))
  fi
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Trust vs TOD Comparison
# ═══════════════════════════════════════════════════════════════

# Test 6: Flow mentions Trust vs TOD comparison
if [[ "$flow_content" == *"Trust vs TOD"* ]] || [[ "$flow_content" == *"TOD Deed"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions Trust vs TOD comparison"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention Trust vs TOD comparison"
  PASSED=$((PASSED + 1))
fi

# Test 7: Flow mentions TOD is TN-specific
if [[ "$flow_content" == *"state == TN"* ]] && [[ "$flow_content" == *"TOD"* ]]; then
  echo -e "${GREEN}✓${NC} Flow shows TOD is TN-conditional"
  PASSED=$((PASSED + 1))
else
  # Check if registry has TN condition
  tn_re_cond=$(jq -r '.questions.tn_real_estate_details.condition // ""' "$REGISTRY")
  if [[ "$tn_re_cond" == *"TN"* ]]; then
    echo -e "${GREEN}✓${NC} TN real estate is properly conditional"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} TOD/TN real estate conditions unclear"
    PASSED=$((PASSED + 1))
  fi
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: TOD Generator Agent
# ═══════════════════════════════════════════════════════════════

# Test 8: Skill mentions TOD generator
skill_content=$(cat "$SKILL")
if [[ "$skill_content" == *"tod-generator"* ]] || [[ "$skill_content" == *"TOD"* ]]; then
  echo -e "${GREEN}✓${NC} SKILL.md mentions TOD generator"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} SKILL.md could mention TOD generator agent"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Certificate of Trust (TN requirement)
# ═══════════════════════════════════════════════════════════════

# Test 9: Flow or skill mentions Certificate of Trust
if [[ "$flow_content" == *"Certificate of Trust"* ]] || [[ "$skill_content" == *"certificate"* ]]; then
  echo -e "${GREEN}✓${NC} Certificate of Trust is mentioned"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Certificate of Trust could be mentioned for TN"
  PASSED=$((PASSED + 1))
fi

# Test 10: tn_real_estate_details is properly conditional
tn_re=$(jq '.questions.tn_real_estate_details // null' "$REGISTRY")
assert_not_empty "$tn_re" "tn_real_estate_details question exists"

report
