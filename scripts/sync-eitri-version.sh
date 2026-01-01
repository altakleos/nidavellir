#!/usr/bin/env bash
# sync-eitri-version.sh - Synchronize Eitri version across all 3 locations
#
# Usage: ./scripts/sync-eitri-version.sh <new-version>
# Example: ./scripts/sync-eitri-version.sh 1.10.0

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths relative to repository root
PLUGIN_JSON="plugins/eitri/.claude-plugin/plugin.json"
SKILL_MD="plugins/eitri/SKILL.md"
MARKETPLACE_JSON=".claude-plugin/marketplace.json"

# Get repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Validate input
if [[ $# -ne 1 ]]; then
    echo -e "${RED}Error: Version argument required${NC}"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.10.0"
    exit 1
fi

NEW_VERSION="$1"

# Validate semver format
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format. Use semantic versioning (e.g., 1.10.0)${NC}"
    exit 1
fi

echo -e "${YELLOW}Syncing Eitri version to $NEW_VERSION${NC}"
echo ""

# Function to get current version from file
get_current_version() {
    local file="$1"
    case "$file" in
        *plugin.json)
            grep -o '"version": *"[^"]*"' "$file" | head -1 | sed 's/.*"\([^"]*\)"/\1/'
            ;;
        *SKILL.md)
            grep -o 'version: *[0-9.]*' "$file" | head -1 | sed 's/version: *//'
            ;;
        *marketplace.json)
            # Get version from eitri entry specifically
            jq -r '.plugins[] | select(.name == "eitri") | .version' "$file" 2>/dev/null || echo "unknown"
            ;;
    esac
}

# Update plugin.json
echo -n "Updating $PLUGIN_JSON... "
OLD_VERSION=$(get_current_version "$PLUGIN_JSON")
if [[ -f "$PLUGIN_JSON" ]]; then
    sed -i "s/\"version\": *\"[^\"]*\"/\"version\": \"$NEW_VERSION\"/" "$PLUGIN_JSON"
    echo -e "${GREEN}✓${NC} ($OLD_VERSION → $NEW_VERSION)"
else
    echo -e "${RED}✗ File not found${NC}"
    exit 1
fi

# Update SKILL.md frontmatter
echo -n "Updating $SKILL_MD... "
OLD_VERSION=$(get_current_version "$SKILL_MD")
if [[ -f "$SKILL_MD" ]]; then
    sed -i "s/^version: *[0-9.]*/version: $NEW_VERSION/" "$SKILL_MD"
    echo -e "${GREEN}✓${NC} ($OLD_VERSION → $NEW_VERSION)"
else
    echo -e "${RED}✗ File not found${NC}"
    exit 1
fi

# Update marketplace.json (eitri entry only)
echo -n "Updating $MARKETPLACE_JSON (eitri entry)... "
OLD_VERSION=$(get_current_version "$MARKETPLACE_JSON")
if [[ -f "$MARKETPLACE_JSON" ]]; then
    # Use jq to update only the eitri plugin version
    jq --arg ver "$NEW_VERSION" '(.plugins[] | select(.name == "eitri") | .version) = $ver' "$MARKETPLACE_JSON" > "$MARKETPLACE_JSON.tmp"
    mv "$MARKETPLACE_JSON.tmp" "$MARKETPLACE_JSON"
    echo -e "${GREEN}✓${NC} ($OLD_VERSION → $NEW_VERSION)"
else
    echo -e "${RED}✗ File not found${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Version sync complete!${NC}"
echo ""
echo "Files updated:"
echo "  - $PLUGIN_JSON"
echo "  - $SKILL_MD"
echo "  - $MARKETPLACE_JSON"
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Commit: git commit -am 'chore(eitri): Bump version to $NEW_VERSION'"
