#!/usr/bin/env bash
# impact-analysis.sh - Analisa impacto de mudanças via BFS traversal
#
# Usage: ./scripts/impact-analysis.sh <changed_id> [project_root]
#
# Reads: RTM.yaml
# Output: Lista de artefatos afetados downstream com profundidade
#
# Exit codes:
#   0 - Análise completa
#   1 - Erro (ID não existe ou RTM não encontrado)

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

CHANGED_ID="$1"
PROJECT_ROOT="${2:-.}"
RTM_FILE="$PROJECT_ROOT/RTM.yaml"

if [[ -z "$CHANGED_ID" ]]; then
    echo "Usage: $0 <changed_id> [project_root]"
    exit 1
fi

if [[ ! -f "$RTM_FILE" ]]; then
    echo -e "${RED}ERROR: RTM.yaml not found at $RTM_FILE${NC}"
    echo "Run scripts/generate-rtm.sh first"
    exit 1
fi

if ! command -v yq &> /dev/null; then
    echo -e "${RED}ERROR: yq not installed${NC}"
    exit 1
fi

echo "========================================="
echo "Change Impact Analysis"
echo "========================================="
echo "Changed ID: $CHANGED_ID"
echo "RTM: $RTM_FILE"
echo ""

# Check if ID exists
ALL_IDS=$(yq '.nodes | to_entries | .[] | .value | to_entries | .[].key' "$RTM_FILE" | sort -u)

if ! echo "$ALL_IDS" | grep -qx "$CHANGED_ID"; then
    echo -e "${RED}ERROR: ID '$CHANGED_ID' not found in RTM${NC}"
    exit 1
fi

# BFS traversal
declare -A VISITED
declare -A DEPTH_MAP
QUEUE=("$CHANGED_ID")
DEPTH_MAP[$CHANGED_ID]=0
VISITED[$CHANGED_ID]=1

MAX_DEPTH=0
TOTAL_AFFECTED=0

echo "Traversing downstream dependencies..."
echo ""

while [[ ${#QUEUE[@]} -gt 0 ]]; do
    current="${QUEUE[0]}"
    QUEUE=("${QUEUE[@]:1}")

    current_depth=${DEPTH_MAP[$current]}

    # Get downstream links
    DOWNSTREAM=$(yq ".edges.downstream.\"$current\" // []" "$RTM_FILE" 2>/dev/null | yq '.[]' 2>/dev/null | tr -d '"' || echo "")

    if [[ -n "$DOWNSTREAM" ]]; then
        while IFS= read -r target; do
            if [[ -z "${VISITED[$target]:-}" ]]; then
                VISITED[$target]=1
                new_depth=$((current_depth + 1))
                DEPTH_MAP[$target]=$new_depth
                QUEUE+=("$target")

                if [[ $new_depth -gt $MAX_DEPTH ]]; then
                    MAX_DEPTH=$new_depth
                fi

                ((TOTAL_AFFECTED++))
            fi
        done <<< "$DOWNSTREAM"
    fi
done

echo "========================================="
echo "Impact Summary"
echo "========================================="
echo "Total affected artifacts: $TOTAL_AFFECTED"
echo "Maximum depth: $MAX_DEPTH"
echo ""

if [[ $TOTAL_AFFECTED -eq 0 ]]; then
    echo -e "${GREEN}No downstream dependencies affected${NC}"
    exit 0
fi

echo "Affected artifacts by depth:"
echo ""

for depth in $(seq 1 $MAX_DEPTH); do
    echo -e "${BLUE}Depth $depth:${NC}"

    for id in "${!DEPTH_MAP[@]}"; do
        if [[ ${DEPTH_MAP[$id]} -eq $depth ]]; then
            # Get type
            TYPE=""
            if [[ "$id" =~ ^UJ- ]]; then
                TYPE="User Journey"
            elif [[ "$id" =~ ^FR- ]]; then
                TYPE="Functional Requirement"
            elif [[ "$id" =~ ^PROC- ]]; then
                TYPE="Process"
            elif [[ "$id" =~ ^DOC- ]]; then
                TYPE="Document"
            elif [[ "$id" =~ ^INV- ]]; then
                TYPE="Invariant"
            elif [[ "$id" =~ ^SC- ]]; then
                TYPE="Success Criteria"
            fi

            echo "  - $id ($TYPE)"
        fi
    done
    echo ""
done

echo "========================================="
echo "Recommendations"
echo "========================================="
echo "1. Execute mudança em branch separado"
echo "2. Regenerar apenas artefatos afetados (não tudo!)"
echo "3. Executar scripts/validate-links.sh após mudança"
echo "4. QA deve validar specs afetadas"
echo ""

if [[ $MAX_DEPTH -ge 3 ]]; then
    echo -e "${YELLOW}⚠️  WARNING: Change affects depth 3+ (specs layer)${NC}"
    echo "   Estimated effort: High (requires spec regeneration)"
fi

exit 0
