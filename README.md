# Post-Quantum PKI Lab

> **"The PKI is the tool for transition — post-quantum is an engineering problem, not magic."**

Educational demonstrations for transitioning to Post-Quantum Cryptography using a real PKI implementation.

---

## Why This Matters

Quantum computers will eventually break RSA and ECC cryptography. The question isn't *if*, but *when*. Organizations need to prepare now — not panic, but plan.

This lab demonstrates:
- **Classical and post-quantum PKI work the same way**
- **Hybrid certificates provide a safe migration path**
- **The PKI model is algorithm-agnostic**

---

## The Threat: Store Now, Decrypt Later

Adversaries **capture your encrypted traffic today** to decrypt it when they have a quantum computer. This is **"Store Now, Decrypt Later"** (SNDL).

```
TODAY                                 IN 10-15 YEARS
─────                                 ──────────────
    Adversary                             Adversary
        │                                     │
        │  Captures encrypted traffic         │  Decrypts everything
        ▼                                     ▼
   [████████████]  ──────────────────►   [Plaintext data]
    Your TLS traffic                      Passwords, secrets,
    (RSA/ECDSA)                           intellectual property
```

**If your data must remain confidential for 10+ years, you must act now.**

---

## Use Cases

### 📚 PKI Fundamentals
| Use Case | Description |
|----------|-------------|
| [**PKI Hierarchy**](reference/usecases/pki/03-full-pqc-chain/) | Build Root CA → Issuing CA → End-entity certificates |
| [**Hybrid Certificates**](reference/usecases/pki/04-hybrid-catalyst/) | Dual-key certs (ECDSA + ML-DSA) for backward compatibility |

### 🔧 Applications
| Use Case | Description |
|----------|-------------|
| [**mTLS Authentication**](reference/usecases/applications/03-mtls-authentication/) | Mutual client/server authentication with PQC |
| [**Code Signing**](reference/usecases/applications/01-pqc-code-signing/) | Sign firmware and releases with ML-DSA |
| [**Timestamping**](reference/usecases/applications/02-pqc-timestamping/) | Cryptographic proof of existence at a point in time |

### ⚙️ Ops & Lifecycle
| Use Case | Description |
|----------|-------------|
| [**Revocation (CRL)**](reference/usecases/pki/05-revocation-crl/) | Revoke compromised certificates |
| [**OCSP Responder**](reference/usecases/applications/04-ocsp-responder/) | Real-time certificate status verification |
| [**Crypto-Agility**](reference/usecases/applications/05-crypto-agility/) | Migrate from classic → hybrid → full PQC |

### 🎯 Advanced
| Use Case | Description |
|----------|-------------|
| [**LTV Signatures**](reference/usecases/applications/07-ltv-document-signing/) | Long-term validation for 30+ year archives |
| [**TLS Tunnel**](reference/usecases/applications/06-tls-tunnel/) | ML-KEM key exchange for secure tunnels |
| [**CMS Encryption**](journey/04-advanced/03-cms-encryption/) | Encrypt documents with hybrid ML-KEM |

---

## Quick Start

```bash
# 1. Clone and install
git clone https://github.com/remiblancher/post-quantum-pki-lab.git
cd post-quantum-pki-lab
./tooling/install.sh

# 2. Launch menu
./start.sh

# 3. Or directly the Quick Start (10 min)
./quickstart/demo.sh
```

---

## Learning Path

**Total time: ~2h** | **Minimum path: 18 min** (Quick Start + Revelation)

### 🚀 Getting Started

| # | Mission | Time | Run |
|---|---------|------|-----|
| 0 | **Quick Start** — My first PKI (ECDSA) | 10 min | [`./quickstart/demo.sh`](quickstart/demo.sh) |
| 1 | **The Revelation** — Why change? (Mosca inequality) | 8 min | [`./journey/00-revelation/demo.sh`](journey/00-revelation/demo.sh) |

