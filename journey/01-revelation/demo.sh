#!/bin/bash
# =============================================================================
#  LA RÉVÉLATION : Pourquoi changer ? (8 minutes)
#
#  Objectif : Comprendre pourquoi passer au post-quantique.
#             Tu viens de créer une CA classique... elle sera cassable.
#
#  Contenu :
#    - Partie 1 : Le contexte PQC (3 min)
#    - Partie 2 : La menace SNDL (2 min)
#    - Partie 3 : Calcul de ton urgence - Mosca (3 min)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source les helpers
source "$LAB_ROOT/lib/colors.sh"
source "$LAB_ROOT/lib/interactive.sh"
source "$LAB_ROOT/lib/workspace.sh"

# =============================================================================
# Bannière
# =============================================================================

show_welcome() {
    clear
    echo ""
    echo -e "${BOLD}${YELLOW}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║   ⚠️  LA RÉVÉLATION                                           ║"
    echo "  ║                                                               ║"
    echo "  ║   Pourquoi changer ?                                          ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "  ${BOLD}Durée estimée :${NC} 8 minutes"
    echo ""
    echo "  Tu viens peut-être de créer ta première CA avec ECDSA."
    echo "  C'est bien. Mais..."
    echo ""
    echo -e "  ${RED}Cette CA sera cassable par un ordinateur quantique.${NC}"
    echo ""
    echo "  Dans ce module, tu vas comprendre :"
    echo ""
    echo "    1. Ce qu'est la cryptographie post-quantique"
    echo "    2. Pourquoi c'est urgent (menace SNDL)"
    echo "    3. Comment calculer TON urgence de migration"
    echo ""
}

# =============================================================================
# Partie 1 : Le contexte PQC
# =============================================================================

partie_1_contexte() {
    echo ""
    echo -e "${BOLD}${BG_BLUE}${WHITE} PARTIE 1 ${NC} ${BOLD}Le contexte Post-Quantum${NC}"
    echo -e "${DIM}Durée : 3 minutes${NC}"
    echo ""

    echo -e "${BOLD}Qu'est-ce que le PQC ?${NC}"
    echo ""
    echo "  PQC = Post-Quantum Cryptography"
    echo "  = Cryptographie résistante aux ordinateurs quantiques"
    echo ""
    echo -e "  ${YELLOW}Attention :${NC} Ce n'est PAS de la cryptographie quantique (QKD)."
    echo "  C'est de la cryptographie classique, mais avec des algorithmes"
    echo "  que les ordinateurs quantiques ne peuvent pas casser."
    echo ""

    wait_enter

    echo -e "${BOLD}Pourquoi maintenant ?${NC}"
    echo ""
    echo "  Les ordinateurs quantiques exploitent l'algorithme de Shor"
    echo "  pour casser RSA et ECDSA en temps polynomial."
    echo ""
    echo "  ┌─────────────────────────────────────────────────────────┐"
    echo "  │  ALGORITHME         TEMPS CLASSIQUE    TEMPS QUANTIQUE  │"
    echo "  ├─────────────────────────────────────────────────────────┤"
    echo "  │  RSA-2048           10^9 années        ~8 heures        │"
    echo "  │  ECDSA P-256        10^30 années       ~minutes         │"
    echo "  └─────────────────────────────────────────────────────────┘"
    echo ""
    echo -e "  ${CYAN}Timeline estimée :${NC} 10-15 ans selon les experts"
    echo "  (Mais personne ne sait vraiment quand...)"
    echo ""

    wait_enter

    echo -e "${BOLD}Les nouveaux standards NIST (FIPS 2024)${NC}"
    echo ""
    echo "  Le NIST a standardisé 3 nouveaux algorithmes :"
    echo ""
    echo "  ┌────────────────────────────────────────────────────────────────┐"
    echo "  │  STANDARD      ANCIEN NOM      TYPE                 USAGE      │"
    echo "  ├────────────────────────────────────────────────────────────────┤"
    echo "  │  ML-DSA        Dilithium       Signatures           PKI, TLS   │"
    echo "  │  ML-KEM        Kyber           Échange de clés      TLS, VPN   │"
    echo "  │  SLH-DSA       SPHINCS+        Signatures (backup)  Archivage  │"
    echo "  └────────────────────────────────────────────────────────────────┘"
    echo ""
    echo -e "  ${GREEN}[INFO]${NC} Ce lab utilise ML-DSA (signatures) et ML-KEM (encryption)"
    echo ""

    # Comparer avec la CA créée dans le Quick Start
    local classic_ca="$WORKSPACE_ROOT/quickstart/classic-ca"
    if [[ -f "$classic_ca/ca.crt" ]]; then
        echo ""
        echo -e "  ${YELLOW}Ta CA du Quick Start :${NC}"
        local algo=$(openssl x509 -in "$classic_ca/ca.crt" -noout -text 2>/dev/null | grep "Signature Algorithm" | head -1 | awk '{print $3}')
        echo -e "    Algorithme actuel : ${RED}$algo${NC}"
        echo -e "    Status quantique  : ${RED}VULNÉRABLE${NC}"
        echo ""
    fi

    checkpoint "Contexte PQC compris"
}

