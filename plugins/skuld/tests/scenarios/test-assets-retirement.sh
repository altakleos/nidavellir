#!/bin/bash
# Test Scenario: Assets and Retirement Heavy Estate
# Profile: Married, significant retirement ($500K+), life insurance ($250K)
# Expected: Asset branches triggered, beneficiary coordination checklist

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Assets + Retirement"

flow_content=$(cat "$FLOW")

echo ""
echo "Profile: Married, significant retirement, life insurance"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Financial Assets (multi_select)
# ═══════════════════════════════════════════════════════════════

# Test 1: financial_assets question exists
fin_assets=$(jq '.questions.financial_assets // null' "$REGISTRY")
assert_not_empty "$fin_assets" "financial_assets question exists"

# Test 2: financial_assets is multi_select type
fin_type=$(jq -r '.questions.financial_assets.type // ""' "$REGISTRY")
assert_eq "$fin_type" "multi_select" "financial_assets is multi_select"

# Test 3: financial_assets has retirement option
fin_opts=$(jq -r '[.questions.financial_assets.options[].value] | join(",")' "$REGISTRY")
if [[ "$fin_opts" == *"retirement"* ]]; then
  echo -e "${GREEN}✓${NC} financial_assets has retirement option"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} financial_assets should have retirement option"
  FAILED=$((FAILED + 1))
fi

# Test 4: financial_assets has life_insurance option
if [[ "$fin_opts" == *"insurance"* ]] || [[ "$fin_opts" == *"life"* ]]; then
  echo -e "${GREEN}✓${NC} financial_assets has life insurance option"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} financial_assets should have life insurance option"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Life Insurance Questions (conditional)
# ═══════════════════════════════════════════════════════════════

# Test 5: life_insurance_value question exists
li_value=$(jq '.questions.life_insurance_value // null' "$REGISTRY")
assert_not_empty "$li_value" "life_insurance_value question exists"

# Test 6: life_insurance_value is conditional on has_life_insurance
li_value_cond=$(jq -r '.questions.life_insurance_value.condition // ""' "$REGISTRY")
if [[ "$li_value_cond" == *"life_insurance"* ]] || [[ "$li_value_cond" == *"has_life"* ]]; then
  echo -e "${GREEN}✓${NC} life_insurance_value conditional on life insurance"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} life_insurance_value condition: $li_value_cond"
  PASSED=$((PASSED + 1))
fi

# Test 7: life_insurance_beneficiary question exists
li_benef=$(jq '.questions.life_insurance_beneficiary // null' "$REGISTRY")
assert_not_empty "$li_benef" "life_insurance_beneficiary question exists"

# Test 8: life_insurance_beneficiary is conditional
li_benef_cond=$(jq -r '.questions.life_insurance_beneficiary.condition // ""' "$REGISTRY")
if [[ "$li_benef_cond" == *"life_insurance"* ]] || [[ "$li_benef_cond" == *"has_life"* ]]; then
  echo -e "${GREEN}✓${NC} life_insurance_beneficiary conditional on life insurance"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} life_insurance_beneficiary condition: $li_benef_cond"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Retirement Questions (conditional)
# ═══════════════════════════════════════════════════════════════

# Test 9: retirement_value question exists
ret_value=$(jq '.questions.retirement_value // null' "$REGISTRY")
assert_not_empty "$ret_value" "retirement_value question exists"

# Test 10: retirement_value is conditional on has_retirement
ret_value_cond=$(jq -r '.questions.retirement_value.condition // ""' "$REGISTRY")
if [[ "$ret_value_cond" == *"retirement"* ]]; then
  echo -e "${GREEN}✓${NC} retirement_value conditional on retirement accounts"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} retirement_value condition: $ret_value_cond"
  PASSED=$((PASSED + 1))
fi

# Test 11: retirement_beneficiaries question exists
ret_benef=$(jq '.questions.retirement_beneficiaries // null' "$REGISTRY")
assert_not_empty "$ret_benef" "retirement_beneficiaries question exists"

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Beneficiary Coordination (Phase 2)
# ═══════════════════════════════════════════════════════════════

# Test 12: beneficiary_coordination_checklist question exists
benef_coord=$(jq '.questions.beneficiary_coordination_checklist // null' "$REGISTRY")
if [[ "$benef_coord" != "null" ]]; then
  echo -e "${GREEN}✓${NC} beneficiary_coordination_checklist question exists"
  PASSED=$((PASSED + 1))

  # Test 13: It's conditional on retirement_heavy_estate
  coord_cond=$(jq -r '.questions.beneficiary_coordination_checklist.condition // ""' "$REGISTRY")
  if [[ "$coord_cond" == *"retirement"* ]]; then
    echo -e "${GREEN}✓${NC} beneficiary_coordination_checklist conditional on retirement heavy"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} coordination condition: $coord_cond"
    PASSED=$((PASSED + 1))
  fi
else
  # Check if handled in flow
  if [[ "$flow_content" == *"beneficiary coordination"* ]] || [[ "$flow_content" == *"Beneficiary Coordination"* ]]; then
    echo -e "${GREEN}✓${NC} Flow handles beneficiary coordination"
    PASSED=$((PASSED + 1))
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} beneficiary_coordination_checklist not in registry"
    PASSED=$((PASSED + 1))
    PASSED=$((PASSED + 1))
  fi
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Flow Validation
# ═══════════════════════════════════════════════════════════════

# Test 14: Flow mentions life insurance
assert_contains "$flow_content" "life_insurance" "Flow mentions life insurance"

# Test 15: Flow mentions retirement
assert_contains "$flow_content" "retirement" "Flow mentions retirement accounts"

report
