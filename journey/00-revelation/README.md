# The Revelation: "Store Now, Decrypt Later"

## Why change algorithms?

You just created a classical PKI with ECDSA. It works. So why change?

Because **quantum computers will break everything**.

---

## The SNDL Threat

**Store Now, Decrypt Later** (SNDL): adversaries capture your encrypted traffic TODAY to decrypt it LATER.

```
TODAY                                    IN 10-15 YEARS
─────                                    ──────────────

   You                                       Adversary
    │                                           │
    │  TLS Connection                           │
    ▼  (RSA/ECDSA)                              │
┌────────┐          ┌────────┐                  │
│ Client │◄────────►│ Server │                  │
└────────┘          └────────┘                  │
    │                   │                       │
    │    Adversary      │                       ▼
    │        │          │              ┌──────────────────┐
    │        ▼          │              │ Quantum          │
    │   [Capture]       │              │ Computer         │
    │   [████████]      │              │                  │
    │   Stores the      │              │ Shor's           │
    │   traffic         │              │ Algorithm        │
    │                   │              │                  │
    │                   │              │ Breaks RSA/ECDSA │
    │                   │              │ in hours         │
    │                   │              └────────┬─────────┘
    │                   │                       │
    │                   │                       ▼
    │                   │              ┌──────────────────┐
    │                   │              │ ALL your past    │
    │                   │              │ communications   │
    │                   │              │ are now          │
    │                   │              │ readable         │
    │                   │              └──────────────────┘
```

---

## Who is affected?

| Data Type | Confidentiality Duration | SNDL Risk |
|-----------|--------------------------|-----------|
| Medical records | 50+ years (patient lifetime) | **CRITICAL** |
| Government secrets | 25-75 years | **CRITICAL** |
| Intellectual property | 10-20 years | **HIGH** |
| Financial data | 7-10 years | MODERATE |
| Daily communications | < 5 years | LOW |

**If your data must remain secret for more than 10 years, you're already late.**

---

## Mosca's Inequality

Michele Mosca formalized the urgency of migration:

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   If  X + Y > Z  →  You must act NOW                           │
│                                                                 │
│   X = Years until quantum computer (10-15 years)               │
│   Y = Time to migrate your systems (2-5 years)                 │
│   Z = Required confidentiality duration of your data           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Example 1: Medical data

```
X = 12 years  (quantum computer in 2037)
Y = 3 years   (infrastructure migration)
Z = 50 years  (patient records)

X + Y = 15 years

15 < 50  →  YOU'RE 35 YEARS LATE!
```

### Example 2: Standard e-commerce

```
X = 12 years  (quantum computer in 2037)
Y = 2 years   (simple migration)
Z = 5 years   (payment data)

X + Y = 14 years

14 > 5  →  You have time, but start planning
```

---

## What you'll do

In this mission, you will:

1. **Understand the PQC context**: NIST standards, new algorithms
2. **See the SNDL threat**: Attack visualization
3. **Calculate YOUR urgency**: With your own values

---

## NIST Standards (August 2024)

NIST finalized 3 post-quantum algorithms:

| Algorithm | Standard | Usage | Replaces |
|-----------|----------|-------|----------|
| **ML-DSA** | FIPS 204 | Signatures | RSA, ECDSA, Ed25519 |
| **ML-KEM** | FIPS 203 | Key exchange | ECDH, RSA-KEM |
| **SLH-DSA** | FIPS 205 | Signatures (hash-based) | Alternative to ML-DSA |

### ML-DSA (formerly Dilithium)

- Based on **lattice** cryptography
- 3 security levels: ML-DSA-44, ML-DSA-65, ML-DSA-87
- Larger signatures (~2-4 KB) but very fast

### ML-KEM (formerly Kyber)

- Also based on **lattices**
- 3 levels: ML-KEM-512, ML-KEM-768, ML-KEM-1024
- For key exchange (TLS, VPN, etc.)

---

## What you'll have at the end

- Understanding of the SNDL threat
- Your personal Mosca score
- Motivation to move to PQC

---

## Run the mission

```bash
./demo.sh
```

---

## Next step

→ **Level 1: "Build Your Quantum-Safe Foundation"**

You'll create your first post-quantum CA with ML-DSA.
