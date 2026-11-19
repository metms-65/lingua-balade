import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'llm_client.dart';

/// Client pour l'API Gemini de Google (generateContent).
///
/// Gemini n'a pas de service de transcription séparé : l'enregistrement est
/// envoyé au modèle avec la consigne de le transcrire mot pour mot.
class GeminiClient implements LlmClient {
  GeminiClient(
    this.apiKey, {
    required this.model,
    this.fallbackModel = 'gemini-flash-lite-latest',
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta',
    this.onNote,
    http.Client? client,
  }) : _http = client ?? http.Client();

  /// Quand le modèle principal est saturé et que le modèle léger a répondu,
  /// on garde le modèle léger un moment au lieu de retenter le principal à chaque fois.
  static DateTime? _fallbackUntil;
  static const _fallbackStickiness = Duration(minutes: 15);

  /// Pour tests : oublie la bascule mémorisée.
  static void resetFallback() => _fallbackUntil = null;

  final String apiKey;
  final String model;

  /// Modèle plus léger, essayé quand [model] reste saturé.
  final String fallbackModel;
  final String baseUrl;

  /// Reçoit la durée de chaque essai, pour le journal.
  final void Function(String message)? onNote;
  final http.Client _http;

  @override
  String get recordingFormat => 'wav';

  @override
  Future<String> transcribe(File audio, {String? prompt}) async {
    final bytes = await audio.readAsBytes();
    return _generate(
      system: '${prompt ?? ''}\nRéponds uniquement par la transcription, sans guillemets ni commentaire. '
          'S\'il n\'y a aucune parole, réponds par une chaîne vide.',
      contents: [
        {
          'role': 'user',
          'parts': [
            {
              'inline_data': {'mime_type': 'audio/wav', 'data': base64Encode(bytes)},
            },
          ],
        },
      ],
      maxTokens: 300,
      temperature: 0,
    );
  }

  @override
  Future<String> chat(List<ChatMessage> messages, {bool json = false, int maxTokens = 400}) {
    final system = messages.where((m) => m.role == 'system').map((m) => m.content).join('\n\n');
    return _generate(
      system: system,
      contents: [
        for (final m in messages.where((m) => m.role != 'system'))
          {
            'role': m.role == 'assistant' ? 'model' : 'user',
            'parts': [
              {'text': m.content},
            ],
          },
      ],
      maxTokens: maxTokens,
      json: json,
    );
  }

  Future<String> _generate({
    required String system,
    required List<Map<String, Object>> contents,
    required int maxTokens,
    bool json = false,
    double? temperature,
  }) =>
      _withSchedule(maxTokens, (m, timeout) => _generateOnce(
            m,
            timeout: timeout,
            system: system,
            contents: contents,
            maxTokens: maxTokens,
            json: json,
            temperature: temperature,
          ));

  /// Le modèle principal, souvent saturé, n'a jamais plus de [max] secondes au premier essai.
  static Duration _cap(Duration d, int max) => d > Duration(seconds: max) ? Duration(seconds: max) : d;

  /// Ordre des essais : le modèle principal a peu de temps pour répondre ; s'il est
  /// saturé, on passe vite au modèle léger, et on s'en souvient.
  Future<String> _withSchedule(int maxTokens, Future<String> Function(String model, Duration timeout) call) {
    // Les longues réponses (liste de vocabulaire) ont droit à plus de temps.
    final scale = (maxTokens / 600).clamp(1.0, 6.0);
    Duration secs(int s) => Duration(milliseconds: (s * 1000 * scale).round());
    final sticky = _fallbackUntil != null && DateTime.now().isBefore(_fallbackUntil!);
    final schedule = fallbackModel == model
        ? [(model, secs(30)), (model, secs(30)), (model, secs(30))]
        : sticky
            ? [(fallbackModel, secs(30)), (fallbackModel, secs(30)), (model, secs(20))]
            : [(model, _cap(secs(12), 25)), (fallbackModel, secs(30)), (fallbackModel, secs(30)), (model, secs(20))];
    return withRetry(
      'Gemini',
      (attempt) async {
        final (m, timeout) = schedule[attempt];
        final watch = Stopwatch()..start();
        try {
          final out = await call(m, timeout);
          onNote?.call('Gemini $m : ${(watch.elapsedMilliseconds / 1000).toStringAsFixed(1)} s');
          if (m == fallbackModel && m != model) {
            _fallbackUntil = DateTime.now().add(_fallbackStickiness);
          } else if (m == model) {
            _fallbackUntil = null;
          }
          return out;
        } catch (e) {
          final why = e is TimeoutException ? 'pas de réponse' : e.toString();
          onNote?.call('Gemini $m : échec après ${(watch.elapsedMilliseconds / 1000).toStringAsFixed(1)} s ($why)');
          rethrow;
        }
      },
      tries: schedule.length,
      pause: (_) => const Duration(milliseconds: 400),
    );
  }

  Future<String> _generateOnce(
    String model, {
    required Duration timeout,
    required String system,
    required List<Map<String, Object>> contents,
    required int maxTokens,
    required bool json,
    double? temperature,
  }) async {
    final res = await _http
        .post(
          Uri.parse('$baseUrl/models/$model:generateContent'),
          headers: {'x-goog-api-key': apiKey, 'Content-Type': 'application/json'},
          body: jsonEncode({
            if (system.isNotEmpty)
              'systemInstruction': {
                'parts': [
                  {'text': system},
                ],
              },
            'contents': contents,
            'generationConfig': {
              // Les modèles « thinking » consomment aussi ce budget : on garde de la marge.
              'maxOutputTokens': maxTokens + 1024,
              'temperature': ?temperature,
              if (json) 'responseMimeType': 'application/json',
            },
          }),
        )
        .timeout(timeout);
    final body = utf8.decode(res.bodyBytes);
    if (res.statusCode != 200) {
      String detail = body;
      try {
        detail = (jsonDecode(body)['error']['message'] as String?) ?? body;
      } catch (_) {}
      throw httpError('Gemini', res.statusCode, detail);
    }
    final j = jsonDecode(body) as Map<String, dynamic>;
    final candidates = j['candidates'] as List? ?? const [];
    if (candidates.isEmpty) {
      throw ApiException('Gemini n\'a pas répondu (${j['promptFeedback'] ?? 'réponse vide'}).', retryable: true);
    }
    final parts = ((candidates.first as Map)['content']?['parts'] as List?) ?? const [];
    return parts
        .where((p) => p is Map && p['thought'] != true && p['text'] is String)
        .map((p) => (p as Map)['text'] as String)
        .join()
        .trim();
  }
}
