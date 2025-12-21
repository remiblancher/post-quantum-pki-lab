# Mission 4 : "Secure Your Releases"

## Code Signing avec ML-DSA

### Le probleme

Tu distribues un firmware a tes clients. Comment ils savent que c'est vraiment toi qui l'as cree ?

```
SANS CODE SIGNING
─────────────────

   Developpeur                    Attaquant                    Client
       │                              │                           │
       │  firmware.bin                │                           │
       │  ────────────────────────────┼──────────────────────────►│
       │                              │                           │
       │                              │  firmware.bin (modifie)   │
       │                              │  ──────────────────────►  │
       │                              │                           │
       │                              │                           ▼
       │                              │                    ┌──────────────┐
       │                              │                    │  Lequel est  │
       │                              │                    │  le vrai ?   │
       │                              │                    └──────────────┘
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  SUPPLY CHAIN ATTACK : Modifier le code en transit              │
│                                                                  │
│                                                                  │
│    Developpeur                                                   │
│        │                                                         │
│        │  firmware.bin (original)                                │
│        ▼                                                         │
│    ┌──────────┐                                                  │
│    │  Mirror  │ ◄──── Attaquant injecte du malware              │
│    │  Server  │                                                  │
│    └──────────┘                                                  │
│        │                                                         │
│        │  firmware.bin (compromis)                               │
│        ▼                                                         │
│    ┌──────────┐                                                  │
│    │  Client  │  Installe le firmware                           │
│    │          │  sans savoir qu'il                              │
│    │          │  est modifie                                    │
│    └──────────┘                                                  │
│                                                                  │
│  Exemples reels :                                                │
│  - SolarWinds (2020) : malware injecte dans une mise a jour    │
│  - CodeCov (2021) : script de build compromis                   │
│  - 3CX (2023) : supply chain d'une supply chain                 │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : Code Signing

Signer le code AVANT de le distribuer :

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  AVEC CODE SIGNING                                               │
│                                                                  │
│    Developpeur                                                   │
│        │                                                         │
│        │  1. Signe firmware.bin avec ML-DSA                      │
│        ▼                                                         │
│    ┌─────────────────────────────────┐                          │
│    │  firmware.bin                   │                          │
│    │  + firmware.bin.sig (signature) │                          │
│    │  + signing.crt (certificat)     │                          │
│    └─────────────────────────────────┘                          │
│        │                                                         │
│        ▼                                                         │
│    ┌──────────┐                                                  │
│    │  Client  │  2. Verifie la signature                        │
│    │          │                                                  │
│    │          │  ✓ Hash correspond                              │
│    │          │  ✓ Signature valide                             │
│    │          │  ✓ Certificat dans la chaine                    │
│    │          │                                                  │
│    │          │  → Installation autorisee                       │
│    └──────────┘                                                  │
│                                                                  │
│  Si le firmware est modifie :                                    │
│  ❌ Hash ne correspond plus → Signature invalide → REJET        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Ce que garantit une signature

| Propriete | Signification |
|-----------|---------------|
| **Integrite** | Le fichier n'a pas ete modifie |
| **Authenticite** | Il vient bien de l'editeur |
| **Non-repudiation** | L'editeur ne peut pas nier l'avoir signe |

---

## Ce que tu vas faire

1. **Creer un certificat code-signing** avec ML-DSA-65
2. **Signer un "firmware"** (fichier binaire)
3. **Verifier la signature** : integrite + authenticite
4. **Modifier le fichier** et voir la verification echouer

---

## Anatomie d'une signature

```
firmware.bin.sig
────────────────

┌─────────────────────────────────────────────────────────────┐
│  Signature ML-DSA-65                                        │
│  ─────────────────────                                      │
│                                                              │
│  Hash du fichier : SHA-512(firmware.bin)                    │
│  Signature       : ML-DSA.Sign(hash, cle_privee)           │
│  Taille          : ~3293 bytes                              │
│                                                              │
│  Verification :                                              │
│  1. Recalculer le hash du fichier                           │
│  2. Verifier avec la cle publique du certificat            │
│  3. Verifier que le certificat est dans la chaine CA       │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Ce que tu auras a la fin

- Certificat de signature ML-DSA-65
- Fichier firmware.bin
- Signature firmware.bin.sig
- Preuve de verification (valide / invalide si modifie)

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 5 : "Trust Now, Verify Forever"** (Timestamping)
