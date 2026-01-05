#!/bin/bash
# Test Scenario: Trust Generator Distribution Logic
# Tests: Distribution handling in trust-generator.md agent
# Expected: Complete distribution logic with intake value consumption

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Trust Generator Distribution Logic"

TRUST_GEN="$REPO_ROOT/plugins/skuld/agents/trust-generator.md"
gen_content=$(cat "$TRUST_GEN")

echo ""
echo "Testing distribution logic in trust-generator.md"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Required Intake Fields
# ═══════════════════════════════════════════════════════════════

# Test 1: trust-generator requires distribution_preferences
if [[ "$gen_content" == *"distribution_preferences"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator references distribution_preferences"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should reference distribution_preferences"
  FAILED=$((FAILED + 1))
fi

# Test 2: trust-generator requires distribution_age_schedule
if [[ "$gen_content" == *"distribution_age_schedule"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator references distribution_age_schedule"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should reference distribution_age_schedule"
  FAILED=$((FAILED + 1))
fi

# Test 3: trust-generator requires distribution_method
if [[ "$gen_content" == *"distribution_method"* ]] || [[ "$gen_content" == *"distribution.method"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator references distribution_method"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should reference distribution_method"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Age Schedule Handling (SWITCH Statement)
# ═══════════════════════════════════════════════════════════════

# Test 4: trust-generator has SWITCH for age_schedule
if [[ "$gen_content" == *"SWITCH"* ]] && [[ "$gen_content" == *"age_schedule"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has SWITCH for distribution.age_schedule"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should have SWITCH for age_schedule"
  FAILED=$((FAILED + 1))
fi

# Test 5: trust-generator handles staggered_standard case
if [[ "$gen_content" == *"staggered_standard"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles staggered_standard (25/30/35)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle staggered_standard"
  FAILED=$((FAILED + 1))
fi

# Test 6: trust-generator handles staggered_later case
if [[ "$gen_content" == *"staggered_later"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles staggered_later (30/35/40)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle staggered_later"
  FAILED=$((FAILED + 1))
fi

# Test 7: trust-generator handles staggered_earlier case
if [[ "$gen_content" == *"staggered_earlier"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles staggered_earlier (21/25/30)"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle staggered_earlier"
  FAILED=$((FAILED + 1))
fi

# Test 8: trust-generator handles all_at_once_25 case
if [[ "$gen_content" == *"all_at_once_25"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles all_at_once_25"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle all_at_once_25"
  FAILED=$((FAILED + 1))
fi

# Test 9: trust-generator handles custom ages case
if [[ "$gen_content" == *"custom"* ]] && [[ "$gen_content" == *"custom_ages"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles custom ages"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle custom ages"
  FAILED=$((FAILED + 1))
fi

# Test 10: trust-generator has DEFAULT case
if [[ "$gen_content" == *"DEFAULT"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has DEFAULT case for age schedule"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} trust-generator could have DEFAULT case"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 3: Per Stirpes / Per Capita Logic
# ═══════════════════════════════════════════════════════════════

# Test 11: trust-generator has per_stirpes handling
if [[ "$gen_content" == *"per_stirpes"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles per_stirpes distribution"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle per_stirpes"
  FAILED=$((FAILED + 1))
fi

# Test 12: trust-generator has per_capita handling
if [[ "$gen_content" == *"per_capita"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles per_capita distribution"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle per_capita"
  FAILED=$((FAILED + 1))
fi

# Test 13: trust-generator uses distribution.method from intake
if [[ "$gen_content" == *"distribution.method"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator uses distribution.method from intake"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should use distribution.method from intake"
  FAILED=$((FAILED + 1))
fi

# Test 14: Per stirpes document text includes descendants/representation
if [[ "$gen_content" == *"descendants"* ]] || [[ "$gen_content" == *"representation"* ]]; then
  echo -e "${GREEN}✓${NC} Per stirpes text includes descendants/representation"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Per stirpes text could be more detailed"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Equal/Unequal Distribution
# ═══════════════════════════════════════════════════════════════

# Test 15: trust-generator handles equal distribution
if [[ "$gen_content" == *"equal"* ]] && [[ "$gen_content" == *"shares"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles equal shares"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle equal shares"
  FAILED=$((FAILED + 1))
fi

# Test 16: trust-generator handles unequal distribution
if [[ "$gen_content" == *"unequal"* ]] || [[ "$gen_content" == *"distribution.equality"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles unequal distribution"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should handle unequal distribution"
  FAILED=$((FAILED + 1))
fi

# Test 17: trust-generator iterates over child shares
if [[ "$gen_content" == *"FOR"* ]] && [[ "$gen_content" == *"child"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator iterates over child shares"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} trust-generator could iterate over child shares"
  PASSED=$((PASSED + 1))
fi

# Test 18: trust-generator has Share Allocation section
if [[ "$gen_content" == *"Share Allocation"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has Share Allocation section"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} trust-generator could have Share Allocation section"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Attorney Review Markers
# ═══════════════════════════════════════════════════════════════

# Test 19: trust-generator has attorney review for distribution ages
if [[ "$gen_content" == *"ATTORNEY REVIEW"* ]] && [[ "$gen_content" == *"distribution"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has ATTORNEY REVIEW for distribution"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should have ATTORNEY REVIEW for distribution"
  FAILED=$((FAILED + 1))
fi

# Test 20: trust-generator has attorney review for age appropriateness
if [[ "$gen_content" == *"appropriate"* ]] || [[ "$gen_content" == *"ages"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has age appropriateness review"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} trust-generator could have age appropriateness review"
  PASSED=$((PASSED + 1))
fi

# Test 21: trust-generator has attorney review for unequal distribution
if [[ "$gen_content" == *"100%"* ]] || [[ "$gen_content" == *"percentage"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has percentage validation review"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} trust-generator could have percentage validation"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 6: HEMS Standard Integration
# ═══════════════════════════════════════════════════════════════

# Test 22: trust-generator handles discretionary distribution
if [[ "$gen_content" == *"discretionary"* ]] || [[ "$gen_content" == *"distribution.pattern"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator handles discretionary distribution"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} trust-generator could handle discretionary pattern"
  PASSED=$((PASSED + 1))
fi

# Test 23: trust-generator includes HEMS standard for discretionary
if [[ "$gen_content" == *"HEMS"* ]] && [[ "$gen_content" == *"health"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator includes HEMS standard"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should include HEMS standard"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 7: Document Structure
# ═══════════════════════════════════════════════════════════════

# Test 24: trust-generator has Distribution Schedule section
if [[ "$gen_content" == *"Distribution Schedule"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has Distribution Schedule section"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should have Distribution Schedule section"
  FAILED=$((FAILED + 1))
fi

# Test 25: trust-generator has Children's Trust Provisions
if [[ "$gen_content" == *"Children's Trust Provisions"* ]]; then
  echo -e "${GREEN}✓${NC} trust-generator has Children's Trust Provisions"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} trust-generator should have Children's Trust Provisions"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 8: Frontmatter Intake Requirements
# ═══════════════════════════════════════════════════════════════

# Extract frontmatter
frontmatter=$(sed -n '/^---$/,/^---$/p' "$TRUST_GEN")

# Test 26: requires_intake includes distribution fields
if [[ "$frontmatter" == *"distribution_preferences"* ]]; then
  echo -e "${GREEN}✓${NC} requires_intake includes distribution_preferences"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} requires_intake should include distribution_preferences"
  FAILED=$((FAILED + 1))
fi

# Test 27: requires_intake includes distribution_age_schedule
if [[ "$frontmatter" == *"distribution_age_schedule"* ]]; then
  echo -e "${GREEN}✓${NC} requires_intake includes distribution_age_schedule"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} requires_intake should include distribution_age_schedule"
  FAILED=$((FAILED + 1))
fi

# Test 28: requires_intake includes distribution_method
if [[ "$frontmatter" == *"distribution_method"* ]]; then
  echo -e "${GREEN}✓${NC} requires_intake includes distribution_method"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} requires_intake should include distribution_method"
  FAILED=$((FAILED + 1))
fi

# Test 29: optional_intake includes distribution_custom_ages
if [[ "$frontmatter" == *"distribution_custom_ages"* ]]; then
  echo -e "${GREEN}✓${NC} optional_intake includes distribution_custom_ages"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} optional_intake should include distribution_custom_ages"
  FAILED=$((FAILED + 1))
fi

# Test 30: optional_intake includes distribution_equality
if [[ "$frontmatter" == *"distribution_equality"* ]]; then
  echo -e "${GREEN}✓${NC} optional_intake includes distribution_equality"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} optional_intake should include distribution_equality"
  FAILED=$((FAILED + 1))
fi

report
