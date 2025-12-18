#!/bin/bash
# =============================================================================
#  UC-03: "The real problem: Store Now, Decrypt Later"
#
#  Interactive Mosca calculator to assess your PQC urgency
#
#  Key Message: Encrypted data captured today can be decrypted tomorrow.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

# =============================================================================
# Demo Setup
# =============================================================================

setup_demo "UC-03: Store Now, Decrypt Later"

# =============================================================================
# Introduction (brief)
# =============================================================================

echo -e "${BOLD}THE THREAT: Store Now, Decrypt Later (SNDL)${NC}"
echo ""
echo "  Adversaries are recording encrypted traffic TODAY."
echo "  When quantum computers arrive, they'll decrypt it ALL."
echo ""
echo -e "  ${CYAN}See README.md and diagram.txt for detailed explanations.${NC}"
echo ""

pause_for_explanation "Press Enter to calculate YOUR urgency..."

# =============================================================================
# Mosca's Inequality Calculator
# =============================================================================

print_step "Mosca's Inequality Calculator"

echo -e "${CYAN}Formula: If X + Y > Z then ACT NOW${NC}"
echo ""
echo "  X = Years until quantum computers exist"
echo "  Y = Years to migrate your systems to PQC"
echo "  Z = Years your data needs to stay secret"
echo ""

# Get user inputs
echo -e "${BOLD}Enter your values:${NC}"
echo ""

read -p "  X - Years until quantum computer (default: 10): " X
X=${X:-10}

read -p "  Y - Years to migrate your systems (default: 5): " Y
Y=${Y:-5}

read -p "  Z - Years your data must stay secret: " Z

# Validate Z is provided
if [[ -z "$Z" ]]; then
    echo ""
    echo -e "${YELLOW}No value for Z provided. Here are some examples:${NC}"
    echo ""
    echo "  Healthcare (HIPAA):     50 years"
    echo "  Government classified:  75 years"
    echo "  Financial records:      10 years"
    echo "  Trade secrets:          20 years"
    echo "  PCI compliance:          7 years"
    echo ""
    read -p "  Z - Years your data must stay secret: " Z
    Z=${Z:-20}
fi

# Calculate
SUM=$((X + Y))

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "  ${BOLD}Your values:${NC}"
echo "    X (quantum timeline):  $X years"
echo "    Y (migration time):    $Y years"
echo "    Z (secrecy required):  $Z years"
echo ""
echo -e "  ${BOLD}Calculation:${NC}"
echo "    X + Y = $X + $Y = $SUM"
echo ""

if [[ $SUM -gt $Z ]]; then
    echo -e "  ${GREEN}Result: $SUM > $Z${NC}"
    echo ""
    echo -e "  ${GREEN}✓ You have time, but don't wait too long.${NC}"
    echo "    Start planning your PQC migration now."
else
    echo -e "  ${RED}Result: $SUM ≤ $Z${NC}"
    echo ""
    echo -e "  ${RED}⚠ WARNING: You need to act NOW!${NC}"
    echo ""
    echo "    Data captured today will still be sensitive when"
    echo "    quantum computers can decrypt it."
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"

# =============================================================================
# Key Message
# =============================================================================

echo ""
print_key_message "Encrypted data captured today can be decrypted tomorrow."

echo -e "${BOLD}Next steps:${NC}"
echo "  1. Inventory your sensitive data and its lifetime"
echo "  2. Start with hybrid encryption (classical + PQC)"
echo "  3. See UC-01 for PQC certificates, UC-02 for hybrid approach"
echo ""

show_lesson "SNDL is not a future problem — it's happening now.
Use Mosca's inequality to assess your urgency.
See README.md for detailed threat analysis."

show_footer
