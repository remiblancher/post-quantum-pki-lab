# Level 1: PQC Basics

## Why this section?

You created a classical PKI in the Quick Start. You understood the SNDL threat.

Now you'll **transform your PKI to post-quantum**.

---

## What you'll learn

### ML-DSA: The post-quantum signature algorithm

ML-DSA (Module Lattice Digital Signature Algorithm) replaces RSA and ECDSA.

```
┌─────────────────────────────────────────────────────────────────┐
│  ECDSA (classical)              ML-DSA (post-quantum)           │
│  ─────────────────              ─────────────────────           │
│                                                                 │
│  Public key: 64 bytes           Public key: 1952 bytes          │
│  Signature: 64 bytes            Signature: 3293 bytes           │
│  Security: 128 bits             Security: 192 bits (level 3)    │
│                                                                 │
│  Vulnerable to quantum          Resistant to quantum            │
└─────────────────────────────────────────────────────────────────┘
```

**Signatures are larger, but the PKI works exactly the same.**

### CA Hierarchy

A professional PKI has a hierarchy:

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                    ROOT CA (ML-DSA-87)                          │
│                    ══════════════════                           │
│                    Maximum security level                       │
│                    Key kept offline                             │
│                           │                                     │
│                           ▼                                     │
│                    ISSUING CA (ML-DSA-65)                       │
│                    ═════════════════════                        │
│                    Signs certificates                           │
│                    Key accessible (protected)                   │
│                           │                                     │
│              ┌────────────┼────────────┐                        │
│              ▼            ▼            ▼                        │
│          [Server]    [Client]    [Code Signing]                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Hybrid: Best of both worlds

During transition, you can have BOTH algorithms in one certificate:

```
┌─────────────────────────────────────────────────────────────────┐
│  HYBRID CERTIFICATE (Catalyst)                                  │
│  ════════════════════════════                                   │
│                                                                 │
│  Primary key: ECDSA P-384 (classical)                           │
│  PQC extension: ML-DSA-65 (post-quantum)                        │
│                                                                 │
│  → Legacy clients use ECDSA                                     │
│  → Modern clients use ML-DSA                                    │
│  → If one algo is broken, the other protects                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

- Quick Start completed (you have a working classical CA)
- Revelation completed (you understand why to migrate)

---

## Missions

### Mission 1: "Build Your Quantum-Safe Foundation"

Create a 100% post-quantum PKI chain.

**The problem**: Your classical CA will be breakable by a quantum computer.

**The solution**: Create a new hierarchy with ML-DSA.

```bash
./01-full-chain/demo.sh
```

### Mission 2: "Best of Both Worlds"

Create hybrid certificates compatible with legacy AND quantum-safe.

**The problem**: You can't migrate all your clients at once.

**The solution**: Hybrid certificates work with both worlds.

```bash
./02-hybrid/demo.sh
```

---

## What you'll have at the end

```
workspace/niveau-1/
├── pqc-root-ca/           # Root CA ML-DSA-87
│   ├── ca.crt
│   └── ca.key
├── pqc-issuing-ca/        # Issuing CA ML-DSA-65
│   ├── ca.crt
│   └── ca.key
├── hybrid-ca/             # Hybrid CA ECDSA + ML-DSA
│   ├── ca.crt
│   └── ca.key
└── *.crt                  # Issued certificates
```

---

## Next step

→ **Level 2: Applications**

You'll use your PQC PKI for real use cases: mTLS, code signing, timestamping.
