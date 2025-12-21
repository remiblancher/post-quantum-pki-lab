# Post-Quantum PKI Lab

> **"La PKI ne change pas. Seul l'algorithme change."**

Apprends la cryptographie post-quantique en pratiquant. Un parcours interactif de ~2h où tu construis ta propre PKI quantum-safe.

---

## La menace quantique en 30 secondes

Les ordinateurs quantiques vont casser RSA et ECDSA. Pas demain, mais dans **10-15 ans**.

Le problème ? Les adversaires **capturent ton trafic chiffré aujourd'hui** pour le déchiffrer quand ils auront un ordinateur quantique. C'est le **"Store Now, Decrypt Later"** (SNDL).

```
AUJOURD'HUI                           DANS 10-15 ANS
───────────                           ──────────────
    Adversaire                            Adversaire
        │                                     │
        │  Capture le trafic chiffré          │  Déchiffre tout
        ▼                                     ▼
   [████████████]  ──────────────────►   [Données en clair]
    Ton trafic TLS                        Mots de passe, secrets,
    (RSA/ECDSA)                           propriété intellectuelle
```

**Si tes données doivent rester confidentielles 10+ ans, tu dois agir maintenant.**

---

## Ce que tu vas apprendre

| Compétence | Mission | Ce que ça résout |
|------------|---------|-----------------|
| Créer une PKI | Quick Start | "Je ne sais pas par où commencer" |
| Comprendre l'urgence | Révélation + Mosca | "Pourquoi maintenant ?" |
| Passer au PQC | Full PQC Chain | "Comment migrer ?" |
| Garder la compatibilité | Hybrid Catalyst | "Je ne peux pas tout casser" |
| Authentifier des clients | mTLS | "Qui se connecte à mon serveur ?" |
| Signer du code | Code Signing | "Comment prouver l'intégrité ?" |
| Horodater | Timestamping | "Quand cette signature a été faite ?" |
| Gérer les incidents | Revocation + OCSP | "Ce certificat est-il encore valide ?" |
| Préparer la transition | Crypto-Agility | "Comment migrer sans tout casser ?" |
| Archiver long terme | LTV Signatures | "Valide dans 30 ans ?" |

---

## Démarrage rapide

```bash
# 1. Cloner et installer
git clone https://github.com/remiblancher/post-quantum-pki-lab.git
cd post-quantum-pki-lab
./tooling/install.sh

# 2. Lancer le menu
./start.sh

# 3. Ou directement le Quick Start (10 min)
./quickstart/demo.sh
```

---

## Le parcours complet

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   QUICK START (10 min)                                                      │
│   ════════════════════                                                      │
│   "Ma première PKI"                                                         │
│                                                                             │
│   Tu crées ta première CA et ton premier certificat.                        │
│   Algo: ECDSA P-384 (classique, pour comprendre les bases)                 │
│                                                                             │
└───────────────────────────────────┬─────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│   LA RÉVÉLATION (8 min)                                                     │
│   ═════════════════════                                                     │
│   "Store Now, Decrypt Later"                                                │
│                                                                             │
│   Ta CA classique sera cassable. Quand ? Calcule-le avec Mosca.            │
│   Tu comprends POURQUOI migrer vers le post-quantique.                      │
│                                                                             │
└───────────────────────────────────┬─────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌───────────────────┐   ┌───────────────────┐   ┌───────────────────┐
│                   │   │                   │   │                   │
│  NIVEAU 1 (20min) │   │  NIVEAU 2 (25min) │   │  NIVEAU 3 (30min) │
│  ═══════════════  │   │  ═══════════════  │   │  ═══════════════  │
│  PQC Basics       │   │  Applications     │   │  Ops & Lifecycle  │
│                   │   │                   │   │                   │
│  • "Build Your    │──▶│  • "Show Me Your  │──▶│  • "Oops, We Need │
│    Foundation"    │   │    Badge" (mTLS)  │   │    to Revoke!"    │
│  • "Best of Both  │   │  • "Secure Your   │   │  • "Is This Cert  │
│    Worlds"        │   │    Releases"      │   │    Still Good?"   │
│                   │   │  • "Trust Now,    │   │  • "Rotate Without│
│  Algo: ML-DSA     │   │    Verify Forever"│   │    Breaking"      │
│                   │   │                   │   │                   │
│                   │   │  Algo: ML-DSA     │   │  Algo: HYBRIDE    │
└───────────────────┘   └───────────────────┘   └───────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
                    ▼                               ▼
        ┌───────────────────┐           ┌───────────────────┐
        │                   │           │                   │
        │  NIVEAU 4 (20min) │           │   NEXT STEPS      │
        │  ═══════════════  │           │   ══════════════  │
        │  Advanced         │           │                   │
        │                   │           │   Tu as géré 10   │
        │  • "Sign Today,   │           │   certificats.    │
        │    Verify in 30   │           │   En production,  │
        │    Years"         │           │   tu en as 10000. │
        │  • "Build a PQC   │           │                   │
        │    Tunnel"        │           │   → QentriQ       │
        │  • "Encrypt       │           │                   │
        │    Documents"     │           │                   │
        │                   │           │                   │
        │  Algo: ML-KEM     │           │                   │
        └───────────────────┘           └───────────────────┘
