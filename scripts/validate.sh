#!/bin/bash

# Validation script for AltaKleos Claude Code Marketplace
# This script validates marketplace.json and all plugin.json files

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "========================================="
echo "Claude Code Marketplace Validator"
echo "========================================="
echo ""

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    echo "Please install jq: https://stedolan.github.io/jq/download/"
    exit 1
fi

# Function to validate JSON syntax
validate_json_syntax() {
    local file=$1
    if ! jq empty "$file" 2>/dev/null; then
        echo -e "${RED}✗ Invalid JSON syntax: $file${NC}"
        ERRORS=$((ERRORS + 1))
        return 1
    fi
    return 0
}

# Function to validate against schema (basic validation)
validate_plugin_schema() {
    local file=$1
    local plugin_dir=$(dirname "$file")

    echo "  Checking $file..."

    # Validate JSON syntax first
    if ! validate_json_syntax "$file"; then
        return
    fi

    # Check required fields
    local required_fields=("name" "version" "description" "author")
    for field in "${required_fields[@]}"; do
        if ! jq -e ".$field" "$file" > /dev/null 2>&1; then
            echo -e "${RED}  ✗ Missing required field: $field${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    done

    # Validate name format (lowercase, hyphens only)
    local name=$(jq -r '.name // ""' "$file")
    if [[ -n "$name" ]] && ! [[ "$name" =~ ^[a-z0-9-]+$ ]]; then
        echo -e "${RED}  ✗ Invalid name format: $name (use lowercase and hyphens only)${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Validate version format (semver)
    local version=$(jq -r '.version // ""' "$file")
    if [[ -n "$version" ]] && ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?(\+[a-zA-Z0-9.-]+)?$ ]]; then
        echo -e "${RED}  ✗ Invalid version format: $version (use semver: X.Y.Z)${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Validate description length
    local description=$(jq -r '.description // ""' "$file")
    local desc_len=${#description}
    if [[ $desc_len -lt 10 ]]; then
        echo -e "${RED}  ✗ Description too short: $desc_len chars (min 10)${NC}"
        ERRORS=$((ERRORS + 1))
    elif [[ $desc_len -gt 500 ]]; then
        echo -e "${RED}  ✗ Description too long: $desc_len chars (max 500)${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Check author fields
    if ! jq -e '.author.name' "$file" > /dev/null 2>&1; then
        echo -e "${RED}  ✗ Missing author.name${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    if ! jq -e '.author.email' "$file" > /dev/null 2>&1; then
        echo -e "${RED}  ✗ Missing author.email${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Check for README.md (in plugin root, not .claude-plugin/)
    local plugin_root=$(dirname "$plugin_dir")
    if [[ ! -f "$plugin_root/README.md" ]]; then
        echo -e "${YELLOW}  ⚠ Missing README.md${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi

    # Check category if exists
    local category=$(jq -r '.category // ""' "$file")
    if [[ -n "$category" ]]; then
        local valid_categories=("productivity" "development" "testing" "documentation" "security" "ai-assistance" "utilities" "integration" "other")
        if [[ ! " ${valid_categories[@]} " =~ " ${category} " ]]; then
            echo -e "${YELLOW}  ⚠ Invalid category: $category${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi

    echo -e "${GREEN}  ✓ $file validated${NC}"
}

