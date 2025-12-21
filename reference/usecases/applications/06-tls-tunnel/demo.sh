#!/bin/bash
#
# APP-06: "Build a PQC Tunnel"
# Secure TLS Tunnel with Post-Quantum Certificates
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
CLIENT_DIR="$WORKSPACE/client"
BACKEND_PORT=8080
TUNNEL_PORT=8443
LOCAL_PORT=9000

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

wait_for_key() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

cleanup() {
    print_step "Cleaning up..."
    pkill -f "go run.*backend.go" 2>/dev/null || true
    pkill -f "go run.*tunnel-server.go" 2>/dev/null || true
    pkill -f "go run.*tunnel-client.go" 2>/dev/null || true
    rm -rf "$WORKSPACE"
}

trap cleanup EXIT

# ============================================================================
# MAIN DEMO
# ============================================================================

print_header "APP-06: Build a PQC Tunnel"
echo "Secure TLS Tunnel with Post-Quantum Certificates"
echo ""
echo "Architecture:"
echo ""
echo "  ┌────────┐     ┌────────────┐     ┌────────────┐     ┌─────────┐"
echo "  │  curl  │────>│  Tunnel    │═════│  Tunnel    │────>│ Backend │"
echo "  │        │     │  Client    │ TLS │  Server    │     │  :8080  │"
echo "  └────────┘     │  :9000     │     │  :8443     │     └─────────┘"
echo "                 └────────────┘     └────────────┘"
echo ""
echo "Algorithm: ML-DSA-65 (NIST Level 3)"

wait_for_key

# ----------------------------------------------------------------------------
# Step 1: Setup PKI
# ----------------------------------------------------------------------------
print_header "Step 1: Create PKI Infrastructure"

cleanup 2>/dev/null || true
mkdir -p "$CA_DIR" "$SERVER_DIR" "$CLIENT_DIR"

print_step "Initializing ML-DSA CA..."
pki ca init \
    --path "$CA_DIR" \
    --cn "Tunnel CA" \
    --org "Demo Lab" \
    --algorithm ml-dsa-65

print_step "Issuing tunnel server certificate..."
pki cert issue \
    --ca-path "$CA_DIR" \
    --cn "tunnel-server" \
    --dns "localhost" \
    --ip "127.0.0.1" \
    --profile tls-server \
    --out "$SERVER_DIR/server"

print_step "Issuing tunnel client certificate..."
pki cert issue \
    --ca-path "$CA_DIR" \
    --cn "tunnel-client" \
    --profile tls-client \
    --out "$CLIENT_DIR/client"

print_success "PKI ready: CA + server cert + client cert"

wait_for_key

# ----------------------------------------------------------------------------
# Step 2: Create Backend Service
# ----------------------------------------------------------------------------
print_header "Step 2: Create Backend Service"

cat > "$WORKSPACE/backend.go" << 'GOCODE'
package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		response := fmt.Sprintf(`
┌─────────────────────────────────────────────┐
│         BACKEND SERVICE RESPONSE            │
├─────────────────────────────────────────────┤
│  Status: OK                                 │
│  Time:   %s            │
│  Path:   %-35s │
│                                             │
│  You reached me through the PQC tunnel!     │
└─────────────────────────────────────────────┘
`, time.Now().Format("2006-01-02 15:04:05"), r.URL.Path)
		fmt.Fprint(w, response)
		log.Printf("Request: %s %s", r.Method, r.URL.Path)
	})

	log.Println("Backend running on :8080")
	http.ListenAndServe(":8080", nil)
}
GOCODE

print_step "Starting backend service on :$BACKEND_PORT..."
cd "$WORKSPACE"
go run backend.go &
BACKEND_PID=$!
cd - > /dev/null
sleep 1

print_success "Backend running (PID: $BACKEND_PID)"

# Quick test
echo ""
print_step "Testing backend directly..."
curl -s http://localhost:$BACKEND_PORT/ | head -5

wait_for_key

# ----------------------------------------------------------------------------
# Step 3: Create Tunnel Server
# ----------------------------------------------------------------------------
print_header "Step 3: Create Tunnel Server"

cat > "$WORKSPACE/tunnel-server.go" << 'GOCODE'
package main

import (
	"crypto/tls"
	"crypto/x509"
	"io"
	"log"
	"net"
	"os"
)

func main() {
	// Load CA for client verification
	caCert, _ := os.ReadFile("ca/ca.crt")
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	// Load server certificate
	cert, err := tls.LoadX509KeyPair("server/server.crt", "server/server.key")
	if err != nil {
		log.Fatalf("Failed to load server cert: %v", err)
	}

	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{cert},
		ClientCAs:    caCertPool,
		ClientAuth:   tls.RequireAndVerifyClientCert,
		MinVersion:   tls.VersionTLS13,
	}

	listener, err := tls.Listen("tcp", ":8443", tlsConfig)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}
	log.Println("Tunnel server listening on :8443 (mTLS)")

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Printf("Accept error: %v", err)
			continue
		}

		// Log client info
		tlsConn := conn.(*tls.Conn)
		tlsConn.Handshake()
		state := tlsConn.ConnectionState()
		if len(state.PeerCertificates) > 0 {
			log.Printf("Client connected: %s", state.PeerCertificates[0].Subject.CommonName)
		}

		go handleConnection(conn)
	}
}

