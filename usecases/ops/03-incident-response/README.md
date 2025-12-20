# OPS-03: "Incident Drill"

## Algorithm Deprecation Incident Response

> **Key Message:** Practice makes perfect. When an algorithm is deprecated, you need a rehearsed playbook.

> **Visual diagrams:** See [`diagram.txt`](diagram.txt) for ASCII diagrams of the incident response timeline.

## The Scenario

*"NIST just announced that Algorithm X is deprecated due to a newly discovered vulnerability. What do we do?"*

This demo simulates an algorithm deprecation incident and walks through the complete response workflow: identify, revoke, re-issue, and verify.

## What You'll See

| Step | What Happens | What You See |
|------|--------------|--------------|
| 1. Normal operation | Certificates issued | Everything working |
| 2. Incident declared | Algorithm deprecated | "ALERT: RSA compromised" |
| 3. Identify affected | Scan inventory | List of at-risk certs |
| 4. Revoke & re-issue | Mass rotation | Status: revoked → new |
| 5. Verify | Confirm migration | "0 affected certs remaining" |

## Personas

- **Bob** - PKI Admin responding to incident
- **Security** - Team that declared the incident
- **Services** - Systems that need new certificates

## Quick Start

```bash
./demo.sh
```

## What This Demo Creates

```
workspace/
├── ca/                      # Main CA
├── affected/                # Certificates with "deprecated" algo
│   ├── service-1.crt        # → Revoked
│   └── service-2.crt        # → Revoked
├── rotated/                 # New certificates (safe algo)
│   ├── service-1.crt        # → New
│   └── service-2.crt        # → New
└── incident-report.txt      # Full incident report
```

## The Incident Response Timeline

```
    TIME
      │
      │  T+0: Vulnerability Announced
      │       ────────────────────────
      │       "RSA-2048 is now considered weak"
      │
      ▼  T+1h: Incident Declared
      │       ────────────────────────
      │       Security team activates playbook
      │
      │  T+2h: Inventory Complete
      │       ────────────────────────
      │       "Found 15 affected certificates"
      │
      │  T+4h: Revocation Complete
      │       ────────────────────────
      │       All affected certs on CRL
      │
      │  T+6h: Re-Issuance Complete
      │       ────────────────────────
      │       New certs deployed to services
      │
      ▼  T+8h: Verification Complete
             ────────────────────────
             "0 affected certificates remaining"
```

## Learning Outcomes

After this demo, you'll understand:
- How to respond to algorithm deprecation
- The importance of inventory and automation
- How revocation and re-issuance work together
- Why incident drills are essential

## Duration

~10 minutes

## Next Steps

- [PKI-05: Revocation & CRL](../../pki/05-revocation-crl/) - Deep dive into revocation
- [OPS-01: Inventory Before You Migrate](../01-inventory-scan/) - Inventory fundamentals
