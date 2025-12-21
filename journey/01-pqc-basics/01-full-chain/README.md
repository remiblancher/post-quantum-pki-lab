# Mission 1 : "Build Your Quantum-Safe Foundation"

## Full PQC Chain avec ML-DSA

### Le probleme

Ta CA classique (ECDSA) sera cassable par un ordinateur quantique.
Tous les certificats qu'elle a signes deviendront non fiables.

```
AUJOURD'HUI                          DANS 10-15 ANS
───────────                          ──────────────

   Ta CA ECDSA                          Ordinateur Quantique
       │                                       │
       │ Signe                                 │ Casse ECDSA
       ▼                                       ▼
  [Certificat]  ───────────────────────►  [Certificat FORGE]

  "Ce serveur est                         "N'importe qui peut
   authentique"                            forger ce certificat"
```

### La solution

Creer une nouvelle hierarchie CA avec **ML-DSA** (post-quantique).

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                    ROOT CA                                      │
│                    ════════                                     │
│                    ML-DSA-87                                    │
│                    (securite maximale, 256 bits)                │
│                           │                                     │
│                           │ Signe                               │
│                           ▼                                     │
│                    ISSUING CA                                   │
│                    ══════════                                   │
│                    ML-DSA-65                                    │
│                    (operations quotidiennes)                    │
│                           │                                     │
│                           │ Signe                               │
│                           ▼                                     │
│                    CERTIFICAT TLS                               │
│                    ═══════════════                              │
│                    ML-DSA-65                                    │
│                    server.example.com                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Ce que tu vas faire

1. **Creer la Root CA** avec ML-DSA-87 (niveau de securite maximal)
2. **Creer l'Issuing CA** avec ML-DSA-65 (signee par la Root)
3. **Emettre un certificat TLS** pour un serveur
4. **Verifier la chaine de confiance**

---

## Les niveaux de securite ML-DSA

| Niveau | Algorithme | Securite | Usage |
|--------|------------|----------|-------|
| 2 | ML-DSA-44 | 128 bits | Applications legeres |
| 3 | ML-DSA-65 | 192 bits | **Usage general** |
| 5 | ML-DSA-87 | 256 bits | **Root CA, haute securite** |

**Recommandation** : ML-DSA-87 pour la Root, ML-DSA-65 pour le reste.

---

## Ce que tu auras a la fin

- Root CA post-quantique (ML-DSA-87)
- Issuing CA post-quantique (ML-DSA-65)
- Certificat TLS post-quantique
- Chaine de confiance verifiee

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 2 : "Best of Both Worlds"** (Hybrid Catalyst)
