# Niveau 4 : Advanced

**Duree :** 20 minutes
**Algorithmes :** HYBRIDE, ML-KEM-768

## Objectif

Maitriser les cas d'usage avances : signatures a long terme, tunnels PQC, et chiffrement CMS.

## Missions

### Mission 9 : LTV Signatures
Signatures valides pour 30+ ans (archivage legal) :
- Combiner signature + timestamp + chaine de certificats
- Verification offline possible
- Cas d'usage : contrats, factures, dossiers medicaux

```bash
./journey/04-advanced/01-ltv-signatures/demo.sh
```

### Mission 10 : PQC Tunnel
Comprendre ML-KEM pour l'echange de cles :
- Difference ML-DSA (signatures) vs ML-KEM (encapsulation)
- Workflow Encaps/Decaps
- Certificat dual ML-DSA + ML-KEM
- KEM hybride X25519 + ML-KEM-768

```bash
./journey/04-advanced/02-pqc-tunnel/demo.sh
```

### Mission 11 : CMS Encryption
Chiffrer des documents avec ML-KEM :
- Certificat d'encryption ML-KEM
- Chiffrement enveloppe CMS
- Dechiffrement et verification

```bash
./journey/04-advanced/03-cms-encryption/demo.sh
```

## Workspace

Les artefacts sont sauvegardes dans `workspace/niveau-4/`

## Ce que vous apprendrez

- LTV = signature + timestamp + OCSP + chaine
- ML-KEM pour la CONFIDENTIALITE (vs ML-DSA pour l'AUTHENTICITE)
- Chiffrement de bout en bout quantum-safe
