#!/usr/bin/env bash
# validate-links.sh - Valida links entre requisitos (detecta orphans e nós isolados)
#
# Usage: ./scripts/validate-links.sh [project_root]
#
# Reads: RTM.yaml (gerado por generate-rtm.sh)
# Validates:
#   1. Links apontam para IDs existentes (no orphans)
#   2. Nós isolados (sem upstream nem downstream)
#
# Exit codes:
#   0 - Validação passou
#   1 - Orphans ou nós isolados detectados

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROJECT_ROOT="${1:-.}"
RTM_FILE="$PROJECT_ROOT/RTM.yaml"

ORPHAN_COUNT=0
ISOLATED_COUNT=0
ERRORS=()

echo "========================================="
echo "Link Validation Report"
echo "========================================="
echo "RTM: $RTM_FILE"
echo ""

if [[ ! -f "$RTM_FILE" ]]; then
    echo -e "${RED}ERROR: RTM.yaml not found${NC}"
    echo "Run scripts/generate-rtm.sh first"
    exit 1
fi

if ! command -v yq &> /dev/null; then
    echo -e "${RED}ERROR: yq not installed${NC}"
    exit 1
fi

# Extract all existing IDs
ALL_IDS=$(yq '.nodes | to_entries | .[] | .value | to_entries | .[].key' "$RTM_FILE" | sort -u)

echo "Total IDs in RTM: $(echo "$ALL_IDS" | wc -l)"
echo ""
echo "Validating links..."
echo ""

# Validate upstream links
UPSTREAM_LINKS=$(yq '.edges.upstream | to_entries[] | .key as $source | .value[] | "\($source) <- \(.)"' "$RTM_FILE" 2>/dev/null || echo "")

if [[ -n "$UPSTREAM_LINKS" ]]; then
    while IFS= read -r link; do
        target=$(echo "$link" | awk '{print $NF}')
        source=$(echo "$link" | awk '{print $1}')

        if ! echo "$ALL_IDS" | grep -qx "$target"; then
            ERRORS+=("Orphan upstream link: $source <- $target (target does not exist)")
            ((ORPHAN_COUNT++))
        fi
    done <<< "$UPSTREAM_LINKS"
fi

# Validate downstream links
DOWNSTREAM_LINKS=$(yq '.edges.downstream | to_entries[] | .key as $source | .value[] | "\($source) -> \(.)"' "$RTM_FILE" 2>/dev/null || echo "")

if [[ -n "$DOWNSTREAM_LINKS" ]]; then
    while IFS= read -r link; do
        target=$(echo "$link" | awk '{print $NF}')
        source=$(echo "$link" | awk '{print $1}')

        if ! echo "$ALL_IDS" | grep -qx "$target"; then
            ERRORS+=("Orphan downstream link: $source -> $target (target does not exist)")
            ((ORPHAN_COUNT++))
        fi
    done <<< "$DOWNSTREAM_LINKS"
fi

# Detect isolated nodes
while IFS= read -r id; do
    HAS_UPSTREAM=$(yq ".edges.upstream.\"$id\" // []" "$RTM_FILE" | grep -v "^\[\]$" || echo "")
    HAS_DOWNSTREAM=$(yq ".edges.downstream.\"$id\" // []" "$RTM_FILE" | grep -v "^\[\]$" || echo "")

    if [[ -z "$HAS_UPSTREAM" && -z "$HAS_DOWNSTREAM" ]]; then
        ERRORS+=("Isolated node: $id (no upstream or downstream links)")
        ((ISOLATED_COUNT++))
    fi
done <<< "$ALL_IDS"

echo "========================================="
echo "Validation Summary"
echo "========================================="
echo "Orphan links: $ORPHAN_COUNT"
echo "Isolated nodes: $ISOLATED_COUNT"
echo ""

if [[ ${#ERRORS[@]} -gt 0 ]]; then
    echo -e "${RED}Errors detected:${NC}"
    for error in "${ERRORS[@]}"; do
        echo -e "  ${RED}✗${NC} $error"
    done
    echo ""
    echo -e "${RED}❌ VALIDATION FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}✅ VALIDATION PASSED${NC}"
    echo "All links are valid, no isolated nodes."
    exit 0
fi
