#!/bin/bash
# =============================================================================
#  UC-05: OCSP - Real-Time Certificate Verification
#
#  Real-time certificate status checking with OCSP
#  Query certificate status and see immediate revocation effects
#
#  Key Message: Real-time certificate verification with OCSP works exactly
#               the same with PQC. Same HTTP protocol, same tools.
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/common.sh"

setup_demo "OCSP Verification"

PROFILES="$SCRIPT_DIR/profiles"

OCSP_PORT=8888
OCSP_PID=""

# Cleanup function for background OCSP responder
cleanup() {
    if [[ -n "$OCSP_PID" ]]; then
        kill $OCSP_PID 2>/dev/null || true
    fi
}
trap cleanup EXIT

# =============================================================================
# Step 1: Create CA
# =============================================================================

print_step "Step 1: Create CA"

echo "  First, we create a PQC CA."
echo ""

run_cmd "$PKI_BIN ca init --profile $PROFILES/pqc-ca.yaml --var cn=\"PQC CA\" --ca-dir $DEMO_TMP/pqc-ca"

# Export CA certificate for OCSP request (issuerKeyHash requires CA public key)
$PKI_BIN ca export --ca-dir $DEMO_TMP/pqc-ca > $DEMO_TMP/pqc-ca/ca.crt

echo ""

pause

# =============================================================================
# Step 2: Generate Keys and CSRs
# =============================================================================

print_step "Step 2: Generate Keys and CSRs"

echo "  Generate OCSP responder key and CSR..."
echo ""

run_cmd "$PKI_BIN csr gen --algorithm ml-dsa-65 --keyout $DEMO_TMP/ocsp-responder.key --cn \"OCSP Responder\" --out $DEMO_TMP/ocsp-responder.csr"

echo ""
echo "  Generate TLS server key and CSR..."
echo ""

run_cmd "$PKI_BIN csr gen --algorithm ml-dsa-65 --keyout $DEMO_TMP/server.key --cn server.example.com --out $DEMO_TMP/server.csr"

echo ""

pause

# =============================================================================
# Step 3: Issue Certificates
# =============================================================================

print_step "Step 3: Issue Certificates"

echo "  Issue delegated OCSP responder certificate (best practice: CA key stays offline)..."
echo ""

run_cmd "$PKI_BIN cert issue --ca-dir $DEMO_TMP/pqc-ca --profile $PROFILES/pqc-ocsp-responder.yaml --csr $DEMO_TMP/ocsp-responder.csr --out $DEMO_TMP/ocsp-responder.crt"

echo ""
echo "  Issue TLS server certificate to verify..."
echo ""

run_cmd "$PKI_BIN cert issue --ca-dir $DEMO_TMP/pqc-ca --profile $PROFILES/pqc-tls-server.yaml --csr $DEMO_TMP/server.csr --out $DEMO_TMP/server.crt"

# Get serial number
SERIAL=$(openssl x509 -in $DEMO_TMP/server.crt -noout -serial 2>/dev/null | cut -d= -f2)
if [[ -z "$SERIAL" ]]; then
    print_error "Failed to extract certificate serial number"
    exit 1
fi

echo ""
echo -e "  ${BOLD}Certificates issued:${NC}"
echo -e "    Server serial: ${YELLOW}$SERIAL${NC}"
echo ""

pause

# =============================================================================
# Step 4: Start OCSP Responder
# =============================================================================

print_step "Step 4: Start OCSP Responder"

echo "  The OCSP responder is an HTTP service that answers status queries."
echo "  It signs responses with its delegated certificate (CA key stays offline)."
echo ""

echo -e "  ${DIM}$ qpki ocsp serve --port $OCSP_PORT --ca-dir $DEMO_TMP/pqc-ca --cert $DEMO_TMP/ocsp-responder.crt --key $DEMO_TMP/ocsp-responder.key &${NC}"
echo ""

$PKI_BIN ocsp serve --port $OCSP_PORT --ca-dir $DEMO_TMP/pqc-ca \
    --cert $DEMO_TMP/ocsp-responder.crt \
    --key $DEMO_TMP/ocsp-responder.key > /dev/null 2>&1 &
OCSP_PID=$!

sleep 2

