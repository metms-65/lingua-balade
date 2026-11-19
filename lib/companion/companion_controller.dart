import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../audio/tts_health.dart';
import '../audio/wav.dart';
import '../core/error_log.dart';
import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/repository.dart';
import 'companion_reply.dart';
import 'llm_client.dart';
import 'llm_factory.dart';
import 'prompts.dart';

enum CompanionStatus { idle, recording, transcribing, thinking, speaking, summarizing }

class Turn {
  const Turn({
    required this.fromUser,
    required this.text,
    this.translationFr,
    this.transliteration,
    this.correction,
    this.suggestion,
  });

  final bool fromUser;
  final String text;

  /// Réplique du compagnon : sa traduction française (bouton « Traduction »).
  final String? translationFr;

  /// Réplique du compagnon en lettres latines (grec).
  final String? transliteration;

  /// Phrase de l'utilisateur : sa correction, ou sa version en langue cible s'il a parlé français.
  final Correction? correction;
  final Suggestion? suggestion;

  Turn withFeedback(Correction? correction, Suggestion? suggestion) => Turn(
        fromUser: fromUser,
        text: text,
        translationFr: translationFr,
        transliteration: transliteration,
        correction: correction,
        suggestion: suggestion,
      );
}

class WalkError {
  const WalkError({required this.said, required this.correct, required this.explanation});

  final String said;
  final String correct;
  final String explanation;
}

class WalkSummary {
  const WalkSummary({required this.errors, required this.wordsToReview, required this.encouragement, required this.flagged});

  final List<WalkError> errors;
  final List<String> wordsToReview;
  final String encouragement;

  /// Mots retrouvés dans le vocabulaire et passés « à revoir ».
  final List<String> flagged;
}

class CompanionState {
  const CompanionState({this.turns = const [], this.status = CompanionStatus.idle, this.error, this.summary});

  final List<Turn> turns;
  final CompanionStatus status;
  final String? error;
  final WalkSummary? summary;

  bool get busy => status != CompanionStatus.idle && status != CompanionStatus.recording;

  CompanionState copyWith({List<Turn>? turns, CompanionStatus? status, String? error, WalkSummary? summary, bool clearError = false}) =>
      CompanionState(
        turns: turns ?? this.turns,
        status: status ?? this.status,
        error: clearError ? null : (error ?? this.error),
        summary: summary ?? this.summary,
      );
}

final companionProvider = NotifierProvider<CompanionController, CompanionState>(CompanionController.new);

/// Boucle de conversation : micro → transcription → LLM → voix de la langue cible.
class CompanionController extends Notifier<CompanionState> {
  final _recorder = AudioRecorder();
  final _tts = FlutterTts();
  final _beeper = AudioPlayer();
  String? _recordingPath;

  /// Incrémenté par « Recommencer » : une réponse arrivée ensuite est ignorée.
  int _session = 0;

  @override
  CompanionState build() {
    // Le lecteur reste « en lecture » après la fin d'un bip : on le met en pause
    // pour rendre la priorité audio au micro et à la voix.
    _beeper.processingStateStream.listen((s) {
      if (s == ProcessingState.completed) _beeper.pause();
    });
    ref.onDispose(() {
      _recorder.dispose();
      _tts.stop();
      _beeper.dispose();
    });
    return const CompanionState();
  }

  AppSettings get _settings => ref.read(settingsProvider);
  TargetLanguage get _lang => languageByCode(_settings.lang);

  Future<LlmClient> _client() => buildLlmClient(_settings, ref.read(apiKeyStoreProvider));