```

**Temps total : ~2h (interactif)**
**Parcours minimum : 18 min** (Quick Start + Révélation)

---

## Glossaire

### Algorithmes

| Terme | Signification | Usage |
|-------|---------------|-------|
| **ML-DSA** | Module Lattice Digital Signature Algorithm (FIPS 204) | Signatures post-quantiques |
| **ML-KEM** | Module Lattice Key Encapsulation Mechanism (FIPS 203) | Échange de clés post-quantique |
| **SLH-DSA** | Stateless Hash-Based Digital Signature Algorithm | Signatures (alternative) |
| **Hybride** | Certificat avec 2 clés (classique + PQC) | Transition en douceur |
| **Catalyst** | Standard ITU-T X.509 Section 9.8 pour hybride | Format des certificats hybrides |

### Concepts

| Terme | Signification |
|-------|---------------|
| **PQC** | Post-Quantum Cryptography — résiste aux ordinateurs quantiques |
| **SNDL** | Store Now, Decrypt Later — capturer maintenant, déchiffrer plus tard |
| **Mosca** | Inégalité pour calculer l'urgence de migration |
| **LTV** | Long-Term Validation — signatures valides 30+ ans |
| **mTLS** | Mutual TLS — authentification bidirectionnelle |
| **CRL** | Certificate Revocation List — liste des certificats révoqués |
| **OCSP** | Online Certificate Status Protocol — vérification en temps réel |

### L'inégalité de Mosca

```
Si X + Y > Z  →  Tu dois agir MAINTENANT

X = Années avant qu'un ordinateur quantique soit disponible (10-15 ans)
Y = Temps pour migrer tes systèmes (2-5 ans typiquement)
Z = Durée de confidentialité requise de tes données

Exemple :
  - X = 12 ans (ordinateur quantique en 2037)
  - Y = 3 ans (migration de ton infra)
  - Z = 20 ans (données médicales)

  X + Y = 15 ans < Z = 20 ans  →  TU ES EN RETARD !
