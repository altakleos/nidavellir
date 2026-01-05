#!/bin/bash
# Test Scenario: Exclusive Choice UX Enhancements
# Tests: Document preview, escape hatches, bias removal, preambles
# Expected: Better UX for binary/exclusive choice questions

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "Scenario: Exclusive Choice UX"

echo ""
echo "Testing UX enhancements for exclusive choice questions"
echo ""

# ═══════════════════════════════════════════════════════════════
# SECTION 1: Document Preview Before Acceptance
# ═══════════════════════════════════════════════════════════════

# Test 1: document_acceptance references documents shown above
doc_accept_text=$(jq -r '.questions.document_acceptance.question_text // ""' "$REGISTRY")
if [[ "$doc_accept_text" == *"above"* ]] || [[ "$doc_accept_text" == *"shown"* ]]; then
  echo -e "${GREEN}✓${NC} document_acceptance references visible documents"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} document_acceptance should reference 'documents shown above'"
  echo "  Actual: $doc_accept_text"
  FAILED=$((FAILED + 1))
fi

# Test 2: document_acceptance has note about displaying preview
doc_accept_note=$(jq -r '.questions.document_acceptance.note // ""' "$REGISTRY")
if [[ "$doc_accept_note" == *"display"* ]] || [[ "$doc_accept_note" == *"BEFORE"* ]]; then
  echo -e "${GREEN}✓${NC} document_acceptance note mentions displaying preview first"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} document_acceptance should have note about preview display"
  FAILED=$((FAILED + 1))
fi

# Test 3: intake-flow.md has document preview box in section 2.1
if grep -q "YOUR RECOMMENDED ESTATE PLAN DOCUMENTS" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md contains document preview box"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should contain document preview box"
  FAILED=$((FAILED + 1))
fi

# Test 4: Preview box appears BEFORE document_acceptance question
preview_line=$(grep -n "YOUR RECOMMENDED ESTATE PLAN DOCUMENTS" "$FLOW" | head -1 | cut -d: -f1)
acceptance_line=$(grep -n "Ask.*document_acceptance" "$FLOW" | head -1 | cut -d: -f1)
if [[ -n "$preview_line" ]] && [[ -n "$acceptance_line" ]] && [[ $preview_line -lt $acceptance_line ]]; then
  echo -e "${GREEN}✓${NC} Document preview appears before acceptance question"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Document preview should appear before acceptance question"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 2: Escape Hatches on Critical Questions
# ═══════════════════════════════════════════════════════════════

# Test 5: spendthrift_preference has discuss escape hatch
spend_opts=$(jq -r '[.questions.spendthrift_preference.options[].value] | join(",")' "$REGISTRY")
assert_contains "$spend_opts" "discuss" "spendthrift_preference has discuss escape hatch"

# Test 6: distribution_equality has discuss escape hatch
eq_opts=$(jq -r '[.questions.distribution_equality.options[].value] | join(",")' "$REGISTRY")
assert_contains "$eq_opts" "discuss" "distribution_equality has discuss escape hatch"

# Test 7: trust_structure has help escape hatch
trust_opts=$(jq -r '[.questions.trust_structure.options[].value] | join(",")' "$REGISTRY")
assert_contains "$trust_opts" "help" "trust_structure has help escape hatch"

# Test 8: partner_healthcare_agent has help escape hatch
hc_opts=$(jq -r '[.questions.partner_healthcare_agent.options[].value] | join(",")' "$REGISTRY")
assert_contains "$hc_opts" "help" "partner_healthcare_agent has help escape hatch"

# Test 9: partner_financial_agent has help escape hatch
fin_opts=$(jq -r '[.questions.partner_financial_agent.options[].value] | join(",")' "$REGISTRY")
assert_contains "$fin_opts" "help" "partner_financial_agent has help escape hatch"

# Test 10: beneficiary_coordination_checklist has later escape hatch
bcc_opts=$(jq -r '[.questions.beneficiary_coordination_checklist.options[].value] | join(",")' "$REGISTRY")
assert_contains "$bcc_opts" "later" "beneficiary_coordination_checklist has later escape hatch"

# ═══════════════════════════════════════════════════════════════
# SECTION 3: No "(Recommended)" Bias in Labels
# ═══════════════════════════════════════════════════════════════

# Test 11: No options contain "(Recommended)" or "(recommended)"
biased_labels=$(jq -r '[.questions[].options[]?.label // empty] | .[]' "$REGISTRY" | grep -i "(recommended)" || true)
if [[ -z "$biased_labels" ]]; then
  echo -e "${GREEN}✓${NC} No option labels contain (Recommended) bias"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} Found biased labels with (Recommended):"
  echo "$biased_labels" | while read -r label; do
    echo "  - $label"
  done
  FAILED=$((FAILED + 1))
fi

