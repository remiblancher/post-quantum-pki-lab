# QLAB

**Post-Quantum PKI Lab**

> **"The PKI is the tool for transition — post-quantum is an engineering problem, not magic."**

QLAB is an educational resource to help teams understand PKI and Post-Quantum Cryptography (PQC) migration through hands-on practice.

- **Lab exercises** — Learn PQC migration with real scenarios
- **Interactive demos** — Quantum-safe certificate operations
- **Step-by-step journeys** — From classical to post-quantum PKI

QLAB uses **[QPKI](https://github.com/remiblancher/post-quantum-pki)** for all PKI operations:
- Certificate Authority (CA) management
- Certificate generation and issuance
- Post-Quantum Cryptography (PQC) algorithms
- Hybrid certificates support

---

## Table of Contents

- [Why This Matters](#why-this-matters)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Learning Path](#learning-path)
- [Supported Algorithms](#supported-algorithms)
- [Useful Links](#useful-links)
- [License](#license)

---

## Why This Matters

Quantum computers will eventually break RSA and ECC cryptography.
The question isn't *if*, but *when* — and whether your data and signatures
will still need to be trusted **after that moment**.

This matters today because:

- **Store Now, Decrypt Later (SNDL):** Encrypted data captured now can be decrypted later
- **Trust Now, Forge Later (TNFL):** Software signatures must remain valid for 10–30 years
- **Long-term records:** Legal, medical, and industrial records outlive cryptographic algorithms

This lab demonstrates:
- **Classical and post-quantum PKI work the same way** — only the algorithm changes
- **Hybrid certificates provide a quantum-safe migration path** — protect legacy and future clients
- **The PKI model is algorithm-agnostic** — your workflow stays exactly the same

---

## Prerequisites

- **Go 1.25+** (for building QPKI from source)
- **OpenSSL 3.x** (for verification demos)
- **Docker** (optional, for isolated environments)

---

## Installation

```bash
git clone https://github.com/remiblancher/post-quantum-pki-lab.git
cd post-quantum-pki-lab
./tooling/install.sh
```

Then start with: `./journey/00-quickstart/demo.sh`

---

## Learning Path

**Total time: ~1h45** | **Minimum path: 20 min** (Quick Start + Revelation)

### 🚀 Getting Started

| # | Mission | Time | Key Message |
|---|---------|------|-------------|
| 0 | [**Quick Start**](journey/00-quickstart/) — Create your first CA | 10 min | Quantum breaks algorithms, not PKI workflows. Migration is configuration, not redesign. |
| 1 | [**The Revelation**](journey/01-revelation/) — Why PQC matters? | 10 min | Quantum attacks are passive and retroactive. Today's encrypted data is tomorrow's plaintext. |

### 📚 Core PKI

| # | Mission | Time | Key Message |
|---|---------|------|-------------|
| 2 | [**Full PQC Chain**](journey/02-full-chain/) — Root → Issuing → TLS (ML-DSA) | 10 min | One classical link breaks the entire chain. PQC must be end-to-end. |
| 3 | [**Hybrid Catalyst**](journey/03-hybrid/) — Dual-key certificate (ECDSA + ML-DSA) | 10 min | Hybrid bridges legacy and quantum-safe. Security fails only if both algorithms fail. |

### ⚙️ PKI Lifecycle

| # | Mission | Time | Key Message |
|---|---------|------|-------------|
| 4 | [**Revocation**](journey/04-revocation/) — CRL generation | 10 min | PQC keys get compromised too. Revocation works exactly the same. |
| 5 | [**PQC OCSP**](journey/05-ocsp/) — Is This Cert Still Good? | 10 min | OCSP reports trust in real-time. PQC doesn't change how revocation is checked. |

### 🔧 Applications

| # | Mission | Time | Key Message |
|---|---------|------|-------------|
| 6 | [**PQC Code Signing**](journey/06-code-signing/) — Signatures That Outlive the Threat | 10 min | Signatures must outlive algorithms. Quantum makes forgery undetectable. |
| 7 | [**PQC Timestamping**](journey/07-timestamping/) — Trust Now, Verify Forever | 10 min | Timestamps prove WHEN. Without PQC, that proof becomes forgeable. |
| 8 | [**PQC LTV**](journey/08-ltv-signatures/) — Sign Today, Verify in 30 Years | 10 min | LTV bundles all proofs for offline verification. Every element must be quantum-safe. |
| 9 | [**CMS Encryption**](journey/09-cms-encryption/) — Encrypt documents (ML-KEM) | 10 min | KEM keys can't sign. Attestation links encryption keys to identity. |

### 🧭 Architecture & Migration

| # | Mission | Time | Key Message |
|---|---------|------|-------------|
| 10 | [**Crypto-Agility**](journey/10-crypto-agility/) — Migrate ECDSA → ML-DSA | 15 min | Quantum timelines are uncertain. Crypto-agility means reversible migration. |

---

## Supported Algorithms

### Classical (Production)
- ECDSA P-256, P-384, P-521
- RSA 2048, 4096
- Ed25519

### Post-Quantum (NIST Standards 2024)
- **ML-DSA** (FIPS 204) — Lattice-based signatures
- **SLH-DSA** (FIPS 205) — Hash-based signatures
- **ML-KEM** (FIPS 203) — Key encapsulation

*Standards finalized in 2024, ecosystem still maturing.*

### Hybrid (Transition)
- Catalyst certificates (ITU-T X.509 9.8)
- Composite certificates *(supported, no lab demo)*

---

## Useful Links

- [QPKI - Post-Quantum PKI](https://github.com/remiblancher/post-quantum-pki) — The PKI toolkit used by QLAB
- [Glossary](docs/GLOSSARY.md) — PQC and PKI terminology
- [NIST Post-Quantum Cryptography](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [FIPS 203 (ML-KEM)](https://csrc.nist.gov/pubs/fips/203/final)
- [FIPS 204 (ML-DSA)](https://csrc.nist.gov/pubs/fips/204/final)
- [ITU-T X.509 (Hybrid Certificates)](https://www.itu.int/rec/T-REC-X.509)

---

## License

Apache License 2.0 — See [LICENSE](LICENSE)
