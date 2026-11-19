# Cahier des Charges v2 — Lingua Balade

Application mobile d'apprentissage des langues : noyau de 1 000 mots, grammaire rythmée et compagnon de balade IA.
Version révisée du 30/10/2026 (remplace la v1).

## 1. Vision & périmètre

Apprentissage nomade « mains libres, oreilles attentives », inspiré de deux expériences :

- **l'immersion avec un binôme natif** qui corrige chaque phrase, avec bienveillance ;
- **la méthode de la Légion étrangère** : vocabulaire des besoins immédiats, répétition à voix haute, rengaines, régularité quotidienne.

- Plateforme : Android d'abord (Flutter), iOS ensuite (même code, compilation sur Mac).
- Langue source : français.
- Langues cibles : allemand (**pilote du MVP**), **grec moderne** et **latin** (disponibles), anglais, espagnol, portugais, slovène (à venir).
- Grec : transcription phonétique en lettres latines (avec accent tonique) pour chaque mot, chaque exemple et chaque réplique du compagnon.
- Latin : latin classique simple (latin moderne pour les réalités actuelles), noms donnés avec génitif et genre, verbes avec leurs formes principales ; voix italienne (prononciation proche du latin d'Église), faute de voix latine sur les téléphones.
- Chaque langue a sa liste de **phrases toutes faites** (salutations, demandes, restaurant, orientation…).
- Usage MVP : personnel. L'utilisateur saisit sa propre clé d'API. Une publication sur le Play Store exigera le backend proxy (§ 6).

## 2. Piliers

### Pilier 1 — Transport & répétition (hors ligne)

- 1 000 mots par langue, rangés par **situations** (au café, faire les courses, se déplacer, au travail, la maison, le corps et la santé…), complétés par un groupe « mots essentiels » (mots-outils, verbes de base).
- Chaque mot vient avec une **phrase toute faite** directement réutilisable.
- **Séquence audio** (durées réglables) :
  `[mot cible + article]` → `[silence : RÉPÉTER À VOIX HAUTE]` → `[traduction FR]` → `[mot cible + article]` → *(option)* `[phrase exemple]`.
- **Mode inversé** (rappel actif) : `[FR]` → `[silence : chercher le mot]` → `[mot cible]`.
- **Audio** : la synthèse vocale n'est pas lue en direct, elle est **pré-générée en fichiers**, puis lue par `just_audio` + `audio_service` (lecture en arrière-plan, écran de verrouillage, boutons Bluetooth).
  - MVP : fichiers générés **sur l'appareil** par le moteur TTS natif (`flutter_tts.synthesizeToFile`), une seule fois, puis mis en cache.
  - Plus tard : packs MP3 générés par une TTS cloud (indispensable pour le slovène, souvent absent des voix natives).
- **Retour mains libres** : le bouton « suivant » du casque Bluetooth marque le mot courant « à revoir ». La progression alimente une répétition espacée simple (boîtes de Leitner, 5 niveaux).

### Pilier 2 — Grammaire visuelle & rythmée

- Fiches A1/A2 courtes, avec un résumé en français.
- Tableaux interactifs avec **un code couleur par cellule** (genre : masculin bleu, féminin rouge, neutre vert, pluriel orange).
- **Lecture rythmée** générée à partir du tableau : ligne par ligne ou colonne par colonne. Chaque segment est étiqueté par langue, et chaque langue a sa voix.
- **Rengaines** : courte formule originale à répéter par point de grammaire (pas de chansons protégées par le droit d'auteur).

### Pilier 3 — Compagnon de balade IA (en ligne)

- Chaîne simple **STT → LLM → TTS**. Une latence de quelques secondes est acceptée, il n'y a pas de temps réel.
- Prise de parole : **appuyer pour parler** (bouton à l'écran ou bouton Bluetooth), avec un bip à l'envoi et un bip au retour.
- Fournisseur au choix dans les réglages, derrière une interface commune :
  - **Google Gemini** (par défaut, `gemini-flash-latest`) : l'enregistrement WAV est envoyé au modèle, qui le transcrit puis converse.
  - **OpenAI** : transcription `gpt-4o-mini-transcribe`, conversation `gpt-4o-mini`.
- STT : langue en détection automatique, avec la consigne de **transcrire les fautes telles quelles**.
- TTS : **voix unique de la langue cible** (TTS native de l'appareil ; une voix cloud en option).
- Le compagnon parle **uniquement la langue cible**, corrige chaque erreur par une **reformulation bienveillante**, encourage et félicite sincèrement.
- **Ouverture :** Lukas salue et demande de quel sujet l'utilisateur veut parler, en rappelant qu'il peut parler français.
- **Niveau choisi dans l'écran de balade** : Débutant (phrases de 2 à 6 mots, voix plus lente, traduction affichée d'office), A1, A2, B1.
- **Réponse structurée** (JSON) : réplique, traduction française (bouton « Traduction »), correction éventuelle, proposition dans la langue cible quand l'utilisateur parle français.
- **Révision** : chaque correction et chaque traduction demandée est rangée dans l'onglet Révision, retravaillée par cartes (« Je savais » / « À revoir », boîtes de Leitner).
- En fin de balade : bilan en français **à l'écran** (3 ou 4 erreurs récurrentes), et les mots concernés passent en « à revoir ».
- Le compagnon est invité à réutiliser les **mots déjà étudiés** par l'utilisateur.

## 3. Architecture

| Couche | Choix |
|---|---|
| UI | Flutter (Material 3), interface en français |
| État | Riverpod |
| Base locale | Drift (SQLite). Contenu importé des JSON au premier lancement, progression stockée en base. |
| Audio | `flutter_tts` (génération des fichiers) + `just_audio` + `audio_service` |
| Micro | `record` (fichier m4a) |
| Réseau | `http` |
| Secrets | `flutter_secure_storage` (clé d'API) |
| Backend (après le MVP) | Proxy (Cloudflare Worker / Cloud Function) : clés côté serveur, authentification, quotas |

## 4. Structures de données

### A. Vocabulaire (`assets/content/de/vocabulary.json`)

Chaque mot est rattaché à un **concept commun** à toutes les langues, ce qui garde les thèmes alignés.

```json
{
  "id": "de_0042",
  "concept": "table",
  "word": "Tisch",
  "article": "der",
  "gender": "m",
  "plural": "die Tische",
  "pos": "noun",
  "translations_fr": ["table"],
  "frequency_rank": 142,
  "situation": "maison",
  "example": { "target": "Der Tisch ist groß.", "fr": "La table est grande." }
}
```

- `gender` : `m` | `f` | `n` | `pl` | `null`. Pour le slovène, pas d'article mais un genre.
- `article` : facultatif (anglais : vide ; grec : ο / η / το).
- Ajout possible, langue par langue : `transliteration` (grec).

### B. Grammaire (`assets/content/de/grammar.json`)

```json
{
  "id": "de_gram_articles_definis",
  "title": "Les articles définis",
  "level": "A1",
  "summary_fr": "L'article change selon le genre et le cas.",
  "chant": "der, die, das — den, die, das — dem, der, dem — des, der, des",
  "table": {
    "headers": ["Cas", "Masculin", "Féminin", "Neutre", "Pluriel"],
    "column_genders": [null, "m", "f", "n", "pl"],
    "column_langs": ["fr", "target", "target", "target", "target"],
    "rows": [
      ["Nominatif", "der", "die", "das", "die"],
      ["Accusatif", "den", "die", "das", "die"]
    ]
  },
  "examples": [{ "target": "Ich sehe den Mann.", "fr": "Je vois l'homme." }]
}
```

La séquence audio n'est plus stockée. Elle est **générée** à partir du tableau : `column_langs` indique pour chaque colonne la voix à utiliser (`fr` ou `target`).

## 5. System prompt du compagnon

```text
Tu es {NOM}, un ami natif de {LANGUE_CIBLE}, chaleureux et bienveillant, qui se
promène avec l'utilisateur (francophone, niveau {NIVEAU}).
Tu parles UNIQUEMENT en {LANGUE_CIBLE}.

1. Si la phrase de l'utilisateur contient une erreur : reformule-la
   correctement avec gentillesse (« Ah, du meinst: ... — super! »),
   puis réponds et relance la conversation.
   Jamais de reproche, jamais de « c'est faux ».
2. Si la phrase est correcte : réponds naturellement. De temps en temps,
   félicite-le avec sincérité, surtout quand il réussit une tournure
   difficile ou un mot nouveau.
3. Si l'utilisateur parle français : rassure-le, donne-lui la phrase en
   {LANGUE_CIBLE}, invite-le à la répéter, puis félicite-le quand il y arrive.
4. Sois poli, patient et encourageant : remercie, montre de l'intérêt pour
   ce qu'il raconte, souligne ses progrès au fil de la balade.
5. Réponses courtes (2 à 3 phrases), vocabulaire de niveau {NIVEAU}.
   Réutilise volontiers ces mots qu'il étudie : {MOTS_RECENTS}.
6. Pas d'émoji, pas de liste, pas de mise en forme : ta réponse est lue à voix haute.
```

Le bilan de fin de balade fait l'objet d'un appel séparé, qui renvoie du JSON :
`{"erreurs":[{"dit":"...","correct":"...","explication_fr":"..."}],"mots_a_revoir":["..."]}`.

## 6. Exigences non fonctionnelles

- **Hors ligne** : les piliers 1 et 2 fonctionnent intégralement sans réseau.
- **Confidentialité / RGPD** : écran de consentement avant le premier envoi de voix. Aucune donnée vocale n'est conservée sur l'appareil après traitement. Fiche « Sécurité des données » à remplir pour le Play Store.
- **Clés d'API** : MVP personnel avec la clé de l'utilisateur, stockée de façon chiffrée. Publication : backend proxy obligatoire, aucune clé dans l'APK.
- **Contenu** : brouillon assisté par l'IA, puis **relecture humaine obligatoire** pour chaque langue avant publication.
- **Taille** : packs audio cloud téléchargeables par langue (environ 30 à 40 Mo).

## 7. Feuille de route

| # | Étape | Statut |
|---|---|---|
| 0 | Prototype du compagnon (STT → LLM → TTS) pour valider coût et qualité | dans le MVP |
| 1 | Projet Flutter + base Drift + import du contenu | MVP |
| 2 | 1 000 mots allemands + fiches de grammaire A1/A2 | MVP (relecture humaine à prévoir) |
| 3 | Lecteur Transport (arrière-plan, Bluetooth, répétition) + révision Leitner | MVP |
| 4 | Fiches de grammaire colorées + lecture rythmée | MVP |
| 5 | Compagnon de balade + bilan | MVP |
| 6 | APK Android | MVP |
| 7 | Packs audio cloud, backend proxy, 5 autres langues | après le MVP |
| 8 | iOS / TestFlight (Mac nécessaire) | après le MVP |
| 9 | Traduction locale (ML Kit) en repli quand l'IA en ligne est lente ou indisponible | à venir |
| 10 | Explication de la structure des phrases de Lukas (utile pour le latin et le grec) | à venir |

**Points ouverts** : modèle économique (abonnement ou clé personnelle), test de niveau initial.
