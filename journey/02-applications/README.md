# Niveau 2 : Applications

## Pourquoi cette section ?

Tu as une PKI post-quantique. Maintenant, il faut l'**utiliser**.

Une PKI ne sert a rien toute seule. Elle existe pour securiser des **applications** :
- Authentifier des clients et serveurs (mTLS)
- Signer du code (firmware, releases)
- Horodater des documents (preuve temporelle)

---

## Ce que tu vas apprendre

### mTLS : Authentification mutuelle

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  HTTPS CLASSIQUE                   mTLS                        │
│  ───────────────                   ────                        │
│                                                                 │
│  Client ──────► Serveur            Client ◄────► Serveur       │
│                                                                 │
│  "Je verifie que                   "On verifie                 │
│   le serveur est                    TOUS LES DEUX              │
│   authentique"                      qu'on est authentiques"    │
│                                                                 │
│  Serveur prouve                    Serveur prouve              │
│  son identite                      son identite                │
│                                    + Client prouve             │
│                                      son identite              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Cas d'usage** : APIs securisees, microservices, IoT, zero-trust

### Code Signing : Signature de code

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  SANS SIGNATURE                    AVEC SIGNATURE              │
│  ──────────────                    ───────────────             │
│                                                                 │
│  firmware.bin                      firmware.bin                │
│  (vient d'ou ?)                    + signature ML-DSA          │
│                                    + certificat                │
│                                                                 │
│  "Quelqu'un l'a                    "Signe par Acme Corp       │
│   peut-etre modifie"                le 15 dec 2024"           │
│                                                                 │
│  ❌ Aucune garantie                ✓ Integrite                 │
│                                    ✓ Authenticite              │
│                                    ✓ Non-repudiation           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Cas d'usage** : Firmware updates, releases logicielles, scripts

### Timestamping : Horodatage cryptographique

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  PROBLEME                          SOLUTION                    │
│  ────────                          ────────                    │
│                                                                 │
│  Document signe                    Document signe              │
│  le 15 dec 2024                    + Timestamp TSA             │
│                                                                 │
│  Certificat expire                 Meme si le certificat       │
│  le 15 dec 2025                    expire, on PROUVE           │
│                                    que la signature            │
│  "La signature                     existait AVANT              │
│   est-elle encore                  l'expiration                │
│   valide ?"                                                    │
│                                    ✓ Signature valide          │
│                                      indefiniment              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Cas d'usage** : Contrats, factures, archivage legal

---

## Prerequis

- Niveau 1 termine (tu as une CA PQC fonctionnelle)
- Concepts : certificats, chaine de confiance

---

## Les missions

### Mission 3 : "Show Me Your Badge" (mTLS)

Authentifier des clients avec ta CA PQC.

**Le probleme** : Comment savoir que c'est vraiment Alice qui se connecte ?

```bash
./01-mtls/demo.sh
```

### Mission 4 : "Secure Your Releases" (Code Signing)

Signer du code avec ML-DSA.

**Le probleme** : Comment garantir que le firmware n'a pas ete modifie ?

```bash
./02-code-signing/demo.sh
```

### Mission 5 : "Trust Now, Verify Forever" (Timestamping)

Horodater des documents pour preuve legale.

**Le probleme** : Comment prouver qu'un document existait a une date precise ?

```bash
./03-timestamping/demo.sh
```

---

## Ce que tu auras a la fin

```
workspace/niveau-2/
├── mtls/
│   ├── server.crt          # Certificat serveur ML-DSA
│   ├── alice.crt           # Certificat client Alice
│   └── bob.crt             # Certificat client Bob
├── code-signing/
│   ├── signing.crt         # Certificat de signature
│   ├── firmware.bin        # Fichier signe
│   └── firmware.bin.sig    # Signature ML-DSA
└── timestamping/
    ├── tsa.crt             # Certificat TSA
    ├── document.txt        # Document horodate
    └── document.tsr        # Timestamp response
```

---

## Prochaine etape

→ **Niveau 3 : Ops & Lifecycle**

Tu vas apprendre a gerer le cycle de vie : revocation, OCSP, rotation d'algorithmes.
