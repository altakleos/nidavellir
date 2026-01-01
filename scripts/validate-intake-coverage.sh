#!/bin/bash

# Skuld Intake Coverage Validator
# Validates that all handler requirements have corresponding intake questions

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SKULD_DIR="plugins/skuld"
AGENTS_DIR="$SKULD_DIR/agents"
SKILL_FILE="$SKULD_DIR/SKILL.md"

ERRORS=0
WARNINGS=0

# Check if skuld plugin exists
if [[ ! -d "$SKULD_DIR" ]]; then
    echo -e "${YELLOW}⚠ Skuld plugin not found, skipping intake coverage validation${NC}"
    exit 0
fi

echo -e "${BLUE}Validating Skuld Intake Coverage${NC}"
echo "-------------------------------------"

# Extract requires_intake from all agent files
declare -A HANDLER_REQUIREMENTS
declare -A HANDLER_OPTIONAL

extract_handler_requirements() {
    local agent_file=$1
    local agent_name=$(basename "$agent_file" .md)

    # Extract frontmatter
    local in_frontmatter=false
    local frontmatter=""
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
    done < "$agent_file"

    # Parse requires_intake (simple grep for now)
    local in_requires=false
    local requires=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^requires_intake: ]]; then
            in_requires=true
            continue
        fi
        if [[ "$in_requires" == true ]]; then
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
                requires+="${BASH_REMATCH[1]} "
            elif [[ ! "$line" =~ ^[[:space:]] ]]; then
                break
            fi
        fi
    done <<< "$frontmatter"

    HANDLER_REQUIREMENTS[$agent_name]="$requires"

    # Parse optional_intake
    local in_optional=false
    local optional=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^optional_intake: ]]; then
            in_optional=true
            continue
        fi
        if [[ "$in_optional" == true ]]; then
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.*) ]]; then
                optional+="${BASH_REMATCH[1]} "
            elif [[ ! "$line" =~ ^[[:space:]] ]]; then
                break
            fi
        fi
    done <<< "$frontmatter"

    HANDLER_OPTIONAL[$agent_name]="$optional"
}

# Extract intake_ids from SKILL.md
declare -A INTAKE_IDS

extract_intake_ids() {
    # Extract from HTML comments: <!-- intake_id: xxx -->
    while IFS= read -r line; do
        if [[ "$line" =~ \<!--[[:space:]]*intake_id:[[:space:]]*([a-z_,[:space:]]+)[[:space:]]*--\> ]]; then
            local ids="${BASH_REMATCH[1]}"
            # Split by comma and add each
            IFS=',' read -ra ID_ARRAY <<< "$ids"
            for id in "${ID_ARRAY[@]}"; do
                id=$(echo "$id" | tr -d ' ')
                if [[ -n "$id" ]]; then
                    INTAKE_IDS[$id]=1
                fi
            done
        fi
    done < "$SKILL_FILE"

    # Also extract from intake graph tables (| `id` | format)
    while IFS= read -r line; do
        if [[ "$line" =~ ^\|[[:space:]]*\`([a-z_]+)\`[[:space:]]*\| ]]; then
            local id="${BASH_REMATCH[1]}"
            INTAKE_IDS[$id]=1
        fi
    done < "$SKILL_FILE"
}

# Process all agent files
echo "  Extracting handler requirements..."
for agent_file in "$AGENTS_DIR"/*.md; do
    if [[ -f "$agent_file" ]]; then
        extract_handler_requirements "$agent_file"
    fi
done

# Extract intake IDs from SKILL.md
echo "  Extracting intake IDs from SKILL.md..."
extract_intake_ids

# Report findings
echo ""
echo "  Handler Requirements:"
for agent in "${!HANDLER_REQUIREMENTS[@]}"; do
    reqs="${HANDLER_REQUIREMENTS[$agent]}"
    if [[ -n "$reqs" ]]; then
        echo "    $agent: $reqs"
    fi
done

echo ""
echo "  Intake IDs Found: ${!INTAKE_IDS[@]}"
echo ""

# Check for missing intake IDs
echo "  Checking coverage..."
MISSING_INTAKES=""

for agent in "${!HANDLER_REQUIREMENTS[@]}"; do
    reqs="${HANDLER_REQUIREMENTS[$agent]}"
    for req in $reqs; do
        if [[ -z "${INTAKE_IDS[$req]}" ]]; then
            MISSING_INTAKES+="    $agent requires '$req' - NOT FOUND\n"
            ERRORS=$((ERRORS + 1))
        fi
    done
done

if [[ -n "$MISSING_INTAKES" ]]; then
    echo ""
    echo -e "${RED}  Missing Intake Questions:${NC}"
    echo -e "$MISSING_INTAKES"
else
    echo -e "${GREEN}  ✓ All handler requirements have corresponding intake questions${NC}"
fi

# Check for optional intake coverage (warnings only)
MISSING_OPTIONAL=""
for agent in "${!HANDLER_OPTIONAL[@]}"; do
    opts="${HANDLER_OPTIONAL[$agent]}"
    for opt in $opts; do
        if [[ -z "${INTAKE_IDS[$opt]}" ]]; then
            MISSING_OPTIONAL+="    $agent optional '$opt' - NOT FOUND\n"
            WARNINGS=$((WARNINGS + 1))
        fi
    done
done

if [[ -n "$MISSING_OPTIONAL" ]]; then
    echo ""
    echo -e "${YELLOW}  Missing Optional Intake Questions:${NC}"
    echo -e "$MISSING_OPTIONAL"
fi

echo ""
echo "-------------------------------------"
echo -e "Intake Coverage: Errors=${RED}$ERRORS${NC}, Warnings=${YELLOW}$WARNINGS${NC}"

if [[ $ERRORS -gt 0 ]]; then
    exit 1
fi
exit 0
