# Niveau 1 : PQC Basics

## Pourquoi cette section ?

Tu as cree une PKI classique dans le Quick Start. Tu as compris la menace SNDL.

Maintenant tu vas **transformer ta PKI en post-quantique**.

---

## Ce que tu vas apprendre

### ML-DSA : L'algorithme de signature post-quantique

ML-DSA (Module Lattice Digital Signature Algorithm) remplace RSA et ECDSA.

```
┌─────────────────────────────────────────────────────────────────┐
│  ECDSA (classique)              ML-DSA (post-quantique)        │
│  ─────────────────              ─────────────────────          │
│                                                                 │
│  Cle publique : 64 bytes        Cle publique : 1952 bytes      │
│  Signature : 64 bytes           Signature : 3293 bytes         │
│  Securite : 128 bits            Securite : 192 bits (niveau 3) │
│                                                                 │
│  Vulnerable au quantique        Resistant au quantique          │
└─────────────────────────────────────────────────────────────────┘
```

**Les signatures sont plus grandes, mais la PKI fonctionne exactement pareil.**

### Hierarchie CA

Une PKI professionnelle a une hierarchie :

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                    ROOT CA (ML-DSA-87)                         │
│                    ══════════════════                          │
│                    Niveau de securite maximal                   │
│                    Cle gardee offline                          │
│                           │                                     │
│                           ▼                                     │
│                    ISSUING CA (ML-DSA-65)                      │
│                    ═════════════════════                       │
│                    Signe les certificats                       │
│                    Cle accessible (protegee)                   │
│                           │                                     │
│              ┌────────────┼────────────┐                       │
│              ▼            ▼            ▼                       │
│          [Serveur]    [Client]    [Code Signing]               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Hybride : Le meilleur des deux mondes

Pendant la transition, tu peux avoir les DEUX algorithmes dans un certificat :

```
┌─────────────────────────────────────────────────────────────────┐
│  CERTIFICAT HYBRIDE (Catalyst)                                 │
│  ════════════════════════════                                  │
│                                                                 │
│  Cle principale : ECDSA P-384 (classique)                      │
│  Extension PQC  : ML-DSA-65 (post-quantique)                   │
│                                                                 │
│  → Les clients legacy utilisent ECDSA                          │
│  → Les clients modernes utilisent ML-DSA                       │
│  → Si un algo est casse, l'autre protege                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Prerequis

- Quick Start termine (tu as une CA classique fonctionnelle)
- Revelation terminee (tu comprends pourquoi migrer)

---

## Les missions

### Mission 1 : "Build Your Quantum-Safe Foundation"

Creer une chaine PKI 100% post-quantique.

**Le probleme** : Ta CA classique sera cassable par un ordinateur quantique.

**La solution** : Creer une nouvelle hierarchie avec ML-DSA.

```bash
./01-full-chain/demo.sh
```

### Mission 2 : "Best of Both Worlds"

Creer des certificats hybrides compatibles legacy ET quantum-safe.

**Le probleme** : Tu ne peux pas migrer tous tes clients d'un coup.

**La solution** : Les certificats hybrides sont compatibles avec les deux mondes.

```bash
./02-hybrid/demo.sh
```

---

## Ce que tu auras a la fin

```
workspace/niveau-1/
├── pqc-root-ca/           # CA racine ML-DSA-87
│   ├── ca.crt
│   └── ca.key
├── pqc-issuing-ca/        # CA intermediaire ML-DSA-65
│   ├── ca.crt
│   └── ca.key
├── hybrid-ca/             # CA hybride ECDSA + ML-DSA
│   ├── ca.crt
│   └── ca.key
└── *.crt                  # Certificats emis
```

---

## Prochaine etape

→ **Niveau 2 : Applications**

Tu vas utiliser ta PKI PQC pour des cas reels : mTLS, signature de code, horodatage.
