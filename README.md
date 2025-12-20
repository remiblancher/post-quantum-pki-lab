# Post-Quantum PKI Lab

> **"The PKI is the tool for transition — post-quantum is an engineering problem, not magic."**

Educational demonstrations for transitioning to Post-Quantum Cryptography using a real PKI implementation.

## Why This Matters

Quantum computers will eventually break RSA and ECC cryptography. The question isn't *if*, but *when*. Organizations need to prepare now — not panic, but plan.

**This lab demonstrates:**
- Classical and post-quantum PKI work the same way
- Hybrid certificates provide a safe migration path
- The PKI model is algorithm-agnostic

## Use Cases

### Section 1: PKI Fundamentals (~33 min)

Learn the core concepts of Post-Quantum PKI.

| # | Title | What You'll See | Duration |
|---|-------|-----------------|----------|
| PKI-01 | ["Store Now, Decrypt Later"](usecases/pki/01-store-now-decrypt-later/) | Mosca calculator: X + Y > Z | 5 min |
| PKI-02 | ["Classic vs PQC: Nothing Changes"](usecases/pki/02-nothing-changes/) | Side-by-side: ECDSA vs ML-DSA | 5 min |
| PKI-03 | ["Full PQC Chain of Trust"](usecases/pki/03-chain-of-trust/) | `openssl verify OK` on full chain | 10 min |
| PKI-04 | ["Hybrid PQC: Best of Both Worlds"](usecases/pki/04-best-of-both-worlds/) | 2 public keys in 1 certificate | 8 min |
| PKI-05 | ["Oops, We Need to Revoke!"](usecases/pki/05-oops-revoke/) | Status: good → revoked | 5 min |

### Section 2: Applications (~54 min)

See PQC in action with real-world applications.

| # | Title | What You'll See | Duration |
|---|-------|-----------------|----------|
| APP-01 | ["PQC Signing: Sign It, Prove It"](usecases/applications/01-sign-it-prove-it/) | Valid ✓ → Tampered ✗ | 8 min |
| APP-02 | ["PQC Timestamping: Trust Now, Verify Forever"](usecases/applications/02-trust-now-verify-forever/) | RFC 3161 timestamp proof | 8 min |
| APP-03 | ["PQC mTLS: Show Me Your Badge"](usecases/applications/03-show-me-your-badge/) | "Welcome Alice!" via mTLS | 10 min |
| APP-04 | ["PQC OCSP: Is This Cert Still Good?"](usecases/applications/04-is-this-cert-still-good/) | OCSP: good → revoked | 8 min |
| APP-05 | ["Crypto-Agility: Rotate Without Breaking"](usecases/applications/05-rotate-without-breaking/) | Synchronized cert rotation | 10 min |
| APP-06 | ["Build a PQC Tunnel"](usecases/applications/06-build-a-pqc-tunnel/) | Encrypted tunnel traffic | 10 min |

## Quick Start

```bash
# Install the PKI tool
./tooling/install.sh

# Run your first demo
cd usecases/pki/01-store-now-decrypt-later
./demo.sh
```

## Learning Paths

```
              START HERE
                  │
                  ▼
    ┌─────────────────────────────┐
    │  PKI Fundamentals (5 UC)    │  ~33 min
    │  Understand the concepts    │
    └─────────────┬───────────────┘
                  │
                  ▼
    ┌─────────────────────────────┐
    │  Applications (6 UC)        │  ~54 min
    │  See it in action           │
    └─────────────────────────────┘
```

### By Role

| Role | Recommended Path |
|------|------------------|
| **Developer** | PKI-01, PKI-02 → APP-01, APP-03 |
| **Security Architect** | All PKI → APP-04, APP-05 |
| **CISO/Executive** | PKI-01, PKI-04 → APP-02 |
| **Operations** | PKI-05 → APP-04, APP-05, APP-06 |

## Supported Algorithms

### Classical (Production)
- ECDSA P-256, P-384, P-521
- RSA 2048, 4096
- Ed25519

### Post-Quantum (Experimental)
- **ML-DSA** (FIPS 204) — Lattice-based signatures
- **SLH-DSA** (FIPS 205) — Hash-based signatures
- **ML-KEM** (FIPS 203) — Key encapsulation

### Hybrid
- Catalyst certificates (ITU-T X.509 9.8)
- Composite certificates

## Requirements

- Go 1.21+ (for building the PKI tool)
- OpenSSL 3.x (for verification demos)
- Docker (optional, for isolated environments)

## Project Structure

```
post-quantum-pki-lab/
├── usecases/
│   ├── pki/                # PKI fundamentals (5 UC)
│   ├── applications/       # Real-world applications (6 UC)
│   └── _archive/           # Previous UC versions
├── tooling/                # Installation scripts
├── lib/                    # Shared shell functions
├── docker/                 # Container environments
└── assets/                 # Diagrams and branding
```

## About

This project is part of the **Quantum-Safe PKI** initiative by **QentriQ**.

**Need help with your PQC transition?** [Contact us](https://qentriq.com)

## License

Apache License 2.0 — See [LICENSE](LICENSE)