### 📚 Level 1: PQC Basics

| # | Mission | Time | Run |
|---|---------|------|-----|
| 2 | **Full PQC Chain** — 100% ML-DSA hierarchy | 10 min | [`./journey/01-pqc-basics/01-full-chain/demo.sh`](journey/01-pqc-basics/01-full-chain/demo.sh) |
| 3 | **Hybrid Catalyst** — Dual-key ECDSA + ML-DSA | 10 min | [`./journey/01-pqc-basics/02-hybrid/demo.sh`](journey/01-pqc-basics/02-hybrid/demo.sh) |

### 🔧 Level 2: Applications

| # | Mission | Time | Run |
|---|---------|------|-----|
| 4 | **mTLS** — Mutual client/server authentication | 8 min | [`./journey/02-applications/01-mtls/demo.sh`](journey/02-applications/01-mtls/demo.sh) |
| 5 | **Code Signing** — Sign your releases | 8 min | [`./journey/02-applications/02-code-signing/demo.sh`](journey/02-applications/02-code-signing/demo.sh) |
| 6 | **Timestamping** — Cryptographic timestamping | 8 min | [`./journey/02-applications/03-timestamping/demo.sh`](journey/02-applications/03-timestamping/demo.sh) |

### ⚙️ Level 3: Ops & Lifecycle

| # | Mission | Time | Run |
|---|---------|------|-----|
| 7 | **Revocation** — Revoke a certificate, generate CRL | 10 min | [`./journey/03-ops-lifecycle/01-revocation/demo.sh`](journey/03-ops-lifecycle/01-revocation/demo.sh) |
| 8 | **OCSP** — Real-time status verification | 10 min | [`./journey/03-ops-lifecycle/02-ocsp/demo.sh`](journey/03-ops-lifecycle/02-ocsp/demo.sh) |
| 9 | **Crypto-Agility** — Migrate without breaking | 10 min | [`./journey/03-ops-lifecycle/03-crypto-agility/demo.sh`](journey/03-ops-lifecycle/03-crypto-agility/demo.sh) |

### 🎯 Level 4: Advanced

| # | Mission | Time | Run |
|---|---------|------|-----|
| 10 | **LTV Signatures** — Valid in 30 years | 8 min | [`./journey/04-advanced/01-ltv-signatures/demo.sh`](journey/04-advanced/01-ltv-signatures/demo.sh) |
| 11 | **PQC Tunnel** — ML-KEM key exchange | 8 min | [`./journey/04-advanced/02-pqc-tunnel/demo.sh`](journey/04-advanced/02-pqc-tunnel/demo.sh) |
| 12 | **CMS Encryption** — Encrypt documents | 8 min | [`./journey/04-advanced/03-cms-encryption/demo.sh`](journey/04-advanced/03-cms-encryption/demo.sh) |

### 🚀 Next Steps

You've managed 12 certificates. In production, you have 10,000. → [QentriQ](https://qentriq.com)

---

## Glossary

### Algorithms

| Term | Meaning | Usage |
|------|---------|-------|
| **ML-DSA** | Module Lattice Digital Signature Algorithm (FIPS 204) | Post-quantum signatures |
| **ML-KEM** | Module Lattice Key Encapsulation Mechanism (FIPS 203) | Post-quantum key exchange |
| **SLH-DSA** | Stateless Hash-Based Digital Signature Algorithm | Signatures (alternative) |
| **Hybrid** | Certificate with 2 keys (classic + PQC) | Smooth transition |
| **Catalyst** | ITU-T X.509 Section 9.8 standard for hybrid | Hybrid certificate format |

### Concepts

| Term | Meaning |
|------|---------|
| **PQC** | Post-Quantum Cryptography — resists quantum computers |
| **SNDL** | Store Now, Decrypt Later — capture now, decrypt later |
| **Mosca** | Inequality to calculate migration urgency |
| **LTV** | Long-Term Validation — signatures valid 30+ years |
| **mTLS** | Mutual TLS — bidirectional authentication |
| **CRL** | Certificate Revocation List — list of revoked certificates |
| **OCSP** | Online Certificate Status Protocol — real-time verification |

