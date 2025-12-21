#!/bin/bash
# =============================================================================
#  QUICK START : Ma première PKI (10 minutes)
#
#  Objectif : Créer ta première CA et émettre un certificat TLS.
#             Tu vas TAPER les commandes toi-même.
#
#  Algorithme : ECDSA P-384 (classique, pour commencer)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source les helpers
source "$LAB_ROOT/lib/colors.sh"
source "$LAB_ROOT/lib/interactive.sh"
source "$LAB_ROOT/lib/workspace.sh"

# PKI binary
PKI_BIN="$LAB_ROOT/bin/pki"

# =============================================================================
# Vérifications préliminaires
# =============================================================================

check_pki_installed() {
    if [[ ! -x "$PKI_BIN" ]]; then
        echo ""
        print_error "L'outil PKI n'est pas installé"
        echo ""
        echo "  Pour l'installer, exécute :"
        echo -e "  ${CYAN}./tooling/install.sh${NC}"
        echo ""
        exit 1
    fi
}

# =============================================================================
# Bannière de bienvenue
# =============================================================================

show_welcome() {
    clear
    echo ""
    echo -e "${BOLD}${CYAN}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║                                                               ║"
    echo "  ║   🔐  POST-QUANTUM PKI LAB                                    ║"
    echo "  ║                                                               ║"
    echo "  ║   QUICK START : Ma première PKI                               ║"
    echo "  ║                                                               ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo -e "  ${BOLD}Durée estimée :${NC} 10 minutes"
    echo -e "  ${BOLD}Algorithme    :${NC} ECDSA P-384 (classique)"
    echo ""
    echo "  Dans ce Quick Start, tu vas :"
    echo ""
    echo "    1. Créer ta propre Autorité de Certification (CA)"
    echo "    2. Émettre un certificat TLS pour un serveur"
    echo "    3. Vérifier que ton certificat est valide"
    echo "    4. Découvrir la différence avec le Post-Quantum"
    echo ""
    echo -e "  ${DIM}Tu vas taper les commandes toi-même pour mieux retenir.${NC}"
    echo ""
}

# =============================================================================
# Étape 1 : Créer ta CA
# =============================================================================

etape_1_creer_ca() {
    etape "Créer ta Autorité de Certification (CA)" \
          "Une CA est l'entité qui signe les certificats. C'est la racine de confiance."

    echo "  Une CA possède :"
    echo "    - Une clé privée (ca.key) → garde-la secrète !"
    echo "    - Un certificat auto-signé (ca.crt) → distribue-le"
    echo ""
    echo -e "  ${BOLD}Algorithme choisi :${NC} ECDSA P-384"
    echo "    - Courbe elliptique standard (NIST)"
    echo "    - 192 bits de sécurité"
    echo "    - Clés et signatures compactes"
    echo ""

    local ca_dir="$LEVEL_WORKSPACE/classic-ca"

    # Vérifier si la CA existe déjà
    if [[ -f "$ca_dir/ca.crt" ]]; then
        echo -e "${YELLOW}[INFO]${NC} Ta CA existe déjà ! On la réutilise."
        echo ""
        validate_file "$ca_dir/ca.crt" "Certificat CA"
        validate_file "$ca_dir/ca.key" "Clé privée CA"
        echo ""
        learned "Une CA peut être réutilisée pour émettre plusieurs certificats"
        return 0
    fi

    # L'utilisateur tape la commande
    teach_cmd "pki init-ca --name \"Ma Premiere CA\" --algorithm ecdsa-p384 --dir $ca_dir" \
              "Cette commande initialise une nouvelle CA avec l'algorithme ECDSA P-384"

    # Validation
    echo ""
    validate_files "$ca_dir" "ca.crt" "ca.key" "index.txt" "serial"

    checkpoint "CA créée avec succès !"

    # Ce qu'on a appris
    learned "pki init-ca crée une CA avec clé + certificat auto-signé"
}

# =============================================================================
# Étape 2 : Émettre un certificat TLS
# =============================================================================

