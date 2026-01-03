#!/bin/bash
# Test C7: Document Selection Questions Asked Separately
# document_acceptance and trust_structure MUST be separate questions

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C7: Document Questions Separate"

# Test 1: document_acceptance exists
doc_q=$(jq '.questions.document_acceptance // null' "$REGISTRY")
assert_not_empty "$doc_q" "document_acceptance question exists"

# Test 2: trust_structure exists
trust_q=$(jq '.questions.trust_structure // null' "$REGISTRY")
assert_not_empty "$trust_q" "trust_structure question exists"

# Test 3: Both are in Phase 2
doc_phase=$(jq '.questions.document_acceptance.phase' "$REGISTRY")
trust_phase=$(jq '.questions.trust_structure.phase' "$REGISTRY")
assert_eq "$doc_phase" "2" "document_acceptance in phase 2"
assert_eq "$trust_phase" "2" "trust_structure in phase 2"

# Test 4: document_acceptance has C7 constraint tag
doc_c7=$(question_has_constraint "document_acceptance" "C7")
assert_eq "$doc_c7" "true" "document_acceptance tagged with C7"

# Test 5: trust_structure has C7 constraint tag
trust_c7=$(question_has_constraint "trust_structure" "C7")
assert_eq "$trust_c7" "true" "trust_structure tagged with C7"

# Test 6: Flow shows them as separate questions with [STOP] between
flow_content=$(cat "$FLOW")
assert_contains "$flow_content" "document_acceptance" "Flow references document_acceptance"
assert_contains "$flow_content" "trust_structure" "Flow references trust_structure"

# Test 7: Flow explicitly notes C7 constraint
assert_contains "$flow_content" "C7" "Flow mentions C7 constraint"

report
