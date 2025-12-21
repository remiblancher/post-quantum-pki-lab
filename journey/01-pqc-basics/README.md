# Niveau 1 : PQC Basics

**Duree :** 20 minutes
**Algorithmes :** ML-DSA-87, ML-DSA-65, ECDSA+ML-DSA (Hybride)

## Objectif

Creer votre premiere infrastructure PKI post-quantique et comprendre les certificats hybrides.

## Missions

### Mission 1 : Full PQC Chain
Creer une hierarchie CA complete en full PQC :
- Root CA avec ML-DSA-87 (niveau de securite maximal)
- Issuing CA avec ML-DSA-65 (operationnel)
- Certificat TLS serveur

```bash
./journey/01-pqc-basics/01-full-chain/demo.sh
```

### Mission 2 : Hybrid Catalyst
Creer une CA hybride compatible avec les systemes legacy :
- ECDSA P-384 pour la compatibilite
- ML-DSA-65 pour la protection post-quantique
- Test d'interoperabilite OpenSSL/pki

```bash
./journey/01-pqc-basics/02-hybrid/demo.sh
```

## Workspace

Les artefacts sont sauvegardes dans `workspace/niveau-1/` :
- `pqc-root-ca/` - CA racine ML-DSA-87
- `pqc-issuing-ca/` - CA intermediaire ML-DSA-65
- `hybrid-ca/` - CA hybride Catalyst
- Certificats emis

## Ce que vous apprendrez

- Hierarchie PKI a 3 niveaux
- Difference ML-DSA-87 vs ML-DSA-65
- Certificats hybrides (ITU-T X.509 Section 9.8)