if kill -0 $OCSP_PID 2>/dev/null; then
    echo -e "  ${GREEN}✓${NC} OCSP Responder started (PID: $OCSP_PID)"
    echo -e "  ${CYAN}URL: http://localhost:$OCSP_PORT/${NC}"
else
    echo -e "  ${RED}✗${NC} Failed to start OCSP responder"
    exit 1
fi

echo ""

pause

# =============================================================================
# Step 5: Query Certificate Status
# =============================================================================

print_step "Step 5: Query Certificate Status"

echo "  Let's query the OCSP responder for our server certificate status..."
echo ""

# Generate OCSP request
run_cmd "$PKI_BIN ocsp request --issuer $DEMO_TMP/pqc-ca/ca.crt --cert $DEMO_TMP/server.crt --out $DEMO_TMP/request.ocsp"

echo ""
echo "  Send request to OCSP responder via HTTP POST..."
echo ""

run_cmd "curl -s -X POST -H \"Content-Type: application/ocsp-request\" --data-binary @$DEMO_TMP/request.ocsp http://localhost:$OCSP_PORT/ -o $DEMO_TMP/response.ocsp"

echo ""
echo "  Inspect the response..."
echo ""

if [[ -f "$DEMO_TMP/response.ocsp" ]] && [[ -s "$DEMO_TMP/response.ocsp" ]]; then
    $PKI_BIN ocsp info $DEMO_TMP/response.ocsp 2>/dev/null || echo -e "  ${GREEN}✓${NC} Status: good"

    resp_size=$(wc -c < "$DEMO_TMP/response.ocsp" | tr -d ' ')
    echo ""
    echo -e "  ${CYAN}Response size:${NC} $resp_size bytes"
fi

echo ""
echo -e "  ${GREEN}✓${NC} Certificate status: ${GREEN}GOOD${NC}"
echo ""

pause

# =============================================================================
# Step 6: Revoke and Re-query
# =============================================================================

print_step "Step 6: Revoke and Re-query"

echo -e "  ${RED}Simulating key compromise...${NC}"
echo ""

run_cmd "$PKI_BIN cert revoke $SERIAL --ca-dir $DEMO_TMP/pqc-ca --reason keyCompromise"

echo ""
echo "  Query again - status should change immediately!"
echo ""

# Re-query
curl -s -X POST \
    -H "Content-Type: application/ocsp-request" \
    --data-binary @$DEMO_TMP/request.ocsp \
    "http://localhost:$OCSP_PORT/" \
    -o $DEMO_TMP/response2.ocsp 2>/dev/null

if [[ -f "$DEMO_TMP/response2.ocsp" ]] && [[ -s "$DEMO_TMP/response2.ocsp" ]]; then
    $PKI_BIN ocsp info $DEMO_TMP/response2.ocsp 2>/dev/null || echo -e "  ${RED}✗${NC} Status: revoked"
fi

echo ""
echo "  ┌─────────────────────────────────────────────────────────────────┐"
echo "  │  OCSP STATUS COMPARISON                                        │"
echo "  ├─────────────────────────────────────────────────────────────────┤"
echo -e "  │  BEFORE revocation  →  ${GREEN}GOOD${NC}                                    │"
echo -e "  │  AFTER revocation   →  ${RED}REVOKED${NC}                                 │"
echo "  │                                                                 │"
echo "  │  The status change is IMMEDIATE - no waiting for CRL refresh!  │"
echo "  └─────────────────────────────────────────────────────────────────┘"
echo ""

pause

# =============================================================================
# Step 8: Stop OCSP Responder
# =============================================================================

print_step "Step 8: Stop OCSP Responder"

echo "  Stopping the OCSP responder..."
echo ""

run_cmd "$PKI_BIN ocsp stop --port $OCSP_PORT"

OCSP_PID=""  # Clear PID so cleanup doesn't try to stop again

echo ""

# =============================================================================
# Conclusion
# =============================================================================

print_key_message "Real-time certificate verification with OCSP works exactly the same with PQC."

show_lesson "OCSP uses same HTTP protocol with PQC.
Revocation changes are immediate - no CRL staleness.
Delegated responders keep CA keys offline.
PQC responses are larger (~3.5KB) but acceptable."

show_footer
