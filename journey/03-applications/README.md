# Level 2: Applications

## Why this section?

You have a post-quantum PKI. Now you need to **use it**.

A PKI is useless on its own. It exists to secure **applications**:
- Authenticate clients and servers (mTLS)
- Sign code (firmware, releases)
- Timestamp documents (proof of time)

---

## What you'll learn

### mTLS: Mutual Authentication

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  STANDARD HTTPS                    mTLS                         │
│  ──────────────                    ────                         │
│                                                                 │
│  Client ──────► Server            Client ◄────► Server          │
│                                                                 │
│  "I verify that                   "We BOTH verify               │
│   the server is                    that we're                   │
│   authentic"                       authentic"                   │
│                                                                 │
│  Server proves                    Server proves                 │
│  its identity                     its identity                  │
│                                   + Client proves               │
│                                     its identity                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Use cases**: Secure APIs, microservices, IoT, zero-trust

### Code Signing: Sign your code

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  WITHOUT SIGNATURE                 WITH SIGNATURE               │
│  ─────────────────                 ──────────────               │
│                                                                 │
│  firmware.bin                      firmware.bin                 │
│  (where from?)                     + ML-DSA signature           │
│                                    + certificate                │
│                                                                 │
│  "Someone might                    "Signed by Acme Corp         │
│   have modified it"                 on Dec 15, 2024"            │
│                                                                 │
│  ❌ No guarantee                   ✓ Integrity                  │
│                                    ✓ Authenticity               │
│                                    ✓ Non-repudiation            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Use cases**: Firmware updates, software releases, scripts

### Timestamping: Cryptographic timestamping

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  PROBLEM                           SOLUTION                     │
│  ───────                           ────────                     │
│                                                                 │
│  Document signed                   Document signed              │
│  on Dec 15, 2024                   + TSA Timestamp              │
│                                                                 │
│  Certificate expires               Even if the certificate      │
│  on Dec 15, 2025                   expires, we PROVE            │
│                                    the signature                │
│  "Is the signature                 existed BEFORE               │
│   still valid?"                    expiration                   │
│                                                                 │
│                                    ✓ Signature valid            │
│                                      indefinitely               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Use cases**: Contracts, invoices, legal archiving

---

## Prerequisites

- Level 1 completed (you have a working PQC CA)
- Concepts: certificates, chain of trust

---

## Missions

### Mission 3: "Show Me Your Badge" (mTLS)

Authenticate clients with your PQC CA.

**The problem**: How do you know it's really Alice connecting?

```bash
./01-mtls/demo.sh
```

### Mission 4: "Secure Your Releases" (Code Signing)

Sign code with ML-DSA.

**The problem**: How do you guarantee the firmware hasn't been modified?

```bash
./02-code-signing/demo.sh
```

### Mission 5: "Trust Now, Verify Forever" (Timestamping)

Timestamp documents for legal proof.

**The problem**: How do you prove a document existed at a specific date?

```bash
./03-timestamping/demo.sh
```

---

## What you'll have at the end

```
workspace/niveau-2/
├── mtls/
│   ├── server.crt          # Server certificate ML-DSA
│   ├── alice.crt           # Client certificate Alice
│   └── bob.crt             # Client certificate Bob
├── code-signing/
│   ├── signing.crt         # Signing certificate
│   ├── firmware.bin        # Signed file
│   └── firmware.bin.sig    # ML-DSA signature
└── timestamping/
    ├── tsa.crt             # TSA certificate
    ├── document.txt        # Timestamped document
    └── document.tsr        # Timestamp response
```

---

## Next step

→ **Level 3: Ops & Lifecycle**

You'll learn to manage the lifecycle: revocation, OCSP, algorithm rotation.
