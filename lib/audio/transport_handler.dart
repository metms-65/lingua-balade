import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../core/languages.dart';
import '../core/settings.dart';
import '../data/database.dart';
import '../data/repository.dart';
import 'tts_files.dart';
import 'wav.dart';

/// Lecteur « Transport » : enchaîne les fichiers audio des mots d'une séance,
/// en arrière-plan, pilotable depuis l'écran de verrouillage ou un casque Bluetooth.
///
/// Boutons : précédent = rejouer le mot, suivant = « à revoir » puis mot suivant.
class TransportHandler extends BaseAudioHandler {
  TransportHandler(this._tts) {
    _player.playbackEventStream.listen((_) => _broadcastState(), onError: (Object e, StackTrace s) {
      debugPrint('Erreur de lecture : $e');
    });
    _player.playingStream.listen((_) => _broadcastState());
    _player.currentIndexStream.listen(_onSegmentChanged);
    _player.processingStateStream.listen((s) {
      if (s == ProcessingState.completed) _onCompleted();
    });
  }

  final TtsFileCache _tts;
  final _player = AudioPlayer();

  List<Word> _words = [];

  /// Pour chaque segment audio : l'indice du mot (-1 pour l'introduction et la conclusion).
  List<int> _segmentWord = [];
  final List<int> _wordStart = [];
  final Set<String> _heard = {};
  bool _finished = false;

  Future<void> Function(Word word)? onHeard;
  Future<void> Function(Word word)? onFlag;

  final currentWord = ValueNotifier<int>(-1);
  final flagged = ValueNotifier<Set<String>>({});
  final finished = ValueNotifier<bool>(false);

  List<Word> get words => _words;

  /// Génère les fichiers manquants puis prépare la playlist de la séance.
  Future<void> load(
    List<Word> words,
    AppSettings settings, {
    void Function(int done, int total)? onProgress,
  }) async {
    await _player.stop();
    final lang = languageByCode(settings.lang);
    final dir = await _tts.directory();
    final rate = settings.speechRate;
    final repeat = await silenceFile(dir, settings.repeatPauseMs);
    final recall = await silenceFile(dir, settings.recallPauseMs);
    final short = await silenceFile(dir, 700);
    final gap = await silenceFile(dir, 1500);

    final plan = <(int, Future<String> Function())>[];
    Future<String> Function() say(String text, String locale) =>
        () async => (await _tts.file(text, locale, rate)).path;
    Future<String> Function() wait(File file) => () async => file.path;

    plan.add((
      -1,
      say(
        settings.reverseMode
            ? 'Écoutez le mot en français, cherchez-le pendant le silence, puis répétez-le à voix haute.'
            : 'Répétez chaque mot à voix haute pendant le silence.',
        frenchTtsLocale,
      ),
    ));
    plan.add((-1, wait(short)));
    for (final (i, w) in words.indexed) {
      final target = say(w.withArticle, lang.ttsLocale);
      final fr = say(w.translationList.take(2).join(', '), frenchTtsLocale);
      if (settings.reverseMode) {
        plan.addAll([(i, fr), (i, wait(recall)), (i, target), (i, wait(repeat)), (i, target)]);
      } else {
        plan.addAll([(i, target), (i, wait(repeat)), (i, fr), (i, wait(short)), (i, target)]);
      }
      if (settings.includeExample) {
        plan.addAll([(i, wait(short)), (i, say(w.exampleTarget, lang.ttsLocale))]);
      }
      plan.add((i, wait(gap)));
    }
    plan.add((-1, say('Fin de la séance. Bravo !', frenchTtsLocale)));

    final paths = <String>[];
    for (final (n, step) in plan.indexed) {
      paths.add(await step.$2());
      onProgress?.call(n + 1, plan.length);
    }

    _words = words;
    _segmentWord = plan.map((p) => p.$1).toList();
    _wordStart
      ..clear()
      ..addAll(List.generate(words.length, (i) => _segmentWord.indexOf(i)));
    _heard.clear();
    _finished = false;
    finished.value = false;
    flagged.value = {};
    currentWord.value = -1;

    queue.add([for (final w in words) _mediaItem(w)]);
    await _player.setAudioSources([for (final p in paths) AudioSource.file(p)]);
  }

  MediaItem _mediaItem(Word w) => MediaItem(
        id: w.id,
        title: w.withArticle,
        artist: w.translationText,
        album: 'Lingua Balade',
      );

  void _onSegmentChanged(int? index) {
    if (index == null || index >= _segmentWord.length) return;
    final w = _segmentWord[index];
    final previous = currentWord.value;
    if (w == previous) return;
    if (previous >= 0 && w > previous) _markHeard(previous);
    if (w >= 0) {
      currentWord.value = w;
      mediaItem.add(_mediaItem(_words[w]).copyWith(album: 'Mot ${w + 1} / ${_words.length}'));
    }
    _broadcastState();
  }

  void _markHeard(int index) {
    final w = _words[index];
    if (flagged.value.contains(w.id) || !_heard.add(w.id)) return;
    onHeard?.call(w);
  }

  void _onCompleted() {
    if (_finished) return;
    _finished = true;
    if (currentWord.value >= 0) _markHeard(currentWord.value);
    finished.value = true;
    _player.pause();
  }

  Future<void> jumpTo(int wordIndex) async {
    if (wordIndex < 0 || wordIndex >= _wordStart.length) return;
    await _player.seek(Duration.zero, index: _wordStart[wordIndex]);
    if (!_player.playing) unawaited(_player.play());
  }

  /// Signale le mot courant « à revoir » et passe au suivant.
  Future<void> flagCurrent() async {
    final i = currentWord.value;
    if (i < 0) return;
    final w = _words[i];
    flagged.value = {...flagged.value, w.id};
    await onFlag?.call(w);
    if (i + 1 < _words.length) {
      await jumpTo(i + 1);
    } else {
      await _player.seek(Duration.zero, index: _segmentWord.length - 1);
    }
  }

  @override
  Future<void> play() async {
    if (_finished) {
      _finished = false;
      finished.value = false;
      _heard.clear();
      currentWord.value = -1;
      await _player.seek(Duration.zero, index: 0);
    }
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> skipToNext() => flagCurrent();

  @override
  Future<void> skipToPrevious() async {
    final i = currentWord.value;
    if (i >= 0) await jumpTo(i);
  }

  @override
  Future<void> skipToQueueItem(int index) => jumpTo(index);

  void _broadcastState() {
    final playing = _player.playing;
    playbackState.add(PlaybackState(
      controls: [
        const MediaControl(
          androidIcon: 'drawable/audio_service_skip_previous',
          label: 'Rejouer',
          action: MediaAction.skipToPrevious,
        ),
        if (playing) MediaControl.pause else MediaControl.play,
        const MediaControl(
          androidIcon: 'drawable/audio_service_skip_next',
          label: 'À revoir',
          action: MediaAction.skipToNext,
        ),
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      queueIndex: currentWord.value < 0 ? null : currentWord.value,
    ));
  }
}
