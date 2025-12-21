#!/bin/bash
# =============================================================================
#  POST-QUANTUM PKI LAB - Menu Principal
#
#  Point d'entrée unique pour le parcours d'apprentissage
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source les helpers
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/workspace.sh"

# =============================================================================
# Affichage du menu
# =============================================================================

show_header() {
    clear
    echo ""
    echo -e "${BOLD}${CYAN}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║   🔐  POST-QUANTUM PKI LAB                                    ║"
    echo "  ║                                                               ║"
    echo "  ║   Apprends la cryptographie post-quantique en pratiquant     ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

show_menu() {
    echo -e "${BOLD}PARCOURS D'APPRENTISSAGE${NC}"
    echo ""

    # Quick Start
    if workspace_exists "quickstart"; then
        echo -e "  ${GREEN}[OK]${NC} ${BOLD}0)${NC} Quick Start : Ma première PKI ${DIM}(10 min)${NC}"
    else
        echo -e "  ${CYAN}[ ]${NC} ${BOLD}0)${NC} Quick Start : Ma première PKI ${DIM}(10 min)${NC}"
    fi

    # La Révélation
    echo -e "  ${DIM}[ ]${NC} ${BOLD}1)${NC} La Révélation : Pourquoi changer ? ${DIM}(8 min)${NC}"

    echo ""
    echo -e "${BOLD}NIVEAUX${NC}"
    echo ""

    # Niveau 1
    if workspace_exists "niveau-1"; then
        echo -e "  ${GREEN}[OK]${NC} ${BOLD}2)${NC} Niveau 1 : PQC Basics ${DIM}(20 min) - ML-DSA, ML-KEM${NC}"
    else
        echo -e "  ${DIM}[ ]${NC} ${BOLD}2)${NC} Niveau 1 : PQC Basics ${DIM}(20 min) - ML-DSA, ML-KEM${NC}"
    fi

    # Niveau 2
    if workspace_exists "niveau-2"; then
        echo -e "  ${GREEN}[OK]${NC} ${BOLD}3)${NC} Niveau 2 : Applications ${DIM}(25 min) - ML-DSA${NC}"
    else
        echo -e "  ${DIM}[ ]${NC} ${BOLD}3)${NC} Niveau 2 : Applications ${DIM}(25 min) - ML-DSA${NC}"
    fi

    # Niveau 3
    if workspace_exists "niveau-3"; then
        echo -e "  ${GREEN}[OK]${NC} ${BOLD}4)${NC} Niveau 3 : Ops & Lifecycle ${DIM}(30 min) - HYBRIDE${NC}"
    else
        echo -e "  ${DIM}[ ]${NC} ${BOLD}4)${NC} Niveau 3 : Ops & Lifecycle ${DIM}(30 min) - HYBRIDE${NC}"
    fi

    # Niveau 4
    if workspace_exists "niveau-4"; then
        echo -e "  ${GREEN}[OK]${NC} ${BOLD}5)${NC} Niveau 4 : Advanced ${DIM}(20 min) - HYBRIDE${NC}"
    else
        echo -e "  ${DIM}[ ]${NC} ${BOLD}5)${NC} Niveau 4 : Advanced ${DIM}(20 min) - HYBRIDE${NC}"
    fi

    echo ""
    echo -e "${BOLD}AUTRES OPTIONS${NC}"
    echo ""
    echo -e "       ${BOLD}s)${NC} Statut des workspaces"
    echo -e "       ${BOLD}r)${NC} Réinitialiser un workspace"
    echo -e "       ${BOLD}q)${NC} Quitter"
    echo ""
}

# =============================================================================
# Gestion des choix
# =============================================================================

launch_demo() {
    local script="$1"
    if [[ -f "$script" ]]; then
        bash "$script"
        echo ""
        read -p "$(echo -e "${DIM}Appuie sur Entrée pour revenir au menu...${NC}")" _
    else
        echo ""
        echo -e "${YELLOW}[INFO]${NC} Ce module n'est pas encore disponible."
        echo -e "       Il sera ajouté prochainement."
        echo ""
        read -p "$(echo -e "${DIM}Appuie sur Entrée pour continuer...${NC}")" _
    fi
}

show_workspace_menu() {
    echo ""
    show_workspace_status
    echo ""
    read -p "$(echo -e "${DIM}Appuie sur Entrée pour revenir au menu...${NC}")" _
}

reset_workspace_menu() {
    echo ""
    echo -e "${BOLD}Quel workspace veux-tu réinitialiser ?${NC}"
    echo ""
    echo "  0) quickstart"
    echo "  1) niveau-1"
    echo "  2) niveau-2"
    echo "  3) niveau-3"
    echo "  4) niveau-4"
    echo "  a) Tous les workspaces"
    echo "  q) Annuler"
    echo ""
    echo -n -e "${GREEN}Ton choix : ${NC}"
    read -r choice

    case "$choice" in
        0) reset_workspace "quickstart" ;;
        1) reset_workspace "niveau-1" ;;
        2) reset_workspace "niveau-2" ;;
        3) reset_workspace "niveau-3" ;;
        4) reset_workspace "niveau-4" ;;
        a)
            echo ""
            echo -e "${YELLOW}[WARN]${NC} Tu vas supprimer TOUS les workspaces."
            echo -n "Confirmer ? (oui/non) : "
            read -r confirm
            if [[ "$confirm" == "oui" ]]; then
                reset_all_workspaces
            else
                echo "Annulé."
            fi
            ;;
        q) return ;;
        *) echo -e "${RED}Choix invalide${NC}" ;;
    esac

    echo ""
    read -p "$(echo -e "${DIM}Appuie sur Entrée pour continuer...${NC}")" _
}