### Mosca's Inequality

```
If X + Y > Z  →  You must act NOW

X = Years until a quantum computer is available (10-15 years)
Y = Time to migrate your systems (typically 2-5 years)
Z = Required confidentiality duration of your data

Example:
  - X = 12 years (quantum computer in 2037)
  - Y = 3 years (your infra migration)
  - Z = 20 years (medical data)

  X + Y = 15 years < Z = 20 years  →  YOU'RE ALREADY LATE!
```

---

## Project Structure

```
post-quantum-pki-lab/
├── start.sh                    # Main menu
├── quickstart/                 # Quick Start (10 min)
│   ├── demo.sh
│   └── README.md
├── journey/                    # Guided journey
│   ├── 00-revelation/          # "Store Now, Decrypt Later"
│   ├── 01-pqc-basics/          # "Build Your Foundation" + "Best of Both"
│   ├── 02-applications/        # mTLS, Code Signing, Timestamping
│   ├── 03-ops-lifecycle/       # Revocation, OCSP, Crypto-Agility
│   └── 04-advanced/            # LTV, PQC Tunnel, CMS
├── workspace/                  # Your artifacts (persistent)
│   ├── quickstart/             # Classic CA
│   ├── niveau-1/               # PQC CA + Hybrid CA
│   ├── niveau-2/               # Signatures, timestamps
│   ├── niveau-3/               # CRL, OCSP
│   └── niveau-4/               # LTV, tunnels
├── reference/usecases/         # Reference documentation
├── lib/                        # Shell helpers
└── bin/pki                     # PKI tool (Go)
```

---

## Supported Algorithms

### Classic
- ECDSA P-256, P-384, P-521
- RSA 2048, 4096
- Ed25519

### Post-Quantum (NIST FIPS 2024)
- **ML-DSA-44, ML-DSA-65, ML-DSA-87** — Signatures
- **ML-KEM-512, ML-KEM-768, ML-KEM-1024** — Key encapsulation
- **SLH-DSA** — Hash-based signatures

### Hybrid (Catalyst ITU-T X.509 9.8)
- ECDSA P-384 + ML-DSA-65
- X25519 + ML-KEM-768

---

## Prerequisites

- **Go 1.21+** (to compile the PKI tool)
- **OpenSSL 3.x** (for verifications)
- **Bash 4+**

---

## Interactive Mode

This lab uses an interactive mode where you type the important commands:

```bash
┌─────────────────────────────────────────────────────────────────┐
│  MISSION 1: Create your CA                                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  A CA (Certificate Authority) is the trust anchor.             │
│  It signs all your certificates.                                │
│                                                                 │
│  >>> Type this command:                                         │
│                                                                 │
│      pki init-ca --name "My CA" --algorithm ml-dsa-65          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

$ pki init-ca --name "My CA" --algorithm ml-dsa-65
✓ CA created: ca.crt (ML-DSA-65)
```

Complex commands are executed automatically with explanation.

---

## Persistent Workspace

Each level has its own workspace. Your CAs and certificates are preserved between sessions:

```bash
# View workspace status
./start.sh  # then option "s"

# Reset a level
./start.sh  # then option "r"
```

---

## Useful Links

- [NIST Post-Quantum Cryptography](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [FIPS 203 (ML-KEM)](https://csrc.nist.gov/pubs/fips/203/final)
- [FIPS 204 (ML-DSA)](https://csrc.nist.gov/pubs/fips/204/final)
- [ITU-T X.509 (Hybrid Certificates)](https://www.itu.int/rec/T-REC-X.509)

---

Created by [QentriQ](https://qentriq.com) — Apache 2.0 License
