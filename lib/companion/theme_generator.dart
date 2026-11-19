import 'dart:convert';

import '../data/repository.dart';
import 'llm_client.dart';

String themeVocabularyPrompt({
  required String languageName,
  required String level,
  required int count,
  bool transliterate = false,
}) =>
    '''
Tu prépares le vocabulaire d'un francophone qui apprend la langue $languageName (niveau $level). L'utilisateur décrit soit une famille de mots (« aliments et épices »), soit une situation où il va se trouver (« une course cycliste »).
Choisis exactement $count mots et expressions, les plus utiles d'abord : pour une famille, couvre-la largement (y compris des mots courants comme la farine ou le sel pour les aliments) ; pour une situation, ajoute des verbes, des adjectifs et quelques expressions toutes faites pour parler, demander, réagir.
Pour les noms, donne l'article défini au singulier (en allemand : der, die ou das ; en grec : ο, η ou το ; en latin, pas d'article mais le genre m, f ou n) et le pluriel ; pour les verbes, les formes principales.${transliterate ? '\nDonne aussi la transcription phonétique en lettres latines du mot et de l\'exemple, avec l\'accent tonique (ex. : καλημέρα → kaliméra).' : ''}
Chaque exemple est une phrase courte, naturelle et utile dans la situation.
Réponds uniquement en JSON :
{"titre":"titre court du thème en français","mots":[{"mot":"mot sans article","article":"article ou null","pluriel":"pluriel ou null","formes":"formes du verbe ou null","nature":"n|v|adj|adv|expr","traductions_fr":["traduction"],"exemple":"phrase en $languageName","exemple_fr":"sa traduction"${transliterate ? ',"translitteration":"mot en lettres latines","exemple_translitteration":"exemple en lettres latines"' : ''}}]}''';

/// Demande à l'IA le vocabulaire d'une situation (« compétition de cyclisme »).
Future<({String title, List<ThemeEntry> entries})> generateThemeVocabulary(
  LlmClient client, {
  required String theme,
  required String languageName,
  required String level,
  int count = 40,
  bool transliterate = false,
}) async {
  final raw = await client.chat(
    [
      ChatMessage('system', themeVocabularyPrompt(languageName: languageName, level: level, count: count, transliterate: transliterate)),
      ChatMessage('user', theme),
    ],
    json: true,
    // Environ 130 jetons par mot (mot, traductions, exemple et sa traduction).
    maxTokens: (count * 130).clamp(1500, 16000),
  );
  return parseThemeVocabulary(raw, fallbackTitle: theme);
}

({String title, List<ThemeEntry> entries}) parseThemeVocabulary(String raw, {required String fallbackTitle}) {
  final s = raw.trim();
  final start = s.indexOf('{');
  final end = s.lastIndexOf('}');
  if (start < 0 || end <= start) throw ApiException('La liste de mots reçue est illisible. Réessayez.');
  final Map<String, dynamic> j;
  try {
    j = jsonDecode(s.substring(start, end + 1)) as Map<String, dynamic>;
  } on FormatException {
    throw ApiException('La liste de mots reçue est incomplète. Réessayez.');
  }
  String? str(Object? v) {
    if (v is! String) return null;
    final t = v.trim();
    return t.isEmpty || t == 'null' || t == '-' ? null : t;
  }

  const posCodes = {'n': 'noun', 'v': 'verb', 'adj': 'adjective', 'adv': 'adverb', 'expr': 'expression'};
  final entries = <ThemeEntry>[];
  for (final m in (j['mots'] as List? ?? const []).whereType<Map>()) {
    var word = str(m['mot']);
    final translations = [for (final t in (m['traductions_fr'] as List? ?? const [])) ?str(t)];
    if (word == null || translations.isEmpty) continue;
    var article = str(m['article']);
    // L'IA met parfois l'article dans le mot : « der Helm ».
    final split = RegExp(r'^(der|die|das)\s+(.+)$').firstMatch(word);
    if (split != null) {
      article ??= split.group(1);
      word = split.group(2)!;
    }
    entries.add(ThemeEntry(
      word: word,
      article: article,
      plural: str(m['pluriel']),
      forms: str(m['formes']),
      pos: posCodes[str(m['nature'])] ?? str(m['nature']) ?? 'expression',
      translations: translations,
      exampleTarget: str(m['exemple']) ?? word,
      exampleFr: str(m['exemple_fr']) ?? translations.first,
      transliteration: str(m['translitteration']),
      exampleTransliteration: str(m['exemple_translitteration']),
    ));
  }
  if (entries.isEmpty) throw ApiException('L\'IA n\'a proposé aucun mot pour ce thème. Essayez de le décrire autrement.');
  return (title: str(j['titre']) ?? fallbackTitle, entries: entries);
}
