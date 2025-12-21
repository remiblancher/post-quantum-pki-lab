#!/bin/bash
# =============================================================================
# Interactive Mode Helpers for Post-Quantum PKI Lab
# =============================================================================
# Provides hands-on learning experience where users type commands themselves

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

# =============================================================================
# Core Interactive Functions
# =============================================================================

# Teach a command: show it, wait for user to type it, validate
# Usage: teach_cmd "pki init-ca --name 'My CA' --algorithm ml-dsa-65 --dir ./my-ca"
teach_cmd() {
    local expected_cmd="$1"
    local hint="${2:-}"
    local max_attempts=3
    local attempt=0

    echo ""
    echo -e "${BOLD}${CYAN}>>> Tape cette commande :${NC}"
    echo ""
    echo -e "    ${YELLOW}$expected_cmd${NC}"
    echo ""

    if [[ -n "$hint" ]]; then
        echo -e "    ${DIM}$hint${NC}"
        echo ""
    fi

    while [[ $attempt -lt $max_attempts ]]; do
        echo -n -e "${GREEN}\$ ${NC}"
        read -r user_input

        # Normalize both commands (remove extra spaces)
        local normalized_expected=$(echo "$expected_cmd" | tr -s ' ')
        local normalized_input=$(echo "$user_input" | tr -s ' ')

        if [[ "$normalized_input" == "$normalized_expected" ]]; then
            echo ""
            # Execute the command
            eval "$user_input"
            local exit_code=$?
            echo ""
            if [[ $exit_code -eq 0 ]]; then
                echo -e "${GREEN}[OK]${NC} Commande executee avec succes"
            else
                echo -e "${YELLOW}[WARN]${NC} Commande terminee avec code $exit_code"
            fi
            return $exit_code
        else
            attempt=$((attempt + 1))
            if [[ $attempt -lt $max_attempts ]]; then
                echo -e "${RED}[X]${NC} Pas tout a fait. Reessaie."
                echo -e "  ${DIM}Attendu: $expected_cmd${NC}"
                echo ""
            fi
        fi
    done

    # After max attempts, offer to run it automatically
    echo ""
    echo -e "${YELLOW}Pas de souci, je l'execute pour toi :${NC}"
    echo -e "    ${CYAN}$expected_cmd${NC}"
    echo ""
    eval "$expected_cmd"
    return $?
}

# Simplified version: just show command and execute (for complex/long commands)
demo_cmd() {
    local cmd="$1"
    local description="${2:-}"

    echo ""
    if [[ -n "$description" ]]; then
        echo -e "${DIM}$description${NC}"
    fi
    echo -e "  ${YELLOW}\$ $cmd${NC}"
    echo ""
    eval "$cmd"
}

# =============================================================================
# Validation Functions
# =============================================================================

# Validate that a file exists
# Usage: validate_file "./my-ca/ca.crt" "Certificat CA"
validate_file() {
    local file_path="$1"
    local label="${2:-Fichier}"

    if [[ -f "$file_path" ]]; then
        local size=$(wc -c < "$file_path" | tr -d ' ')
        echo -e "${GREEN}[OK]${NC} $label cree (${size} bytes)"
        return 0
    else
        echo -e "${RED}[X]${NC} $label non trouve: $file_path"
        return 1
    fi
}

