#!/bin/bash
# =============================================================================
#  Lab-03: Hybrid Certificates (Catalyst)
#
#  Best of Both Worlds: Classical + Post-Quantum
#  ECDSA P-384 + ML-DSA-65 in a single certificate
#
#  Key Message: You don't choose between classical and PQC. You stack them.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

setup_demo "Hybrid Certificates (Catalyst)"

PROFILES="$SCRIPT_DIR/profiles"

# =============================================================================
# Introduction
# =============================================================================

echo -e "${BOLD}SCENARIO:${NC}"
echo "  \"I need to migrate to PQC but can't break legacy clients."
echo "   How do I support both classical and post-quantum simultaneously?\""
echo ""

echo -e "${BOLD}WHAT WE'LL DO:${NC}"
echo "  1. Create a Hybrid Root CA (ECDSA + ML-DSA)"
echo "  2. Generate hybrid keys and CSR"
echo "  3. Issue a hybrid TLS certificate"
echo "  4. Verify with both OpenSSL (classical) and QPKI (PQC)"
echo ""

echo -e "${DIM}Hybrid = Catalyst standard (ITU-T X.509 Section 9.8)${NC}"
echo ""

pause "Press Enter to start..."

# =============================================================================
# Step 1: Create Hybrid Root CA
# =============================================================================

print_step "Step 1: Create Hybrid Root CA (ECDSA P-384 + ML-DSA-65)"

echo "  A hybrid CA contains TWO key pairs:"
echo ""
echo "    Primary:     ECDSA P-384 (classical)"
echo "    Alternative: ML-DSA-65 (post-quantum)"
echo ""
echo "  Standard: ITU-T X.509 Section 9.8 (Catalyst)"
echo ""

run_cmd "$PKI_BIN ca init --profile $PROFILES/hybrid-root-ca.yaml --var cn=\"Hybrid Root CA\" --ca-dir $DEMO_TMP/hybrid-ca"

# Export CA certificate for verification
$PKI_BIN ca export --ca-dir $DEMO_TMP/hybrid-ca --out $DEMO_TMP/hybrid-ca/ca.crt

echo ""

pause

# =============================================================================
# Step 2: Generate Hybrid Keys and CSR
# =============================================================================

print_step "Step 2: Generate Hybrid Keys and CSR"

echo "  Generate hybrid keys (classical + PQC) and create CSR."
echo ""
echo "    Primary:     ECDSA P-384 (classical)"
echo "    Alternative: ML-DSA-65 (post-quantum)"
echo ""

run_cmd "$PKI_BIN csr gen --algorithm ecdsa-p384 --hybrid ml-dsa-65 --keyout $DEMO_TMP/hybrid-server.key --hybrid-keyout $DEMO_TMP/hybrid-server-pqc.key --cn hybrid.example.com --out $DEMO_TMP/hybrid-server.csr"

echo ""

pause

# =============================================================================
# Step 3: Issue Hybrid TLS Certificate
# =============================================================================

print_step "Step 3: Issue Hybrid TLS Certificate"

echo "  The certificate inherits the hybrid nature from the CA."
echo "  It will contain both ECDSA and ML-DSA keys/signatures."
echo ""

run_cmd "$PKI_BIN cert issue --ca-dir $DEMO_TMP/hybrid-ca --profile $PROFILES/hybrid-tls-server.yaml --csr $DEMO_TMP/hybrid-server.csr --out $DEMO_TMP/hybrid-server.crt"

echo ""

pause

# =============================================================================
# Step 4: Test Interoperability
# =============================================================================

print_step "Step 4: Test Interoperability"

echo "  The power of hybrid: works with EVERYONE!"
echo ""
echo -e "  ${BOLD}Test 1: Legacy Client (OpenSSL)${NC}"
echo "    OpenSSL doesn't understand PQC, but still verifies."
echo ""

echo -e "  ${DIM}$ openssl verify -CAfile $DEMO_TMP/hybrid-ca/ca.crt $DEMO_TMP/hybrid-server.crt${NC}"
if openssl verify -CAfile $DEMO_TMP/hybrid-ca/ca.crt $DEMO_TMP/hybrid-server.crt 2>&1; then
    echo ""
    echo -e "    ${GREEN}✓${NC} Legacy client: Certificate verified via ECDSA"
    echo -e "    ${DIM}(PQC extensions are ignored)${NC}"
fi

echo ""
pause

echo -e "  ${BOLD}Test 2: PQC-Aware Client (pki)${NC}"
echo "    The qpki tool verifies BOTH signatures."
echo ""

echo -e "  ${DIM}$ qpki cert verify $DEMO_TMP/hybrid-server.crt --ca $DEMO_TMP/hybrid-ca/ca.crt${NC}"
if $PKI_BIN cert verify $DEMO_TMP/hybrid-server.crt --ca $DEMO_TMP/hybrid-ca/ca.crt 2>&1; then
    echo ""
    echo -e "    ${GREEN}✓${NC} PQC client: BOTH ECDSA AND ML-DSA verified"
fi

echo ""
echo "  ┌─────────────────────────────────────────────────────────────────┐"
echo "  │  INTEROPERABILITY SUMMARY                                       │"
echo "  ├─────────────────────────────────────────────────────────────────┤"
echo -e "  │  Legacy (OpenSSL)  │ Uses ECDSA, ignores PQC │ ${GREEN}✓ OK${NC}           │"
echo -e "  │  PQC-Aware (pki)   │ Verifies BOTH           │ ${GREEN}✓ OK${NC}           │"
echo "  └─────────────────────────────────────────────────────────────────┘"
echo ""
echo -e "  ${BOLD}Zero changes for legacy clients. Quantum protection for modern ones.${NC}"
echo ""

pause

# =============================================================================
# Step 5: Size Comparison
# =============================================================================

print_step "Step 5: Size Comparison"

if [[ -f "$DEMO_TMP/hybrid-ca/ca.crt" ]]; then
    hybrid_ca_size=$(wc -c < "$DEMO_TMP/hybrid-ca/ca.crt" | tr -d ' ')
    hybrid_cert_size=$(wc -c < "$DEMO_TMP/hybrid-server.crt" | tr -d ' ')
    hybrid_key_size=$(wc -c < "$DEMO_TMP/hybrid-server.key" | tr -d ' ')

    echo -e "  ${BOLD}Hybrid certificate sizes:${NC}"
    echo ""
    echo "  ┌────────────────────────────────────────────────────────────┐"
    printf "  │  %-25s %10s %18s │\n" "" "Size" "Overhead vs Classical"
    echo "  ├────────────────────────────────────────────────────────────┤"
    printf "  │  %-25s %8s B %16s │\n" "Hybrid CA" "$hybrid_ca_size" "~5 KB"
    printf "  │  %-25s %8s B %16s │\n" "Hybrid TLS Certificate" "$hybrid_cert_size" "~5 KB"
    printf "  │  %-25s %8s B %16s │\n" "Hybrid Private Key" "$hybrid_key_size" "~2 KB"
    echo "  └────────────────────────────────────────────────────────────┘"
    echo ""
    echo -e "  ${DIM}Overhead comes from ML-DSA key (~1952 B) + signature (~3309 B)${NC}"
fi

echo ""

# =============================================================================
# Conclusion
# =============================================================================

print_key_message "You don't choose between classical and PQC. You stack them."

show_lesson "Hybrid = belt AND suspenders. Legacy clients work unchanged.
Modern clients get quantum protection. No flag day required."

show_footer
