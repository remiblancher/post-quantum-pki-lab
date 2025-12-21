# Mission 5 : "Trust Now, Verify Forever"

## Timestamping avec ML-DSA

### Le probleme

Tu signes un contrat aujourd'hui. Dans 5 ans, ton certificat a expire.

La signature est-elle encore valide ?

```
AUJOURD'HUI                          DANS 5 ANS
───────────                          ──────────

  Contrat.pdf                        Contrat.pdf
  + Signature                        + Signature
  ✓ Certificat valide                ❌ Certificat expire

  "Ce contrat a ete                  "Ce contrat a-t-il
   signe le 15/12/2024"               vraiment ete signe
                                       AVANT l'expiration ?"
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  PROBLEME : La date de signature n'est pas prouvee              │
│                                                                  │
│                                                                  │
│    2024                              2029                        │
│      │                                 │                         │
│      │  Signature creee               │  Certificat expire      │
│      │                                 │                         │
│      ▼                                 ▼                         │
│    ┌─────────┐                      ┌─────────┐                 │
│    │ Contrat │                      │ Contrat │                 │
│    │ signe   │                      │ signe   │                 │
│    │         │                      │         │                 │
│    │ ✓ Valid │  ────────────────►   │ ? Valid │                 │
│    └─────────┘                      └─────────┘                 │
│                                                                  │
│    Sans horodatage, impossible de prouver que la signature      │
│    a ete creee AVANT l'expiration du certificat.                │
│                                                                  │
│    Un attaquant pourrait :                                       │
│    - Antidater une signature (fraude)                           │
│    - Contester la validite d'un contrat                         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : Horodatage cryptographique (TSA)

Une autorite de confiance (TSA) prouve quand la signature a ete creee :

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  AVEC HORODATAGE TSA                                             │
│                                                                  │
│    1. Tu signes le document                                      │
│                                                                  │
│       Contrat.pdf                                                │
│       + Ta signature                                             │
│           │                                                      │
│           │  2. Tu demandes un timestamp                         │
│           ▼                                                      │
│       ┌───────────────────────────────────────────┐             │
│       │  TSA (Timestamp Authority)                │             │
│       │  ─────────────────────────                │             │
│       │                                           │             │
│       │  "Je certifie que ce hash existait       │             │
│       │   le 15/12/2024 a 14:32:05 UTC"          │             │
│       │                                           │             │
│       │  + Signature TSA (ML-DSA-65)             │             │
│       │  + Horloge certifiee                     │             │
│       └───────────────────────────────────────────┘             │
│           │                                                      │
│           ▼                                                      │
│    3. Le timestamp est ajoute au document                       │
│                                                                  │
│       Contrat.pdf                                                │
│       + Ta signature                                             │
│       + Timestamp TSA                                            │
│                                                                  │
│    VERIFICATION EN 2029 :                                        │
│    ✓ La signature existait le 15/12/2024                        │
│    ✓ C'etait AVANT l'expiration du certificat                   │
│    ✓ Le document est toujours valide                            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Comment ca marche techniquement

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  WORKFLOW TIMESTAMPING (RFC 3161)                              │
│                                                                 │
│  1. CLIENT                                                      │
│     ────────                                                    │
│     hash = SHA-512(signature)                                   │
│     request = TimeStampReq(hash)                                │
│                                                                 │
│  2. TSA                                                         │
│     ────                                                        │
│     horloge = temps_certifie()                                  │
│     token = {                                                   │
│       hash: hash_recu,                                          │
│       time: "2024-12-15T14:32:05Z",                            │
│       tsa: "TSA Acme Corp",                                     │
│       serial: 123456                                            │
│     }                                                           │
│     signature = ML-DSA.Sign(token, tsa_key)                     │
│                                                                 │
│  3. RESULTAT                                                    │
│     ─────────                                                   │
│     TimeStampResp = token + signature                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Cas d'usage

| Domaine | Besoin | Duree de conservation |
|---------|--------|----------------------|
| Contrats | Preuve de signature | 10-30 ans |
| Factures | Conformite fiscale | 10 ans |
| Brevets | Preuve d'anteriorite | 20+ ans |
| Medical | Dossiers patients | 50+ ans |
| Legal | Preuves juridiques | Indefini |

---

## Ce que tu vas faire

1. **Creer une TSA** (Timestamp Authority) avec ML-DSA-65
2. **Horodater un document** via le protocole RFC 3161
3. **Verifier le timestamp** : horloge, hash, signature TSA
4. **Simuler le futur** : verifier en 2055

---

## Ce que tu auras a la fin

- Certificat TSA ML-DSA-65
- Document horodate (timestamp token)
- Preuve de verification
- Confiance jusqu'en 2055+

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine etape

→ **Niveau 3 : Ops & Lifecycle**

Tu vas apprendre a gerer le cycle de vie : revocation, OCSP, rotation.