etape_2_emettre_cert() {
    etape "Émettre un certificat TLS" \
          "Un certificat TLS permet à un serveur de prouver son identité."

    echo "  Pour un certificat TLS serveur, on a besoin de :"
    echo "    - Un Common Name (CN) : le nom du serveur"
    echo "    - Des DNS SANs : les noms de domaine alternatifs"
    echo "    - Un profil : ec/tls-server (certificat serveur ECDSA)"
    echo ""

    local ca_dir="$LEVEL_WORKSPACE/classic-ca"
    local cert_out="$LEVEL_WORKSPACE/server.crt"
    local key_out="$LEVEL_WORKSPACE/server.key"

    # Vérifier si le certificat existe déjà
    if [[ -f "$cert_out" ]]; then
        echo -e "${YELLOW}[INFO]${NC} Un certificat serveur existe déjà !"
        echo ""
        validate_file "$cert_out" "Certificat serveur"
        validate_file "$key_out" "Clé privée serveur"
        echo ""
        learned "Tu peux émettre autant de certificats que tu veux avec ta CA"
        return 0
    fi

    # L'utilisateur tape la commande
    teach_cmd "pki issue --ca-dir $ca_dir --profile ec/tls-server --cn \"mon-serveur.local\" --dns \"mon-serveur.local\" --out $cert_out --key-out $key_out" \
              "Cette commande demande à ta CA de signer un nouveau certificat"

    # Validation
    echo ""
    validate_file "$cert_out" "Certificat TLS"
    validate_file "$key_out" "Clé privée TLS"

    # Afficher les infos du certificat
    echo ""
    echo -e "  ${BOLD}Détails du certificat :${NC}"
    "$PKI_BIN" info "$cert_out" 2>/dev/null | head -15 | sed 's/^/    /'

    checkpoint "Certificat TLS émis !"

    learned "pki issue utilise ta CA pour signer un nouveau certificat"
}

# =============================================================================
# Étape 3 : Vérifier le certificat
# =============================================================================

etape_3_verifier() {
    etape "Vérifier ton certificat" \
          "La vérification confirme que le certificat est valide et signé par ta CA."

    echo "  La vérification vérifie :"
    echo "    - La signature de la CA"
    echo "    - La période de validité"
    echo "    - La chaîne de confiance"
    echo ""

    local ca_dir="$LEVEL_WORKSPACE/classic-ca"
    local cert_file="$LEVEL_WORKSPACE/server.crt"

    # L'utilisateur tape la commande
    teach_cmd "pki verify --ca $ca_dir/ca.crt --cert $cert_file" \
              "Cette commande vérifie que le certificat est bien signé par ta CA"

    checkpoint "Certificat vérifié avec succès !"

    learned "pki verify valide la chaîne de confiance"
}

# =============================================================================
# Étape 4 : Découvrir le Post-Quantum
# =============================================================================

