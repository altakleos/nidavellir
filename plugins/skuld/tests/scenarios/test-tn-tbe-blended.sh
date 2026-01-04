#!/bin/bash
# Test Scenario: TN TBE Blended Family Handling
# Tests for blended family warnings and survivorship risks

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TBE Blended Family"

flow_content=$(cat "$FLOW")
tn_md=$(cat "$REPO_ROOT/plugins/skuld/intelligence/state-laws/TN.md")
validation_agent=$(cat "$REPO_ROOT/plugins/skuld/agents/validation-agent.md")

# Test 1: blended_family detection exists (prerequisite)
blended_q=$(jq '.questions.has_prior_children // .questions.blended_family // null' "$REGISTRY")
if [[ "$blended_q" != "null" ]] || [[ "$flow_content" == *"blended_family"* ]]; then
  echo -e "${GREEN}✓${NC} blended_family detection exists"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} blended_family detection should exist"
  FAILED=$((FAILED + 1))
fi

# Test 2: tbe_blended_home_plan is conditional on blended_family
blended_cond=$(jq -r '.questions.tbe_blended_home_plan.condition // ""' "$REGISTRY")
if [[ "$blended_cond" == *"blended_family"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_blended_home_plan requires blended_family"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_blended_home_plan should require blended_family"
  FAILED=$((FAILED + 1))
fi

# Test 3: Flow has blended family TBE warning
if [[ "$flow_content" == *"BLENDED FAMILY"* ]] || [[ "$flow_content" == *"blended_family"* && "$flow_content" == *"TBE"* ]]; then
  echo -e "${GREEN}✓${NC} Flow has blended family TBE warning"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should have blended family TBE warning"
  FAILED=$((FAILED + 1))
fi

# Test 4: Blended warning mentions survivorship risk
assert_contains "$flow_content" "survivorship" "Flow mentions TBE survivorship in blended context"

# Test 5: Blended warning mentions disinheritance risk
if [[ "$flow_content" == *"disinherit"* ]] || [[ "$flow_content" == *"children"* && "$flow_content" == *"exclude"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions disinheritance risk"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow should mention disinheritance risk for blended families"
  PASSED=$((PASSED + 1))
fi

# Test 6: tbe_blended_home_plan has life_estate option
blended_opts=$(jq -c '[.questions.tbe_blended_home_plan.options[].value]' "$REGISTRY")
if [[ "$blended_opts" == *"life_estate"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_blended_home_plan has life_estate option"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_blended_home_plan should have life_estate option"
  FAILED=$((FAILED + 1))
fi

# Test 7: tbe_blended_home_plan has transfer_to_trust option
if [[ "$blended_opts" == *"transfer_to_trust"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_blended_home_plan has transfer_to_trust option"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_blended_home_plan should have transfer_to_trust option"
  FAILED=$((FAILED + 1))
fi

# Test 8: TN.md recommends transfer for blended families
if [[ "$tn_md" == *"Blended Family"* ]] && [[ "$tn_md" == *"Transfer to Trust"* || "$tn_md" == *"transfer to trust"* || "$tn_md" == *"Recommended"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md recommends transfer for blended families"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should recommend transfer for blended families"
  FAILED=$((FAILED + 1))
fi

# Test 9: TN.md explains first-to-die children at risk
if [[ "$tn_md" == *"first-to-die"* ]] || [[ "$tn_md" == *"prior marriage"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md explains first-to-die's children risk"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should explain risk to first-to-die's children"
  FAILED=$((FAILED + 1))
fi

# Test 10: Validation agent checks blended + keep_tbe combination
if [[ "$validation_agent" == *"blended_family"* ]] && [[ "$validation_agent" == *"keep_tbe"* || "$validation_agent" == *"tbe_pourover"* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent checks blended + keep_tbe combination"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should check blended + keep_tbe combination"
  FAILED=$((FAILED + 1))
fi

# Test 11: Validation agent warns on blended family keeping TBE
if [[ "$validation_agent" == *"blended_family"* ]] && [[ "$validation_agent" == *"disinherit"* || "$validation_agent" == *"children"* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent warns on blended family TBE risk"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should warn about blended family TBE disinheritance risk"
  FAILED=$((FAILED + 1))
fi

# Test 12: TN.md mentions life estate + remainder as solution
if [[ "$tn_md" == *"Life Estate"* ]] && [[ "$tn_md" == *"Remainder"* || "$tn_md" == *"remainder"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md mentions life estate + remainder solution"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should mention life estate + remainder as blended family solution"
  FAILED=$((FAILED + 1))
fi

report
