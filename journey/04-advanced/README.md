# Level 4: Advanced (Optional)

> These missions are optional and exploratory. You can stop at Level 3 without losing the main thread.

## Why this section?

You've mastered PQC PKI basics. Here are **advanced** use cases:
- Signatures valid 30+ years (legal archiving)
- Post-quantum key exchange (ML-KEM)
- Document encryption (CMS)

---

## What you'll learn

### LTV: Long-Term Validation

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  PROBLEM: Classical signature                                   │
│                                                                 │
│  2024          2025          2030          2050                 │
│    │             │             │             │                  │
│    ▼             ▼             ▼             ▼                  │
│  Signature    Cert expires  OCSP down    Verification?          │
│  created                                                        │
│                                                                 │
│  Without LTV, impossible to verify after expiration.            │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SOLUTION: LTV (Long-Term Validation)                           │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  Signed document                                         │    │
│  │  + Signature                                             │    │
│  │  + TSA Timestamp                                         │    │
│  │  + OCSP Response                                         │    │
│  │  + Complete certificate chain                            │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Everything embedded = OFFLINE verification in 2050.            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### ML-KEM: Post-quantum key exchange

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ML-DSA vs ML-KEM                                               │
│  ────────────────                                               │
│                                                                 │
│  ML-DSA                            ML-KEM                       │
│  ──────                            ──────                       │
│  Signature                         Key encapsulation            │
│  AUTHENTICATION                    CONFIDENTIALITY              │
│                                                                 │
│  "This message really              "This message is             │
│   comes from Alice"                 readable ONLY                │
│                                     by Bob"                     │
│                                                                 │
│  ┌───────┐                         ┌───────┐                    │
│  │ Sign  │                         │Encaps │                    │
│  │  ───► │                         │  ───► │ Ciphertext         │
│  │  ◄─── │                         │  ◄─── │ Shared key         │
│  │Verify │                         │Decaps │                    │
│  └───────┘                         └───────┘                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### CMS: Document encryption

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  CMS (Cryptographic Message Syntax)                             │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                                                          │    │
│  │  Original document                                       │    │
│  │       │                                                  │    │
│  │       ▼                                                  │    │
│  │  ┌──────────────┐                                        │    │
│  │  │ AES-256 key  │ ◄── Randomly generated                 │    │
│  │  └──────────────┘                                        │    │
│  │       │                                                  │    │
│  │       ├──────────────────┐                               │    │
│  │       ▼                  ▼                               │    │
│  │  Encrypted document  Key encapsulated                    │    │
│  │  (AES-256-GCM)       with ML-KEM                         │    │
│  │                      (recipient)                         │    │
│  │                                                          │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Standard S/MIME compatible format.                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Algorithms used

| Mission | Signature | Encryption |
|---------|-----------|------------|
| LTV Signatures | ECDSA + ML-DSA (hybrid) | - |
| PQC Tunnel | ML-DSA-65 | X25519 + ML-KEM-768 |
| CMS Encryption | ML-DSA-65 | ML-KEM-768 |

---

## Prerequisites

- Level 3 completed (revocation, OCSP, crypto-agility)
- Advanced concepts: timestamp, OCSP, hybrid

---

## Missions

### Mission 9: "Sign Today, Verify in 30 Years" (LTV)

Create signatures valid for legal archiving.

**The problem**: How do you verify in 2055 a signature from 2024?

```bash
./01-ltv-signatures/demo.sh
```

### Mission 10: "Secure the Tunnel" (ML-KEM)

Understand post-quantum key exchange. This is a **demonstration** of ML-KEM key encapsulation, not a production VPN.

**The problem**: How do you establish a quantum-safe shared secret?

```bash
./02-pqc-tunnel/demo.sh
```

### Mission 11: "Encrypt for Their Eyes Only" (CMS)

Encrypt documents with ML-KEM.

**The problem**: How do you send a document readable only by Bob?

```bash
./03-cms-encryption/demo.sh
```

---

## What you'll have at the end

```
workspace/niveau-4/
├── ltv/
│   ├── document-signed.pdf   # Document with LTV
│   ├── ltv-data.der          # Embedded LTV data
│   └── verify-2055.log       # Verification proof
├── pqc-tunnel/
│   ├── kem.crt               # ML-KEM certificate
│   ├── encapsulated.bin      # Encapsulated key
│   └── shared-secret.hex     # Shared secret
└── cms-encryption/
    ├── encrypt.crt           # Encryption certificate
    ├── secret.txt.p7m        # Encrypted document
    └── decrypted.txt         # Decrypted document
```

---

## Next step

→ **Next Steps: Organize migration**

You've mastered PQC PKI. Now, how do you migrate 10,000 certificates?
