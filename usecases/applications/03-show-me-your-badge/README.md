# APP-03: "Show Me Your Badge"

## Mutual TLS Authentication with Post-Quantum Certificates

> **Key Message:** mTLS (mutual TLS) authenticates both client and server. With PQC certificates, this authentication is quantum-resistant.

> **Visual diagrams:** See [`diagram.txt`](diagram.txt) for ASCII diagrams of the mTLS handshake.

## The Scenario

*"We need to authenticate clients connecting to our API. How does mTLS work with post-quantum certificates?"*

In mutual TLS, both sides present certificates:
- **Server** proves its identity to the client
- **Client** proves its identity to the server

This is how zero-trust architectures work. With PQC certificates, these proofs remain valid even against quantum attackers.

## What You'll See

| Step | What Happens | What You See |
|------|--------------|--------------|
| 1. Alice connects | Valid client cert | "Welcome Alice!" |
| 2. Bob connects | Valid client cert | "Welcome Bob!" |
| 3. Mallory connects | No/invalid cert | "403 Forbidden" |

## Personas

- **Alice** - Employee with valid client certificate
- **Bob** - Admin with valid client certificate
- **Mallory** - Attacker without valid certificate

## Prerequisites

- `pki` tool installed
- Go 1.21+ (for the HTTPS server)

## Quick Start

```bash
./demo.sh
```

## What This Demo Creates

```
workspace/
├── ca/                    # ML-DSA CA
├── server/               # Server certificate
├── clients/
│   ├── alice/           # Alice's client cert
│   └── bob/             # Bob's client cert
└── server.go            # mTLS HTTPS server
```

## The mTLS Handshake

```
┌──────────────┐                          ┌──────────────┐
│   Client     │                          │   Server     │
│   (Alice)    │                          │   (API)      │
└──────┬───────┘                          └──────┬───────┘
       │                                         │
       │──── ClientHello ───────────────────────>│
       │                                         │
       │<─── ServerHello + ServerCertificate ────│
       │<─── CertificateRequest ─────────────────│  ← Server asks for client cert
       │                                         │
       │──── ClientCertificate ─────────────────>│  ← Client sends its cert
       │──── CertificateVerify ─────────────────>│  ← Client proves ownership
       │                                         │
       │<─── Finished ───────────────────────────│
       │                                         │
       │════ Encrypted Application Data ════════>│
       │     "GET /api/whoami"                   │
       │                                         │
       │<════ "Welcome Alice!" ══════════════════│
       │                                         │
```

## Learning Outcomes

After this demo, you'll understand:
- How mTLS authenticates both parties
- How to issue client certificates with PKI
- Why PQC makes authentication future-proof
- How to build zero-trust APIs

## Duration

~10 minutes

## Next Steps

- [APP-04: Is This Cert Still Good?](../04-is-this-cert-still-good/) - Add OCSP checking
- [APP-06: Build a PQC Tunnel](../06-build-a-pqc-tunnel/) - Secure tunneling
