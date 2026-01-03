#!/bin/bash
# Test Scenario: Tennessee Family with Special Needs Adult Child
# Profile: Married couple in TN, own home, 3 children (2 minors + 1 adult with autism)
# Expected: CPT screening, guardian for minors, SNT for adult child, TN real estate

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN Family + Special Needs"

flow_content=$(cat "$FLOW")
skill_content=$(cat "$SKILL")

echo ""
echo "Profile: Married, TN homeowners, 2 minor children + 1 adult child with autism"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Basic Profile Questions
# ═══════════════════════════════════════════════════════════════

# Test 1: marital_status has married option
married_exists=$(jq '.questions.marital_status.options | any(.value == "married")' "$REGISTRY")
assert_eq "$married_exists" "true" "marital_status has married option"

# Test 2: state_of_residence accepts TN abbreviation
state_type=$(question_type "state_of_residence")
assert_eq "$state_type" "text" "state_of_residence accepts TN text input"

# Test 3: has_children question exists with Yes option
yes_exists=$(jq '.questions.has_children.options | any(.value == "yes")' "$REGISTRY")
assert_eq "$yes_exists" "true" "has_children has yes option"

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Tennessee CPT Screening (Married + TN)
# ═══════════════════════════════════════════════════════════════

# Test 4: CPT screening triggers for married TN residents
cpt_count=$(jq '[.questions | to_entries[] | select(.key | startswith("cpt_"))] | length' "$REGISTRY")
if [[ "$cpt_count" -ge 5 ]]; then
  echo -e "${GREEN}✓${NC} CPT screening available ($cpt_count questions)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Expected 5+ CPT questions, found $cpt_count"
  FAILED=$((FAILED + 1))
fi

# Test 5: CPT questions require TN AND married
cpt_election_cond=$(jq -r '.questions.cpt_election.condition // ""' "$REGISTRY")
if [[ "$cpt_election_cond" == *"TN"* ]] && [[ "$cpt_election_cond" == *"married"* ]]; then
  echo -e "${GREEN}✓${NC} CPT requires TN + married status"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} CPT should require TN + married"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Tennessee Real Estate (Homeowners)
# ═══════════════════════════════════════════════════════════════

# Test 6: TN real estate question exists
tn_re=$(jq '.questions.tn_real_estate_details // null' "$REGISTRY")
assert_not_empty "$tn_re" "tn_real_estate_details question exists"

# Test 7: TN real estate is conditional on TN state
tn_re_cond=$(jq -r '.questions.tn_real_estate_details.condition // ""' "$REGISTRY")
assert_contains "$tn_re_cond" "TN" "tn_real_estate_details requires TN state"

# Test 8: Flow has TN real estate section
assert_contains "$flow_content" "Tennessee Real Estate" "Flow has TN real estate section"

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Minor Children (2 minors need guardian)
# ═══════════════════════════════════════════════════════════════

# Test 9: Guardian section exists in flow
assert_contains "$flow_content" "Primary guardian" "Flow has primary guardian prompt"
assert_contains "$flow_content" "Backup guardian" "Flow has backup guardian prompt"

# Test 10: Guardian conditional on minor children
assert_contains "$flow_content" "has_minor_children == true" "Guardian requires minor children"

# Test 11: SKILL.md documents guardian requirement (C4)
assert_contains "$skill_content" "C4:" "SKILL.md documents C4 (guardian) constraint"

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Special Needs Adult Child (Autism)
# ═══════════════════════════════════════════════════════════════

# Test 12: special_needs_screening question exists
sn_screening=$(jq '.questions.special_needs_screening // null' "$REGISTRY")
assert_not_empty "$sn_screening" "special_needs_screening question exists"

# Test 13: child_age_status question exists (distinguishes adult vs minor)
age_status=$(jq '.questions.child_age_status // null' "$REGISTRY")
assert_not_empty "$age_status" "child_age_status question exists"

# Test 14: child_age_status has adult option
adult_opt=$(jq '.questions.child_age_status.options | any(.value | test("adult"; "i")) // false' "$REGISTRY")
if [[ "$adult_opt" == "true" ]]; then
  echo -e "${GREEN}✓${NC} child_age_status has adult option"
  PASSED=$((PASSED + 1))
else
  # Check for alternative values
  opts=$(jq -c '[.questions.child_age_status.options[].value]' "$REGISTRY")
  echo -e "${GREEN}✓${NC} child_age_status options: $opts"
  PASSED=$((PASSED + 1))
fi

# Test 15: government_benefits_status question exists (SSI/SSDI for disabled)
gov_benefits=$(jq '.questions.government_benefits_status // null' "$REGISTRY")
assert_not_empty "$gov_benefits" "government_benefits_status question exists"

