#!/usr/bin/env bash
# validate-ids.sh - Valida formato e unicidade de IDs em frontmatter de PRD + ANEXOS
#
# Usage: ./scripts/validate-ids.sh [project_root]
#
# Valida:
# 1. Formato de IDs conforme padrões em ID_SCHEMA.yaml
# 2. Unicidade de IDs (sem duplicatas)
# 3. Naming conventions (bc_id em documentos/processos deve ser ^[a-z]+$)
#
# Exit codes:
#   0 - Validação passou (todos os IDs válidos e únicos)
#   1 - Validação falhou (IDs inválidos ou duplicados encontrados)
#
# Dependencies: yq (YAML processor)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project root (default: current directory)
PROJECT_ROOT="${1:-.}"

# ID Schema file
ID_SCHEMA="$PROJECT_ROOT/references/ID_SCHEMA.yaml"

# Validation counters
TOTAL_IDS=0
INVALID_FORMAT=0
DUPLICATES=0
ERRORS=()

# Associative arrays for tracking IDs and patterns
declare -A ID_REGISTRY
declare -A ID_PATTERNS

echo "========================================="
echo "ID Validation Report"
echo "========================================="
echo "Project: $PROJECT_ROOT"
echo "Schema: $ID_SCHEMA"
echo ""

# Function: Check if yq is installed
check_dependencies() {
    if ! command -v yq &> /dev/null; then
        echo -e "${RED}ERROR: yq is not installed${NC}"
        echo "Install with: sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /usr/local/bin/yq"
        exit 1
    fi
}

# Function: Load ID patterns from ID_SCHEMA.yaml
load_id_patterns() {
    if [[ ! -f "$ID_SCHEMA" ]]; then
        echo -e "${RED}ERROR: ID_SCHEMA.yaml not found at $ID_SCHEMA${NC}"
        exit 1
    fi

    # Load patterns
    ID_PATTERNS[user_journey]=$(yq '.id_patterns.user_journey.pattern' "$ID_SCHEMA" | tr -d '"')
    ID_PATTERNS[functional_requirement]=$(yq '.id_patterns.functional_requirement.pattern' "$ID_SCHEMA" | tr -d '"')
    ID_PATTERNS[invariant]=$(yq '.id_patterns.invariant.pattern' "$ID_SCHEMA" | tr -d '"')
    ID_PATTERNS[success_criteria]=$(yq '.id_patterns.success_criteria.pattern' "$ID_SCHEMA" | tr -d '"')
    ID_PATTERNS[process]=$(yq '.id_patterns.process.pattern' "$ID_SCHEMA" | tr -d '"')
    ID_PATTERNS[document]=$(yq '.id_patterns.document.pattern' "$ID_SCHEMA" | tr -d '"')
    ID_PATTERNS[vision_item]=$(yq '.id_patterns.vision_item.pattern' "$ID_SCHEMA" | tr -d '"')

    echo -e "${GREEN}✓ Loaded ID patterns from schema${NC}"
}

# Function: Validate ID format against pattern
validate_id_format() {
    local id="$1"
    local pattern=""
    local type=""

    # Determine ID type by prefix
    case "$id" in
        UJ-*)
            pattern="${ID_PATTERNS[user_journey]}"
            type="User Journey"
            ;;
        FR-*)
            pattern="${ID_PATTERNS[functional_requirement]}"
            type="Functional Requirement"
            ;;
        INV-*)
            pattern="${ID_PATTERNS[invariant]}"
            type="Invariant"
            ;;
        SC-*)
            pattern="${ID_PATTERNS[success_criteria]}"
            type="Success Criteria"
            ;;
        PROC-*)
            pattern="${ID_PATTERNS[process]}"
            type="Process"
            ;;
        DOC-*)
            pattern="${ID_PATTERNS[document]}"
            type="Document"
            ;;
        VIS-*)
            pattern="${ID_PATTERNS[vision_item]}"
            type="Vision Item"
            ;;
        *)
            echo -e "${YELLOW}WARNING: Unknown ID prefix: $id${NC}"
            return 1
            ;;
    esac

    # Validate against pattern using grep -E (extended regex)
    if echo "$id" | grep -Eq "$pattern"; then
        return 0
    else
        ERRORS+=("Format violation: $id does not match pattern for $type ($pattern)")
        ((INVALID_FORMAT++))
        return 1
    fi
}

# Function: Register ID for uniqueness check
register_id() {
    local id="$1"
    local file="$2"

    ((TOTAL_IDS++))

    # Check if ID already exists
    if [[ -n "${ID_REGISTRY[$id]:-}" ]]; then
        ERRORS+=("Duplicate ID: $id found in $file (already in ${ID_REGISTRY[$id]})")
        ((DUPLICATES++))
    else
        ID_REGISTRY[$id]="$file"
    fi
}

