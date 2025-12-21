# Mission 8 : "Rotate Without Breaking"

## Crypto-Agility : Migrer sans casser

### Le probleme

Tu as 10 000 certificats ECDSA en production.
Tu dois migrer vers ML-DSA.

Mais tu ne peux pas tout casser d'un coup.

```
SITUATION ACTUELLE
──────────────────

  ┌─────────────────────────────────────────────────────────────┐
  │                                                             │
  │  Production                                                 │
  │  ──────────                                                 │
  │                                                             │
  │  ┌───────────┐  ┌───────────┐  ┌───────────┐              │
  │  │  Serveur  │  │  Serveur  │  │  Serveur  │  ... x 500   │
  │  │  ECDSA    │  │  ECDSA    │  │  ECDSA    │              │
  │  └───────────┘  └───────────┘  └───────────┘              │
  │                                                             │
  │  ┌───────────┐  ┌───────────┐  ┌───────────┐              │
  │  │  Client   │  │  Client   │  │  Client   │  ... x 9500  │
  │  │  Legacy   │  │  Legacy   │  │  Moderne  │              │
  │  │  (ECDSA)  │  │  (ECDSA)  │  │  (PQC OK) │              │
  │  └───────────┘  └───────────┘  └───────────┘              │
  │                                                             │
  └─────────────────────────────────────────────────────────────┘

  Comment migrer sans couper le service ?
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  MIGRATION "BIG BANG" : Risque d'outage massif                  │
│                                                                  │
│                                                                  │
│    Jour J : Migration vers ML-DSA                               │
│                                                                  │
│       ┌─────────┐         ┌─────────┐                           │
│       │ Serveur │  ❌───► │ Client  │  Ne comprend pas ML-DSA   │
│       │ ML-DSA  │         │ Legacy  │                           │
│       └─────────┘         └─────────┘                           │
│                                                                  │
│    Resultat :                                                    │
│    - 80% des clients ne peuvent plus se connecter               │
│    - Outage massif                                               │
│    - Rollback necessaire                                         │
│    - Migration retardee de 6 mois                               │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : Migration en 3 phases

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  PHASE 1 : PREPARATION (aujourd'hui)                            │
│  ───────────────────────────────────                            │
│                                                                  │
│  ┌─────────┐                                                    │
│  │  ECDSA  │  Statut quo. Inventorier les systemes.            │
│  └─────────┘                                                    │
│                                                                  │
│  Actions :                                                       │
│  □ Inventorier tous les certificats                             │
│  □ Identifier les clients legacy vs modernes                    │
│  □ Tester les outils PQC en lab                                 │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PHASE 2 : HYBRIDE (transition)                                 │
│  ─────────────────────────────                                  │
│                                                                  │
│  ┌─────────────────────┐                                        │
│  │  ECDSA + ML-DSA    │  Les deux algorithmes dans un cert.    │
│  └─────────────────────┘                                        │
│                                                                  │
│  Comportement :                                                  │
│  - Client legacy → Utilise ECDSA (ignore ML-DSA)                │
│  - Client moderne → Verifie les DEUX                            │
│                                                                  │
│  ✓ 100% compatibilite                                           │
│  ✓ Protection PQC pour les clients modernes                     │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PHASE 3 : FULL PQC (apres migration clients)                   │
│  ─────────────────────────────────────────────                  │
│                                                                  │
│  ┌─────────┐                                                    │
│  │  ML-DSA │  Quand TOUS les clients supportent PQC.            │
│  └─────────┘                                                    │
│                                                                  │
│  Prerequis :                                                     │
│  □ Tous les clients mis a jour                                  │
│  □ Tests de non-regression                                       │
│  □ Plan de rollback                                              │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Crypto-Agility : Definition

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  CRYPTO-AGILITY                                                │
│  ──────────────                                                │
│                                                                 │
│  La capacite d'un systeme a :                                  │
│                                                                 │
│  1. CHANGER d'algorithme                                       │
│     → Sans redesigner l'architecture                           │
│                                                                 │
│  2. SUPPORTER plusieurs algorithmes                            │
│     → Pendant la transition                                    │
│                                                                 │
│  3. ROLLBACK rapidement                                        │
│     → Si un probleme survient                                  │
│                                                                 │
│  C'est une PROPRIETE ARCHITECTURALE, pas un outil.            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Checklist Crypto-Agility

| Question | Crypto-Agile | Non Crypto-Agile |
|----------|--------------|------------------|
| Les algos sont-ils configures ou hardcodes ? | Configure | Hardcode |
| Peut-on changer l'algo sans rebuild ? | Oui | Non |
| Les certs supportent plusieurs algos ? | Oui (hybride) | Non |
| Peut-on rollback en < 1h ? | Oui | Non |
| L'inventaire crypto est-il automatise ? | Oui | Manuel |

---

## Ce que tu vas faire

1. **Creer une CA classique** (Phase 1 : ECDSA)
2. **Creer une CA hybride** (Phase 2 : ECDSA + ML-DSA)
3. **Creer une CA full PQC** (Phase 3 : ML-DSA)
4. **Tester l'interoperabilite** : client legacy vs moderne
5. **Simuler un rollback** : de hybride vers classique

---

## Timeline de migration type

```
2024 Q4  Inventaire complet
2025 Q1  Lab tests hybride
2025 Q2  Deploiement hybride (5% trafic)
2025 Q3  Deploiement hybride (100%)
2026 Q1  Debut deprecation clients legacy
2027     Full PQC (si tous clients migres)
```

---

## Ce que tu auras a la fin

- 3 CA (classique, hybride, PQC)
- Preuve d'interoperabilite
- Plan de migration concret
- Comprendre le rollback

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine etape

→ **Niveau 4 : Advanced**

Tu vas maitriser les cas avances : LTV, tunnels PQC, chiffrement CMS.
