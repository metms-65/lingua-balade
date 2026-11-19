import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'llm_client.dart';

/// Client minimal pour l'API OpenAI : transcription et conversation.
///
/// MVP personnel : la clé est celle de l'utilisateur. Pour une publication,
/// remplacer [baseUrl] par le proxy du backend, qui détient la clé.
class OpenAiClient implements LlmClient {
  OpenAiClient(
    this.apiKey, {
    required this.sttModel,
    required this.chatModel,
    this.baseUrl = 'https://api.openai.com/v1',
    http.Client? client,
  }) : _http = client ?? http.Client();

  final String apiKey;
  final String sttModel;
  final String chatModel;
  final String baseUrl;
  final http.Client _http;

  Map<String, String> get _auth => {'Authorization': 'Bearer $apiKey'};

  @override
  String get recordingFormat => 'm4a';

  @override
  Future<String> transcribe(File audio, {String? prompt}) => withRetry('OpenAI', (_) => _transcribeOnce(audio, prompt));

  Future<String> _transcribeOnce(File audio, String? prompt) async {
    final req = http.MultipartRequest('POST', Uri.parse('$baseUrl/audio/transcriptions'))
      ..headers.addAll(_auth)
      ..fields['model'] = sttModel
      ..fields['response_format'] = 'json'
      ..files.add(await http.MultipartFile.fromPath('file', audio.path));
    if (prompt != null) req.fields['prompt'] = prompt;
    final res = await http.Response.fromStream(await _http.send(req).timeout(const Duration(seconds: 30)));
    return (_decode(res)['text'] as String? ?? '').trim();
  }

  @override
  Future<String> chat(List<ChatMessage> messages, {bool json = false, int maxTokens = 400}) =>
      withRetry('OpenAI', (_) => _chatOnce(messages, json, maxTokens));

  Future<String> _chatOnce(List<ChatMessage> messages, bool json, int maxTokens) async {
    final res = await _http
        .post(
          Uri.parse('$baseUrl/chat/completions'),
          headers: {..._auth, 'Content-Type': 'application/json'},
          body: jsonEncode({
            'model': chatModel,
            'messages': [
              for (final m in messages) {'role': m.role, 'content': m.content},
            ],
            'max_completion_tokens': maxTokens,
            if (json) 'response_format': {'type': 'json_object'},
          }),
        )
        .timeout(Duration(seconds: (30 * (maxTokens / 600).clamp(1.0, 6.0)).round()));
    final choices = _decode(res)['choices'] as List;
    return ((choices.first as Map)['message']['content'] as String? ?? '').trim();
  }

  Map<String, dynamic> _decode(http.Response res) {
    final body = utf8.decode(res.bodyBytes);
    if (res.statusCode != 200) {
      String detail = body;
      try {
        detail = (jsonDecode(body)['error']['message'] as String?) ?? body;
      } catch (_) {}
      throw httpError('OpenAI', res.statusCode, detail);
    }
    return jsonDecode(body) as Map<String, dynamic>;
  }
}