# =============================================================================
# Partie 2 : La menace SNDL
# =============================================================================

partie_2_sndl() {
    echo ""
    echo -e "${BOLD}${BG_YELLOW}${BLACK} PARTIE 2 ${NC} ${BOLD}La menace SNDL${NC}"
    echo -e "${DIM}Durée : 2 minutes${NC}"
    echo ""

    echo -e "${BOLD}Store Now, Decrypt Later (SNDL)${NC}"
    echo ""
    echo "  Les adversaires capturent ton trafic chiffré AUJOURD'HUI."
    echo "  Ils attendent les ordinateurs quantiques."
    echo "  Puis ils déchiffrent TOUT rétroactivement."
    echo ""
    echo "  ┌─────────────────────────────────────────────────────────────────┐"
    echo "  │                                                                 │"
    echo "  │   2024              2030              2035              2040    │"
    echo "  │     │                 │                 │                 │     │"
    echo "  │     ▼                 ▼                 ▼                 ▼     │"
    echo "  │  [Capture]        [Stockage]      [Quantum OK]      [Décrypt]  │"
    echo "  │     │                 │                 │                 │     │"
    echo "  │     └─────────────────┴─────────────────┴─────────────────┘     │"
    echo "  │                                                                 │"
    echo "  │            Tes données chiffrées en 2024                        │"
    echo "  │            sont lisibles en 2040                                │"
    echo "  │                                                                 │"
    echo "  └─────────────────────────────────────────────────────────────────┘"
    echo ""

    wait_enter

    echo -e "${BOLD}Qui est concerné ?${NC}"
    echo ""
    echo "  Toute donnée qui doit rester secrète LONGTEMPS :"
    echo ""
    echo "    • Données médicales        → 50+ ans"
    echo "    • Secrets gouvernementaux  → 25-75 ans"
    echo "    • Propriété intellectuelle → 10-20 ans"
    echo "    • Données personnelles     → vie entière"
    echo ""
    echo -e "  ${RED}Si tu chiffres aujourd'hui avec RSA/ECDSA,${NC}"
    echo -e "  ${RED}un adversaire peut DÉJÀ stocker tes données.${NC}"
    echo ""

    checkpoint "Menace SNDL comprise"
}

# =============================================================================
# Partie 3 : Calcul d'urgence (Mosca)
# =============================================================================