# Function to validate SKILL.md frontmatter
validate_skill_md() {
    local file=$1
    local plugin_name=$(basename "$(dirname "$file")")

    echo "  Checking $file..."

    # Check if file exists
    if [[ ! -f "$file" ]]; then
        return 0
    fi

    # Extract frontmatter (between first two --- lines)
    local frontmatter=""
    local in_frontmatter=false
    local line_num=0
    while IFS= read -r line; do
        line_num=$((line_num + 1))
        if [[ "$line" == "---" ]]; then
            if [[ "$in_frontmatter" == false ]]; then
                if [[ $line_num -eq 1 ]]; then
                    in_frontmatter=true
                fi
            else
                break
            fi
        elif [[ "$in_frontmatter" == true ]]; then
            frontmatter+="$line"$'\n'
        fi
    done < "$file"

    if [[ -z "$frontmatter" ]]; then
        echo -e "${YELLOW}  ⚠ No frontmatter found in SKILL.md${NC}"
        WARNINGS=$((WARNINGS + 1))
        return 0
    fi

    # Check for required fields
    if ! echo "$frontmatter" | grep -q "^name:"; then
        echo -e "${RED}  ✗ Missing required field: name${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    if ! echo "$frontmatter" | grep -q "^description:"; then
        echo -e "${RED}  ✗ Missing required field: description${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Check name format and length (max 64 chars)
    local name=$(echo "$frontmatter" | grep "^name:" | sed 's/^name: *//')
    if [[ -n "$name" ]]; then
        if ! [[ "$name" =~ ^[a-z0-9-]+$ ]]; then
            echo -e "${RED}  ✗ Invalid name format: $name (use lowercase, numbers, hyphens only)${NC}"
            ERRORS=$((ERRORS + 1))
        fi
        if [[ ${#name} -gt 64 ]]; then
            echo -e "${RED}  ✗ Name too long: ${#name} chars (max 64)${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    fi

    # Check description length (max 1024 chars)
    local description=$(echo "$frontmatter" | grep "^description:" | sed 's/^description: *//')
    if [[ -n "$description" ]]; then
        if [[ ${#description} -gt 1024 ]]; then
            echo -e "${RED}  ✗ Description too long: ${#description} chars (max 1024)${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    fi

    # Check for non-standard fields (strict - additionalProperties: false per schema)
    local official_fields="name description version disable-model-invocation mode allowed-tools"
    while IFS= read -r line; do
        if [[ "$line" =~ ^([a-z-]+): ]]; then
            local field="${BASH_REMATCH[1]}"
            if [[ ! " $official_fields " =~ " $field " ]]; then
                echo -e "${RED}  ✗ Non-standard frontmatter field: $field (not in official Claude Code spec)${NC}"
                ERRORS=$((ERRORS + 1))
            fi
        fi
    done <<< "$frontmatter"

    echo -e "${GREEN}  ✓ SKILL.md validated${NC}"
}

# Validate marketplace.json
echo "1. Validating marketplace.json"
echo "-------------------------------------"

MARKETPLACE_FILE=".claude-plugin/marketplace.json"

if [[ ! -f "$MARKETPLACE_FILE" ]]; then
    echo -e "${RED}✗ $MARKETPLACE_FILE not found${NC}"
    ERRORS=$((ERRORS + 1))
else
    if validate_json_syntax "$MARKETPLACE_FILE"; then
        # Check required marketplace fields
        required_fields=("name" "owner" "metadata" "plugins")
        for field in "${required_fields[@]}"; do
            if ! jq -e ".$field" "$MARKETPLACE_FILE" > /dev/null 2>&1; then
                echo -e "${RED}✗ Missing required field in marketplace.json: $field${NC}"
                ERRORS=$((ERRORS + 1))
            fi
        done

        echo -e "${GREEN}✓ Marketplace structure valid${NC}"
    fi
fi

echo ""

# Validate all plugin.json files
echo "2. Validating plugin.json files"
echo "-------------------------------------"

PLUGIN_COUNT=0
if [[ -d "plugins" ]]; then
    while IFS= read -r -d '' plugin_file; do
        PLUGIN_COUNT=$((PLUGIN_COUNT + 1))
        validate_plugin_schema "$plugin_file"
    done < <(find plugins -name "plugin.json" -type f -print0)
else
    echo -e "${YELLOW}⚠ No plugins directory found${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""

# Validate SKILL.md files
echo "3. Validating SKILL.md files"
echo "-------------------------------------"

SKILL_COUNT=0
if [[ -d "plugins" ]]; then
    while IFS= read -r -d '' skill_file; do
        SKILL_COUNT=$((SKILL_COUNT + 1))
        validate_skill_md "$skill_file"
    done < <(find plugins -name "SKILL.md" -type f -print0)

    if [[ $SKILL_COUNT -eq 0 ]]; then
        echo -e "${YELLOW}⚠ No SKILL.md files found${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

echo ""

# Cross-validate marketplace.json with actual plugins
echo "4. Cross-validating marketplace entries"
echo "-------------------------------------"

if [[ -f "$MARKETPLACE_FILE" ]]; then
    MARKETPLACE_PLUGIN_COUNT=$(jq '.plugins | length' "$MARKETPLACE_FILE")
    echo "  Marketplace lists $MARKETPLACE_PLUGIN_COUNT plugin(s)"
    echo "  Found $PLUGIN_COUNT plugin.json file(s)"

    # Check each marketplace entry has corresponding plugin
    for i in $(seq 0 $((MARKETPLACE_PLUGIN_COUNT - 1))); do
        plugin_name=$(jq -r ".plugins[$i].name" "$MARKETPLACE_FILE")
        plugin_source=$(jq -r ".plugins[$i].source" "$MARKETPLACE_FILE")

        # Check for plugin.json in either location (root or .claude-plugin/)
        plugin_json_path=""
        if [[ -f "$plugin_source/.claude-plugin/plugin.json" ]]; then
            plugin_json_path="$plugin_source/.claude-plugin/plugin.json"
        elif [[ -f "$plugin_source/plugin.json" ]]; then
            plugin_json_path="$plugin_source/plugin.json"
        fi

        if [[ -z "$plugin_json_path" ]]; then
            echo -e "${RED}  ✗ Plugin not found: $plugin_name at $plugin_source${NC}"
            ERRORS=$((ERRORS + 1))
        else
            # Verify versions match
            marketplace_version=$(jq -r ".plugins[$i].version" "$MARKETPLACE_FILE")
            plugin_version=$(jq -r ".version" "$plugin_json_path")

            if [[ "$marketplace_version" != "$plugin_version" ]]; then
                echo -e "${YELLOW}  ⚠ Version mismatch for $plugin_name: marketplace=$marketplace_version, plugin=$plugin_version${NC}"
                WARNINGS=$((WARNINGS + 1))
            fi
        fi
    done

    echo -e "${GREEN}✓ Cross-validation complete${NC}"
fi

echo ""

# Validate Skuld intake registry
echo "5. Validating Skuld intake registry"
echo "-------------------------------------"

INTAKE_REGISTRY="plugins/skuld/intake-registry.json"
INTAKE_SCHEMA="schemas/intake-registry.schema.json"

if [[ -f "$INTAKE_REGISTRY" ]]; then
    echo "  Checking $INTAKE_REGISTRY..."

    # Validate JSON syntax
    if ! validate_json_syntax "$INTAKE_REGISTRY"; then
        echo -e "${RED}  ✗ Invalid JSON in intake-registry.json${NC}"
    else
        # Check required top-level fields
        if ! jq -e '.version' "$INTAKE_REGISTRY" > /dev/null 2>&1; then
            echo -e "${RED}  ✗ Missing required field: version${NC}"
            ERRORS=$((ERRORS + 1))
        fi

        if ! jq -e '.questions' "$INTAKE_REGISTRY" > /dev/null 2>&1; then
            echo -e "${RED}  ✗ Missing required field: questions${NC}"
            ERRORS=$((ERRORS + 1))
        fi

        # Validate each question has required fields
        QUESTION_COUNT=$(jq '.questions | keys | length' "$INTAKE_REGISTRY")
        echo "  Found $QUESTION_COUNT questions in registry"

        INVALID_QUESTIONS=0
        for key in $(jq -r '.questions | keys[]' "$INTAKE_REGISTRY"); do
            # Check id matches key
            local_id=$(jq -r ".questions[\"$key\"].id // \"\"" "$INTAKE_REGISTRY")
            if [[ "$local_id" != "$key" ]]; then
                echo -e "${RED}  ✗ Question id mismatch: key=$key, id=$local_id${NC}"
                INVALID_QUESTIONS=$((INVALID_QUESTIONS + 1))
            fi

            # Check required fields
            for field in "phase" "type" "question_text"; do
                if ! jq -e ".questions[\"$key\"].$field" "$INTAKE_REGISTRY" > /dev/null 2>&1; then
                    echo -e "${RED}  ✗ Question '$key' missing required field: $field${NC}"
                    INVALID_QUESTIONS=$((INVALID_QUESTIONS + 1))
                fi
            done

            # Check select/multi_select have options
            local_type=$(jq -r ".questions[\"$key\"].type // \"\"" "$INTAKE_REGISTRY")
            if [[ "$local_type" == "select" || "$local_type" == "multi_select" ]]; then
                options_count=$(jq ".questions[\"$key\"].options | length // 0" "$INTAKE_REGISTRY")
                if [[ "$options_count" -lt 2 ]]; then
                    echo -e "${RED}  ✗ Question '$key' ($local_type) needs at least 2 options, found $options_count${NC}"
                    INVALID_QUESTIONS=$((INVALID_QUESTIONS + 1))
                fi
            fi
        done

        if [[ $INVALID_QUESTIONS -gt 0 ]]; then
            ERRORS=$((ERRORS + INVALID_QUESTIONS))
        else
            echo -e "${GREEN}  ✓ All $QUESTION_COUNT questions validated${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠ intake-registry.json not found at $INTAKE_REGISTRY${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""

# Validate Skuld intake coverage
echo "6. Validating Skuld intake coverage"
echo "-------------------------------------"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/validate-intake-coverage.sh" ]]; then
    if ! "$SCRIPT_DIR/validate-intake-coverage.sh"; then
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${YELLOW}⚠ validate-intake-coverage.sh not found, skipping${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "========================================="
echo "Validation Summary"
echo "========================================="
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"
echo ""

if [[ $ERRORS -gt 0 ]]; then
    echo -e "${RED}Validation FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}Validation PASSED${NC}"
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}(with warnings)${NC}"
    fi
    exit 0
fi
