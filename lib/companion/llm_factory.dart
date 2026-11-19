import '../core/error_log.dart';
import '../core/settings.dart';
import 'gemini_client.dart';
import 'llm_client.dart';
import 'openai_client.dart';

/// Client du fournisseur choisi dans les réglages, avec la clé de l'utilisateur.
Future<LlmClient> buildLlmClient(AppSettings s, ApiKeyStore keys) async {
  final key = await keys.read(s.provider);
  if (key == null || key.isEmpty) {
    throw ApiException('Ajoutez votre clé d\'API ${s.providerName} dans les réglages.');
  }
  return s.provider == 'gemini'
      ? GeminiClient(key, model: s.geminiModel, onNote: ErrorLog.instance.note)
      : OpenAiClient(key, sttModel: s.sttModel, chatModel: s.chatModel);
}
