# Niveau 2 : Applications

**Duree :** 25 minutes
**Algorithme :** ML-DSA-65

## Objectif

Utiliser votre PKI post-quantique pour des cas d'usage reels : mTLS, signature de code, horodatage.

## Prerequis

Niveau 1 complete (CA PQC disponible dans `workspace/niveau-1/`)

## Missions

### Mission 3 : mTLS Authentication
Authentification mutuelle client/serveur avec ML-DSA :
- Certificat serveur avec SAN
- Certificats clients (Alice, Bob)
- Verification croisee

```bash
./journey/02-applications/01-mtls/demo.sh
```

### Mission 4 : Code Signing
Signer du code/firmware pour garantir l'integrite :
- Profil code-signing ML-DSA-65
- Signature CMS/PKCS#7
- Verification de l'integrite

```bash
./journey/02-applications/02-code-signing/demo.sh
```

### Mission 5 : Timestamping
Horodatage cryptographique pour preuves legales :
- TSA (Timestamp Authority) ML-DSA-65
- Horodatage RFC 3161
- Validite jusqu'en 2055+

```bash
./journey/02-applications/03-timestamping/demo.sh
```

## Workspace

Les artefacts sont sauvegardes dans `workspace/niveau-2/`

## Ce que vous apprendrez

- mTLS avec PQC (zero-trust)
- Signature de code quantum-safe
- Horodatage pour archivage long terme
