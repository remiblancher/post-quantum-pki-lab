# APP-07: "LTV: Trust Today, Verify in 2055"

## Long-Term Validation for Document Signing

> **Key Message:** A signature is only as good as its proof chain. LTV bundles everything needed to verify a signature decades from now, even if the CA is gone.

> **Visual diagrams:** See [`diagram.txt`](diagram.txt) for ASCII diagrams of the LTV proof structure.

## The Scenario

*"We signed a 30-year contract today. In 2055, how will anyone verify this signature if our CA no longer exists?"*

This is the **Long-Term Validation (LTV)** problem. A signature alone isn't enough — you need:
1. The signature itself
2. Proof of **when** it was signed (timestamp)
3. Proof the certificate was **valid** at signing time (OCSP/CRL snapshot)
4. The full **certificate chain** (including CA certs)

## What You'll See

| Step | What Happens | What You See |
|------|--------------|--------------|
| 1. Sign document | CMS signature with ML-DSA | `contract.pdf.p7s` created |
| 2. Timestamp | RFC 3161 proof of time | Timestamp embedded |
| 3. OCSP snapshot | Certificate status at signing | "Status: good" captured |
| 4. Bundle | All proofs packaged | `contract-ltv-bundle/` |
| 5. Offline verify | Verify without network | "Valid as of 2024-XX-XX" |

## The LTV Bundle

```
contract-ltv-bundle/
├── document.pdf           # Original document
├── signature.p7s          # CMS signature (ML-DSA)
├── timestamp.tsr          # RFC 3161 timestamp
├── ocsp-response.der      # OCSP status snapshot
├── chain.pem              # Full certificate chain
└── manifest.json          # Bundle metadata
```

## Why LTV Matters

### Without LTV (Fragile)

```
2024: Sign document
      ├── Signature: ✓ Valid
      └── Certificate: ✓ Valid (OCSP says so)

2055: Verify document
      ├── Signature: ✓ Still valid
      └── Certificate: ???
          ├── CA server: GONE
          ├── OCSP responder: GONE
          └── CRL distribution point: GONE

      Result: CANNOT VERIFY
```

### With LTV (Durable)

```
2024: Sign document + Create LTV bundle
      ├── Signature: ✓ Valid
      ├── Timestamp: ✓ Proves signing time
      ├── OCSP snapshot: ✓ Certificate was valid
      └── Chain: ✓ All CA certs included

2055: Verify document (offline!)
      ├── Signature: ✓ Still valid
      ├── Timestamp: ✓ Signed on 2024-XX-XX
      ├── OCSP snapshot: ✓ Cert was valid at signing
      └── Chain: ✓ Verification succeeds

      Result: VERIFIED (no network needed)
```

## Personas

- **Alice** - Legal counsel signing a 30-year lease agreement
- **Bob** - Archivist verifying the document in 2055
- **TSA-01** - Timestamp Authority providing time proof

## Prerequisites

- `pki` tool installed
- ~5 minutes

## Quick Start

```bash
./demo.sh
```

## The Commands

### Step 1: Setup PKI Infrastructure

```bash
# Create CA for document signing
pki init-ca --name "LTV Demo CA" \
    --algorithm ml-dsa-65 \
    --dir ./ltv-ca

# Issue document signing certificate
pki issue --ca-dir ./ltv-ca \
    --profile ml-dsa-kem/document-signing \
    --cn "Alice (Legal)" \
    --out alice.crt --key-out alice.key
```

### Step 2: Sign the Document

```bash
# Create a test document
echo "30-YEAR LEASE AGREEMENT - Signed $(date)" > contract.txt

# Sign with CMS
pki cms sign --data contract.txt \
    --cert alice.crt --key alice.key \
    -o contract.txt.p7s
```

### Step 3: Add Timestamp

```bash
# Timestamp the signature (proves WHEN it was signed)
pki tsa sign --data contract.txt.p7s \
    --cert alice.crt --key alice.key \
    -o contract.txt.tsr
```

### Step 4: Capture OCSP Status

```bash
# Get OCSP response (proves certificate was VALID at signing)
pki ocsp query --cert alice.crt \
    --issuer ./ltv-ca/ca.crt \
    --responder http://localhost:8080/ocsp \
    -o ocsp-response.der
```

### Step 5: Create LTV Bundle

```bash
# Bundle everything for long-term verification
mkdir contract-ltv-bundle
cp contract.txt contract-ltv-bundle/document.txt
cp contract.txt.p7s contract-ltv-bundle/signature.p7s
cp contract.txt.tsr contract-ltv-bundle/timestamp.tsr
cp ocsp-response.der contract-ltv-bundle/
cat alice.crt ./ltv-ca/ca.crt > contract-ltv-bundle/chain.pem
```

### Step 6: Verify Offline (Simulating 2055)

```bash
# Verify using only the bundle (no network)
pki cms verify --signature contract-ltv-bundle/signature.p7s \
    --data contract-ltv-bundle/document.txt \
    --ca contract-ltv-bundle/chain.pem

# Verify timestamp
pki tsa verify --token contract-ltv-bundle/timestamp.tsr \
    --data contract-ltv-bundle/signature.p7s \
    --ca contract-ltv-bundle/chain.pem
```

## Use Cases for LTV

| Document Type | Retention Period | LTV Required? |
|--------------|------------------|---------------|
| Legal contracts | 10-30 years | **Yes** |
| Medical records | 50+ years | **Yes** |
| Real estate deeds | Permanent | **Yes** |
| Financial audits | 7-10 years | Yes |
| Software licenses | 5-15 years | Yes |
| Email archives | 3-7 years | Optional |

## Learning Outcomes

After this demo, you'll understand:
- Why signatures alone aren't enough for long-term validity
- What components make up an LTV bundle
- How to create verifiable proof packages
- Why PQC is essential for 30+ year documents

## Duration

~8 minutes

## Related Use Cases

- [APP-01: PQC Code Signing](../01-pqc-code-signing/) - Basic CMS signatures
- [APP-02: PQC Timestamping](../02-pqc-timestamping/) - RFC 3161 timestamps
- [APP-04: OCSP Responder](../04-ocsp-responder/) - Certificate status checking

## References

- [RFC 5126: CMS Advanced Electronic Signatures (CAdES)](https://datatracker.ietf.org/doc/html/rfc5126)
- [ETSI TS 101 733: Electronic Signatures and Infrastructures](https://www.etsi.org/deliver/etsi_ts/101700_101799/101733/)
- [PAdES: PDF Advanced Electronic Signatures](https://www.etsi.org/deliver/etsi_en/319100_319199/31914201/)

---

**Need help with long-term document signing?** Contact [QentriQ](https://qentriq.com)