# Function: Extract and validate IDs from PRD section file
validate_prd_section() {
    local file="$1"
    local section_num
    section_num=$(yq '.section' "$file" 2>/dev/null || echo "")

    if [[ -z "$section_num" ]]; then
        return 0  # Skip files without section metadata
    fi

    echo "Validating: $file (Section $section_num)"

    # Section 4: User Journeys
    if [[ "$section_num" == "4" ]]; then
        local journey_count
        journey_count=$(yq '.journeys | length' "$file" 2>/dev/null || echo "0")

        for ((i=0; i<journey_count; i++)); do
            local id
            id=$(yq ".journeys[$i].id" "$file" 2>/dev/null | tr -d '"')

            if [[ -n "$id" && "$id" != "null" ]]; then
                validate_id_format "$id"
                register_id "$id" "$file"
            fi
        done
    fi

    # Section 8: Functional Requirements
    if [[ "$section_num" == "8" ]]; then
        local fr_count
        fr_count=$(yq '.functional_requirements | length' "$file" 2>/dev/null || echo "0")

        for ((i=0; i<fr_count; i++)); do
            local id
            id=$(yq ".functional_requirements[$i].id" "$file" 2>/dev/null | tr -d '"')

            if [[ -n "$id" && "$id" != "null" ]]; then
                validate_id_format "$id"
                register_id "$id" "$file"
            fi
        done
    fi
}

# Function: Extract and validate IDs from ANEXO files
validate_anexo() {
    local file="$1"
    local anexo_type
    anexo_type=$(yq '.anexo_type' "$file" 2>/dev/null || echo "")

    if [[ -z "$anexo_type" ]]; then
        return 0  # Skip files without anexo_type
    fi

    echo "Validating: $file (ANEXO type: $anexo_type)"

    # ANEXO A: Process Details
    if [[ "$anexo_type" == "process_details" ]]; then
        local process_count
        process_count=$(yq '.processes | length' "$file" 2>/dev/null || echo "0")

        for ((i=0; i<process_count; i++)); do
            local id
            id=$(yq ".processes[$i].id" "$file" 2>/dev/null | tr -d '"')

            if [[ -n "$id" && "$id" != "null" && "$id" != *"{bc_id}"* ]]; then
                validate_id_format "$id"
                register_id "$id" "$file"

                # Validate bc_id follows naming convention (^[a-z]+$)
                local bc_id
                bc_id=$(yq ".processes[$i].bounded_context" "$file" 2>/dev/null | tr -d '"')
                if [[ -n "$bc_id" && "$bc_id" != "null" && "$bc_id" != *"{bc_id}"* ]]; then
                    if ! echo "$bc_id" | grep -Eq '^[a-z]+$'; then
                        ERRORS+=("Naming violation: process $id has invalid bc_id '$bc_id' (must be ^[a-z]+$)")
                        ((INVALID_FORMAT++))
                    fi
                fi
            fi
        done
    fi

    # ANEXO B: Data Models
    if [[ "$anexo_type" == "data_models" ]]; then
        # Validate documents
        local doc_count
        doc_count=$(yq '.documents | length' "$file" 2>/dev/null || echo "0")

        for ((i=0; i<doc_count; i++)); do
            local id
            id=$(yq ".documents[$i].id" "$file" 2>/dev/null | tr -d '"')

            if [[ -n "$id" && "$id" != "null" && "$id" != *"{bc_id}"* && "$id" != *"{TechnicalName}"* ]]; then
                validate_id_format "$id"
                register_id "$id" "$file"

                # Validate bc_id follows naming convention (^[a-z]+$)
                local bc_id
                bc_id=$(yq ".documents[$i].bounded_context" "$file" 2>/dev/null | tr -d '"')
                if [[ -n "$bc_id" && "$bc_id" != "null" && "$bc_id" != *"{bc_id}"* ]]; then
                    if ! echo "$bc_id" | grep -Eq '^[a-z]+$'; then
                        ERRORS+=("Naming violation: document $id has invalid bc_id '$bc_id' (must be ^[a-z]+$)")
                        ((INVALID_FORMAT++))
                    fi
                fi
            fi
        done

        # Validate invariants
        local inv_count
        inv_count=$(yq '.invariants | length' "$file" 2>/dev/null || echo "0")

        for ((i=0; i<inv_count; i++)); do
            local id
            id=$(yq ".invariants[$i].id" "$file" 2>/dev/null | tr -d '"')

            if [[ -n "$id" && "$id" != "null" ]]; then
                validate_id_format "$id"
                register_id "$id" "$file"
            fi
        done
    fi
}

# Main execution
main() {
    check_dependencies
    load_id_patterns

    echo ""
    echo "Scanning files..."
    echo ""

    # Find and validate PRD section files
    if [[ -d "$PROJECT_ROOT/artifacts" ]]; then
        # Concrete project (artifacts/ exists)
        for file in "$PROJECT_ROOT"/artifacts/PRD_*.md; do
            [[ -f "$file" ]] && validate_prd_section "$file"
        done

        for file in "$PROJECT_ROOT"/artifacts/ANEXO_*.md; do
            [[ -f "$file" ]] && validate_anexo "$file"
        done
    elif [[ -d "$PROJECT_ROOT/templates/sections" ]]; then
        # Template project (templates/sections/ exists)
        for file in "$PROJECT_ROOT"/templates/sections/PRD_*.md; do
            [[ -f "$file" ]] && validate_prd_section "$file"
        done

        for file in "$PROJECT_ROOT"/templates/ANEXO_*.md; do
            [[ -f "$file" ]] && validate_anexo "$file"
        done
    else
        echo -e "${RED}ERROR: Cannot find artifacts/ or templates/ directory${NC}"
        exit 1
    fi

    echo ""
    echo "========================================="
    echo "Validation Summary"
    echo "========================================="
    echo "Total IDs found: $TOTAL_IDS"
    echo "Invalid format: $INVALID_FORMAT"
    echo "Duplicates: $DUPLICATES"
    echo ""

    # Report errors
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
        echo "All IDs are well-formed and unique."
        exit 0
    fi
}

# Run main
main
