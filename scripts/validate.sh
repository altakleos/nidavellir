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

    # Check for README.md
    if [[ ! -f "$plugin_dir/README.md" ]]; then
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

# Cross-validate marketplace.json with actual plugins
echo "3. Cross-validating marketplace entries"
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
