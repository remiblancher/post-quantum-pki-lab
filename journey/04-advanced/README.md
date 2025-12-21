# Niveau 4 : Advanced

## Pourquoi cette section ?

Tu maitrises les bases de la PKI PQC. Voici les cas **avances** :
- Signatures valides 30+ ans (archivage legal)
- Echange de cles post-quantique (ML-KEM)
- Chiffrement de documents (CMS)

---

## Ce que tu vas apprendre

### LTV : Signatures a Long Terme

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  PROBLEME : Signature classique                                │
│                                                                 │
│  2024          2025          2030          2050                │
│    │             │             │             │                  │
│    ▼             ▼             ▼             ▼                  │
│  Signature    Cert expire   OCSP down    Verification ?        │
│  creee                                                          │
│                                                                 │
│  Sans LTV, impossible de verifier apres expiration.            │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SOLUTION : LTV (Long-Term Validation)                         │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Document signe                                          │   │
│  │  + Signature                                             │   │
│  │  + Timestamp TSA                                         │   │
│  │  + Reponse OCSP                                          │   │
│  │  + Chaine de certificats complete                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Tout est embarque = verification OFFLINE en 2050.             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### ML-KEM : Echange de cles post-quantique

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ML-DSA vs ML-KEM                                              │
│  ────────────────                                              │
│                                                                 │
│  ML-DSA                            ML-KEM                      │
│  ──────                            ──────                      │
│  Signature                         Encapsulation de cle        │
│  AUTHENTIFICATION                  CONFIDENTIALITE             │
│                                                                 │
│  "Ce message vient                 "Ce message est             │
│   vraiment d'Alice"                 lisible SEULEMENT          │
│                                     par Bob"                   │
│                                                                 │
│  ┌───────┐                         ┌───────┐                   │
│  │ Signe │                         │Encaps │                   │
│  │  ───► │                         │  ───► │ Ciphertext        │
│  │  ◄─── │                         │  ◄─── │ Shared key        │
│  │Verify │                         │Decaps │                   │
│  └───────┘                         └───────┘                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### CMS : Chiffrement de documents

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  CMS (Cryptographic Message Syntax)                            │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                                                          │   │
│  │  Document original                                       │   │
│  │       │                                                  │   │
│  │       ▼                                                  │   │
│  │  ┌──────────────┐                                       │   │
│  │  │ Cle AES-256  │ ◄── Generee aleatoirement            │   │
│  │  └──────────────┘                                       │   │
│  │       │                                                  │   │
│  │       ├──────────────────┐                              │   │
│  │       ▼                  ▼                              │   │
│  │  Document chiffre   Cle encapsulee                      │   │
│  │  (AES-256-GCM)      avec ML-KEM                         │   │
│  │                      (destinataire)                     │   │
│  │                                                          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Format standard S/MIME compatible.                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Algorithmes utilises

| Mission | Signature | Encryption |
|---------|-----------|------------|
| LTV Signatures | ECDSA + ML-DSA (hybride) | - |
| PQC Tunnel | ML-DSA-65 | X25519 + ML-KEM-768 |
| CMS Encryption | ML-DSA-65 | ML-KEM-768 |

---

## Prerequis

- Niveau 3 termine (revocation, OCSP, crypto-agility)
- Concepts avances : timestamp, OCSP, hybride

---

## Les missions

### Mission 9 : "Sign Today, Verify in 30 Years" (LTV)

Creer des signatures valides pour l'archivage legal.

**Le probleme** : Comment verifier en 2055 une signature de 2024 ?

```bash
./01-ltv-signatures/demo.sh
```

### Mission 10 : "Secure the Tunnel" (ML-KEM)

Comprendre l'echange de cles post-quantique.

**Le probleme** : Comment etablir un secret partage quantum-safe ?

```bash
./02-pqc-tunnel/demo.sh
```

### Mission 11 : "Encrypt for Their Eyes Only" (CMS)

Chiffrer des documents avec ML-KEM.

**Le probleme** : Comment envoyer un document lisible uniquement par Bob ?

```bash
./03-cms-encryption/demo.sh
```

---

## Ce que tu auras a la fin

```
workspace/niveau-4/
├── ltv/
│   ├── document-signed.pdf   # Document avec LTV
│   ├── ltv-data.der          # Donnees LTV embarquees
│   └── verify-2055.log       # Preuve de verification
├── pqc-tunnel/
│   ├── kem.crt               # Certificat ML-KEM
│   ├── encapsulated.bin      # Cle encapsulee
│   └── shared-secret.hex     # Secret partage
└── cms-encryption/
    ├── encrypt.crt           # Certificat encryption
    ├── secret.txt.p7m        # Document chiffre
    └── decrypted.txt         # Document dechiffre
```

---

## Prochaine etape

→ **Next Steps : Organiser la migration**

Tu as maitrise la PKI PQC. Maintenant, comment migrer 10 000 certificats ?
