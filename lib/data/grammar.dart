import 'dart:convert';

/// Fiche de grammaire, lue depuis le JSON stocké en base.
class GrammarContent {
  GrammarContent({
    required this.id,
    required this.title,
    required this.level,
    required this.summaryFr,
    required this.chant,
    required this.headers,
    required this.columnGenders,
    required this.columnLangs,
    required this.rows,
    required this.examples,
  });

  factory GrammarContent.fromJson(Map<String, dynamic> j) {
    final table = j['table'] as Map<String, dynamic>;
    final headers = List<String>.from(table['headers'] as List);
    return GrammarContent(
      id: j['id'] as String,
      title: j['title'] as String,
      level: j['level'] as String,
      summaryFr: j['summary_fr'] as String,
      chant: j['chant'] as String?,
      headers: headers,
      columnGenders: List<String?>.from(table['column_genders'] as List? ?? List.filled(headers.length, null)),
      columnLangs: List<String>.from(table['column_langs'] as List? ?? List.filled(headers.length, 'target')),
      rows: [for (final r in table['rows'] as List) List<String>.from(r as List)],
      examples: [
        for (final e in j['examples'] as List? ?? const [])
          (target: (e as Map)['target'] as String, fr: e['fr'] as String),
      ],
    );
  }

  factory GrammarContent.decode(String body) => GrammarContent.fromJson(jsonDecode(body) as Map<String, dynamic>);

  final String id;
  final String title;
  final String level;
  final String summaryFr;
  final String? chant;
  final List<String> headers;
  final List<String?> columnGenders;

  /// « fr » ou « target » : la voix à utiliser pour chaque colonne.
  final List<String> columnLangs;
  final List<List<String>> rows;
  final List<({String target, String fr})> examples;
}
