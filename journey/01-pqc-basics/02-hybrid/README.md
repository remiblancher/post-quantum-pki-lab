# Mission 2 : "Best of Both Worlds"

## Hybrid Catalyst avec ECDSA + ML-DSA

### Le probleme

Tu as une PKI PQC. Mais certains de tes clients ne supportent pas encore ML-DSA.

```
┌──────────────────┐                    ┌──────────────────┐
│  Client LEGACY   │                    │  Client MODERNE  │
│  ──────────────  │                    │  ───────────────  │
│  OpenSSL 1.x     │                    │  OpenSSL 3.x     │
│  Java 8          │                    │  Go 1.23+        │
│  Vieux navigateur│                    │  Chrome 2024+    │
│                  │                    │                  │
│  Comprend:       │                    │  Comprend:       │
│  ✓ RSA           │                    │  ✓ RSA           │
│  ✓ ECDSA         │                    │  ✓ ECDSA         │
│  ✗ ML-DSA        │                    │  ✓ ML-DSA        │
└──────────────────┘                    └──────────────────┘
         │                                       │
         │                                       │
         └───────────────┬───────────────────────┘
                         │
                         ▼
              Comment servir les deux ?
```

### La solution : Certificat Hybride

Un certificat hybride contient **deux cles** :

```
┌─────────────────────────────────────────────────────────────────┐
│  CERTIFICAT HYBRIDE (Catalyst)                                 │
│  ════════════════════════════                                  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  CLE PRINCIPALE : ECDSA P-384                           │   │
│  │  ────────────────────────────                           │   │
│  │  - Compatible avec TOUS les clients                     │   │
│  │  - Utilisee par les clients legacy                      │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  EXTENSION PQC : ML-DSA-65                              │   │
│  │  ─────────────────────────                              │   │
│  │  - Dans une extension X.509                             │   │
│  │  - Utilisee par les clients modernes                    │   │
│  │  - Invisible pour les clients legacy                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Standard** : ITU-T X.509 Section 9.8 (Catalyst)

---

## Comment ca marche ?

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  Client LEGACY   │     │  CERTIFICAT      │     │  Client MODERNE  │
│                  │     │  HYBRIDE         │     │                  │
│  Verifie avec    │────►│                  │◄────│  Verifie avec    │
│  ECDSA           │     │  ECDSA + ML-DSA  │     │  ML-DSA          │
│                  │     │                  │     │                  │
│  ✓ Fonctionne    │     │                  │     │  ✓ Fonctionne    │
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

**Avantages** :
- Compatibilite retroactive
- Protection post-quantique pour les clients modernes
- Migration progressive
- Si un algo est compromis, l'autre protege

---

## Ce que tu vas faire

1. **Creer une CA hybride** (ECDSA P-384 + ML-DSA-65)
2. **Emettre un certificat hybride** pour un serveur
3. **Tester avec OpenSSL** (voit ECDSA)
4. **Tester avec pki** (verifie ECDSA ET ML-DSA)

---

## Ce que tu auras a la fin

- CA hybride (double signature)
- Certificat serveur hybride
- Preuve de compatibilite legacy
- Preuve de verification PQC

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine etape

→ **Niveau 2 : Applications**

Tu vas utiliser ta PKI pour des cas reels.
