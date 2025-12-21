# Quick Start : Ma première PKI

**Durée : 10 minutes**

## Objectif

Créer ta première PKI (Public Key Infrastructure) en tapant toi-même les commandes.

À la fin de ce Quick Start, tu auras :
- Une Autorité de Certification (CA) fonctionnelle
- Un certificat TLS pour un serveur
- Compris la différence entre classique et post-quantique

## Prérequis

1. L'outil `pki` doit être installé :
   ```bash
   ./tooling/install.sh
   ```

2. Un terminal bash

## Lancer le Quick Start

```bash
./quickstart/demo.sh
```

## Ce que tu vas apprendre

### Étape 1 : Créer ta CA
```bash
pki init-ca --name "Ma Premiere CA" --algorithm ecdsa-p384 --dir ./workspace/quickstart/classic-ca
```

Une CA possède :
- `ca.key` : la clé privée (à garder secrète !)
- `ca.crt` : le certificat auto-signé (à distribuer)

### Étape 2 : Émettre un certificat TLS
```bash
pki issue --ca-dir ./workspace/quickstart/classic-ca \
    --profile ec/tls-server \
    --cn "mon-serveur.local" \
    --dns "mon-serveur.local" \
    --out ./workspace/quickstart/server.crt \
    --key-out ./workspace/quickstart/server.key
```

### Étape 3 : Vérifier le certificat
```bash
pki verify --ca ./workspace/quickstart/classic-ca/ca.crt \
    --cert ./workspace/quickstart/server.crt
```

### Étape 4 : Comparer avec le Post-Quantum

Le script crée automatiquement une CA post-quantique (ML-DSA-65) pour comparer les tailles.

**Observation typique :**
| Fichier | ECDSA | ML-DSA | Ratio |
|---------|-------|--------|-------|
| CA Certificate | ~800 B | ~3 KB | ~4x |
| Server Certificate | ~1 KB | ~5 KB | ~5x |
| Private Key | ~300 B | ~4 KB | ~13x |

## Fichiers générés

Après le Quick Start, tes fichiers sont dans :
```
workspace/quickstart/
├── classic-ca/           # Ta CA ECDSA P-384
│   ├── ca.crt
│   ├── ca.key
│   ├── index.txt
│   └── serial
├── server.crt            # Ton certificat TLS
├── server.key            # Ta clé privée TLS
├── pqc-ca-demo/          # CA de démo ML-DSA-65
├── pqc-server.crt        # Certificat PQC de démo
└── pqc-server.key        # Clé PQC de démo
```

## Et après ?

Ta CA classique sera cassable par un ordinateur quantique. Pour comprendre l'urgence :

```bash
./journey/00-revelation/demo.sh
```

Ou lance le menu principal :
```bash
./start.sh
```

## Réinitialiser

Pour recommencer le Quick Start à zéro :
```bash
rm -rf ./workspace/quickstart
./quickstart/demo.sh
```
