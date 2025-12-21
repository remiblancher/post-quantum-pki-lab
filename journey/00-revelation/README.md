# La Revelation : "Store Now, Decrypt Later"

## Pourquoi changer d'algorithme ?

Tu viens de creer une PKI classique avec ECDSA. Elle fonctionne. Alors pourquoi changer ?

Parce que **les ordinateurs quantiques vont tout casser**.

---

## La menace SNDL

**Store Now, Decrypt Later** (SNDL) : les adversaires capturent ton trafic chiffre AUJOURD'HUI pour le dechiffrer PLUS TARD.

```
AUJOURD'HUI                              DANS 10-15 ANS
───────────                              ──────────────

   Toi                                      Adversaire
    │                                           │
    │  Connexion TLS                            │
    ▼  (RSA/ECDSA)                              │
┌────────┐          ┌────────┐                  │
│ Client │◄────────►│ Serveur│                  │
└────────┘          └────────┘                  │
    │                   │                       │
    │    Adversaire     │                       │
    │        │          │                       ▼
    │        ▼          │              ┌──────────────────┐
    │   [Capture]       │              │ Ordinateur       │
    │   [████████]      │              │ Quantique        │
    │   Stocke le       │              │                  │
    │   trafic          │              │ Algorithme       │
    │                   │              │ de Shor          │
    │                   │              │                  │
    │                   │              │ Casse RSA/ECDSA  │
    │                   │              │ en quelques      │
    │                   │              │ heures           │
    │                   │              └────────┬─────────┘
    │                   │                       │
    │                   │                       ▼
    │                   │              ┌──────────────────┐
    │                   │              │ TOUTES tes       │
    │                   │              │ communications   │
    │                   │              │ passees sont     │
    │                   │              │ lisibles         │
    │                   │              └──────────────────┘
```

---

## Qui est concerne ?

| Type de donnees | Duree de confidentialite | Risque SNDL |
|-----------------|--------------------------|-------------|
| Donnees medicales | 50+ ans (vie du patient) | **CRITIQUE** |
| Secrets gouvernementaux | 25-75 ans | **CRITIQUE** |
| Propriete intellectuelle | 10-20 ans | **ELEVE** |
| Donnees financieres | 7-10 ans | MODERE |
| Communications quotidiennes | < 5 ans | FAIBLE |

**Si tes donnees doivent rester secretes plus de 10 ans, tu es deja en retard.**

---

## L'inegalite de Mosca

Michele Mosca a formalise l'urgence de la migration :

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   Si  X + Y > Z  →  Tu dois agir MAINTENANT                    │
│                                                                 │
│   X = Annees avant l'ordinateur quantique (10-15 ans)          │
│   Y = Temps pour migrer tes systemes (2-5 ans)                 │
│   Z = Duree de confidentialite de tes donnees                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Exemple 1 : Donnees medicales

```
X = 12 ans  (ordinateur quantique en 2037)
Y = 3 ans   (migration de ton infra)
Z = 50 ans  (dossiers patients)

X + Y = 15 ans

15 < 50  →  TU ES EN RETARD DE 35 ANS !
```

### Exemple 2 : E-commerce standard

```
X = 12 ans  (ordinateur quantique en 2037)
Y = 2 ans   (migration simple)
Z = 5 ans   (donnees de paiement)

X + Y = 14 ans

14 > 5  →  Tu as le temps, mais commence a planifier
```

---

## Ce que tu vas faire

Dans cette mission, tu vas :

1. **Comprendre le contexte PQC** : Standards NIST, nouveaux algorithmes
2. **Voir la menace SNDL** : Visualisation de l'attaque
3. **Calculer TON urgence** : Avec tes propres valeurs

---

## Les nouveaux standards NIST (aout 2024)

Le NIST a finalise 3 algorithmes post-quantiques :

| Algorithme | Standard | Usage | Remplace |
|------------|----------|-------|----------|
| **ML-DSA** | FIPS 204 | Signatures | RSA, ECDSA, Ed25519 |
| **ML-KEM** | FIPS 203 | Echange de cles | ECDH, RSA-KEM |
| **SLH-DSA** | FIPS 205 | Signatures (hash-based) | Alternative a ML-DSA |

### ML-DSA (ex-Dilithium)

- Base sur les **reseaux euclidiens** (lattices)
- 3 niveaux de securite : ML-DSA-44, ML-DSA-65, ML-DSA-87
- Signatures plus grandes (~2-4 KB) mais tres rapides

### ML-KEM (ex-Kyber)

- Aussi base sur les **reseaux euclidiens**
- 3 niveaux : ML-KEM-512, ML-KEM-768, ML-KEM-1024
- Pour l'echange de cles (TLS, VPN, etc.)

---

## Ce que tu auras a la fin

- Comprehension de la menace SNDL
- Ton score Mosca personnel
- La motivation pour passer au PQC

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine etape

→ **Niveau 1 : "Build Your Quantum-Safe Foundation"**

Tu vas creer ta premiere CA post-quantique avec ML-DSA.
