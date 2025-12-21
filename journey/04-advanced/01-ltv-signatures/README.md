# Mission 9 : "Sign Today, Verify in 30 Years"

## LTV Signatures avec Hybride

### Le probleme

Tu signes un contrat aujourd'hui. Dans 30 ans, tu dois prouver qu'il etait valide.

Mais :
- Le certificat a expire
- L'OCSP responder n'existe plus
- La CA a peut-etre ete dissoute

Comment verifier ?

```
AUJOURD'HUI (2024)                    DANS 30 ANS (2054)
──────────────────                    ────────────────────

┌────────────────┐                   ┌────────────────┐
│  Contrat.pdf   │                   │  Contrat.pdf   │
│  + Signature   │                   │  + Signature   │
│                │                   │                │
│  Services:     │    ────────────►  │  Services:     │
│  ✓ CA online   │                   │  ❌ CA dissoute │
│  ✓ OCSP online │                   │  ❌ OCSP down   │
│  ✓ Cert valide │                   │  ❌ Cert expire │
└────────────────┘                   └────────────────┘

                                     Comment verifier
                                     la signature ?
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  SIGNATURE "PERISSABLE" : Dependance aux services externes      │
│                                                                  │
│                                                                  │
│    2024                2034                2054                  │
│      │                   │                   │                   │
│      │  Signature        │  Cert expire      │  Verification?   │
│      │  creee            │                   │                   │
│      ▼                   ▼                   ▼                   │
│                                                                  │
│    ┌───────┐           ┌───────┐           ┌───────┐            │
│    │  OK   │           │  ???  │           │  ???  │            │
│    └───────┘           └───────┘           └───────┘            │
│                                                                  │
│    Pour verifier en 2054, il faudrait :                         │
│    - Le certificat (expire)                                      │
│    - La reponse OCSP (service down)                             │
│    - La chaine CA (entreprise dissoute)                         │
│    - Le timestamp (TSA migree)                                   │
│                                                                  │
│    → IMPOSSIBLE sans preparation                                 │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : LTV (Long-Term Validation)

Embarquer TOUT ce qui est necessaire dans le document :

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  LTV : Signature auto-suffisante                                │
│                                                                  │
│                                                                  │
│    ┌─────────────────────────────────────────────────────────┐  │
│    │  Document avec LTV                                       │  │
│    │  ─────────────────────                                   │  │
│    │                                                          │  │
│    │  1. Document original                                    │  │
│    │     └── Contrat.pdf                                      │  │
│    │                                                          │  │
│    │  2. Signature                                            │  │
│    │     └── ML-DSA + ECDSA (hybride)                        │  │
│    │                                                          │  │
│    │  3. Timestamp TSA                                        │  │
│    │     └── Preuve que la signature existait en 2024        │  │
│    │                                                          │  │
│    │  4. Reponse OCSP                                         │  │
│    │     └── "Cert valide au moment de la signature"         │  │
│    │                                                          │  │
│    │  5. Chaine complete                                      │  │
│    │     └── Root CA → Issuing CA → Signing cert             │  │
│    │     └── TSA cert + chaine                               │  │
│    │     └── OCSP cert + chaine                              │  │
│    │                                                          │  │
│    └─────────────────────────────────────────────────────────┘  │
│                                                                  │
│    VERIFICATION EN 2054 :                                        │
│    ✓ Tout est embarque                                           │
│    ✓ Aucune dependance externe                                   │
│    ✓ Verification OFFLINE possible                               │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Composants LTV

| Composant | Role | Pourquoi necessaire |
|-----------|------|---------------------|
| **Signature** | Authenticite du document | Prouve qui a signe |
| **Timestamp** | Preuve temporelle | Prouve QUAND |
| **OCSP Response** | Statut au moment T | Prouve que le cert etait valide |
| **Chaine certs** | Trust anchor | Permet de remonter a la racine |

---

## Cas d'usage

| Domaine | Duree de conservation | Contrainte |
|---------|----------------------|------------|
| Contrats commerciaux | 10 ans | Code de commerce |
| Actes notaries | 75 ans | Obligation legale |
| Dossiers medicaux | 50+ ans | Secret medical |
| Documents fiscaux | 10 ans | Administration fiscale |
| Brevets | 20+ ans | Propriete intellectuelle |

---

## Ce que tu vas faire

1. **Creer un document signe** avec ta CA hybride
2. **Ajouter un timestamp** via la TSA
3. **Capturer la reponse OCSP** au moment de la signature
4. **Embarquer la chaine complete** (tous les certificats)
5. **Simuler 2054** : verifier OFFLINE sans aucun service

---

## Format PAdES-LTV

```
Document PDF avec LTV
─────────────────────

┌─────────────────────────────────────────────────────────────┐
│  PDF Document                                               │
│  ├── Page 1, 2, 3...                                       │
│  │                                                          │
│  └── DSS (Document Security Store)                         │
│      ├── Certs[]                                           │
│      │   ├── signing-cert.der                              │
│      │   ├── issuing-ca.der                                │
│      │   ├── root-ca.der                                   │
│      │   └── tsa-cert.der                                  │
│      │                                                      │
│      ├── OCSPs[]                                           │
│      │   └── ocsp-response.der                             │
│      │                                                      │
│      └── CRLs[]                                            │
│          └── ca.crl (optionnel)                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Ce que tu auras a la fin

- Document avec signature LTV complete
- Preuve de verification offline
- Comprendre l'archivage legal
- Confiance jusqu'en 2054+

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 10 : "Secure the Tunnel"** (ML-KEM)
