import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lingua_balade/companion/gemini_client.dart';
import 'package:lingua_balade/companion/llm_client.dart';

http.Response _reply(String text) => http.Response.bytes(
      utf8.encode(jsonEncode({
        'candidates': [
          {
            'content': {
              'parts': [
                {'text': 'réflexion interne', 'thought': true},
                {'text': text},
              ],
            },
          },
        ],
      })),
      200,
    );

void main() {
  setUp(GeminiClient.resetFallback);

  test('la conversation envoie le prompt système à part et les rôles Gemini', () async {
    late Map<String, dynamic> sent;
    late http.Request request;
    final client = GeminiClient('clé', model: 'gemini-test', client: MockClient((req) async {
      request = req;
      sent = jsonDecode(req.body) as Map<String, dynamic>;
      return _reply('Hallo! Wie geht\'s?');
    }));

    final answer = await client.chat(const [
      ChatMessage('system', 'Tu es Lukas.'),
      ChatMessage('user', 'Bonjour'),
      ChatMessage('assistant', 'Hallo!'),
      ChatMessage('user', 'Ich bin müde.'),
    ]);

    expect(answer, 'Hallo! Wie geht\'s?');
    expect(request.url.path, endsWith('/models/gemini-test:generateContent'));
    expect(request.headers['x-goog-api-key'], 'clé');
    expect(sent['systemInstruction']['parts'][0]['text'], 'Tu es Lukas.');
    expect([for (final c in sent['contents'] as List) c['role']], ['user', 'model', 'user']);
  });

  test('la transcription envoie l\'audio en WAV', () async {
    final dir = await Directory.systemTemp.createTemp();
    final wav = File('${dir.path}/a.wav')..writeAsBytesSync([1, 2, 3]);
    late Map<String, dynamic> sent;
    final client = GeminiClient('clé', model: 'm', client: MockClient((req) async {
      sent = jsonDecode(req.body) as Map<String, dynamic>;
      return _reply(' Ich habe Hunger. ');
    }));

    expect(await client.transcribe(wav, prompt: 'Transcris.'), 'Ich habe Hunger.');
    final audio = sent['contents'][0]['parts'][0]['inline_data'];
    expect(audio['mime_type'], 'audio/wav');
    expect(base64Decode(audio['data'] as String), [1, 2, 3]);
    await dir.delete(recursive: true);
  });

  test('un modèle saturé est réessayé, puis remplacé par le modèle léger', () async {
    final models = <String>[];
    final client = GeminiClient('clé', model: 'principal', fallbackModel: 'leger', client: MockClient((req) async {
      final m = RegExp(r'models/([^:]+):').firstMatch(req.url.path)!.group(1)!;
      models.add(m);
      if (m == 'principal') {
        return http.Response(jsonEncode({'error': {'message': 'This model is currently experiencing high demand.'}}), 503);
      }
      return _reply('Hallo!');
    }));
    expect(await client.chat(const [ChatMessage('user', 'Hallo')]), 'Hallo!');
    expect(models, ['principal', 'leger']);

    // La bascule est mémorisée : l'appel suivant va directement au modèle léger.
    models.clear();
    expect(await client.chat(const [ChatMessage('user', 'Noch einmal')]), 'Hallo!');
    expect(models, ['leger']);
  });

  test('une clé refusée donne un message clair', () async {
    final client = GeminiClient('mauvaise', model: 'm', client: MockClient((_) async {
      return http.Response(jsonEncode({'error': {'message': 'API key not valid'}}), 400);
    }));
    await expectLater(
      client.chat(const [ChatMessage('user', 'Hallo')]),
      throwsA(isA<ApiException>().having((e) => e.message, 'message', contains('Clé d\'API refusée'))),
    );
  });
}