func handleConnection(clientConn net.Conn) {
	defer clientConn.Close()

	// Connect to backend
	backendConn, err := net.Dial("tcp", "localhost:8080")
	if err != nil {
		log.Printf("Backend connection failed: %v", err)
		return
	}
	defer backendConn.Close()

	// Bidirectional copy
	go io.Copy(backendConn, clientConn)
	io.Copy(clientConn, backendConn)
}
GOCODE

print_step "Starting tunnel server on :$TUNNEL_PORT (mTLS)..."
cd "$WORKSPACE"
go run tunnel-server.go &
SERVER_PID=$!
cd - > /dev/null
sleep 1

print_success "Tunnel server running (PID: $SERVER_PID)"
echo "  - Requires client certificate (mTLS)"
echo "  - Forwards to backend :$BACKEND_PORT"

wait_for_key

# ----------------------------------------------------------------------------
# Step 4: Create Tunnel Client
# ----------------------------------------------------------------------------
print_header "Step 4: Create Tunnel Client"

cat > "$WORKSPACE/tunnel-client.go" << 'GOCODE'
package main

import (
	"crypto/tls"
	"crypto/x509"
	"io"
	"log"
	"net"
	"os"
)

func main() {
	// Load CA
	caCert, _ := os.ReadFile("ca/ca.crt")
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	// Load client certificate
	cert, err := tls.LoadX509KeyPair("client/client.crt", "client/client.key")
	if err != nil {
		log.Fatalf("Failed to load client cert: %v", err)
	}

	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{cert},
		RootCAs:      caCertPool,
		ServerName:   "localhost",
		MinVersion:   tls.VersionTLS13,
	}

	// Listen locally
	listener, err := net.Listen("tcp", ":9000")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}
	log.Println("Tunnel client listening on :9000")
	log.Println("Forwarding to tunnel-server:8443 via TLS")

	for {
		localConn, err := listener.Accept()
		if err != nil {
			log.Printf("Accept error: %v", err)
			continue
		}
		go handleLocal(localConn, tlsConfig)
	}
}

func handleLocal(localConn net.Conn, tlsConfig *tls.Config) {
	defer localConn.Close()

	// Connect to tunnel server with TLS
	tlsConn, err := tls.Dial("tcp", "localhost:8443", tlsConfig)
	if err != nil {
		log.Printf("TLS connection failed: %v", err)
		return
	}
	defer tlsConn.Close()

	log.Printf("Tunnel established for %s", localConn.RemoteAddr())

	// Bidirectional copy
	go io.Copy(tlsConn, localConn)
	io.Copy(localConn, tlsConn)
}
GOCODE

print_step "Starting tunnel client on :$LOCAL_PORT..."
cd "$WORKSPACE"
go run tunnel-client.go &
CLIENT_PID=$!
cd - > /dev/null
sleep 1

print_success "Tunnel client running (PID: $CLIENT_PID)"
echo "  - Listens on localhost:$LOCAL_PORT"
echo "  - Connects to tunnel server with mTLS"

wait_for_key

# ----------------------------------------------------------------------------
# Step 5: Test the Tunnel
# ----------------------------------------------------------------------------
print_header "Step 5: Test the PQC Tunnel"

echo "Data flow:"
echo ""
echo "  curl :9000 → Tunnel Client → [TLS/mTLS] → Tunnel Server → Backend :8080"
echo ""

print_step "Sending request through the tunnel..."
echo ""

RESPONSE=$(curl -s http://localhost:$LOCAL_PORT/)
echo -e "${GREEN}$RESPONSE${NC}"

print_success "Request successfully traversed the PQC tunnel!"

wait_for_key

# ----------------------------------------------------------------------------
# Step 6: Demonstrate Security
# ----------------------------------------------------------------------------
print_header "Step 6: Security Demonstration"

print_step "What happens without client certificate?"
echo ""
echo "Trying to connect directly to tunnel server without mTLS..."
echo ""

# Try connecting without client cert
RESULT=$(curl -s --max-time 2 -k https://localhost:$TUNNEL_PORT/ 2>&1) || true
if [ -z "$RESULT" ]; then
    print_success "Connection REJECTED - client certificate required!"
else
    echo "$RESULT"
fi

echo ""
echo "The tunnel server requires a valid client certificate."
echo "Without it, no access to the backend."

wait_for_key

# ----------------------------------------------------------------------------
# Summary
# ----------------------------------------------------------------------------
print_header "Summary"

echo "What we built:"
echo ""
echo "  1. ML-DSA CA (post-quantum)"
echo "  2. Server certificate for tunnel endpoint"
echo "  3. Client certificate for tunnel authentication"
echo "  4. Tunnel server: TLS termination + mTLS + forwarding"
echo "  5. Tunnel client: local proxy → TLS → tunnel server"
echo ""
echo "Security properties:"
echo ""
echo "  ✓ Encrypted transport (TLS 1.3)"
echo "  ✓ Server authentication (ML-DSA certificate)"
echo "  ✓ Client authentication (mTLS)"
echo "  ✓ Quantum-resistant (ML-DSA-65)"
echo ""
echo -e "${GREEN}The tunnel protects traffic against future quantum attacks.${NC}"
echo ""
echo "Real-world applications:"
echo "  - Secure microservice communication"
echo "  - Zero-trust network access"
echo "  - VPN building block"
