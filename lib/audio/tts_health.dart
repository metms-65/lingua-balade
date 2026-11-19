import 'dart:async';
import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

import '../core/error_log.dart';

/// Android coupe la connexion au moteur de synthèse vocale quand celui-ci est mis à jour
/// par le Play Store. flutter_tts ne s'en aperçoit pas toujours : la phrase suivante reste
/// alors en attente pour toujours. On vérifie donc la connexion avant de parler et on la
/// recrée si besoin.
Future<void> ensureTtsBound(FlutterTts tts, String locale) async {
  if (!Platform.isAndroid) return;
  bool ok;
  try {
    final r = await tts.isLanguageAvailable(locale).timeout(const Duration(seconds: 3));
    ok = r == true || r == 1;
  } catch (_) {
    ok = false;
  }
  if (ok) return;
  await ErrorLog.instance.note('synthèse vocale déconnectée : reconnexion du moteur');
  try {
    final engine = await tts.getDefaultEngine.timeout(const Duration(seconds: 3)) as String?;
    await tts.setEngine(engine ?? 'com.google.android.tts').timeout(const Duration(seconds: 10));
  } catch (e, s) {
    await ErrorLog.instance.error('reconnexion de la synthèse vocale', e, s);
  }
}

/// Durée maximale raisonnable pour dire [text] : au-delà, on cesse d'attendre.
Duration speechTimeout(String text, double rate) {
  final perChar = (90 / (rate / 0.5).clamp(0.4, 2.0)).round();
  return Duration(milliseconds: 5000 + text.length * perChar);
}

class SpeechInterruptedException implements Exception {
  @override
  String toString() => 'La voix s\'est interrompue. Touchez « Réécouter » pour entendre la réponse.';
}

/// Dit [text] et attend la fin, sans jamais rester bloqué.
Future<void> speakSafely(FlutterTts tts, String text, String locale, double rate) async {
  await ensureTtsBound(tts, locale);
  await tts.awaitSpeakCompletion(true);
  await tts.setLanguage(locale);
  await tts.setSpeechRate(rate);
  try {
    await tts.speak(text).timeout(speechTimeout(text, rate));
  } on TimeoutException {
    await tts.stop();
    await ErrorLog.instance.note('synthèse vocale : pas de fin de phrase après ${speechTimeout(text, rate).inSeconds} s');
    throw SpeechInterruptedException();
  }
}
