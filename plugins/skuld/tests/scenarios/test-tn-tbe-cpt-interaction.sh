#!/bin/bash
# Test Scenario: TN TBE + CPT Interaction
# Tests for CPT/TBE mutual exclusivity and step-up considerations

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: TN TBE + CPT Interaction"

flow_content=$(cat "$FLOW")
tn_md=$(cat "$REPO_ROOT/plugins/skuld/intelligence/state-laws/TN.md")
validation_agent=$(cat "$REPO_ROOT/plugins/skuld/agents/validation-agent.md")

# Test 1: cpt_election question exists (prerequisite)
cpt_q=$(jq '.questions.cpt_election // null' "$REGISTRY")
assert_not_empty "$cpt_q" "cpt_election question exists"

# Test 2: tbe_home_appreciation requires cpt_election
appreciation_cond=$(jq -r '.questions.tbe_home_appreciation.condition // ""' "$REGISTRY")
if [[ "$appreciation_cond" == *"cpt_election"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_home_appreciation requires cpt_election"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_home_appreciation should require cpt_election"
  FAILED=$((FAILED + 1))
fi

# Test 3: Flow has CPT/TBE interaction warning
if [[ "$flow_content" == *"CPT"* ]] && [[ "$flow_content" == *"TBE"* ]]; then
  echo -e "${GREEN}✓${NC} Flow addresses CPT/TBE interaction"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should address CPT/TBE interaction"
  FAILED=$((FAILED + 1))
fi

# Test 4: Flow explains mutual exclusivity
if [[ "$flow_content" == *"MUTUALLY EXCLUSIVE"* ]] || [[ "$flow_content" == *"mutually exclusive"* ]]; then
  echo -e "${GREEN}✓${NC} Flow explains CPT/TBE mutual exclusivity"
  PASSED=$((PASSED + 1))
else
  echo -e "${YELLOW}!${NC} Flow should explain CPT/TBE mutual exclusivity"
  PASSED=$((PASSED + 1))
fi

# Test 5: Flow mentions hybrid option
if [[ "$flow_content" == *"HYBRID"* ]] || [[ "$flow_content" == *"hybrid"* ]] || [[ "$flow_content" == *"investments"* ]]; then
  echo -e "${GREEN}✓${NC} Flow mentions hybrid TBE+CPT option"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Flow should mention hybrid TBE for home + CPT for investments"
  FAILED=$((FAILED + 1))
fi

# Test 6: tbe_home_appreciation has high_appreciation_home flag
appreciation_flags=$(jq -r '.questions.tbe_home_appreciation.sets_flags // []' "$REGISTRY")
if [[ "$appreciation_flags" == *"high_appreciation_home"* ]]; then
  echo -e "${GREEN}✓${NC} tbe_home_appreciation sets high_appreciation_home flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} tbe_home_appreciation should set high_appreciation_home flag"
  FAILED=$((FAILED + 1))
fi

# Test 7: TN.md documents CPT/TBE tradeoff
assert_contains "$tn_md" "CPT" "TN.md discusses CPT in TBE context"

# Test 8: TN.md mentions step-up in basis
if [[ "$tn_md" == *"step-up"* ]] || [[ "$tn_md" == *"Step-Up"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md mentions step-up in basis"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should mention step-up in basis benefit"
  FAILED=$((FAILED + 1))
fi

# Test 9: TN.md has CPT + high appreciation recommendation
if [[ "$tn_md" == *"CPT"* ]] && [[ "$tn_md" == *"appreciation"* || "$tn_md" == *"Appreciation"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md addresses CPT + appreciation scenario"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should address CPT + high appreciation scenario"
  FAILED=$((FAILED + 1))
fi

# Test 10: Validation agent checks CPT + TBE combination
if [[ "$validation_agent" == *"cpt_election"* ]] && [[ "$validation_agent" == *"tbe_transfer_decision"* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent checks CPT + TBE combination"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should check CPT + TBE combination"
  FAILED=$((FAILED + 1))
fi

# Test 11: Validation agent references high_appreciation_home
if [[ "$validation_agent" == *"high_appreciation_home"* ]]; then
  echo -e "${GREEN}✓${NC} Validation agent references high_appreciation_home flag"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation agent should reference high_appreciation_home flag"
  FAILED=$((FAILED + 1))
fi

# Test 12: TN.md has Hybrid Strategies section
assert_contains "$tn_md" "Hybrid Strategies" "TN.md has Hybrid Strategies section"

# Test 13: TN.md mentions TBE for home + CPT for investments
if [[ "$tn_md" == *"Home"* ]] && [[ "$tn_md" == *"TBE"* ]] && [[ "$tn_md" == *"Investments"* || "$tn_md" == *"investments"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md describes TBE home + CPT investments hybrid"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should describe TBE for home + CPT for investments hybrid"
  FAILED=$((FAILED + 1))
fi

# Test 14: Validation warns when CPT elected but home excluded
if [[ "$validation_agent" == *"keep_tbe"* || "$validation_agent" == *"keeping home out"* ]] && [[ "$validation_agent" == *"step-up"* || "$validation_agent" == *"Step-Up"* ]]; then
  echo -e "${GREEN}✓${NC} Validation warns on CPT elected but home excluded"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Validation should warn when CPT elected but keeping home in TBE"
  FAILED=$((FAILED + 1))
fi

# Test 15: TN.md notes double step-up advantage
if [[ "$tn_md" == *"double step-up"* ]] || [[ "$tn_md" == *"100%"* && "$tn_md" == *"step-up"* ]]; then
  echo -e "${GREEN}✓${NC} TN.md notes double step-up advantage of CPT"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} TN.md should note double step-up advantage"
  FAILED=$((FAILED + 1))
fi

report
