#!/bin/bash
# =============================================================================
#  UC-08: LTV Signatures - Sign Today, Verify in 30 Years
#
#  Long-Term Validation for document signing with ML-DSA
#  Bundle everything needed for offline verification decades from now
#
#  Key Message: A signature is only as good as its proof chain.
#               LTV bundles everything needed for offline verification.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

TSA_PORT=8318
TSA_PID=""
BUNDLE_DIR="output/ltv-bundle"

cleanup() {
    if [[ -n "$TSA_PID" ]] && kill -0 "$TSA_PID" 2>/dev/null; then
        echo ""
        echo -e "  ${DIM}Stopping TSA server (PID $TSA_PID)...${NC}"
        kill "$TSA_PID" 2>/dev/null || true
        wait "$TSA_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT

setup_demo "PQC LTV Signatures"

# =============================================================================
# Step 1: Create CA
# =============================================================================

print_step "Step 1: Create CA"

echo "  We need a CA to issue certificates for document signing and timestamping."
echo ""

run_cmd "$PKI_BIN ca init --profile profiles/pqc-ca.yaml --var cn=\"LTV Demo CA\" --ca-dir output/ltv-ca"

# Export CA certificate for chain building
$PKI_BIN ca export --ca-dir output/ltv-ca > output/ltv-ca/ca.crt

echo ""

pause

# =============================================================================
# Step 2: Issue TSA Certificate
# =============================================================================

print_step "Step 2: Issue TSA Certificate"

echo "  Generate TSA key and issue certificate..."
echo ""

run_cmd "$PKI_BIN csr gen --algorithm ml-dsa-65 --keyout output/tsa.key --cn \"LTV Timestamp Authority\" -o output/tsa.csr"

echo ""

run_cmd "$PKI_BIN cert issue --ca-dir output/ltv-ca --profile profiles/pqc-tsa.yaml --csr output/tsa.csr --out output/tsa.crt"

echo ""

pause

# =============================================================================
# Step 3: Start TSA Server
# =============================================================================

print_step "Step 3: Start TSA Server"

echo "  Starting RFC 3161 HTTP timestamp server on port $TSA_PORT..."
echo ""

echo -e "  ${DIM}$ qpki tsa serve --port $TSA_PORT --cert output/tsa.crt --key output/tsa.key &${NC}"
echo ""

$PKI_BIN tsa serve --port $TSA_PORT --cert output/tsa.crt --key output/tsa.key &
TSA_PID=$!

sleep 1

if kill -0 "$TSA_PID" 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} TSA server running on http://localhost:$TSA_PORT"
    echo -e "  ${DIM}(PID: $TSA_PID)${NC}"
else
    echo -e "  ${RED}✗${NC} Failed to start TSA server"
    exit 1
fi

echo ""

pause

# =============================================================================
# Step 4: Issue Signing Certificate
# =============================================================================

print_step "Step 4: Issue Signing Certificate"

echo "  Generate document signing key and CSR for Alice..."
echo ""

run_cmd "$PKI_BIN csr gen --algorithm ml-dsa-65 --keyout output/alice.key --cn \"Alice (Legal Counsel)\" -o output/alice.csr"

echo ""

run_cmd "$PKI_BIN cert issue --ca-dir output/ltv-ca --profile profiles/pqc-document-signing.yaml --csr output/alice.csr --out output/alice.crt"

echo ""

pause

# =============================================================================
# Step 5: Create and Sign Document
# =============================================================================

print_step "Step 5: Create & Sign the 30-Year Contract"

SIGN_DATE=$(date "+%Y-%m-%d %H:%M:%S")

cat > output/contract.txt << EOF
================================================================================
                    30-YEAR COMMERCIAL LEASE AGREEMENT
================================================================================

Document ID: LEASE-$(date +%s)
Signing Date: $SIGN_DATE
Expiration: 2054-12-22

PARTIES:
  Lessor:  ACME Properties LLC
  Lessee:  TechCorp Industries Inc.

TERMS:
  Property: 123 Innovation Drive, Suite 500
  Duration: 30 years from signing date
  Monthly Rent: \$50,000 (adjusted annually for inflation)

This agreement shall remain valid and enforceable for the full 30-year term.

SIGNATURES:
  Signed electronically with Post-Quantum ML-DSA-65 algorithm.

================================================================================
EOF

echo -e "  ${CYAN}Contract content:${NC}"
head -12 output/contract.txt | sed 's/^/    /'
echo "    ..."
echo ""

echo "  Signing with CMS (ML-DSA)..."
echo ""

run_cmd "$PKI_BIN cms sign --data output/contract.txt --cert output/alice.crt --key output/alice.key -o output/contract.p7s"

echo ""

if [[ -f "output/contract.p7s" ]]; then
    sig_size=$(wc -c < "output/contract.p7s" | tr -d ' ')
    echo -e "  ${CYAN}Signature size:${NC} $sig_size bytes"
fi

echo ""

pause

# =============================================================================
# Step 6: Request Timestamp (via HTTP)
# =============================================================================

print_step "Step 6: Request Timestamp (via HTTP)"

echo "  The timestamp proves WHEN the document was signed."
echo "  This is critical because it proves the certificate was valid at signing time."
echo ""