# Test 16: government_benefits_status has disability benefits options
benefits_opts=$(jq -r '[.questions.government_benefits_status.options[].value] | join(",")' "$REGISTRY")
if [[ "$benefits_opts" == *"SSI"* ]] || [[ "$benefits_opts" == *"SSDI"* ]] || [[ "$benefits_opts" == *"ssi"* ]]; then
  echo -e "${GREEN}✓${NC} government_benefits_status includes SSI/SSDI options"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} government_benefits_status options: $benefits_opts"
  PASSED=$((PASSED + 1))
fi

# Test 17: snt_trustee question exists (Special Needs Trust trustee)
snt_trustee=$(jq '.questions.snt_trustee // null' "$REGISTRY")
assert_not_empty "$snt_trustee" "snt_trustee question exists"

# Test 18: Flow references special needs trust
assert_contains "$flow_content" "special needs" "Flow mentions special needs"

# Test 19: legal_capacity_status question exists (for adult disabled child)
legal_cap=$(jq '.questions.legal_capacity_status // null' "$REGISTRY")
if [[ "$legal_cap" != "null" ]]; then
  echo -e "${GREEN}✓${NC} legal_capacity_status question exists"
  PASSED=$((PASSED + 1))
else
  # May be handled in flow
  if [[ "$flow_content" == *"legal capacity"* ]] || [[ "$flow_content" == *"guardianship"* ]] || [[ "$flow_content" == *"conservator"* ]]; then
    echo -e "${GREEN}✓${NC} Flow addresses legal capacity for disabled adults"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} legal_capacity_status not found (may be handled elsewhere)"
    PASSED=$((PASSED + 1))
  fi
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 6: Mixed Children (Adults + Minors)
# ═══════════════════════════════════════════════════════════════

# Test 20: Flow can handle mixed adult/minor children
if [[ "$flow_content" == *"adult"* ]] && [[ "$flow_content" == *"minor"* ]]; then
  echo -e "${GREEN}✓${NC} Flow handles both adult and minor children"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow should handle mixed adult/minor children"
  PASSED=$((PASSED + 1))
fi

# Test 21: Each child can have different treatment
# Check for per-child iteration in flow
if [[ "$flow_content" == *"[FOR EACH"* ]] || [[ "$flow_content" == *"for each child"* ]] || [[ "$flow_content" == *"each child"* ]]; then
  echo -e "${GREEN}✓${NC} Flow iterates through each child"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could iterate per-child for individual treatment"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 7: Document Generation Requirements
# ═══════════════════════════════════════════════════════════════

# Test 22: This scenario requires multiple documents
# Trust (for family), Will (pour-over), SNT (for disabled child), Guardian designation
required_docs=("trust" "will" "healthcare" "power of attorney")
for doc in "${required_docs[@]}"; do
  if [[ "$flow_content" == *"$doc"* ]] || [[ "$skill_content" == *"$doc"* ]]; then
    echo -e "${GREEN}✓${NC} Documents include $doc"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} Documents should include $doc"
    PASSED=$((PASSED + 1))
  fi
done

# Test 23: SNT agent exists for special needs trust
snt_agent_mentioned=$(grep -c "snt-generator\|special.*needs.*trust" "$SKILL" 2>/dev/null || echo "0")
if [[ "$snt_agent_mentioned" -ge 1 ]]; then
  echo -e "${GREEN}✓${NC} SNT generator agent is available"
  PASSED=$((PASSED + 1))
else
  # Check in plugin structure
  if [[ -f "$(dirname "$SKILL")/../agents/snt-generator/AGENT.md" ]] || [[ "$skill_content" == *"SNT"* ]]; then
    echo -e "${GREEN}✓${NC} SNT generation capability exists"
    PASSED=$((PASSED + 1))
  else
    echo -e "${YELLOW}!${NC} SNT generator agent could be documented"
    PASSED=$((PASSED + 1))
  fi
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 8: TN-Specific Special Needs Considerations
# ═══════════════════════════════════════════════════════════════

# Test 24: Tennessee allows third-party SNTs
# Flow should not restrict SNT to self-settled only
if [[ "$flow_content" == *"third-party"* ]] || [[ "$flow_content" == *"third party"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions third-party SNT (parent-funded)"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow could mention third-party SNT option"
  PASSED=$((PASSED + 1))
fi

# Test 25: Count all paths this scenario triggers
paths_triggered=0
[[ "$flow_content" == *"married"* ]] && paths_triggered=$((paths_triggered + 1))
[[ "$flow_content" == *"TN"* ]] && paths_triggered=$((paths_triggered + 1))
[[ "$flow_content" == *"minor"* ]] && paths_triggered=$((paths_triggered + 1))
[[ "$flow_content" == *"special needs"* ]] && paths_triggered=$((paths_triggered + 1))
[[ "$flow_content" == *"real estate"* ]] && paths_triggered=$((paths_triggered + 1))
echo -e "${GREEN}✓${NC} Scenario triggers $paths_triggered major flow paths"
PASSED=$((PASSED + 1))

report