# =============================================================================
# Boucle principale
# =============================================================================

main() {
    while true; do
        show_header
        show_menu

        echo -n -e "${GREEN}Ton choix : ${NC}"
        read -r choice

        case "$choice" in
            0)
                launch_demo "$SCRIPT_DIR/quickstart/demo.sh"
                ;;
            1)
                launch_demo "$SCRIPT_DIR/journey/00-revelation/demo.sh"
                ;;
            2)
                echo ""
                echo -e "${BOLD}Niveau 1 - Missions disponibles :${NC}"
                echo "  a) Mission 1 : Full PQC Chain"
                echo "  b) Mission 2 : Hybrid Catalyst"
                echo ""
                echo -n -e "${GREEN}Ton choix (ou Entrée pour annuler) : ${NC}"
                read -r subchoice
                case "$subchoice" in
                    a) launch_demo "$SCRIPT_DIR/journey/01-pqc-basics/01-full-chain/demo.sh" ;;
                    b) launch_demo "$SCRIPT_DIR/journey/01-pqc-basics/02-hybrid/demo.sh" ;;
                    *) ;;
                esac
                ;;
            3)
                echo ""
                echo -e "${BOLD}Niveau 2 - Missions disponibles :${NC}"
                echo "  a) Mission 3 : mTLS"
                echo "  b) Mission 4 : Code Signing"
                echo "  c) Mission 5 : Timestamping"
                echo ""
                echo -n -e "${GREEN}Ton choix (ou Entrée pour annuler) : ${NC}"
                read -r subchoice
                case "$subchoice" in
                    a) launch_demo "$SCRIPT_DIR/journey/02-applications/01-mtls/demo.sh" ;;
                    b) launch_demo "$SCRIPT_DIR/journey/02-applications/02-code-signing/demo.sh" ;;
                    c) launch_demo "$SCRIPT_DIR/journey/02-applications/03-timestamping/demo.sh" ;;
                    *) ;;
                esac
                ;;
            4)
                echo ""
                echo -e "${BOLD}Niveau 3 - Missions disponibles :${NC}"
                echo "  a) Mission 6 : Revocation & CRL"
                echo "  b) Mission 7 : OCSP Live"
                echo "  c) Mission 8 : Crypto-Agility"
                echo ""
                echo -n -e "${GREEN}Ton choix (ou Entrée pour annuler) : ${NC}"
                read -r subchoice
                case "$subchoice" in
                    a) launch_demo "$SCRIPT_DIR/journey/03-ops-lifecycle/01-revocation/demo.sh" ;;
                    b) launch_demo "$SCRIPT_DIR/journey/03-ops-lifecycle/02-ocsp/demo.sh" ;;
                    c) launch_demo "$SCRIPT_DIR/journey/03-ops-lifecycle/03-crypto-agility/demo.sh" ;;
                    *) ;;
                esac
                ;;
            5)
                echo ""
                echo -e "${BOLD}Niveau 4 - Missions disponibles :${NC}"
                echo "  a) Mission 9 : LTV Signatures"
                echo "  b) Mission 10 : PQC Tunnel"
                echo "  c) Mission 11 : CMS Encryption"
                echo ""
                echo -n -e "${GREEN}Ton choix (ou Entrée pour annuler) : ${NC}"
                read -r subchoice
                case "$subchoice" in
                    a) launch_demo "$SCRIPT_DIR/journey/04-advanced/01-ltv-signatures/demo.sh" ;;
                    b) launch_demo "$SCRIPT_DIR/journey/04-advanced/02-pqc-tunnel/demo.sh" ;;
                    c) launch_demo "$SCRIPT_DIR/journey/04-advanced/03-cms-encryption/demo.sh" ;;
                    *) ;;
                esac
                ;;
            s|S)
                show_workspace_menu
                ;;
            r|R)
                reset_workspace_menu
                ;;
            q|Q)
                echo ""
                echo -e "${GREEN}À bientôt !${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo ""
                echo -e "${RED}Choix invalide. Réessaie.${NC}"
                sleep 1
                ;;
        esac
    done
}

# Exécution
main "$@"
