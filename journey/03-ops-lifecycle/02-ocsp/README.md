# Mission 7 : "Is This Cert Still Good?"

## OCSP Responder avec Hybride

### Le probleme

Tu as une CRL. Mais elle est mise a jour toutes les heures.

Un certificat a ete revoque il y a 30 secondes.
Les clients ne le savent pas encore.

```
TIMELINE
────────

  03:00    03:30    04:00    04:30    05:00
    │        │        │        │        │
    ▼        ▼        ▼        ▼        ▼
  CRL     Revoc    CRL      CRL      CRL
  publiee  cert    publiee  publiee  publiee

                ↑
                │
                Pendant 30 min, les clients
                font encore confiance au
                certificat revoque !
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  FENETRE DE VULNERABILITE : CRL obsolete                        │
│                                                                  │
│                                                                  │
│    03:30  Certificat revoque (cle compromise)                   │
│    03:35  Client verifie le certificat                          │
│                                                                  │
│       Client                         CRL (03:00)                 │
│         │                               │                        │
│         │  "Ce cert est valide ?"       │                        │
│         │  ───────────────────────────► │                        │
│         │                               │                        │
│         │  ◄─────────────────────────── │                        │
│         │  "Oui, valide"                │                        │
│         │  (CRL obsolete!)              │                        │
│         ▼                                                        │
│       ✓ Connexion acceptee                                       │
│                                                                  │
│    L'attaquant peut utiliser le cert pendant 30 min !           │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### La solution : OCSP (Online Certificate Status Protocol)

Verification en **temps reel** :

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  OCSP : Demande instantanee                                     │
│                                                                  │
│                                                                  │
│    Client                         OCSP Responder                │
│      │                                  │                        │
│      │  "Statut du cert 12345 ?"        │                        │
│      │  ──────────────────────────────► │                        │
│      │                                  │                        │
│      │                                  │  Consulte la base      │
│      │                                  │  temps reel            │
│      │                                  │                        │
│      │  ◄────────────────────────────── │                        │
│      │  OCSP Response:                  │                        │
│      │  - Status: REVOKED               │                        │
│      │  - Reason: keyCompromise         │                        │
│      │  - Time: 03:30:00                │                        │
│      │  - Signature: OCSP (hybride)     │                        │
│      │                                  │                        │
│      ▼                                                           │
│    ❌ Connexion refusee (temps reel)                             │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## CRL vs OCSP

| Critere | CRL | OCSP |
|---------|-----|------|
| **Mise a jour** | Periodique (horaire/journalier) | Temps reel |
| **Taille** | Peut etre grosse (liste complete) | Petite (une reponse) |
| **Disponibilite** | Fonctionne offline | Necessite reseau |
| **Latence** | Lecture locale | Requete reseau |
| **Fenetre vuln.** | Jusqu'a prochaine CRL | Quasi nulle |

**En pratique** : On utilise les DEUX
- OCSP pour les verifications temps reel
- CRL comme fallback offline

---

## Ce que tu vas faire

1. **Demarrer un OCSP responder** pour ta CA hybride
2. **Interroger le statut** d'un certificat valide
3. **Revoquer le certificat** via la CA
4. **Observer le changement** : status passe de "good" a "revoked"
5. **Comparer** : CRL vs OCSP en temps reel

---

## Anatomie d'une reponse OCSP

```
OCSP Response
─────────────

┌─────────────────────────────────────────────────────────────┐
│  Version: 1                                                 │
│  Responder: CN=OCSP Responder                              │
│  Produced At: 2024-12-15T03:35:00Z                         │
│                                                             │
│  Response:                                                  │
│  ──────────                                                 │
│  Serial: 12345                                              │
│  Status: revoked                                            │
│  Revocation Time: 2024-12-15T03:30:00Z                     │
│  Revocation Reason: keyCompromise                          │
│                                                             │
│  This Update: 2024-12-15T03:35:00Z                         │
│  Next Update: 2024-12-15T04:35:00Z                         │
│                                                             │
│  Signature: ECDSA P-384 + ML-DSA-65                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Ce que tu auras a la fin

- OCSP responder fonctionnel
- Reponses capturees (good / revoked)
- Preuve du changement temps reel
- Comprendre le workflow OCSP

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 8 : "Rotate Without Breaking"** (Crypto-Agility)
