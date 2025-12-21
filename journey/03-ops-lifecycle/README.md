# Niveau 3 : Ops & Lifecycle

**Duree :** 30 minutes
**Algorithme :** HYBRIDE (ECDSA P-384 + ML-DSA-65)

## Objectif

Gerer le cycle de vie complet des certificats en production : revocation, OCSP, et preparer la transition.

## Pourquoi Hybride ?

Le niveau 3 simule un environnement de production ou :
- Les clients legacy doivent pouvoir verifier (ECDSA)
- La protection post-quantique est integree (ML-DSA)
- CRL et OCSP doivent etre universellement lisibles

## Missions

### Mission 6 : Revocation & CRL
Simuler un incident de compromission de cle :
- Revoquer un certificat (raison: keyCompromise)
- Generer une CRL signee hybride
- Verifier le statut de revocation

```bash
./journey/03-ops-lifecycle/01-revocation/demo.sh
```

### Mission 7 : OCSP Live
Deployer un OCSP responder en temps reel :
- Demarrer le serveur OCSP
- Interroger le statut d'un certificat
- Observer le changement apres revocation

```bash
./journey/03-ops-lifecycle/02-ocsp/demo.sh
```

### Mission 8 : Crypto-Agility
Preparer la transition vers le full PQC :
- Inventorier les CA existantes
- Comprendre les 3 phases de migration
- Tester le fallback hybride

```bash
./journey/03-ops-lifecycle/03-crypto-agility/demo.sh
```

## Workspace

Les artefacts sont sauvegardes dans `workspace/niveau-3/`

## Ce que vous apprendrez

- Gestion d'incidents PKI
- OCSP en temps reel avec PQC
- Strategie de migration (hybride -> full PQC)