# Test 12: Specific check on distribution_age_schedule (was known to have bias)
age_labels=$(jq -r '[.questions.distribution_age_schedule.options[].label] | join("|")' "$REGISTRY")
if [[ "$age_labels" == *"(Recommended)"* ]] || [[ "$age_labels" == *"(recommended)"* ]]; then
  echo -e "${RED}✗${NC} distribution_age_schedule still has (Recommended) in labels"
  FAILED=$((FAILED + 1))
else
  echo -e "${GREEN}✓${NC} distribution_age_schedule labels are neutral"
  PASSED=$((PASSED + 1))
fi

# Test 13: Specific check on distribution_method
method_labels=$(jq -r '[.questions.distribution_method.options[].label] | join("|")' "$REGISTRY")
if [[ "$method_labels" == *"(Recommended)"* ]] || [[ "$method_labels" == *"(recommended)"* ]]; then
  echo -e "${RED}✗${NC} distribution_method still has (Recommended) in labels"
  FAILED=$((FAILED + 1))
else
  echo -e "${GREEN}✓${NC} distribution_method labels are neutral"
  PASSED=$((PASSED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 4: Preambles Exist on Complex Questions
# ═══════════════════════════════════════════════════════════════

# Test 14: spendthrift_preference has preamble
spend_preamble=$(jq -r '.questions.spendthrift_preference.preamble // ""' "$REGISTRY")
assert_not_empty "$spend_preamble" "spendthrift_preference has preamble"

# Test 15: distribution_equality has preamble
eq_preamble=$(jq -r '.questions.distribution_equality.preamble // ""' "$REGISTRY")
assert_not_empty "$eq_preamble" "distribution_equality has preamble"

# Test 16: trust_structure has preamble
trust_preamble=$(jq -r '.questions.trust_structure.preamble // ""' "$REGISTRY")
assert_not_empty "$trust_preamble" "trust_structure has preamble"

# Test 17: beneficiary_coordination_checklist has preamble
bcc_preamble=$(jq -r '.questions.beneficiary_coordination_checklist.preamble // ""' "$REGISTRY")
assert_not_empty "$bcc_preamble" "beneficiary_coordination_checklist has preamble"

# ═══════════════════════════════════════════════════════════════
# SECTION 5: Escape Hatch Handlers in Flow
# ═══════════════════════════════════════════════════════════════

# Test 18: Flow has handler for spendthrift_preference discuss
if grep -q "spendthrift_preference == discuss" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md has handler for spendthrift discuss"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should handle spendthrift discuss escape"
  FAILED=$((FAILED + 1))
fi

# Test 19: Flow has handler for distribution_equality discuss
if grep -q "distribution.equality == discuss" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md has handler for distribution equality discuss"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should handle distribution equality discuss escape"
  FAILED=$((FAILED + 1))
fi

# Test 20: Flow has handler for trust_structure help
if grep -q "trust_structure == help" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md has handler for trust structure help"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should handle trust structure help escape"
  FAILED=$((FAILED + 1))
fi

# Test 21: Flow has handler for partner_healthcare_agent help
if grep -q "partner_healthcare_agent == help" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md has handler for healthcare agent help"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should handle healthcare agent help escape"
  FAILED=$((FAILED + 1))
fi

# Test 22: Flow has handler for partner_financial_agent help
if grep -q "partner_financial_agent == help" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md has handler for financial agent help"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should handle financial agent help escape"
  FAILED=$((FAILED + 1))
fi

# Test 23: Flow has handler for beneficiary_coordination_checklist later
if grep -q "beneficiary_coordination_checklist == later" "$FLOW"; then
  echo -e "${GREEN}✓${NC} intake-flow.md has handler for checklist later escape"
  PASSED=$((PASSED + 1))
else
  echo -e "${RED}✗${NC} intake-flow.md should handle checklist later escape"
  FAILED=$((FAILED + 1))
fi

# ═══════════════════════════════════════════════════════════════
# SECTION 6: Question Type Consistency (Buttons vs Numbers)
# ═══════════════════════════════════════════════════════════════

# Test 24: Questions with 3 options use select (clickable buttons)
spend_type=$(jq -r '.questions.spendthrift_preference.type // ""' "$REGISTRY")
assert_eq "$spend_type" "select" "spendthrift_preference (3 options) uses select type"

# Test 25: Questions with 3 options use select (buttons)
trust_type=$(jq -r '.questions.trust_structure.type // ""' "$REGISTRY")
assert_eq "$trust_type" "select" "trust_structure (3 options) uses select type"

# Test 26: Questions with 5+ options use numbered_select (type numbers)
age_type=$(jq -r '.questions.distribution_age_schedule.type // ""' "$REGISTRY")
assert_eq "$age_type" "numbered_select" "distribution_age_schedule (6 options) uses numbered_select"

report
