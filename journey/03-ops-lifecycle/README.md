# Level 3: Ops & Lifecycle

## Why this section?

You know how to create certificates. But in production, you need to **manage** them:
- What do you do when a key is compromised?
- How do you verify status in real-time?
- How do you migrate without breaking legacy clients?

---

## What you'll learn

### Revocation: Cancel a certificate

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  PROBLEM: Private key stolen                                    │
│                                                                 │
│    Attacker                                                     │
│        │                                                        │
│        │  Steals server.key                                     │
│        ▼                                                        │
│    ┌──────────┐                                                 │
│    │ Attacker │  Can now:                                       │
│    │  Server  │  - Impersonate your server                      │
│    │          │  - Intercept traffic                            │
│    │          │  - Sign malicious code                          │
│    └──────────┘                                                 │
│                                                                 │
│  SOLUTION: Revoke the certificate                               │
│                                                                 │
│    CA issues a CRL (Certificate Revocation List)                │
│    All clients see: "This cert is revoked"                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### OCSP: Real-time verification

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  CRL vs OCSP                                                    │
│                                                                 │
│  CRL (offline)                     OCSP (online)                │
│  ─────────────                     ─────────────                │
│                                                                 │
│  Client downloads                  Client asks                  │
│  the complete list                 for ONE certificate          │
│  (can be large)                                                 │
│                                                                 │
│  Periodic updates                  Real-time response           │
│  (can be stale)                    (always current)             │
│                                                                 │
│  ✓ Works offline                   ✓ Light and fast             │
│  ❌ Can be outdated                ❌ Requires network           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Crypto-Agility: Migrate without breaking

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  MIGRATION IN 3 PHASES                                          │
│                                                                 │
│  PHASE 1: CLASSICAL               PHASE 2: HYBRID               │
│  ──────────────────               ───────────────               │
│                                                                 │
│  ┌─────────┐                      ┌─────────────────────┐       │
│  │  ECDSA  │   ───────────────►   │  ECDSA + ML-DSA    │       │
│  └─────────┘                      └─────────────────────┘       │
│                                                                 │
│  Legacy clients OK                Legacy OK + PQC ready         │
│                                                                 │
│                                                                 │
│  PHASE 3: FULL PQC                                              │
│  ─────────────────                                              │
│                                                                 │
│  ┌─────────┐                                                    │
│  │  ML-DSA │   When all clients support PQC                     │
│  └─────────┘                                                    │
│                                                                 │
│  Maximum security, legacy clients deprecated                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Why Hybrid in this level?

Level 3 simulates a **production environment** where:
- Legacy clients must be able to verify (ECDSA)
- Post-quantum protection is integrated (ML-DSA)
- CRL and OCSP must be universally readable

Hybrid is the pragmatic choice for transition.

---

## Prerequisites

- Level 2 completed (you know how to use your PKI)
- Concepts: certificates, chain of trust

---

## Missions

### Mission 6: "Oops, We Need to Revoke!" (Revocation)

Simulate an incident and revoke a certificate.

**The problem**: The private key was stolen. What do you do?

```bash
./01-revocation/demo.sh
```

### Mission 7: "Is This Cert Still Good?" (OCSP)

Deploy an OCSP responder in real-time.

**The problem**: How do you verify status RIGHT NOW?

```bash
./02-ocsp/demo.sh
```

### Mission 8: "Rotate Without Breaking" (Crypto-Agility)

Prepare migration to full PQC.

**The problem**: How do you migrate without breaking legacy clients?

```bash
./03-crypto-agility/demo.sh
```

---

## What you'll have at the end

```
workspace/niveau-3/
├── revocation/
│   ├── compromised.crt     # Revoked certificate
│   ├── ca.crl              # Certificate Revocation List
│   └── revocation.log      # Action history
├── ocsp/
│   ├── ocsp.crt            # OCSP responder certificate
│   ├── ocsp-response.der   # Captured OCSP response
│   └── status-*.txt        # Before/after statuses
└── crypto-agility/
    ├── phase1/             # Classical CA
    ├── phase2/             # Hybrid CA
    └── phase3/             # Full PQC CA
```

---

## Next step

→ **Level 4: Advanced**

You'll master advanced use cases: LTV, PQC tunnels, CMS encryption.
