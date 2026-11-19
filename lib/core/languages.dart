/// Langues cibles prises en charge. Seul l'allemand a son contenu pour le MVP.
class TargetLanguage {
  const TargetLanguage({
    required this.code,
    required this.nameFr,
    required this.ttsLocale,
    required this.companionName,
    this.hasContent = false,
    this.transliterated = false,
    this.ttsNote,
  });

  final String code;
  final String nameFr;
  final String ttsLocale;
  final String companionName;
  final bool hasContent;

  /// Alphabet non latin : on affiche aussi la transcription en lettres latines.
  final bool transliterated;

  /// Remarque sur la voix utilisée, quand elle n'est pas celle de la langue.
  final String? ttsNote;
}

const frenchTtsLocale = 'fr-FR';

const targetLanguages = [
  TargetLanguage(code: 'de', nameFr: 'Allemand', ttsLocale: 'de-DE', companionName: 'Lukas', hasContent: true),
  TargetLanguage(code: 'en', nameFr: 'Anglais', ttsLocale: 'en-GB', companionName: 'Emily'),
  TargetLanguage(code: 'es', nameFr: 'Espagnol', ttsLocale: 'es-ES', companionName: 'Lucía'),
  TargetLanguage(code: 'el', nameFr: 'Grec moderne', ttsLocale: 'el-GR', companionName: 'Nikos', transliterated: true, hasContent: true),
  TargetLanguage(
    code: 'la',
    nameFr: 'Latin',
    // Aucun téléphone n'a de voix latine : la voix italienne donne la prononciation du latin d'Église.
    ttsLocale: 'it-IT',
    companionName: 'Marcus',
    hasContent: true,
    ttsNote: 'Prononciation par la voix italienne (proche du latin d\'Église).',
  ),
  TargetLanguage(code: 'pt', nameFr: 'Portugais', ttsLocale: 'pt-PT', companionName: 'João'),
  TargetLanguage(code: 'sl', nameFr: 'Slovène', ttsLocale: 'sl-SI', companionName: 'Maja'),
];

TargetLanguage languageByCode(String code) =>
    targetLanguages.firstWhere((l) => l.code == code, orElse: () => targetLanguages.first);

/// Situations (familles thématiques), dans l'ordre d'affichage.
const situationLabels = {
  'phrases': 'Phrases toutes faites',
  'essentiel': 'Mots essentiels',
  'personnes': 'Les gens & la famille',
  'sentiments': 'Sentiments & caractère',
  'communication': 'Parler & communiquer',
  'temps': 'Le temps & le calendrier',
  'nombres': 'Nombres & quantités',
  'maison': 'À la maison',
  'cafe': 'Au café & au restaurant',
  'courses': 'Faire les courses',
  'transports': 'Se déplacer',
  'ville': 'En ville',
  'travail': 'Au travail',
  'loisirs': 'Loisirs & culture',
  'sport': 'Sport',
  'sante': 'Corps & santé',
  'nature': 'Nature & météo',
  'vetements': 'Vêtements & couleurs',
};

/// Genre grammatical déduit de l'article défini (pour le code couleur).
String? genderFromArticle(String lang, String? article) => switch ((lang, article)) {
      ('de', 'der') => 'm',
      ('de', 'die') => 'f',
      ('de', 'das') => 'n',
      ('el', 'ο') => 'm',
      ('el', 'η') => 'f',
      ('el', 'το') => 'n',
      ('el', 'οι' || 'τα') => 'pl',
      ('la', 'm' || 'f' || 'n') => article,
      _ => null,
    };

/// Langues sans article : la colonne « article » ne donne que le genre.
bool articleIsGender(String lang) => lang == 'la';

/// Abréviation du genre, affichée quand la langue n'a pas d'article (« f. »).
String? genderAbbreviation(String? gender) => switch (gender) {
      'm' => 'm.',
      'f' => 'f.',
      'n' => 'n.',
      _ => null,
    };

const levels = ['A0', 'A1', 'A2', 'B1'];

String levelLabel(String level) => level == 'A0' ? 'Débutant' : level;