```

---

## Détail des missions

### Quick Start : "Ma première PKI"
Tu crées une CA classique et un certificat TLS. En 10 minutes, tu comprends les bases de la PKI avant de passer au post-quantique.

### La Révélation : "Store Now, Decrypt Later"
Tu calcules ton urgence de migration avec l'inégalité de Mosca. Tu comprends pourquoi ta CA classique sera cassable.

### Niveau 1 : PQC Basics

| Mission | Titre | Ce que tu fais |
|---------|-------|----------------|
| 1 | "Build Your Quantum-Safe Foundation" | Créer une hiérarchie CA 100% ML-DSA |
| 2 | "Best of Both Worlds" | Créer des certificats hybrides (ECDSA + ML-DSA) |

### Niveau 2 : Applications

| Mission | Titre | Ce que tu fais |
|---------|-------|----------------|
| 3 | "Show Me Your Badge" | Authentification mTLS avec ML-DSA |
| 4 | "Secure Your Releases" | Signer du code/firmware |
| 5 | "Trust Now, Verify Forever" | Horodater un document pour 2055 |

### Niveau 3 : Ops & Lifecycle

| Mission | Titre | Ce que tu fais |
|---------|-------|----------------|
| 6 | "Oops, We Need to Revoke!" | Simuler une compromission, révoquer, générer CRL |
| 7 | "Is This Cert Still Good?" | Déployer un OCSP responder en temps réel |
| 8 | "Rotate Without Breaking" | Préparer la migration hybride → full PQC |

### Niveau 4 : Advanced

| Mission | Titre | Ce que tu fais |
|---------|-------|----------------|
| 9 | "Sign Today, Verify in 30 Years" | Signatures LTV pour archivage légal |
| 10 | "Build a PQC Tunnel" | Key encapsulation avec ML-KEM |
| 11 | "Encrypt Documents" | Chiffrement CMS avec ML-KEM |

---

## Structure du projet

```
post-quantum-pki-lab/
├── start.sh                    # Menu principal
├── quickstart/                 # Quick Start (10 min)
│   ├── demo.sh
│   └── README.md
├── journey/                    # Parcours guidé
│   ├── 00-revelation/          # "Store Now, Decrypt Later"
│   ├── 01-pqc-basics/          # "Build Your Foundation" + "Best of Both"
│   ├── 02-applications/        # mTLS, Code Signing, Timestamping
│   ├── 03-ops-lifecycle/       # Revocation, OCSP, Crypto-Agility
│   └── 04-advanced/            # LTV, PQC Tunnel, CMS
├── workspace/                  # Tes artefacts (persistants)
│   ├── quickstart/             # CA classique
│   ├── niveau-1/               # CA PQC + CA Hybride
│   ├── niveau-2/               # Signatures, timestamps
│   ├── niveau-3/               # CRL, OCSP
│   └── niveau-4/               # LTV, tunnels
├── reference/usecases/         # Documentation de référence
├── lib/                        # Helpers shell
└── bin/pki                     # Outil PKI (Go)
```

---

## Algorithmes supportés

### Classique
- ECDSA P-256, P-384, P-521
- RSA 2048, 4096
- Ed25519

### Post-Quantum (NIST FIPS 2024)
- **ML-DSA-44, ML-DSA-65, ML-DSA-87** — Signatures
- **ML-KEM-512, ML-KEM-768, ML-KEM-1024** — Key encapsulation
- **SLH-DSA** — Signatures hash-based

### Hybride (Catalyst ITU-T X.509 9.8)
- ECDSA P-384 + ML-DSA-65
- X25519 + ML-KEM-768

---

## Prérequis

- **Go 1.21+** (pour compiler l'outil PKI)
- **OpenSSL 3.x** (pour les vérifications)
- **Bash 4+**

---

## Mode interactif

Ce lab utilise un mode interactif où tu tapes les commandes importantes :

```bash
┌─────────────────────────────────────────────────────────────────┐
│  MISSION 1 : Créer ta CA                                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Une CA (Certificate Authority) est le point de confiance.     │
│  C'est elle qui signe tous tes certificats.                    │
│                                                                 │
│  >>> Tape cette commande :                                      │
│                                                                 │
│      pki init-ca --name "Ma CA" --algorithm ml-dsa-65          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

$ pki init-ca --name "Ma CA" --algorithm ml-dsa-65
✓ CA créée : ca.crt (ML-DSA-65)
```

Les commandes complexes sont exécutées automatiquement avec explication.

---

## Workspace persistant

Chaque niveau a son propre workspace. Tes CA et certificats sont conservés entre les sessions :

```bash
# Voir le statut des workspaces
./start.sh  # puis option "s"

# Réinitialiser un niveau
./start.sh  # puis option "r"
```

---

## Liens utiles

- [NIST Post-Quantum Cryptography](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [FIPS 203 (ML-KEM)](https://csrc.nist.gov/pubs/fips/203/final)
- [FIPS 204 (ML-DSA)](https://csrc.nist.gov/pubs/fips/204/final)
- [ITU-T X.509 (Hybrid Certificates)](https://www.itu.int/rec/T-REC-X.509)

---

Créé par [QentriQ](https://qentriq.com) — Licence Apache 2.0