etape_4_decouvrir_pqc() {
    etape "Découvrir la différence Post-Quantum" \
          "Comparons ton certificat classique avec un certificat post-quantique."

    echo "  Le Post-Quantum (PQC) utilise des algorithmes résistants"
    echo "  aux ordinateurs quantiques :"
    echo ""
    echo "    - ML-DSA (ex-Dilithium) : signatures"
    echo "    - ML-KEM (ex-Kyber) : échange de clés"
    echo ""
    echo -e "  ${CYAN}Créons une CA post-quantique pour comparer...${NC}"
    echo ""

    local pqc_ca="$LEVEL_WORKSPACE/pqc-ca-demo"

    # Création automatique (pas besoin de taper)
    demo_cmd "$PKI_BIN init-ca --name 'PQC Demo CA' --algorithm ml-dsa-65 --dir $pqc_ca" \
             "Création d'une CA avec ML-DSA-65..."

    # Émettre un certificat PQC
    demo_cmd "$PKI_BIN issue --ca-dir $pqc_ca --profile ml-dsa/tls-server --cn 'pqc-server.local' --dns 'pqc-server.local' --out $LEVEL_WORKSPACE/pqc-server.crt --key-out $LEVEL_WORKSPACE/pqc-server.key" \
             "Émission d'un certificat PQC..."

    echo ""

    # Comparaison des tailles
    local classic_ca_size=$(wc -c < "$LEVEL_WORKSPACE/classic-ca/ca.crt" | tr -d ' ')
    local classic_cert_size=$(wc -c < "$LEVEL_WORKSPACE/server.crt" | tr -d ' ')
    local classic_key_size=$(wc -c < "$LEVEL_WORKSPACE/server.key" | tr -d ' ')

    local pqc_ca_size=$(wc -c < "$pqc_ca/ca.crt" | tr -d ' ')
    local pqc_cert_size=$(wc -c < "$LEVEL_WORKSPACE/pqc-server.crt" | tr -d ' ')
    local pqc_key_size=$(wc -c < "$LEVEL_WORKSPACE/pqc-server.key" | tr -d ' ')

    echo ""
    echo -e "${BOLD}┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}│  COMPARAISON : Classique (ECDSA) vs Post-Quantum (ML-DSA)       │${NC}"
    echo -e "${BOLD}├─────────────────────────────────────────────────────────────────┤${NC}"
    printf "${BOLD}│${NC}  %-20s %12s %12s %12s ${BOLD}│${NC}\n" "Fichier" "ECDSA" "ML-DSA" "Ratio"
    echo -e "${BOLD}├─────────────────────────────────────────────────────────────────┤${NC}"

    # CA Certificate
    local ca_ratio=$(echo "scale=1; $pqc_ca_size / $classic_ca_size" | bc)
    printf "${BOLD}│${NC}  %-20s %10s B %10s B %10sx ${BOLD}│${NC}\n" "CA Certificate" "$classic_ca_size" "$pqc_ca_size" "$ca_ratio"

    # Server Certificate
    local cert_ratio=$(echo "scale=1; $pqc_cert_size / $classic_cert_size" | bc)
    printf "${BOLD}│${NC}  %-20s %10s B %10s B %10sx ${BOLD}│${NC}\n" "Server Certificate" "$classic_cert_size" "$pqc_cert_size" "$cert_ratio"

    # Private Key
    local key_ratio=$(echo "scale=1; $pqc_key_size / $classic_key_size" | bc)
    printf "${BOLD}│${NC}  %-20s %10s B %10s B %10sx ${BOLD}│${NC}\n" "Private Key" "$classic_key_size" "$pqc_key_size" "$key_ratio"

    echo -e "${BOLD}└─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""

    echo -e "  ${YELLOW}Observation :${NC} Les certificats PQC sont plus gros (~${cert_ratio}x)"
    echo "  Mais c'est le prix à payer pour résister aux ordinateurs quantiques."
    echo ""

    checkpoint "Comparaison terminée !"

    learned "Le PQC utilise les mêmes commandes, seul l'algorithme change"
}

# =============================================================================
# Récapitulatif final
# =============================================================================

show_recap_final() {
    echo ""
    echo -e "${BOLD}${BG_GREEN}${WHITE} QUICK START TERMINÉ ! ${NC}"
    echo ""

    show_recap "Ce que tu as accompli :" \
        "Créé une CA (Autorité de Certification) ECDSA P-384" \
        "Émis un certificat TLS pour ton serveur" \
        "Vérifié la chaîne de confiance" \
        "Comparé avec le Post-Quantum (ML-DSA)"

    echo -e "  ${BOLD}Tes fichiers sont dans :${NC}"
    echo -e "    ${CYAN}$LEVEL_WORKSPACE/${NC}"
    echo ""

    show_lesson "La PKI ne change pas. Seul l'algorithme change.
Passer au Post-Quantum, c'est juste changer un paramètre."

    echo ""
    echo -e "${BOLD}Et maintenant ?${NC}"
    echo ""
    echo "  Ta CA classique que tu viens de créer... elle sera cassable"
    echo "  par un ordinateur quantique. Quand ? C'est LA question."
    echo ""
    echo "  Pour comprendre l'urgence et commencer ta migration :"
    echo ""
    echo -e "    ${CYAN}./journey/00-revelation/demo.sh${NC}"
    echo ""
    echo "  Ou lance le menu principal :"
    echo ""
    echo -e "    ${CYAN}./start.sh${NC}"
    echo ""
}

# =============================================================================
# Main
# =============================================================================

main() {
    # Vérifications
    check_pki_installed

    # Initialiser le workspace (persistant)
    init_workspace "quickstart"

    # Afficher la bienvenue
    show_welcome

    wait_enter "Appuie sur Entrée pour commencer..."

    # Initialiser les étapes
    init_etapes 4

    # Exécuter les étapes
    etape_1_creer_ca
    wait_enter

    etape_2_emettre_cert
    wait_enter

    etape_3_verifier
    wait_enter

    etape_4_decouvrir_pqc

    # Récapitulatif
    show_recap_final
}

# Exécution
main "$@"
