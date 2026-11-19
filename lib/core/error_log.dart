import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Journal local des erreurs et des étapes du compagnon, consultable dans les réglages
/// pour diagnostiquer un problème sans ordinateur. Ne contient jamais de clé d'API.
class ErrorLog {
  ErrorLog._();

  static final instance = ErrorLog._();
  static const _maxBytes = 64 * 1024;

  File? _file;

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    _file = File('${dir.path}/journal.txt');
  }

  Future<void> note(String message) async {
    debugPrint('[journal] $message');
    final f = _file;
    if (f == null) return;
    try {
      if (await f.exists() && await f.length() > _maxBytes) {
        final text = await f.readAsString();
        await f.writeAsString(text.substring(text.length - _maxBytes ~/ 2));
      }
      await f.writeAsString('${DateTime.now().toIso8601String().substring(0, 19)} $message\n', mode: FileMode.append);
    } catch (_) {}
  }

  Future<void> error(String context, Object error, [StackTrace? stack]) {
    final frames = stack?.toString().split('\n').where((l) => l.trim().isNotEmpty).take(8).join('\n  ');
    return note('ERREUR $context : $error${frames == null ? '' : '\n  $frames'}');
  }

  Future<String> read() async {
    final f = _file;
    if (f == null || !await f.exists()) return '';
    return f.readAsString();
  }

  Future<void> clear() async {
    final f = _file;
    if (f != null && await f.exists()) await f.delete();
  }
}
