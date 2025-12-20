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
| PKI-01 | ["Store Now, Decrypt Later"](usecases/pki/01-store-now-decrypt-later/) | Your urgency score: "Act now!" | 5 min |
| PKI-02 | ["Classic vs PQC: Nothing Changes"](usecases/pki/02-classic-vs-pqc/) | Size & time comparison table | 5 min |
| PKI-03 | ["Full PQC Chain of Trust"](usecases/pki/03-full-pqc-chain/) | Root → Issuing → End ✓ | 10 min |
| PKI-04 | ["Hybrid PQC: Best of Both Worlds"](usecases/pki/04-hybrid-catalyst/) | ECDSA + ML-DSA in 1 cert | 8 min |
| PKI-05 | ["Oops, We Need to Revoke!"](usecases/pki/05-revocation-crl/) | Status: good → revoked | 5 min |

### Section 2: Applications (~64 min)

See PQC in action with real-world applications.

| # | Title | What You'll See | Duration |
|---|-------|-----------------|----------|
| APP-01 | ["PQC Code Signing: Secure Your Releases"](usecases/applications/01-pqc-code-signing/) | Firmware: signed ✓ tampered ✗ | 8 min |
| APP-02 | ["PQC Timestamping: Trust Now, Verify Forever"](usecases/applications/02-pqc-timestamping/) | Certified timestamp on file | 8 min |
| APP-03 | ["PQC mTLS: Show Me Your Badge"](usecases/applications/03-mtls-authentication/) | "Welcome Alice!" via mTLS | 10 min |
| APP-04 | ["PQC OCSP: Is This Cert Still Good?"](usecases/applications/04-ocsp-responder/) | Real-time cert status check | 8 min |
| APP-05 | ["Crypto-Agility: Rotate Without Breaking"](usecases/applications/05-crypto-agility/) | Synchronized cert rotation | 10 min |
| APP-06 | ["Build a PQC Tunnel"](usecases/applications/06-tls-tunnel/) | Data through PQC tunnel | 10 min |
| APP-07 | ["LTV: Sign Today, Verify in 30 Years"](usecases/applications/07-ltv-document-signing/) | Proof file valid in 2055 | 10 min |

### Section 3: Ops & Migration (~26 min) — *Optional*

Bridge between demos and production migration.

| # | Title | What You'll See | Duration |
|---|-------|-----------------|----------|
| OPS-01 | ["Inventory Before You Migrate"](usecases/ops/01-inventory-scan/) | "Found: 3 ECDSA, 0 PQC" | 8 min |
| OPS-02 | ["Policy, Not Refactor"](usecases/ops/02-policy-profiles/) | Same workflow, different algo | 8 min |
| OPS-03 | ["Incident Drill"](usecases/ops/03-incident-response/) | Revoke → Re-issue → Verify | 10 min |

## Quick Start

```bash
# 1. Clone the repositories
git clone https://github.com/remiblancher/post-quantum-pki-lab.git
git clone https://github.com/remiblancher/pki.git
cd post-quantum-pki-lab

# 2. Build the PKI tool
./tooling/install.sh

# 3. Run your first demo
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
    │  Applications (7 UC)        │  ~62 min
    │  See it in action           │
    └─────────────┬───────────────┘
                  │
                  ▼
    ┌─────────────────────────────┐
    │  Ops & Migration (3 UC)     │  ~26 min
    │  Plan your transition       │  (optional)
    └─────────────────────────────┘
```

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
- **Catalyst certificates** (ITU-T X.509 9.8)
- Composite certificates (IETF draft-lamps-pq-composite-*) — *not yet supported*

## Profiles

Profiles are certificate templates that define **algorithm + validity + X.509 extensions**. Instead of specifying each parameter manually, you choose a profile that matches your use case.

### Naming Convention

```
<algorithm-family>/<certificate-type>
```

### Available Profiles

| Profile | Algorithm | Validity | Use Case |
|---------|-----------|----------|----------|
| `ec/root-ca` | ECDSA P-384 | 20 years | Classical Root CA |
| `ec/issuing-ca` | ECDSA P-256 | 10 years | Classical Issuing CA |
| `ec/tls-server` | ECDSA P-256 | 1 year | Classical TLS server |
| `ml-dsa-kem/root-ca` | ML-DSA-65 | 20 years | Post-quantum Root CA |
| `ml-dsa-kem/issuing-ca` | ML-DSA-65 | 10 years | Post-quantum Issuing CA |
| `ml-dsa-kem/tls-server` | ML-DSA-65 + ML-KEM-768 | 1 year | Post-quantum TLS server |
| `hybrid/catalyst/root-ca` | ECDSA + ML-DSA | 20 years | Hybrid Root CA |

### Example Usage

```bash
# Create a classical CA
pki init-ca --profile ec/root-ca --name "My Root CA" --dir ./ca

# Create a post-quantum CA
pki init-ca --profile ml-dsa-kem/root-ca --name "PQ Root CA" --dir ./pqc-ca

# Issue a TLS certificate
pki issue --ca-dir ./ca --profile ec/tls-server --cn example.com --out cert.crt
```

> **Tip:** Profiles include default subject DN fields (Country, Organization). You only need to specify `--name` for the Common Name.

## Requirements

- Go 1.21+ (for building the PKI tool)
- OpenSSL 3.x (for verification demos)
- Docker (optional, for isolated environments)

## Project Structure

```
post-quantum-pki-lab/
├── usecases/
│   ├── pki/                # PKI fundamentals (5 UC)
│   ├── applications/       # Real-world applications (7 UC)
│   ├── ops/                # Ops & Migration (3 UC)
│   └── _archive/           # Previous UC versions
├── workspace/              # Demo artifacts (generated, gitignored)
│   ├── pki-01/             # Artifacts from PKI-01
│   ├── pki-02/             # Artifacts from PKI-02
│   └── ...
├── tooling/                # Installation scripts
├── lib/                    # Shared shell functions
├── docker/                 # Container environments
└── assets/                 # Diagrams and branding
```

> **Note:** After running a demo, explore the generated certificates and keys in `workspace/`. Each use case has its own subfolder that persists until you run the demo again.

---

## About

Built by [QentriQ](https://qentriq.com)

## License

Apache License 2.0 — See [LICENSE](LICENSE)