# Validate that a directory exists
validate_dir() {
    local dir_path="$1"
    local label="${2:-Repertoire}"

    if [[ -d "$dir_path" ]]; then
        local count=$(ls -1 "$dir_path" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "${GREEN}[OK]${NC} $label cree ($count fichiers)"
        return 0
    else
        echo -e "${RED}[X]${NC} $label non trouve: $dir_path"
        return 1
    fi
}

# Validate multiple files at once
validate_files() {
    local dir="$1"
    shift
    local all_ok=true

    echo ""
    echo -e "${BOLD}Verification des fichiers generes :${NC}"

    for file in "$@"; do
        if [[ -f "$dir/$file" ]]; then
            local size=$(wc -c < "$dir/$file" | tr -d ' ')
            printf "  ${GREEN}[OK]${NC} %-25s %7d bytes\n" "$file" "$size"
        else
            printf "  ${RED}[X]${NC} %-25s manquant\n" "$file"
            all_ok=false
        fi
    done

    echo ""
    if $all_ok; then
        return 0
    else
        return 1
    fi
}

# =============================================================================
# Progress and Feedback
# =============================================================================

# Show a success checkpoint
checkpoint() {
    local message="$1"
    echo ""
    echo -e "${BG_GREEN}${BOLD_WHITE} CHECKPOINT ${NC} ${GREEN}$message${NC}"
    echo ""
}

# Show a warning/note
note() {
    local message="$1"
    echo ""
    echo -e "${YELLOW}Note:${NC} $message"
}

# Show what the user learned
learned() {
    local concept="$1"
    echo -e "  ${CYAN}->${NC} Tu as appris : ${BOLD}$concept${NC}"
}

# =============================================================================
# Mission Structure
# =============================================================================

# Start a new mission
mission_start() {
    local mission_num="$1"
    local mission_name="$2"
    local duration="${3:-}"

    echo ""
    echo -e "${BOLD}${BG_BLUE}${WHITE} MISSION $mission_num ${NC}"
    echo -e "${BOLD}$mission_name${NC}"
    if [[ -n "$duration" ]]; then
        echo -e "${DIM}Duree estimee: $duration${NC}"
    fi
    echo ""
}

# Complete a mission
mission_complete() {
    local mission_name="$1"

    echo ""
    echo "--------------------------------------------------------------"
    echo -e "${GREEN}${BOLD}[OK] MISSION ACCOMPLIE${NC}"
    echo -e "  $mission_name"
    echo "--------------------------------------------------------------"
    echo ""
}

# =============================================================================
# Etape Structure (for Quick Start)
# =============================================================================

ETAPE_CURRENT=0
ETAPE_TOTAL=0

# Initialize step counter
init_etapes() {
    ETAPE_TOTAL="$1"
    ETAPE_CURRENT=0
}

# Show a step header
etape() {
    ETAPE_CURRENT=$((ETAPE_CURRENT + 1))
    local title="$1"
    local description="${2:-}"

    echo ""
    echo -e "${BOLD}${CYAN}[ETAPE $ETAPE_CURRENT/$ETAPE_TOTAL]${NC} ${BOLD}$title${NC}"
    if [[ -n "$description" ]]; then
        echo -e "${DIM}$description${NC}"
    fi
    echo ""
}

# =============================================================================
# User Choice (for key decisions)
# =============================================================================

# Let user choose between options
# Usage: choice=$(user_choice "Quel algorithme ?" "classique" "pqc" "hybride")
user_choice() {
    local prompt="$1"
    shift
    local options=("$@")

    echo ""
    echo -e "${BOLD}$prompt${NC}"
    echo ""

    local i=1
    for opt in "${options[@]}"; do
        echo -e "  ${CYAN}$i)${NC} $opt"
        i=$((i + 1))
    done

    echo ""
    while true; do
        echo -n -e "${GREEN}Ton choix [1-${#options[@]}]: ${NC}"
        read -r choice

        if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#options[@]} ]]; then
            echo ""
            echo "${options[$((choice - 1))]}"
            return 0
        else
            echo -e "${RED}Choix invalide. Entre un nombre entre 1 et ${#options[@]}.${NC}"
        fi
    done
}

# =============================================================================
# Comparison Display
# =============================================================================

# Show before/after comparison
show_comparison() {
    local before_label="$1"
    local before_value="$2"
    local after_label="$3"
    local after_value="$4"
    local unit="${5:-}"

    echo ""
    printf "  %-20s %10s%s\n" "$before_label" "$before_value" "$unit"
    printf "  %-20s %10s%s\n" "$after_label" "$after_value" "$unit"

    # Calculate ratio if numeric
    if [[ "$before_value" =~ ^[0-9]+$ ]] && [[ "$after_value" =~ ^[0-9]+$ ]] && [[ "$before_value" -gt 0 ]]; then
        local ratio=$(echo "scale=1; $after_value / $before_value" | bc)
        echo -e "  ${DIM}Ratio: ${ratio}x${NC}"
    fi
}

# =============================================================================
# Wait Functions
# =============================================================================

# Simple pause with custom message
wait_enter() {
    local message="${1:-Appuie sur Entree pour continuer...}"
    echo ""
    read -p "$(echo -e "  ${DIM}$message${NC}")" _
}

# Countdown (for dramatic effect)
countdown() {
    local seconds="${1:-3}"
    local message="${2:-}"

    if [[ -n "$message" ]]; then
        echo -e "$message"
    fi

    for ((i=seconds; i>0; i--)); do
        echo -ne "\r  ${CYAN}$i...${NC}  "
        sleep 1
    done
    echo -ne "\r         \r"
}

# =============================================================================
# Summary Display
# =============================================================================

# Show what was accomplished
show_recap() {
    local title="$1"
    shift
    local items=("$@")

    echo ""
    echo -e "${BOLD}${title}${NC}"
    echo ""
    for item in "${items[@]}"; do
        echo -e "  ${GREEN}[OK]${NC} $item"
    done
    echo ""
}

# Show lesson learned (key takeaway)
show_lesson() {
    local lesson="$1"
    echo ""
    echo -e "${BG_BLUE}${BOLD_WHITE} RETENIR ${NC}"
    echo ""
    echo -e "  $lesson"
    echo ""
}
