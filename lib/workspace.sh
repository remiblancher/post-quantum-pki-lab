#!/bin/bash
# =============================================================================
# Workspace Management for Post-Quantum PKI Lab (QLAB)
# =============================================================================
# Provides persistent workspace per level (no more rm -rf at each demo)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Base workspace directory
WORKSPACE_ROOT="$LAB_ROOT/workspace"

# =============================================================================
# Workspace Initialization
# =============================================================================

# Initialize workspace for a specific level
# Usage: init_workspace "quickstart" or init_workspace "niveau-1"
init_workspace() {
    local level="$1"
    local reset="${2:-false}"

    LEVEL_WORKSPACE="$WORKSPACE_ROOT/$level"

    # Reset if requested
    if [[ "$reset" == "true" ]] && [[ -d "$LEVEL_WORKSPACE" ]]; then
        rm -rf "$LEVEL_WORKSPACE"
    fi

    # Create workspace if doesn't exist
    if [[ ! -d "$LEVEL_WORKSPACE" ]]; then
        mkdir -p "$LEVEL_WORKSPACE"
    fi

    # Export for use in scripts
    export LEVEL_WORKSPACE
    export WORKSPACE_ROOT

    return 0
}

# Get workspace path for a level
get_workspace() {
    local level="$1"
    echo "$WORKSPACE_ROOT/$level"
}

# Check if workspace exists and has content
workspace_exists() {
    local level="$1"
    local ws="$WORKSPACE_ROOT/$level"

    if [[ -d "$ws" ]] && [[ -n "$(ls -A "$ws" 2>/dev/null)" ]]; then
        return 0
    else
        return 1
    fi
}

# =============================================================================
# Level-specific paths
# =============================================================================

# Quick Start workspace
quickstart_workspace() {
    echo "$WORKSPACE_ROOT/quickstart"
}

# Niveau 1 workspace
niveau1_workspace() {
    echo "$WORKSPACE_ROOT/niveau-1"
}

# Niveau 2 workspace
niveau2_workspace() {
    echo "$WORKSPACE_ROOT/niveau-2"
}

# Niveau 3 workspace
niveau3_workspace() {
    echo "$WORKSPACE_ROOT/niveau-3"
}

# Niveau 4 workspace
niveau4_workspace() {
    echo "$WORKSPACE_ROOT/niveau-4"
}

# =============================================================================
# CA Path Helpers
# =============================================================================

# Get classic CA path (from quickstart)
get_classic_ca() {
    echo "$(quickstart_workspace)/classic-ca"
}

# Get PQC Root CA path (from niveau-1)
get_pqc_root_ca() {
    echo "$(niveau1_workspace)/pqc-root-ca"
}

# Get PQC Issuing CA path (from niveau-1)
get_pqc_issuing_ca() {
    echo "$(niveau1_workspace)/pqc-issuing-ca"
}

# Get Hybrid CA path (from niveau-1)
get_hybrid_ca() {
    echo "$(niveau1_workspace)/hybrid-ca"
}

# =============================================================================
# Workspace Status
# =============================================================================

# Show workspace status for all levels
show_workspace_status() {
    echo ""
    echo -e "${BOLD}Workspace Status:${NC}"
    echo ""

    local levels=("quickstart" "niveau-1" "niveau-2" "niveau-3" "niveau-4")

    for level in "${levels[@]}"; do
        local ws="$WORKSPACE_ROOT/$level"
        if [[ -d "$ws" ]] && [[ -n "$(ls -A "$ws" 2>/dev/null)" ]]; then
            local count=$(find "$ws" -type f 2>/dev/null | wc -l | tr -d ' ')
            echo -e "  ${GREEN}[OK]${NC} $level ($count fichiers)"
        else
            echo -e "  ${DIM}[ ]${NC} $level (vide)"
        fi
    done
    echo ""
}

# Reset a specific level's workspace
reset_workspace() {
    local level="$1"
    local ws="$WORKSPACE_ROOT/$level"

    if [[ -d "$ws" ]]; then
        rm -rf "$ws"
        mkdir -p "$ws"
        echo -e "${YELLOW}[RESET]${NC} Workspace $level reinitialise"
        return 0
    else
        echo -e "${DIM}Workspace $level n'existe pas${NC}"
        return 1
    fi
}

# Reset all workspaces
reset_all_workspaces() {
    echo -e "${YELLOW}[WARN]${NC} Reinitialisation de tous les workspaces..."

    local levels=("quickstart" "niveau-1" "niveau-2" "niveau-3" "niveau-4")

    for level in "${levels[@]}"; do
        reset_workspace "$level"
    done

    echo -e "${GREEN}[OK]${NC} Tous les workspaces ont ete reinitialises"
}

# =============================================================================
# Prerequisite Checks
# =============================================================================

# Check if a level's prerequisites are met
check_prerequisites() {
    local level="$1"

    case "$level" in
        "quickstart")
            # No prerequisites
            return 0
            ;;
        "niveau-1")
            # Needs quickstart completed (classic CA exists)
            if [[ -f "$(get_classic_ca)/ca.crt" ]]; then
                return 0
            else
                echo -e "${RED}[X]${NC} Prerequis manquant: Complete d'abord le Quick Start"
                return 1
            fi
            ;;
        "niveau-2")
            # Needs niveau-1 completed (PQC CA exists)
            if [[ -f "$(get_pqc_issuing_ca)/ca.crt" ]]; then
                return 0
            else
                echo -e "${RED}[X]${NC} Prerequis manquant: Complete d'abord le Niveau 1"
                return 1
            fi
            ;;
        "niveau-3")
            # Needs niveau-1 completed (Hybrid CA for ops)
            if [[ -f "$(get_hybrid_ca)/ca.crt" ]]; then
                return 0
            else
                echo -e "${RED}[X]${NC} Prerequis manquant: Complete d'abord le Niveau 1"
                return 1
            fi
            ;;
        "niveau-4")
            # Needs niveau-2 and niveau-3 completed
            if [[ -d "$(niveau2_workspace)" ]] && [[ -d "$(niveau3_workspace)" ]]; then
                return 0
            else
                echo -e "${RED}[X]${NC} Prerequis manquant: Complete d'abord les Niveaux 2 et 3"
                return 1
            fi
            ;;
        *)
            echo -e "${RED}[X]${NC} Niveau inconnu: $level"
            return 1
            ;;
    esac
}

# =============================================================================
# Utility Functions
# =============================================================================

# Create a subdirectory in current level workspace
create_subdir() {
    local subdir="$1"
    local full_path="$LEVEL_WORKSPACE/$subdir"

    if [[ ! -d "$full_path" ]]; then
        mkdir -p "$full_path"
    fi

    echo "$full_path"
}

# Get path relative to workspace root (for display)
relative_path() {
    local full_path="$1"
    echo "${full_path#$WORKSPACE_ROOT/}"
}