  Future<List<ChatMessage>> _messages() async {
    final recent = await ref.read(repositoryProvider).recentWords(_settings.lang);
    final system = companionSystemPrompt(
      companionName: _lang.companionName,
      languageName: _lang.nameFr.toLowerCase(),
      level: _settings.level,
      recentWords: [for (final w in recent) w.withArticle],
      transliterate: _lang.transliterated,
      languageNote: _lang.code == 'la'
          ? 'Parle un latin classique simple et correct ; pour les réalités modernes, emploie des périphrases claires ou le latin moderne courant.'
          : null,
    );
    final history = state.turns.length > 30 ? state.turns.sublist(state.turns.length - 30) : state.turns;
    return [
      ChatMessage('system', system),
      const ChatMessage('user', companionOpening),
      for (final t in history) ChatMessage(t.fromUser ? 'user' : 'assistant', t.text),
    ];
  }

  Future<void> _beep(String name, double hz) async {
    final dir = await getTemporaryDirectory();
    final f = await beepFile(dir, name: name, hz: hz);
    await _beeper.setFilePath(f.path);
    unawaited(_beeper.play());
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  /// Débit de la voix : un peu plus lent pour les grands débutants.
  double get _rate => _settings.level == 'A0' ? _settings.speechRate * 0.85 : _settings.speechRate;

  Future<void> _speak(String text) async {
    state = state.copyWith(status: CompanionStatus.speaking);
    await speakSafely(_tts, text, _lang.ttsLocale, _rate);
  }

  /// Réécouter une réplique ou une phrase proposée, touchée dans la conversation.
  Future<void> speakText(String text) async {
    if (state.busy || state.status == CompanionStatus.recording) return;
    await _guard(() => _speak(text));
  }

  Future<CompanionReply> _ask(LlmClient client) async =>
      CompanionReply.parse(await client.chat(await _messages(), json: true, maxTokens: 600));

  /// Range la correction ou la traduction demandée dans la révision.
  Future<void> _keepForRevision(CompanionReply reply) async {
    final repo = ref.read(repositoryProvider);
    final lang = _settings.lang;
    final c = reply.correction;
    if (c != null) {
      await repo.addRevision(lang: lang, kind: 'correction', prompt: c.said, answer: c.correct, explanation: c.explanation);
    }
    final p = reply.suggestion;
    if (p != null && p.french.isNotEmpty) {
      await repo.addRevision(lang: lang, kind: 'traduction', prompt: p.french, answer: p.target);
    }
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      state = state.copyWith(clearError: true);
      await action();
    } catch (e, stack) {
      await ErrorLog.instance.error('compagnon (${state.status.name})', e, stack);
      state = state.copyWith(error: e.toString());
    } finally {
      if (state.status != CompanionStatus.recording) state = state.copyWith(status: CompanionStatus.idle);
    }
  }

  /// Le compagnon ouvre la conversation.
  Future<void> start() => _guard(() async {
        if (state.turns.isNotEmpty) return;
        final session = _session;
        final client = await _client();
        state = state.copyWith(status: CompanionStatus.thinking);
        final reply = await _ask(client);
        if (session != _session) return;
        state = state.copyWith(turns: [
          Turn(fromUser: false, text: reply.text, translationFr: reply.translationFr, transliteration: reply.transliteration),
        ]);
        await _speak(reply.text);
      });

  /// Bouton « parler » : un appui pour commencer, un appui pour envoyer.
  Future<void> togglePushToTalk() async {
    if (state.status == CompanionStatus.recording) return _sendRecording();
    if (state.busy) return;
    await _guard(() async {
      await _tts.stop();
      final client = await _client();
      if (!await _recorder.hasPermission()) {
        throw ApiException('L\'accès au micro est nécessaire pour parler avec le compagnon.');
      }
      final dir = await getTemporaryDirectory();
      final wav = client.recordingFormat == 'wav';
      _recordingPath = '${dir.path}/balade_${DateTime.now().millisecondsSinceEpoch}.${client.recordingFormat}';
      await _beep('beep_start', 880);
      await _recorder.start(
        RecordConfig(encoder: wav ? AudioEncoder.wav : AudioEncoder.aacLc, sampleRate: 16000, numChannels: 1),
        path: _recordingPath!,
      );
      state = state.copyWith(status: CompanionStatus.recording);
    });
  }

