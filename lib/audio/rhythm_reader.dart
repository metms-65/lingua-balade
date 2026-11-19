import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/languages.dart';
import 'tts_health.dart';
import '../data/grammar.dart';

enum RhythmMode { rows, columns, chant }

typedef _Segment = ({String text, String locale, int pauseMs, int? row, int? col});

/// Lit un tableau de grammaire en rythme : ligne par ligne, colonne par colonne
/// ou en rengaine. Chaque cellule est lue avec la voix de sa langue.
class RhythmReader {
  final _tts = FlutterTts();
  int _run = 0;

  /// Cellule en cours de lecture (ligne -1 = en-tête), pour la surligner.
  final highlight = ValueNotifier<(int, int)?>(null);
  final playing = ValueNotifier<bool>(false);

  bool _skip(String cell) => cell.trim().isEmpty || cell.trim() == '—';

  /// Colonne de transcription en lettres latines : affichée, jamais lue.
  bool _silent(GrammarContent g, int col) => g.columnLangs[col] == 'translit';

  List<_Segment> _segments(GrammarContent g, RhythmMode mode, String targetLocale) {
    String locale(int col) => g.columnLangs[col] == 'fr' ? frenchTtsLocale : targetLocale;
    final out = <_Segment>[];
    switch (mode) {
      case RhythmMode.rows:
        for (final (r, row) in g.rows.indexed) {
          for (final (c, cell) in row.indexed) {
            if (_skip(cell) || _silent(g, c)) continue;
            out.add((text: cell, locale: locale(c), pauseMs: c == row.length - 1 ? 900 : 300, row: r, col: c));
          }
        }
      case RhythmMode.columns:
        for (var c = 1; c < g.headers.length; c++) {
          if (_silent(g, c)) continue;
          out.add((text: g.headers[c], locale: frenchTtsLocale, pauseMs: 400, row: -1, col: c));
          for (final (r, row) in g.rows.indexed) {
            if (_skip(row[c])) continue;
            out.add((text: row[c], locale: locale(c), pauseMs: r == g.rows.length - 1 ? 1000 : 300, row: r, col: c));
          }
        }
      case RhythmMode.chant:
        final parts = (g.chant ?? '').split('—').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
        for (var round = 0; round < 3; round++) {
          for (final (i, p) in parts.indexed) {
            out.add((text: p, locale: targetLocale, pauseMs: i == parts.length - 1 ? 1500 : 600, row: null, col: null));
          }
        }
    }
    return out;
  }

  Future<void> play(GrammarContent g, RhythmMode mode, String targetLocale, double rate) async {
    final run = ++_run;
    await _tts.stop();
    await ensureTtsBound(_tts, targetLocale);
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(rate);
    playing.value = true;
    String? current;
    try {
      for (final s in _segments(g, mode, targetLocale)) {
        if (run != _run) return;
        if (current != s.locale) {
          await _tts.setLanguage(s.locale);
          current = s.locale;
        }
        highlight.value = s.row == null ? null : (s.row!, s.col!);
        try {
          await _tts.speak(s.text).timeout(speechTimeout(s.text, rate));
        } on TimeoutException {
          await _tts.stop();
        }
        if (run != _run) return;
        await Future<void>.delayed(Duration(milliseconds: s.pauseMs));
      }
    } finally {
      if (run == _run) {
        highlight.value = null;
        playing.value = false;
      }
    }
  }

  /// Lit une phrase isolée (exemple, cellule touchée).
  Future<void> say(String text, String locale, double rate) async {
    await stop();
    try {
      await speakSafely(_tts, text, locale, rate);
    } on SpeechInterruptedException {
      // Lecture d'un mot isolé : rien à signaler, l'utilisateur peut retoucher.
    }
  }

  Future<void> stop() async {
    _run++;
    highlight.value = null;
    playing.value = false;
    await _tts.stop();
  }
}
