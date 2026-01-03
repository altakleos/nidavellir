#!/bin/bash
# Test C3: Spouse Details Required for Married
# If marital_status = "Married", must ask spouse name and DOB

source "$(dirname "$0")/../lib/test-helpers.sh"

test_header "C3: Spouse Details Required"

# Test 1: Flow contains spouse name prompt
flow_content=$(cat "$FLOW")
assert_contains "$flow_content" "spouse's full legal name" "Flow has spouse name prompt"

# Test 2: Flow contains spouse DOB prompt
assert_contains "$flow_content" "spouse's date of birth" "Flow has spouse DOB prompt"

# Test 3: Spouse prompts are conditional on married status
assert_contains "$flow_content" "marital_status == married" "Spouse prompts conditional on married"

# Test 4: spouse_citizenship question exists
spouse_q=$(jq '.questions.spouse_citizenship' "$REGISTRY")
assert_not_empty "$spouse_q" "spouse_citizenship question exists"

# Test 5: spouse_citizenship has correct condition
cond=$(jq -r '.questions.spouse_citizenship.condition // ""' "$REGISTRY")
assert_contains "$cond" "has_spouse" "spouse_citizenship requires has_spouse flag"

report
