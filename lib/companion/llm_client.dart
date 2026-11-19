import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

class ChatMessage {
  const ChatMessage(this.role, this.content);

  final String role; // system | user | assistant
  final String content;
}

class ApiException implements Exception {
  ApiException(this.message, {this.retryable = false});

  final String message;

  /// Erreur passagère (serveur saturé, délai dépassé) : la requête peut être relancée.
  final bool retryable;

  @override
  String toString() => message;
}

bool _retryableStatus(int status) => status == 429 || status >= 500;

ApiException httpError(String provider, int status, String detail) =>
    ApiException(httpErrorMessage(provider, status, detail), retryable: _retryableStatus(status));

/// Exécute [attempt] (qui reçoit le numéro de tentative, à partir de 0) et le relance
/// après une courte pause tant que l'erreur est passagère.
Future<T> withRetry<T>(
  String provider,
  Future<T> Function(int attempt) attempt, {
  int tries = 4,
  Duration Function(int attempt)? pause,
}) async {
  for (var i = 0;; i++) {
    try {
      return await attempt(i);
    } on TimeoutException {
      if (i + 1 >= tries) {
        throw ApiException('$provider ne répond pas (réseau lent ou serveurs saturés). Réessayez dans un instant.');
      }
    } on SocketException {
      throw ApiException('Pas de connexion Internet : le compagnon a besoin du réseau.');
    } on http.ClientException {
      if (i + 1 >= tries) throw ApiException('Connexion à $provider interrompue. Réessayez.');
    } on ApiException catch (e) {
      if (!e.retryable || i + 1 >= tries) rethrow;
    }
    await Future<void>.delayed(pause?.call(i) ?? Duration(milliseconds: 1500 * (i + 1)));
  }
}

/// Fournisseur d'IA du compagnon : transcription de la voix et conversation.
abstract class LlmClient {
  /// Format d'enregistrement attendu par le fournisseur (« m4a » ou « wav »).
  String get recordingFormat;

  Future<String> transcribe(File audio, {String? prompt});

  Future<String> chat(List<ChatMessage> messages, {bool json = false, int maxTokens = 400});
}

String httpErrorMessage(String provider, int status, String detail) => switch (status) {
      400 when detail.contains('API key') => 'Clé d\'API refusée. Vérifiez-la dans les réglages.',
      400 => 'Requête refusée par $provider : $detail',
      401 || 403 => 'Clé d\'API refusée. Vérifiez-la dans les réglages.',
      404 => 'Modèle introuvable : vérifiez son nom dans les réglages. ($detail)',
      429 => 'Quota $provider atteint pour le moment. Réessayez dans une minute.',
      >= 500 => 'Les serveurs de $provider sont saturés. Réessayez dans un instant.',
      _ => 'Erreur $status : $detail',
    };
