import 'dart:convert';

/// Correction d'une phrase de l'utilisateur.
class Correction {
  const Correction({required this.said, required this.correct, required this.explanation});

  final String said;
  final String correct;
  final String explanation;
}

/// Phrase dite en français, et sa version dans la langue cible.
class Suggestion {
  const Suggestion({required this.french, required this.target});

  final String french;
  final String target;
}

/// Réponse structurée du compagnon.
class CompanionReply {
  const CompanionReply({required this.text, this.translationFr, this.transliteration, this.correction, this.suggestion});

  /// Réplique en langue cible, lue à voix haute.
  final String text;
  final String? translationFr;

  /// Réplique en lettres latines (grec).
  final String? transliteration;
  final Correction? correction;
  final Suggestion? suggestion;

  /// Lit la réponse JSON du modèle. Si elle n'est pas du JSON valide, le texte brut
  /// devient la réplique : la conversation continue quoi qu'il arrive.
  factory CompanionReply.parse(String raw) {
    var s = raw.trim();
    final fence = RegExp(r'^```(?:json)?\s*([\s\S]*?)\s*```$').firstMatch(s);
    if (fence != null) s = fence.group(1)!;
    Map<String, dynamic>? j;
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) j = decoded;
    } catch (_) {
      final start = s.indexOf('{');
      final end = s.lastIndexOf('}');
      if (start >= 0 && end > start) {
        try {
          j = jsonDecode(s.substring(start, end + 1)) as Map<String, dynamic>;
        } catch (_) {}
      }
    }
    final text = (j?['reponse'] as String?)?.trim();
    if (j == null || text == null || text.isEmpty) return CompanionReply(text: raw.trim());

    String? str(Object? v) => v is String && v.trim().isNotEmpty ? v.trim() : null;
    final c = j['correction'];
    final p = j['proposition'];
    Correction? correction;
    if (c is Map && str(c['correct']) != null && str(c['dit']) != null && str(c['dit']) != str(c['correct'])) {
      correction = Correction(said: str(c['dit'])!, correct: str(c['correct'])!, explanation: str(c['explication_fr']) ?? '');
    }
    Suggestion? suggestion;
    if (p is Map && str(p['cible']) != null) {
      suggestion = Suggestion(french: str(p['fr']) ?? '', target: str(p['cible'])!);
    }
    return CompanionReply(
      text: text,
      translationFr: str(j['traduction_fr']),
      transliteration: str(j['translitteration']),
      correction: correction,
      suggestion: suggestion,
    );
  }
}
