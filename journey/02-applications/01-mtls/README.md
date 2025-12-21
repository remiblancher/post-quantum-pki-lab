# Mission 3 : "Show Me Your Badge"

## mTLS Authentication avec ML-DSA

### Le probleme

Tu as un serveur. Des clients veulent s'y connecter.
Comment tu sais que c'est vraiment Alice et pas un imposteur ?

```
HTTPS classique = Une seule verification
────────────────────────────────────────

   Client                              Serveur
     │                                    │
     │  ────────────────────────────────► │
     │     "Prouve-moi qui tu es"         │
     │                                    │
     │  ◄──────────────────────────────── │
     │     Certificat serveur ✓           │
     │                                    │

     Le serveur est verifie.
     Mais le client ? N'importe qui peut se connecter.
```

### La menace

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│    HTTPS classique : Le client n'est pas authentifie            │
│                                                                  │
│       Attaquant                                                  │
│          │                                                       │
│          │  "Je suis Alice"                                      │
│          ▼                                                       │
│    ┌──────────┐         ┌──────────┐                            │
│    │  Client  │────────►│  Serveur │                            │
│    │  (qui?)  │         │          │                            │
│    └──────────┘         └──────────┘                            │
│                                                                  │
│    Le serveur ne sait pas si c'est vraiment Alice.              │
│    Il fait confiance a n'importe qui.                           │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Risques** :
- Usurpation d'identite
- Acces non autorise aux APIs
- Attaque man-in-the-middle

### La solution : mTLS (mutual TLS)

Avec mTLS, les **DEUX** parties prouvent leur identite :

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│    mTLS : Verification mutuelle                                 │
│                                                                  │
│    ┌──────────┐                           ┌──────────┐          │
│    │  Alice   │◄─────────────────────────►│  Serveur │          │
│    │          │                           │          │          │
│    │  Cert    │   1. Serveur → Client     │  Cert    │          │
│    │  ML-DSA  │      "Voici mon cert"     │  ML-DSA  │          │
│    │          │                           │          │          │
│    │          │   2. Client → Serveur     │          │          │
│    │          │      "Voici mon cert"     │          │          │
│    │          │                           │          │          │
│    │    ✓     │   3. Verification         │    ✓     │          │
│    │  Valide  │      mutuelle             │  Valide  │          │
│    └──────────┘                           └──────────┘          │
│                                                                  │
│    Les deux parties sont authentifiees.                         │
│    L'attaquant ne peut plus usurper Alice.                      │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

**Avantages** :
- Zero-trust : ne jamais faire confiance par defaut
- Pas de mots de passe a gerer
- Quantum-safe avec ML-DSA

---

## Ce que tu vas faire

1. **Creer un certificat serveur** avec ML-DSA-65 et SAN
2. **Creer des certificats clients** pour Alice et Bob
3. **Verifier l'authentification** : Alice OK, inconnu rejete
4. **Tester la chaine de confiance** : tous signent par la meme CA

---

## Cas d'usage reels

| Scenario | Pourquoi mTLS ? |
|----------|-----------------|
| API microservices | Chaque service s'authentifie aupres des autres |
| IoT devices | Chaque device prouve son identite au backend |
| Zero-trust network | Aucune confiance implicite, tout est verifie |
| CI/CD pipelines | Les runners s'authentifient aupres des registries |

---

## Ce que tu auras a la fin

- Certificat serveur ML-DSA avec SAN
- 2 certificats clients (Alice, Bob)
- Preuve que mTLS fonctionne avec PQC
- Verification croisee reussie

---

## Lancer la mission

```bash
./demo.sh
```

---

## Prochaine mission

→ **Mission 4 : "Secure Your Releases"** (Code Signing)