  Future<void> _sendRecording() => _guard(() async {
        final path = await _recorder.stop();
        await ErrorLog.instance.note('enregistrement arrêté : $path');
        state = state.copyWith(status: CompanionStatus.transcribing);
        await _beep('beep_send', 660);
        if (path == null) throw ApiException('L\'enregistrement a échoué.');
        final session = _session;
        final file = File(path);
        await ErrorLog.instance.note('envoi de ${await file.length()} octets à ${_settings.providerName}');
        final client = await _client();
        final String text;
        try {
          text = await client.transcribe(file, prompt: transcriptionPrompt(_lang.nameFr.toLowerCase()));
        } finally {
          // Aucune donnée vocale n'est conservée sur l'appareil.
          if (await file.exists()) await file.delete();
        }
        await ErrorLog.instance.note('transcription : ${text.length} caractères');
        if (text.isEmpty) throw ApiException('Je n\'ai rien entendu. Réessayez en parlant près du micro.');

        state = state.copyWith(turns: [...state.turns, Turn(fromUser: true, text: text)], status: CompanionStatus.thinking);
        final reply = await _ask(client);
        await ErrorLog.instance.note('réponse : ${reply.text.length} caractères'
            '${reply.correction != null ? ', avec correction' : ''}${reply.suggestion != null ? ', avec traduction' : ''}');
        if (session != _session) return;
        final turns = [...state.turns];
        turns[turns.length - 1] = turns.last.withFeedback(reply.correction, reply.suggestion);
        state = state.copyWith(turns: [
          ...turns,
          Turn(fromUser: false, text: reply.text, translationFr: reply.translationFr, transliteration: reply.transliteration),
        ]);
        await _keepForRevision(reply);
        await _beep('beep_reply', 990);
        await _speak(reply.text);
      });

  Future<void> replayLast() => _guard(() async {
        final last = state.turns.lastWhere((t) => !t.fromUser, orElse: () => const Turn(fromUser: false, text: ''));
        if (last.text.isNotEmpty) await _speak(last.text);
      });

  /// Fin de balade : bilan des erreurs, et les mots concernés passent « à revoir ».
  Future<void> endWalk() => _guard(() async {
        await _tts.stop();
        if (!state.turns.any((t) => t.fromUser)) return;
        final client = await _client();
        state = state.copyWith(status: CompanionStatus.summarizing);
        final transcript = [for (final t in state.turns) '${t.fromUser ? 'user' : 'assistant'}: ${t.text}'].join('\n');
        final raw = await client.chat(
          [ChatMessage('system', summaryPrompt(_lang.nameFr.toLowerCase())), ChatMessage('user', transcript)],
          json: true,
          maxTokens: 700,
        );
        final j = jsonDecode(raw) as Map<String, dynamic>;
        final words = List<String>.from(j['mots_a_revoir'] as List? ?? const []);
        final repo = ref.read(repositoryProvider);
        final found = await repo.findWords(_settings.lang, words);
        for (final w in found) {
          await repo.markForReview(w.id);
        }
        state = state.copyWith(
          summary: WalkSummary(
            errors: [
              for (final e in (j['erreurs'] as List? ?? const []).cast<Map<String, dynamic>>())
                WalkError(
                  said: e['dit'] as String? ?? '',
                  correct: e['correct'] as String? ?? '',
                  explanation: e['explication_fr'] as String? ?? '',
                ),
            ],
            wordsToReview: words,
            encouragement: j['encouragement_fr'] as String? ?? '',
            flagged: [for (final w in found) w.withArticle],
          ),
        );
      });

  Future<void> reset() async {
    _session++;
    await _tts.stop();
    if (await _recorder.isRecording()) await _recorder.cancel();
    state = const CompanionState();
  }
}
