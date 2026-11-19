# Lingua Balade

Apprendre une langue en marchant : 1000 mots à écouter et répéter écran éteint, grammaire en couleurs lue en rythme, et un compagnon IA qui converse et corrige chaque phrase avec bienveillance.

Le cahier des charges est dans [docs/cahier_des_charges_v2.md](docs/cahier_des_charges_v2.md). Langue pilote : allemand.

## Installer sur un téléphone Android

1. Copier `build/app/outputs/flutter-apk/app-release.apk` sur le téléphone et l'ouvrir. Il faut autoriser l'installation d'applications de cette source.
2. Dans **Réglages Android › Synthèse vocale**, vérifier que le moteur Google est installé, avec les voix **allemand** et **français**.
3. Pour le compagnon : créer une clé Google Gemini (aistudio.google.com/apikey) ou OpenAI (platform.openai.com), puis la coller dans les réglages de l'application.

## Développer

```bash
. ~/development/env.sh                 # Java 17, SDK Android, Flutter
flutter pub get
dart run build_runner build            # après une modification de lib/data/database.dart
python3 tool/build_content.py de       # après une modification de tool/content/de/*.txt
flutter test
flutter build apk --release
```

## Organisation

| Dossier | Rôle |
|---|---|
| `tool/content/de/*.txt` | Vocabulaire au format compact (une ligne par mot), source à relire et corriger |
| `assets/content/de/` | Contenu livré : `vocabulary.json` (généré), `grammar.json` (écrit à la main) |
| `lib/data/` | Base Drift, import du contenu, répétition espacée (Leitner) |
| `lib/audio/` | Génération des fichiers audio, lecteur Transport en arrière-plan, lecture rythmée |
| `lib/companion/` | Clients Gemini et OpenAI (interface commune `LlmClient`), prompts, boucle micro → transcription → réponse → voix |
| `lib/ui/` | Écrans |

## Ajouter une langue

1. Écrire `tool/content/<code>/*.txt` et `assets/content/<code>/grammar.json`, puis lancer `python3 tool/build_content.py <code>`.
2. Pour une langue à articles, ajouter sa table article → genre dans `GENDERS` (`tool/build_content.py`).
3. Déclarer `assets/content/<code>/` dans `pubspec.yaml`, puis passer `hasContent: true` dans `lib/core/languages.dart`.

## Limites connues

- Le vocabulaire et la grammaire sont un brouillon rédigé avec l'IA. Un germanophone doit les **relire** avant toute publication. Le rang de fréquence est approximatif.
- L'APK est signé avec la clé de débogage : il convient pour un usage personnel, pas pour le Play Store.
- La clé d'API est celle de l'utilisateur. Une publication exige un backend proxy (voir le cahier des charges, § 6).
- Le bouton Bluetooth pilote le Transport, mais pas encore le micro du compagnon.
