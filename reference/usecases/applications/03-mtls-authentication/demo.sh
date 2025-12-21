#!/bin/bash
#
# APP-03: "Show Me Your Badge"
# Mutual TLS Authentication with Post-Quantum Certificates
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
WORKSPACE="workspace"
CA_DIR="$WORKSPACE/ca"
SERVER_DIR="$WORKSPACE/server"
CLIENTS_DIR="$WORKSPACE/clients"
SERVER_PORT=8443

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${CYAN}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

wait_for_key() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

cleanup() {
    print_step "Cleaning up workspace..."
    rm -rf "$WORKSPACE"
    # Kill any running server
    pkill -f "go run.*server.go" 2>/dev/null || true
}

# ============================================================================
# MAIN DEMO
# ============================================================================

print_header "APP-03: Show Me Your Badge"
echo "Mutual TLS Authentication with Post-Quantum Certificates"
echo ""
echo "In this demo:"
echo "  - Alice and Bob will connect with valid client certificates"
echo "  - Mallory will try to connect without a certificate"
echo ""
echo "Algorithm: ML-DSA-65 (NIST Level 3)"

wait_for_key

# ----------------------------------------------------------------------------
# Step 1: Setup CA
# ----------------------------------------------------------------------------
print_header "Step 1: Create the Certificate Authority"

cleanup
mkdir -p "$CA_DIR" "$SERVER_DIR" "$CLIENTS_DIR/alice" "$CLIENTS_DIR/bob"

print_step "Initializing ML-DSA CA..."
pki ca init \
    --path "$CA_DIR" \
    --cn "mTLS Demo CA" \
    --org "Demo Lab" \
    --algorithm ml-dsa-65

print_success "CA created with ML-DSA-65"

wait_for_key

# ----------------------------------------------------------------------------
# Step 2: Issue Server Certificate
# ----------------------------------------------------------------------------
print_header "Step 2: Issue Server Certificate"

print_step "Issuing server certificate for localhost..."
pki cert issue \
    --ca-path "$CA_DIR" \
    --cn "localhost" \
    --dns "localhost" \
    --ip "127.0.0.1" \
    --profile tls-server \
    --out "$SERVER_DIR/server"

print_success "Server certificate issued"
echo ""
echo "Files created:"
ls -la "$SERVER_DIR/"

wait_for_key

# ----------------------------------------------------------------------------
# Step 3: Issue Client Certificates
# ----------------------------------------------------------------------------
print_header "Step 3: Issue Client Certificates"

print_step "Issuing certificate for Alice..."
pki cert issue \
    --ca-path "$CA_DIR" \
    --cn "Alice" \
    --org "Employees" \
    --profile tls-client \
    --out "$CLIENTS_DIR/alice/alice"

print_success "Alice's certificate issued"

print_step "Issuing certificate for Bob..."
pki cert issue \
    --ca-path "$CA_DIR" \
    --cn "Bob" \
    --org "Admins" \
    --profile tls-client \
    --out "$CLIENTS_DIR/bob/bob"

print_success "Bob's certificate issued"

echo ""
echo "Client certificates:"
ls -la "$CLIENTS_DIR/alice/"
ls -la "$CLIENTS_DIR/bob/"

wait_for_key

# ----------------------------------------------------------------------------
# Step 4: Create the HTTPS Server
# ----------------------------------------------------------------------------
print_header "Step 4: Create mTLS HTTPS Server"

cat > "$WORKSPACE/server.go" << 'GOCODE'
package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	// Load CA certificate for client verification
	caCert, err := os.ReadFile("ca/ca.crt")
	if err != nil {
		log.Fatalf("Failed to read CA cert: %v", err)
	}
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	// Configure TLS with client certificate requirement
	tlsConfig := &tls.Config{
		ClientCAs:  caCertPool,
		ClientAuth: tls.RequireAndVerifyClientCert,
		MinVersion: tls.VersionTLS13,
	}

	// Handler that shows client identity
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if len(r.TLS.PeerCertificates) > 0 {
			cert := r.TLS.PeerCertificates[0]
			cn := cert.Subject.CommonName
			org := ""
			if len(cert.Subject.Organization) > 0 {
				org = cert.Subject.Organization[0]
			}
			response := fmt.Sprintf("\n  Welcome %s! (Organization: %s)\n\n", cn, org)
			fmt.Fprint(w, response)
			log.Printf("Authenticated: %s (%s)", cn, org)
		} else {
			http.Error(w, "No client certificate", http.StatusForbidden)
		}
	})

	// Create server
	server := &http.Server{
		Addr:      ":8443",
		TLSConfig: tlsConfig,
	}

	fmt.Println("mTLS Server running on https://localhost:8443")
	fmt.Println("Waiting for client connections...")
	fmt.Println("")

	err = server.ListenAndServeTLS("server/server.crt", "server/server.key")
	if err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
