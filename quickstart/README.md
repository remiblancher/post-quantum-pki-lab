# Quick Start: My First PKI

**Duration: 10 minutes**

## Objective

Create your first PKI (Public Key Infrastructure) by typing the commands yourself.

At the end of this Quick Start, you will have:
- A working Certificate Authority (CA)
- A TLS certificate for a server
- Understood the difference between classical and post-quantum

## Prerequisites

1. The `pki` tool must be installed:
   ```bash
   ./tooling/install.sh
   ```

2. A bash terminal

## Launch the Quick Start

```bash
./quickstart/demo.sh
```

## What You'll Learn

### Step 1: Create Your CA
```bash
pki init-ca --name "My First CA" --algorithm ecdsa-p384 --dir ./workspace/quickstart/classic-ca
```

A CA has:
- `ca.key`: the private key (keep it secret!)
- `ca.crt`: the self-signed certificate (distribute it)

### Step 2: Issue a TLS Certificate
```bash
pki issue --ca-dir ./workspace/quickstart/classic-ca \
    --profile ec/tls-server \
    --cn "my-server.local" \
    --dns "my-server.local" \
    --out ./workspace/quickstart/server.crt \
    --key-out ./workspace/quickstart/server.key
```

### Step 3: Verify the Certificate
```bash
pki verify --ca ./workspace/quickstart/classic-ca/ca.crt \
    --cert ./workspace/quickstart/server.crt
```

### Step 4: Compare with Post-Quantum

The script automatically creates a post-quantum CA (ML-DSA-65) to compare sizes.

**Typical observation:**
| File | ECDSA | ML-DSA | Ratio |
|------|-------|--------|-------|
| CA Certificate | ~800 B | ~3 KB | ~4x |
| Server Certificate | ~1 KB | ~5 KB | ~5x |
| Private Key | ~300 B | ~4 KB | ~13x |

## Generated Files

After the Quick Start, your files are in:
```
workspace/quickstart/
├── classic-ca/           # Your ECDSA P-384 CA
│   ├── ca.crt
│   ├── ca.key
│   ├── index.txt
│   └── serial
├── server.crt            # Your TLS certificate
├── server.key            # Your TLS private key
├── pqc-ca-demo/          # Demo ML-DSA-65 CA
├── pqc-server.crt        # Demo PQC certificate
└── pqc-server.key        # Demo PQC key
```

## What's Next?

Your classical CA will be breakable by a quantum computer. To understand the urgency:

```bash
./journey/00-revelation/demo.sh
```

Or launch the main menu:
```bash
./start.sh
```

## Reset

To restart the Quick Start from scratch:
```bash
rm -rf ./workspace/quickstart
./quickstart/demo.sh
```
