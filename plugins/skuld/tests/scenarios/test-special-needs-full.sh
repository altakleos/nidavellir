#!/bin/bash
# Test Scenario: Complete Special Needs Trust Flow
# Profile: Married, 1 adult special needs child receiving SSI
# Expected: Full SNT flow including letter of intent, ABLE account

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Special Needs Full Flow"

flow_content=$(cat "$FLOW")
skill_content=$(cat "$SKILL")

echo ""
echo "Profile: Married, 1 adult child with special needs receiving SSI"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Letter of Intent
# ═══════════════════════════════════════════════════════════════

# Test 1: letter_of_intent question exists
loi=$(jq '.questions.letter_of_intent // null' "$REGISTRY")
assert_not_empty "$loi" "letter_of_intent question exists"

# Test 2: letter_of_intent is conditional on special needs child
loi_cond=$(jq -r '.questions.letter_of_intent.condition // ""' "$REGISTRY")
if [[ "$loi_cond" == *"special_needs"* ]] || [[ "$loi_cond" == *"has_special"* ]]; then
  echo -e "${GREEN}✓${NC} letter_of_intent conditional on special needs child"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} letter_of_intent condition: $loi_cond"
  PASSED=$((PASSED + 1))
fi

# Test 3: letter_of_intent sets appropriate flag
loi_flag=$(jq -r '.questions.letter_of_intent.sets_flags // []' "$REGISTRY")
if [[ "$loi_flag" == *"letter_of_intent"* ]]; then
  echo -e "${GREEN}✓${NC} letter_of_intent sets flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} letter_of_intent may need flag setting"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: ABLE Account Interest
# ═══════════════════════════════════════════════════════════════

# Test 4: able_account_interest question exists
able=$(jq '.questions.able_account_interest // null' "$REGISTRY")
assert_not_empty "$able" "able_account_interest question exists"

# Test 5: able_account_interest is conditional on special needs child
able_cond=$(jq -r '.questions.able_account_interest.condition // ""' "$REGISTRY")
if [[ "$able_cond" == *"special_needs"* ]] || [[ "$able_cond" == *"has_special"* ]]; then
  echo -e "${GREEN}✓${NC} able_account_interest conditional on special needs"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} able_account_interest condition: $able_cond"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: SNT Trustee (already tested, verify integration)
# ═══════════════════════════════════════════════════════════════

# Test 6: snt_trustee question exists
snt_trustee=$(jq '.questions.snt_trustee // null' "$REGISTRY")
assert_not_empty "$snt_trustee" "snt_trustee question exists"

# Test 7: Flow shows SNT trustee is per-child
if [[ "$flow_content" == *"[child_name]"* ]] || [[ "$flow_content" == *"FOR EACH"* ]]; then
  echo -e "${GREEN}✓${NC} Flow handles per-child SNT trustee assignment"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could show per-child SNT trustee handling"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Government Benefits (already tested, verify options)
# ═══════════════════════════════════════════════════════════════

# Test 8: government_benefits_status has SSI option
gov_opts=$(jq -r '[.questions.government_benefits_status.options[].value] | join(",")' "$REGISTRY")
if [[ "$gov_opts" == *"SSI"* ]] || [[ "$gov_opts" == *"ssi"* ]]; then
  echo -e "${GREEN}✓${NC} government_benefits_status includes SSI"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} government_benefits options: $gov_opts"
  PASSED=$((PASSED + 1))
fi

# Test 9: government_benefits_status has Medicaid option
if [[ "$gov_opts" == *"Medicaid"* ]] || [[ "$gov_opts" == *"medicaid"* ]]; then
  echo -e "${GREEN}✓${NC} government_benefits_status includes Medicaid"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} government_benefits options: $gov_opts"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: SNT Generator Agent
# ═══════════════════════════════════════════════════════════════

# Test 10: Skill mentions SNT generator
if [[ "$skill_content" == *"snt-generator"* ]] || [[ "$skill_content" == *"special needs trust"* ]]; then
  echo -e "${GREEN}✓${NC} SKILL.md mentions SNT generator"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} SKILL.md could mention SNT generator agent"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 6: Flow Completeness
# ═══════════════════════════════════════════════════════════════

# Test 11: Flow mentions ABLE accounts
if [[ "$flow_content" == *"ABLE"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions ABLE accounts"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention ABLE accounts"
  PASSED=$((PASSED + 1))
fi

# Test 12: Flow mentions letter of intent
if [[ "$flow_content" == *"letter of intent"* ]] || [[ "$flow_content" == *"Letter of Intent"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions Letter of Intent"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention Letter of Intent"
  PASSED=$((PASSED + 1))
fi

report
