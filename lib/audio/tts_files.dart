import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

import 'tts_health.dart';

/// Pré-génère les phrases en fichiers audio avec la synthèse vocale du téléphone,
/// une fois pour toutes : la lecture se fait ensuite par fichiers, sans coupure,
/// écran éteint.
class TtsFileCache {
  final _tts = FlutterTts();
  Directory? _dir;

  Future<Directory> directory() async {
    if (_dir != null) return _dir!;
    final base = await getApplicationSupportDirectory();
    _dir = await Directory('${base.path}/tts').create(recursive: true);
    return _dir!;
  }

  Future<bool> isLanguageAvailable(String locale) async {
    final ok = await _tts.isLanguageAvailable(locale);
    return ok == true || ok == 1;
  }

  /// Fichier audio pour [text] dans la langue [locale], généré s'il manque.
  Future<File> file(String text, String locale, double rate) async {
    final dir = await directory();
    final name = md5.convert(utf8.encode('$locale|$rate|$text')).toString();
    final file = File('${dir.path}/$name.wav');
    if (await file.exists() && await file.length() > 1000) return file;

    // Le moteur natif est partagé avec la grammaire et le compagnon :
    // on fixe la langue et le débit à chaque fois.
    await ensureTtsBound(_tts, locale);
    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(rate);
    await _tts.awaitSynthCompletion(true);
    try {
      await _tts.synthesizeToFile(text, file.path, true).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw TtsUnavailableException(locale);
    }
    // Certains moteurs signalent la fin avant d'avoir fermé le fichier.
    for (var i = 0; i < 20 && !(await file.exists() && await file.length() > 1000); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (!await file.exists()) {
      throw TtsUnavailableException(locale);
    }
    return file;
  }

  Future<void> clear() async {
    final dir = await directory();
    if (await dir.exists()) await dir.delete(recursive: true);
    _dir = null;
  }
}

class TtsUnavailableException implements Exception {
  TtsUnavailableException(this.locale);

  final String locale;

  @override
  String toString() =>
      'La synthèse vocale n\'a pas pu produire l\'audio pour « $locale ». '
      'Installez cette voix dans les réglages Android (Synthèse vocale).';
}
