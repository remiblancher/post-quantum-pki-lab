# Mission 6 : "Oops, We Need to Revoke!"

## Revocation & CRL avec Hybride

### Le probleme

C'est 3h du matin. Tu recois une alerte :

```
🚨 ALERTE SECURITE
   La cle privee de server.example.com
   a ete detectee sur GitHub.
```

Qu'est-ce que tu fais ?

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  CLE PRIVEE COMPROMISE : L'attaquant peut tout faire            │
│                                                                  │
│                                                                  │
│    Attaquant                                                     │
│        │                                                         │
│        │  server.key (volee)                                     │
│        ▼                                                         │
│    ┌──────────┐                                                  │
│    │ Faux     │  L'attaquant peut maintenant :                  │
│    │ Serveur  │                                                  │
│    │          │  1. Se faire passer pour server.example.com     │
│    │          │  2. Intercepter le trafic des clients           │
│    │          │  3. Signer du code malveillant                  │
│    │          │  4. Voler des donnees en transit                │
│    └──────────┘                                                  │
│                                                                  │
│    Le certificat est toujours "valide" techniquement.           │
│    Les clients font confiance a l'attaquant.                    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Impact** :
- Man-in-the-middle
- Vol de credentials
- Injection de malware
- Reputation detruite

### La solution : Revoquer immediatement

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  REVOCATION : Annuler la confiance dans un certificat           │
│                                                                  │
│                                                                  │
│    1. CA ajoute le certificat a la CRL                          │
│                                                                  │
│       ┌─────────────────────────────────────────┐               │
│       │  CRL (Certificate Revocation List)      │               │
│       │  ─────────────────────────────────      │               │
│       │                                         │               │
│       │  Serial: 12345                          │               │
│       │  Raison: keyCompromise                  │               │
│       │  Date: 2024-12-15T03:45:00Z            │               │
│       │                                         │               │
│       │  Signature: CA (ECDSA + ML-DSA)        │               │
│       └─────────────────────────────────────────┘               │
│                                                                  │
│    2. Les clients verifient la CRL                              │
│                                                                  │
│       Client                         CRL                         │
│         │                             │                          │
│         │  "Ce cert est valide ?"     │                          │
│         │  ─────────────────────────► │                          │
│         │                             │                          │
│         │  ◄───────────────────────── │                          │
│         │  "Non, revoque pour         │                          │
│         │   keyCompromise"            │                          │
│         │                             │                          │
│         ▼                                                        │
│       ❌ Connexion refusee                                       │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Les raisons de revocation

| Code | Raison | Quand l'utiliser |
|------|--------|------------------|
| `keyCompromise` | Cle volee | Fuite sur GitHub, piratage |
| `caCompromise` | CA compromise | Incident majeur |
| `affiliationChanged` | Changement d'affiliation | Employe quitte l'entreprise |
| `superseded` | Remplace | Nouveau certificat emis |
| `cessationOfOperation` | Fin d'activite | Service arrete |
| `certificateHold` | Suspension temporaire | Investigation en cours |

---

## Ce que tu vas faire

1. **Emettre un certificat** avec ta CA hybride
2. **Simuler une compromission** : la cle est volee
3. **Revoquer le certificat** avec raison `keyCompromise`
4. **Generer une CRL** signee hybride
5. **Verifier** : le certificat est maintenant rejete

---

## Timeline d'un incident reel

```
03:00  Alerte : cle detectee sur GitHub
03:05  Identification du certificat concerne
03:10  Revocation via la CA
03:15  CRL mise a jour et publiee
03:20  Clients commencent a rejeter le cert
03:30  Nouveau certificat emis (nouvelle cle)
03:35  Incident clos
```

---

## Ce que tu auras a la fin

- Certificat revoque
- CRL signee (ECDSA + ML-DSA)
- Preuve de verification : cert rejete
- Comprendre le workflow d'incident

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 7 : "Is This Cert Still Good?"** (OCSP)