partie_3_mosca() {
    echo ""
    echo -e "${BOLD}${BG_RED}${WHITE} PARTIE 3 ${NC} ${BOLD}Calcul de TON urgence${NC}"
    echo -e "${DIM}Durée : 3 minutes${NC}"
    echo ""

    echo -e "${BOLD}L'inégalité de Mosca${NC}"
    echo ""
    echo "  Pour savoir si tu dois agir maintenant, utilise cette formule :"
    echo ""
    echo "  ┌─────────────────────────────────────────────────────────────────┐"
    echo "  │                                                                 │"
    echo "  │    Si  X + Y  >  Z   →  Tu as le temps (mais planifie)         │"
    echo "  │    Si  X + Y  ≤  Z   →  AGIS MAINTENANT !                      │"
    echo "  │                                                                 │"
    echo "  │    X = Années avant l'ordinateur quantique (estimé: 10-15)     │"
    echo "  │    Y = Années pour migrer tes systèmes                          │"
    echo "  │    Z = Années de confidentialité requise                        │"
    echo "  │                                                                 │"
    echo "  └─────────────────────────────────────────────────────────────────┘"
    echo ""

    wait_enter

    echo -e "${BOLD}${CYAN}Calculons TON urgence :${NC}"
    echo ""

    # X - années avant quantum
    echo -n -e "  ${GREEN}X${NC} - Dans combien d'années les ordinateurs quantiques ? "
    echo -e "${DIM}[défaut: 10]${NC}"
    echo -n -e "      ${GREEN}→ ${NC}"
    read -r X
    X=${X:-10}

    # Y - temps de migration
    echo ""
    echo -n -e "  ${GREEN}Y${NC} - Combien d'années pour migrer tes systèmes ? "
    echo -e "${DIM}[défaut: 5]${NC}"
    echo -n -e "      ${GREEN}→ ${NC}"
    read -r Y
    Y=${Y:-5}

    # Z - durée de confidentialité
    echo ""
    echo -e "  ${GREEN}Z${NC} - Combien d'années tes données doivent rester secrètes ?"
    echo -e "      ${DIM}Exemples : Santé=50, Gouvernement=75, Finance=10, Perso=30${NC}"
    echo -n -e "      ${GREEN}→ ${NC}"
    read -r Z
    Z=${Z:-20}

    echo ""
    echo "  ─────────────────────────────────────────────────────────────────"
    echo ""

    # Calcul
    SUM=$((X + Y))

    echo -e "  ${BOLD}Résultat :${NC}"
    echo ""
    echo "    X + Y = $X + $Y = $SUM"
    echo "    Z = $Z"
    echo ""

    if [[ $SUM -gt $Z ]]; then
        echo -e "  ┌─────────────────────────────────────────────────────────────┐"
        echo -e "  │  ${GREEN}✓ $SUM > $Z${NC}                                                │"
        echo -e "  │                                                             │"
        echo -e "  │  Tu as le temps, mais commence à planifier maintenant.     │"
        echo -e "  │  La migration PQC prend des années.                         │"
        echo -e "  └─────────────────────────────────────────────────────────────┘"
    else
        echo -e "  ┌─────────────────────────────────────────────────────────────┐"
        echo -e "  │  ${RED}⚠ $SUM ≤ $Z${NC}                                                │"
        echo -e "  │                                                             │"
        echo -e "  │  ${RED}AGIS MAINTENANT !${NC}                                          │"
        echo -e "  │  Tes données sont déjà à risque.                            │"
        echo -e "  └─────────────────────────────────────────────────────────────┘"
    fi

    echo ""

    checkpoint "Urgence calculée"
}

# =============================================================================
# Récapitulatif
# =============================================================================

show_recap_final() {
    echo ""
    echo -e "${BOLD}${BG_GREEN}${WHITE} RÉVÉLATION TERMINÉE ${NC}"
    echo ""

    show_recap "Ce que tu as appris :" \
        "PQC = cryptographie résistante aux ordinateurs quantiques" \
        "SNDL = tes données chiffrées aujourd'hui seront déchiffrables demain" \
        "Mosca = formule pour calculer ton urgence de migration" \
        "Standards NIST : ML-DSA (signatures), ML-KEM (encryption)"

    show_lesson "Ta CA classique sera cassable.
Le moment d'agir, c'est AVANT que les ordinateurs quantiques arrivent.
Pas après."

    echo ""
    echo -e "${BOLD}Prêt à passer au Post-Quantum ?${NC}"
    echo ""
    echo "  Le Niveau 1 t'apprend à créer des CA et certificats PQC :"
    echo ""
    echo -e "    ${CYAN}./journey/02-pqc-basics/01-full-chain/demo.sh${NC}"
    echo ""
    echo "  Ou retourne au menu principal :"
    echo ""
    echo -e "    ${CYAN}./start.sh${NC}"
    echo ""
}

# =============================================================================
# Main
# =============================================================================

main() {
    show_welcome
    wait_enter "Appuie sur Entrée pour commencer..."

    partie_1_contexte
    wait_enter

    partie_2_sndl
    wait_enter

    partie_3_mosca

    show_recap_final
}

# Exécution
main "$@"