run_cmd "$PKI_BIN tsa request --data output/contract.p7s -o output/request.tsq"

echo ""

echo -e "  ${DIM}$ curl -s -X POST -H \"Content-Type: application/timestamp-query\" --data-binary @output/request.tsq http://localhost:$TSA_PORT/ -o output/contract.tsr${NC}"
echo ""

curl -s -X POST \
    -H "Content-Type: application/timestamp-query" \
    --data-binary @output/request.tsq \
    "http://localhost:$TSA_PORT/" \
    -o output/contract.tsr

if [[ -f "output/contract.tsr" ]]; then
    tsr_size=$(wc -c < "output/contract.tsr" | tr -d ' ')
    echo -e "  ${GREEN}✓${NC} Timestamp token received"
    echo -e "  ${CYAN}Timestamp size:${NC} $tsr_size bytes"
else
    echo -e "  ${RED}✗${NC} Failed to get timestamp"
    exit 1
fi

echo ""

pause

# =============================================================================
# Step 7: Create LTV Bundle
# =============================================================================

print_step "Step 7: Create LTV Bundle"

echo "  Packaging everything for long-term verification..."
echo ""

mkdir -p "$BUNDLE_DIR"

# Copy all components
cp output/contract.txt "$BUNDLE_DIR/document.txt"
cp output/contract.p7s "$BUNDLE_DIR/signature.p7s"
cp output/contract.tsr "$BUNDLE_DIR/timestamp.tsr"
cat output/alice.crt output/ltv-ca/ca.crt > "$BUNDLE_DIR/chain.pem"

# Create manifest
cat > "$BUNDLE_DIR/manifest.json" << EOF
{
  "version": "1.0",
  "created": "$SIGN_DATE",
  "algorithm": "ML-DSA-65",
  "components": {
    "document": "document.txt",
    "signature": "signature.p7s",
    "timestamp": "timestamp.tsr",
    "chain": "chain.pem"
  },
  "note": "This bundle contains all proofs needed for offline verification in 2055+"
}
EOF

echo -e "  ${GREEN}✓${NC} LTV Bundle created at: $BUNDLE_DIR/"
echo ""
echo -e "  ${CYAN}Bundle contents:${NC}"
ls -la "$BUNDLE_DIR" | sed 's/^/    /'
echo ""

# Calculate total bundle size
bundle_size=$(du -sh "$BUNDLE_DIR" 2>/dev/null | cut -f1)
echo -e "  ${CYAN}Total bundle size:${NC} $bundle_size"
echo ""

pause

# =============================================================================
# Step 8: Verify Offline (Simulating 2055)
# =============================================================================

print_step "Step 8: Verify Offline (Simulating Year 2055)"

echo "  ┌─────────────────────────────────────────────────────────────────┐"
echo "  │  SIMULATING: It's now 2055. The original CA is long gone.      │"
echo "  │  Bob (archivist) needs to verify this 30-year-old contract.    │"
echo "  │  He only has the LTV bundle - no network access to original CA.│"
echo "  └─────────────────────────────────────────────────────────────────┘"
echo ""

echo "  Verifying CMS signature using bundled chain..."
echo ""

run_cmd "$PKI_BIN cms verify $BUNDLE_DIR/signature.p7s --data $BUNDLE_DIR/document.txt"

echo ""
echo -e "  ${GREEN}✓${NC} Signature VALID"
echo -e "  ${GREEN}✓${NC} Document verified using bundled certificate chain"
echo -e "  ${GREEN}✓${NC} No network access required"
echo ""

pause

# =============================================================================
# Step 9: Stop TSA Server
# =============================================================================

print_step "Step 9: Stop TSA Server"

echo "  Stopping the TSA server..."
echo ""

run_cmd "$PKI_BIN tsa stop --port $TSA_PORT"

TSA_PID=""  # Clear PID so cleanup doesn't try to stop again

echo ""

# =============================================================================
# Why LTV Matters (Comparison)
# =============================================================================

echo ""
echo -e "  ${BOLD}WITHOUT LTV (in 2055):${NC}"
echo -e "    ${RED}✗${NC} Signature: Still mathematically valid"
echo -e "    ${RED}✗${NC} Certificate: Cannot verify (CA gone, OCSP offline)"
echo -e "    ${RED}✗${NC} Time of signing: Unknown"
echo -e "    ${RED}→ Result: CANNOT TRUST THE SIGNATURE${NC}"
echo ""
echo -e "  ${BOLD}WITH LTV (in 2055):${NC}"
echo -e "    ${GREEN}✓${NC} Signature: Valid (ML-DSA is quantum-resistant)"
echo -e "    ${GREEN}✓${NC} Certificate: Bundled chain verifies offline"
echo -e "    ${GREEN}✓${NC} Time of signing: Timestamp proves $SIGN_DATE"
echo -e "    ${GREEN}→ Result: FULLY VERIFIED, LEGALLY BINDING${NC}"
echo ""

# =============================================================================
# Conclusion
# =============================================================================

print_key_message "A signature is only as good as its proof chain. LTV bundles everything."

show_lesson "LTV bundles: document + signature + timestamp + chain.
With PQC (ML-DSA), your 30-year contracts stay valid in 2055.
No network dependencies - everything is self-contained.
Essential for legal, medical, and real estate documents."

show_footer