GOCODE

print_success "Server code created"
echo ""
echo "Key security settings:"
echo "  - ClientAuth: RequireAndVerifyClientCert"
echo "  - MinVersion: TLS 1.3"
echo "  - ClientCAs: Our ML-DSA CA"

wait_for_key

# ----------------------------------------------------------------------------
# Step 5: Start Server and Test Connections
# ----------------------------------------------------------------------------
print_header "Step 5: Test mTLS Connections"

print_step "Starting mTLS server in background..."
cd "$WORKSPACE"
go run server.go &
SERVER_PID=$!
cd - > /dev/null
sleep 2

echo ""
echo -e "${GREEN}Server is running on https://localhost:8443${NC}"
echo ""

wait_for_key

# Test 1: Alice connects
print_step "Test 1: Alice connects with her certificate..."
echo ""
RESPONSE=$(curl -s --cacert "$CA_DIR/ca.crt" \
    --cert "$CLIENTS_DIR/alice/alice.crt" \
    --key "$CLIENTS_DIR/alice/alice.key" \
    https://localhost:8443/ 2>&1) || true

if echo "$RESPONSE" | grep -q "Welcome Alice"; then
    print_success "Alice authenticated successfully!"
    echo -e "${GREEN}$RESPONSE${NC}"
else
    print_error "Alice failed to authenticate"
    echo "$RESPONSE"
fi

wait_for_key

# Test 2: Bob connects
print_step "Test 2: Bob connects with his certificate..."
echo ""
RESPONSE=$(curl -s --cacert "$CA_DIR/ca.crt" \
    --cert "$CLIENTS_DIR/bob/bob.crt" \
    --key "$CLIENTS_DIR/bob/bob.key" \
    https://localhost:8443/ 2>&1) || true

if echo "$RESPONSE" | grep -q "Welcome Bob"; then
    print_success "Bob authenticated successfully!"
    echo -e "${GREEN}$RESPONSE${NC}"
else
    print_error "Bob failed to authenticate"
    echo "$RESPONSE"
fi

wait_for_key

# Test 3: Mallory tries without certificate
print_step "Test 3: Mallory tries to connect WITHOUT a certificate..."
echo ""
RESPONSE=$(curl -s --cacert "$CA_DIR/ca.crt" \
    https://localhost:8443/ 2>&1) || true

if echo "$RESPONSE" | grep -qi "error\|failed\|refused\|required"; then
    print_success "Mallory was REJECTED! (No valid certificate)"
    echo -e "${RED}Connection refused - certificate required${NC}"
else
    print_error "Unexpected: Mallory got through?"
    echo "$RESPONSE"
fi

# Cleanup server
kill $SERVER_PID 2>/dev/null || true

wait_for_key

# ----------------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------------
print_header "Summary"

echo "What we demonstrated:"
echo ""
echo "  1. Created an ML-DSA CA (post-quantum)"
echo "  2. Issued server and client certificates"
echo "  3. Built an mTLS server requiring client certs"
echo "  4. Alice and Bob authenticated successfully"
echo "  5. Mallory was rejected without a certificate"
echo ""
echo -e "${GREEN}mTLS + PQC = Quantum-resistant mutual authentication${NC}"
echo ""
echo "Key takeaways:"
echo "  - Both parties prove identity with certificates"
echo "  - No passwords needed - cryptographic proof only"
echo "  - PQC ensures long-term security"
echo ""
echo "Next: APP-04 'Is This Cert Still Good?' - Add OCSP verification"
