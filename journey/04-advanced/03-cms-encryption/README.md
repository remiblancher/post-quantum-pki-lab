# Mission 11 : "Encrypt for Their Eyes Only"

## CMS Encryption avec ML-KEM

### Le probleme

Tu veux envoyer un document confidentiel a Bob.
Seul Bob doit pouvoir le lire.

```
SITUATION
─────────

  Alice                                           Bob
    │                                               │
    │  document-secret.pdf                          │
    │  ─────────────────────────────────────────►   │
    │                                               │
    │                                               │
    ▼                                               ▼
  Comment s'assurer que                     Comment le lire
  SEUL Bob peut le lire ?                   de maniere securisee ?
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  INTERCEPTION : Le document est lisible par tous                │
│                                                                  │
│                                                                  │
│    Alice                    Attaquant                  Bob       │
│      │                          │                        │       │
│      │  document.pdf            │                        │       │
│      │  ───────────────────────►│                        │       │
│      │                          │                        │       │
│      │                          ▼                        │       │
│      │                    ┌──────────┐                   │       │
│      │                    │  Copie   │                   │       │
│      │                    │  le doc  │                   │       │
│      │                    └──────────┘                   │       │
│      │                          │                        │       │
│      │                          │  document.pdf          │       │
│      │                          │────────────────────────│       │
│      │                                                   ▼       │
│                                                                  │
│    L'attaquant a une copie du document.                         │
│    Il peut le lire, le modifier, le redistribuer.               │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : Chiffrement CMS

Chiffrer le document avec la cle publique de Bob :

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  CMS ENCRYPTION : Seul Bob peut dechiffrer                      │
│                                                                  │
│                                                                  │
│  1. ALICE CHIFFRE                                                │
│                                                                  │
│     document.pdf                                                 │
│          │                                                       │
│          ▼                                                       │
│     ┌──────────────────────────────────────────────────────┐    │
│     │  Generer cle AES-256 aleatoire                       │    │
│     │       │                                               │    │
│     │       ├────────────────────────┐                     │    │
│     │       ▼                        ▼                     │    │
│     │  Chiffrer document        Encapsuler cle AES         │    │
│     │  avec AES-256-GCM         avec ML-KEM (Bob)          │    │
│     │       │                        │                     │    │
│     │       ▼                        ▼                     │    │
│     │  Document chiffre         Cle encapsulee             │    │
│     └──────────────────────────────────────────────────────┘    │
│          │                           │                           │
│          └─────────┬─────────────────┘                          │
│                    ▼                                             │
│          ┌──────────────────┐                                   │
│          │  document.p7m    │  ←── Fichier CMS                  │
│          └──────────────────┘                                   │
│                                                                  │
│  2. BOB DECHIFFRE                                                │
│                                                                  │
│     document.p7m                                                 │
│          │                                                       │
│          ▼                                                       │
│     ┌──────────────────────────────────────────────────────┐    │
│     │  Decapsuler cle AES avec sk_bob (ML-KEM)             │    │
│     │       │                                               │    │
│     │       ▼                                               │    │
│     │  Dechiffrer document avec AES-256-GCM                │    │
│     │       │                                               │    │
│     │       ▼                                               │    │
│     │  document.pdf (original)                              │    │
│     └──────────────────────────────────────────────────────┘    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Pourquoi AES + ML-KEM ?

On ne chiffre pas directement avec ML-KEM car :
- ML-KEM est **lent** pour de gros fichiers
- ML-KEM produit des **ciphertexts volumineux**

On utilise le **schema hybride** :
1. AES-256 pour le contenu (rapide)
2. ML-KEM pour proteger la cle AES (quantum-safe)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Chiffrement "enveloppe"                                       │
│                                                                 │
│  ┌───────────────────────────────────────────────────────┐     │
│  │  Fichier CMS (.p7m)                                    │     │
│  │  ──────────────────                                    │     │
│  │                                                        │     │
│  │  ┌─────────────────────────────────────────────────┐  │     │
│  │  │  EnvelopedData                                   │  │     │
│  │  │  ─────────────                                   │  │     │
│  │  │                                                  │  │     │
│  │  │  RecipientInfo:                                  │  │     │
│  │  │    - Algo: ML-KEM-768                           │  │     │
│  │  │    - EncryptedKey: (cle AES encapsulee)         │  │     │
│  │  │                                                  │  │     │
│  │  │  EncryptedContent:                               │  │     │
│  │  │    - Algo: AES-256-GCM                          │  │     │
│  │  │    - Data: (document chiffre)                   │  │     │
│  │  │                                                  │  │     │
│  │  └─────────────────────────────────────────────────┘  │     │
│  │                                                        │     │
│  └───────────────────────────────────────────────────────┘     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## CMS : Standard S/MIME

CMS (RFC 5652) est le format utilise par :
- **S/MIME** : Emails chiffres (Outlook, Apple Mail, Thunderbird)
- **PKCS#7** : Signatures et chiffrement
- **Archivage** : Documents confidentiels

---

## Ce que tu vas faire

1. **Creer un certificat encryption** pour Bob (ML-KEM-768)
2. **Preparer un document** secret.txt
3. **Chiffrer** le document en CMS avec la cle publique de Bob
4. **Dechiffrer** avec la cle privee de Bob
5. **Verifier** que le contenu est identique

---

## Cas d'usage

| Scenario | Pourquoi CMS ? |
|----------|----------------|
| Emails confidentiels | S/MIME standard |
| Documents RH | Salaires, evaluations |
| Donnees medicales | Secret medical |
| Contrats | Avant signature |
| Backup chiffre | Protection offline |

---

## Ce que tu auras a la fin

- Certificat encryption ML-KEM-768
- Document chiffre (secret.txt.p7m)
- Document dechiffre (identique a l'original)
- Comprendre le workflow CMS

---

## Lancer la mission

```bash
./demo.sh
```

---

## Fin du parcours

Tu as complete le parcours Post-Quantum PKI Lab !

Tu maitrises maintenant :
- ✓ PKI classique et post-quantique
- ✓ Signatures ML-DSA
- ✓ Certificats hybrides
- ✓ mTLS, Code Signing, Timestamping
- ✓ Revocation, OCSP, Crypto-Agility
- ✓ LTV, ML-KEM, CMS Encryption

→ **Next Steps** : Comment migrer 10 000 certificats en production ?
