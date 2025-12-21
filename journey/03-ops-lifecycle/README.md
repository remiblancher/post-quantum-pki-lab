# Niveau 3 : Ops & Lifecycle

## Pourquoi cette section ?

Tu sais creer des certificats. Mais en production, tu dois les **gerer** :
- Que faire quand une cle est compromise ?
- Comment verifier le statut en temps reel ?
- Comment migrer sans casser les clients legacy ?

---

## Ce que tu vas apprendre

### Revocation : Annuler un certificat

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  PROBLEME : Cle privee volee                                   │
│                                                                 │
│    Attaquant                                                    │
│        │                                                        │
│        │  Vol de server.key                                     │
│        ▼                                                        │
│    ┌──────────┐                                                 │
│    │ Attacker │  Peut maintenant :                             │
│    │  Server  │  - Se faire passer pour ton serveur            │
│    │          │  - Intercepter le trafic                       │
│    │          │  - Signer du code malveillant                  │
│    └──────────┘                                                 │
│                                                                 │
│  SOLUTION : Revoquer le certificat                             │
│                                                                 │
│    CA emet une CRL (Certificate Revocation List)               │
│    Tous les clients voient : "Ce cert est revoque"             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### OCSP : Verification en temps reel

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  CRL vs OCSP                                                   │
│                                                                 │
│  CRL (offline)                     OCSP (online)               │
│  ─────────────                     ─────────────               │
│                                                                 │
│  Client telecharge                 Client demande              │
│  la liste complete                 pour UN certificat          │
│  (peut etre grosse)                                            │
│                                                                 │
│  Mise a jour periodique            Reponse temps reel          │
│  (peut etre en retard)             (toujours a jour)           │
│                                                                 │
│  ✓ Fonctionne offline              ✓ Leger et rapide           │
│  ❌ Peut etre obsolete             ❌ Necessite reseau          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Crypto-Agility : Migrer sans casser

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  MIGRATION EN 3 PHASES                                          │
│                                                                 │
│  PHASE 1 : CLASSIQUE              PHASE 2 : HYBRIDE            │
│  ─────────────────────            ────────────────             │
│                                                                 │
│  ┌─────────┐                      ┌─────────────────────┐      │
│  │  ECDSA  │   ───────────────►   │  ECDSA + ML-DSA    │      │
│  └─────────┘                      └─────────────────────┘      │
│                                                                 │
│  Clients legacy OK                Legacy OK + PQC ready        │
│                                                                 │
│                                                                 │
│  PHASE 3 : FULL PQC                                            │
│  ──────────────────                                            │
│                                                                 │
│  ┌─────────┐                                                   │
│  │  ML-DSA │   Quand tous les clients supportent PQC           │
│  └─────────┘                                                   │
│                                                                 │
│  Maximum security, clients legacy abandonnes                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Pourquoi Hybride dans ce niveau ?

Le Niveau 3 simule un **environnement de production** ou :
- Les clients legacy doivent pouvoir verifier (ECDSA)
- La protection post-quantique est integree (ML-DSA)
- CRL et OCSP doivent etre universellement lisibles

L'hybride est le choix pragmatique pour la transition.

---

## Prerequis

- Niveau 2 termine (tu sais utiliser ta PKI)
- Concepts : certificats, chaine de confiance

---

## Les missions

### Mission 6 : "Oops, We Need to Revoke!" (Revocation)

Simuler un incident et revoquer un certificat.

**Le probleme** : La cle privee a ete volee. Que faire ?

```bash
./01-revocation/demo.sh
```

### Mission 7 : "Is This Cert Still Good?" (OCSP)

Deployer un OCSP responder en temps reel.

**Le probleme** : Comment verifier le statut MAINTENANT ?

```bash
./02-ocsp/demo.sh
```

### Mission 8 : "Rotate Without Breaking" (Crypto-Agility)

Preparer la migration vers full PQC.

**Le probleme** : Comment migrer sans casser les clients legacy ?

```bash
./03-crypto-agility/demo.sh
```

---

## Ce que tu auras a la fin

```
workspace/niveau-3/
├── revocation/
│   ├── compromised.crt     # Certificat revoque
│   ├── ca.crl              # Certificate Revocation List
│   └── revocation.log      # Historique des actions
├── ocsp/
│   ├── ocsp.crt            # Certificat OCSP responder
│   ├── ocsp-response.der   # Reponse OCSP capturee
│   └── status-*.txt        # Statuts avant/apres
└── crypto-agility/
    ├── phase1/             # CA classique
    ├── phase2/             # CA hybride
    └── phase3/             # CA full PQC
```

---

## Prochaine etape

→ **Niveau 4 : Advanced**

Tu vas maitriser les cas avances : LTV, tunnels PQC, chiffrement CMS.
