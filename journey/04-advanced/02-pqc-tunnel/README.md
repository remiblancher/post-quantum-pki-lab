# Mission 10 : "Secure the Tunnel"

## ML-KEM : Echange de cles post-quantique

### Le probleme

Tu veux etablir une connexion securisee avec Bob.
Il te faut un **secret partage** pour chiffrer la communication.

Mais comment partager un secret sur un canal non securise ?

```
AUJOURD'HUI : ECDH (Diffie-Hellman sur courbes elliptiques)
─────────────────────────────────────────────────────────────

Alice                                           Bob
  │                                               │
  │  g^a (cle publique Alice)                     │
  │  ─────────────────────────────────────────►   │
  │                                               │
  │  g^b (cle publique Bob)                       │
  │  ◄─────────────────────────────────────────   │
  │                                               │
  │                                               │
  ▼                                               ▼
g^(ab) = Secret partage                   g^(ab) = Secret partage


PROBLEME : Un ordinateur quantique peut calculer 'a' depuis g^a
           → Le secret est compromis retroactivement (SNDL)
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  SNDL applique a l'echange de cles                              │
│                                                                  │
│                                                                  │
│    AUJOURD'HUI                         DANS 15 ANS              │
│                                                                  │
│    Alice ◄────────────► Bob            Ordinateur quantique     │
│          ECDH                                │                   │
│           │                                  │                   │
│           │                                  ▼                   │
│           │                          Casse ECDH                 │
│           ▼                                  │                   │
│    Adversaire capture                        │                   │
│    les cles publiques                        ▼                   │
│    g^a et g^b                         Calcule le secret         │
│           │                           partage g^(ab)            │
│           │                                  │                   │
│           └──────────────────────────────────┘                  │
│                                                                  │
│    → Dechiffre TOUT le trafic capture il y a 15 ans            │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : ML-KEM (Key Encapsulation Mechanism)

ML-KEM fonctionne differemment : **encapsulation** au lieu d'echange.

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  ML-KEM : Encapsulation de cle                                  │
│                                                                  │
│                                                                  │
│  1. Bob a une paire de cles ML-KEM                              │
│                                                                  │
│     ┌─────────────────┐                                         │
│     │  Bob            │                                         │
│     │  ───            │                                         │
│     │  pk (publique)  │  ←── Publiee (certificat)              │
│     │  sk (privee)    │  ←── Gardee secrete                    │
│     └─────────────────┘                                         │
│                                                                  │
│  2. Alice encapsule un secret                                    │
│                                                                  │
│     Alice                                                        │
│       │                                                          │
│       │  Encaps(pk_bob)                                         │
│       │  ─────────────                                          │
│       ▼                                                          │
│     ┌─────────────────────────────────────────┐                 │
│     │  Resultat :                              │                 │
│     │  - ciphertext (envoye a Bob)            │                 │
│     │  - shared_secret (garde par Alice)      │                 │
│     └─────────────────────────────────────────┘                 │
│                                                                  │
│  3. Bob decapsule                                                │
│                                                                  │
│     Bob                                                          │
│       │                                                          │
│       │  Decaps(sk_bob, ciphertext)                             │
│       │  ──────────────────────────                             │
│       ▼                                                          │
│     ┌─────────────────────────────────────────┐                 │
│     │  Resultat :                              │                 │
│     │  - shared_secret (identique a Alice)    │                 │
│     └─────────────────────────────────────────┘                 │
│                                                                  │
│  ✓ Meme secret partage                                          │
│  ✓ Resistant aux ordinateurs quantiques                         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## ML-DSA vs ML-KEM

| Aspect | ML-DSA | ML-KEM |
|--------|--------|--------|
| **Usage** | Signatures | Echange de cles |
| **Objectif** | AUTHENTICITE | CONFIDENTIALITE |
| **Operations** | Sign / Verify | Encaps / Decaps |
| **TLS** | Authentification serveur | Etablissement session |
| **Certificat** | keyUsage: digitalSignature | keyUsage: keyEncipherment |

---

## Hybride en pratique : X25519 + ML-KEM-768

Pour la transition, on combine les deux :

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  KEM HYBRIDE = X25519 + ML-KEM-768                             │
│                                                                 │
│                                                                 │
│  1. Echange X25519 (classique)                                 │
│     └── secret_1 = ECDH(x25519_alice, x25519_bob)              │
│                                                                 │
│  2. Encapsulation ML-KEM-768 (post-quantique)                  │
│     └── secret_2, ciphertext = Encaps(mlkem_bob_pk)            │
│                                                                 │
│  3. Derivation combinee                                         │
│     └── final_secret = KDF(secret_1 || secret_2)               │
│                                                                 │
│                                                                 │
│  Securite :                                                     │
│  - Si X25519 est casse → ML-KEM protege                        │
│  - Si ML-KEM est casse → X25519 protege                        │
│  - Les deux doivent etre casses simultanement                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Ce que tu vas faire

1. **Generer une paire ML-KEM-768** pour Bob
2. **Creer un certificat KEM** (keyUsage: keyEncipherment)
3. **Encapsuler un secret** avec la cle publique de Bob
4. **Decapsuler** et verifier que le secret est identique
5. **Comparer les tailles** : X25519 vs ML-KEM-768

---

## Tailles ML-KEM

| Niveau | Cle publique | Cle privee | Ciphertext | Secret |
|--------|-------------|------------|------------|--------|
| ML-KEM-512 | 800 bytes | 1632 bytes | 768 bytes | 32 bytes |
| ML-KEM-768 | 1184 bytes | 2400 bytes | 1088 bytes | 32 bytes |
| ML-KEM-1024 | 1568 bytes | 3168 bytes | 1568 bytes | 32 bytes |

**Comparaison** : X25519 = 32 bytes cle publique, 32 bytes ciphertext

---

## Ce que tu auras a la fin

- Paire de cles ML-KEM-768
- Certificat KEM
- Encapsulation / Decapsulation reussie
- Secret partage quantum-safe

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 11 : "Encrypt for Their Eyes Only"** (CMS Encryption)
