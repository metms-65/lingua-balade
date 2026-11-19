import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingua_balade/companion/companion_reply.dart';
import 'package:lingua_balade/data/database.dart';
import 'package:lingua_balade/data/repository.dart';

void main() {
  group('lecture des réponses du compagnon', () {
    test('réponse complète avec correction', () {
      final r = CompanionReply.parse('''
{"reponse":"Ah, du meinst: Ich bin müde. Warum bist du müde?","traduction_fr":"Ah, tu veux dire : je suis fatigué. Pourquoi es-tu fatigué ?",
 "correction":{"dit":"Ich habe müde","correct":"Ich bin müde","explication_fr":"Avec müde, on emploie sein."},"proposition":null}''');
      expect(r.text, startsWith('Ah, du meinst'));
      expect(r.translationFr, contains('fatigué'));
      expect(r.correction!.correct, 'Ich bin müde');
      expect(r.suggestion, isNull);
    });

    test('phrase en français : proposition dans la langue cible', () {
      final r = CompanionReply.parse('```json\n{"reponse":"Sag: Ich möchte einen Kaffee.","traduction_fr":"Dis : je voudrais un café.",'
          '"correction":null,"proposition":{"fr":"je voudrais un café","cible":"Ich möchte einen Kaffee."}}\n```');
      expect(r.suggestion!.target, 'Ich möchte einen Kaffee.');
      expect(r.suggestion!.french, 'je voudrais un café');
      expect(r.correction, isNull);
    });

    test('une « correction » identique à la phrase dite est ignorée', () {
      final r = CompanionReply.parse('{"reponse":"Super!","correction":{"dit":"Ich bin müde","correct":"Ich bin müde"}}');
      expect(r.correction, isNull);
    });

    test('un texte non structuré reste utilisable', () {
      final r = CompanionReply.parse('Hallo! Worüber möchtest du sprechen?');
      expect(r.text, 'Hallo! Worüber möchtest du sprechen?');
      expect(r.translationFr, isNull);
    });

    test('du JSON entouré de texte est quand même lu', () {
      final r = CompanionReply.parse('Voici : {"reponse":"Hallo!","traduction_fr":"Salut !"} Bonne journée');
      expect(r.text, 'Hallo!');
      expect(r.translationFr, 'Salut !');
    });
  });

  group('révision', () {
    late AppDatabase db;
    late ContentRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = ContentRepository(db);
    });
    tearDown(() => db.close());

    test('les éléments sont rangés sans doublon et à travailler tout de suite', () async {
      for (var i = 0; i < 2; i++) {
        await repo.addRevision(lang: 'de', kind: 'traduction', prompt: 'je voudrais un café', answer: 'Ich möchte einen Kaffee.');
      }
      await repo.addRevision(lang: 'de', kind: 'correction', prompt: 'Ich habe müde', answer: 'Ich bin müde', explanation: 'sein');
      final due = await repo.dueRevisions('de');
      expect(due, hasLength(2));
      expect(await repo.watchDueRevisionCount('de').first, 2);
    });

    test('« Je savais » repousse l\'élément, « À revoir » le garde pour aujourd\'hui', () async {
      await repo.addRevision(lang: 'de', kind: 'correction', prompt: 'a', answer: 'A');
      await repo.addRevision(lang: 'de', kind: 'correction', prompt: 'b', answer: 'B');
      final items = await repo.dueRevisions('de');
      await repo.answerRevision(items.firstWhere((i) => i.answer == 'A'), known: true);
      await repo.answerRevision(items.firstWhere((i) => i.answer == 'B'), known: false);
      final again = await repo.dueRevisions('de');
      expect(again.map((i) => i.answer), ['B']);
    });
  });
}
