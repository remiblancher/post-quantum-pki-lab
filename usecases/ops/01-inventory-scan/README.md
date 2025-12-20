# OPS-01: "Inventory Before You Migrate"

## Cryptographic Asset Discovery

> **Key Message:** Before you can migrate to PQC, you need to know what you have. Discovery is the first step.

> **Visual diagrams:** See [`diagram.txt`](diagram.txt) for ASCII diagrams of the inventory workflow.

## The Scenario

*"We want to migrate to post-quantum cryptography. But first, we need to understand our current cryptographic landscape."*

This demo simulates scanning a PKI environment and generating a cryptographic inventory report. In production, this would be done by CBOM (Cryptographic Bill of Materials) tools.

## What You'll See

| Step | What Happens | What You See |
|------|--------------|--------------|
| 1. Create mixed PKI | Classical + PQC certificates | Various CA and certs created |
| 2. Run inventory scan | Analyze all certificates | Table of algorithms found |
| 3. Generate report | Summarize findings | "3 ECDSA, 1 RSA, 2 ML-DSA" |

## Personas

- **Bob** - PKI Admin preparing for PQC migration
- **Auditor** - Needs cryptographic inventory for compliance

## Prerequisites

- `pki` tool installed

## Quick Start

```bash
./demo.sh
```

## What This Demo Creates

```
workspace/
├── legacy-ca/           # RSA 2048 CA (legacy)
├── standard-ca/         # ECDSA P-384 CA (current)
├── pqc-ca/              # ML-DSA-65 CA (future)
├── certs/
│   ├── legacy-*.crt     # RSA certificates
│   ├── standard-*.crt   # ECDSA certificates
│   └── pqc-*.crt        # ML-DSA certificates
└── inventory-report.txt # Generated report
```

## The Inventory Report

```
┌─────────────────────────────────────────────────────────┐
│              CRYPTOGRAPHIC INVENTORY REPORT             │
├─────────────────────────────────────────────────────────┤
│  Total Certificates: 9                                  │
│                                                         │
│  By Algorithm:                                          │
│    RSA-2048      : 3 (33%) ⚠️  Legacy                  │
│    ECDSA-P384    : 3 (33%) ✓  Current                  │
│    ML-DSA-65     : 3 (33%) ✓  PQC-Ready                │
│                                                         │
│  PQC Readiness: 33%                                     │
│                                                         │
│  Recommendations:                                       │
│    - Migrate RSA-2048 certificates (deprecated)         │
│    - ECDSA certificates: Plan hybrid migration          │
│    - ML-DSA certificates: Already quantum-safe          │
└─────────────────────────────────────────────────────────┘
```

## Learning Outcomes

After this demo, you'll understand:
- Why inventory is essential before migration
- How to categorize certificates by algorithm type
- How to assess PQC readiness
- Building blocks for CBOM (Cryptographic Bill of Materials)

## Duration

~8 minutes

## Next Steps

- [OPS-02: Policy, Not Refactor](../02-policy-profiles/) - Change algorithm via policy
- [OPS-03: Incident Drill](../03-incident-response/) - Practice incident response
