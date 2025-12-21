# Post-Quantum PKI Lab

> **"La PKI ne change pas. Seul l'algorithme change."**

Apprends la cryptographie post-quantique en pratiquant. Un parcours interactif où tu tapes toi-même les commandes.

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

## Parcours d'apprentissage

```
                    ┌─────────────────────────────┐
                    │     QUICK START (10 min)    │
                    │   "Ma première PKI"         │
                    │   Algo: ECDSA P-384         │
                    └──────────────┬──────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │    LA RÉVÉLATION (8 min)    │
                    │   "Pourquoi changer ?"      │
                    │   SNDL + Mosca              │
                    └──────────────┬──────────────┘
                                   │
         ┌─────────────────────────┼─────────────────────────┐
         │                         │                         │
         ▼                         ▼                         ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  NIVEAU 1       │    │  NIVEAU 2       │    │  NIVEAU 3       │
│  PQC Basics     │    │  Applications   │    │  Ops & Lifecycle│
│  (20 min)       │    │  (25 min)       │    │  (30 min)       │
│  ML-DSA, Hybrid │───▶│  ML-DSA         │───▶│  HYBRIDE        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                   │
                    ┌──────────────▼──────────────┐
                    │  NIVEAU 4 : Advanced        │
                    │  (20 min) — HYBRIDE         │
                    │  LTV, ML-KEM, CMS           │
                    └─────────────────────────────┘
```

**Temps total : ~2h (interactif)**
**Parcours minimum : 18 min** (Quick Start + Révélation)

## Contenu détaillé

### Quick Start : Ma première PKI
- Créer une CA (ECDSA P-384)
- Émettre un certificat TLS
- Vérifier la chaîne de confiance
- Comparer avec le PQC

### La Révélation : Pourquoi changer ?
- Contexte PQC et standards NIST
- Menace SNDL (Store Now, Decrypt Later)
- Calcul de ton urgence (Mosca)

### Niveau 1 : PQC Basics (ML-DSA)
| Mission | Description |
|---------|-------------|
| Full PQC Chain | Hiérarchie Root → Issuing → End avec ML-DSA |
| Hybrid Catalyst | Certificats ECDSA + ML-DSA |

### Niveau 2 : Applications (ML-DSA)
| Mission | Description |
|---------|-------------|
| mTLS | Authentification mutuelle client/serveur |
| Code Signing | Signer des binaires avec ML-DSA |
| Timestamping | Horodatage pour preuve légale |

### Niveau 3 : Ops & Lifecycle (HYBRIDE)
| Mission | Description |
|---------|-------------|
| Revocation | Révoquer un certificat, générer une CRL |
| OCSP Live | Responder OCSP en temps réel |
| Crypto-Agility | Préparer la transition |

### Niveau 4 : Advanced (HYBRIDE + ML-KEM)
| Mission | Description |
|---------|-------------|
| LTV Signatures | Signatures valides 30+ ans |
| PQC Tunnel | Key encapsulation avec ML-KEM |
| CMS Encryption | Chiffrement de documents |

## Algorithmes supportés

### Classique
- ECDSA P-256, P-384, P-521
- RSA 2048, 4096
- Ed25519

### Post-Quantum (NIST FIPS 2024)
- **ML-DSA** (ex-Dilithium) — Signatures
- **ML-KEM** (ex-Kyber) — Key encapsulation
- **SLH-DSA** (ex-SPHINCS+) — Signatures hash-based

### Hybride
- **Catalyst** (ITU-T X.509 9.8) — ECDSA + ML-DSA

## Structure du projet

```
post-quantum-pki-lab/
├── start.sh                    # Menu principal
├── quickstart/                 # Quick Start (10 min)
│   ├── demo.sh
│   └── README.md
├── journey/                    # Parcours guidé
│   ├── 00-revelation/
│   ├── 01-pqc-basics/
│   ├── 02-applications/
│   ├── 03-ops-lifecycle/
│   └── 04-advanced/
├── workspace/                  # Artefacts persistants par niveau
│   ├── quickstart/
│   ├── niveau-1/
│   ├── niveau-2/
│   ├── niveau-3/
│   └── niveau-4/
├── reference/usecases/         # Anciens UC (consultation)
├── lib/                        # Helpers shell
│   ├── colors.sh
│   ├── common.sh
│   ├── interactive.sh          # Mode hands-on
│   └── workspace.sh            # Gestion workspace
└── bin/pki                     # Outil PKI
```

## Prérequis

- Go 1.21+ (pour compiler l'outil PKI)
- OpenSSL 3.x (pour les vérifications)
- Bash 4+

## Mode interactif

Ce lab utilise un mode interactif où tu tapes les commandes importantes :

```bash
>>> Tape cette commande :

    pki init-ca --name "Ma CA" --algorithm ml-dsa-65 --dir ./ca

$ pki init-ca --name "Ma CA" --algorithm ml-dsa-65 --dir ./ca

[OK] Commande executee avec succes
```

Les commandes complexes sont exécutées automatiquement avec explication.

## Workspace persistant

Chaque niveau a son propre workspace. Tes CA et certificats sont conservés :

```bash
# Réinitialiser un niveau
./start.sh  # puis option "r" pour reset

# Ou manuellement
rm -rf workspace/niveau-1
```

---

Créé par [QentriQ](https://qentriq.com)

Licence : Apache 2.0
