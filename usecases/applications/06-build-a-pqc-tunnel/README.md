# APP-06: "Build a PQC Tunnel"

## Secure TLS Tunnel with Post-Quantum Certificates

> **Key Message:** A TLS tunnel provides encrypted, authenticated transport. With PQC certificates, this tunnel is quantum-resistant.

> **Visual diagrams:** See [`diagram.txt`](diagram.txt) for ASCII diagrams of the tunnel architecture.

## The Scenario

*"We need to securely expose an internal service through an untrusted network. Can we build a quantum-resistant tunnel?"*

This demo creates a simple port-forwarding tunnel secured with mTLS and ML-DSA certificates. Think of it as a mini-stunnel or ssh -L, but with post-quantum cryptography.

## What You'll See

| Step | What Happens | What You See |
|------|--------------|--------------|
| 1. Start backend | Simple HTTP service on :8080 | "Backend running" |
| 2. Start tunnel server | TLS endpoint on :8443 | "Tunnel accepting connections" |
| 3. Start tunnel client | Local proxy on :9000 | "Tunnel client ready" |
| 4. Access via tunnel | curl localhost:9000 | Response from backend |

## Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   User      │      │   Tunnel    │      │   Tunnel    │      │   Backend   │
│   (curl)    │─────>│   Client    │══════│   Server    │─────>│   Service   │
│             │      │  :9000      │ mTLS │  :8443      │      │  :8080      │
└─────────────┘      └─────────────┘      └─────────────┘      └─────────────┘
                           │                    │
                      Plaintext            Encrypted
                       locally             over network
```

## Personas

- **Alice** - User accessing the service through the tunnel
- **Backend** - Internal HTTP service (not directly exposed)
- **Tunnel** - Secure bridge with ML-DSA authentication

## Prerequisites

- `pki` tool installed
- Go 1.21+

## Quick Start

```bash
./demo.sh
```

## Security Properties

| Property | How It's Achieved |
|----------|-------------------|
| Confidentiality | TLS 1.3 encryption |
| Server Authentication | Server ML-DSA certificate |
| Client Authentication | Client ML-DSA certificate (mTLS) |
| Quantum Resistance | ML-DSA-65 signatures |

## Learning Outcomes

After this demo, you'll understand:
- How TLS tunnels work
- How mTLS secures both ends
- Why PQC protects long-term
- Building blocks for VPNs

## Duration

~10 minutes

## Next Steps

- Explore OpenVPN + OQS for a full VPN solution
- Add OCSP stapling to the tunnel
- Implement certificate rotation
