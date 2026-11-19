import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio/transport_handler.dart';
import 'audio/tts_files.dart';
import 'core/error_log.dart';
import 'core/providers.dart';
import 'core/settings.dart';
import 'data/database.dart';
import 'data/repository.dart';
import 'ui/home_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ErrorLog.instance.init();
  await ErrorLog.instance.note('--- démarrage de l\'application ---');
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorLog.instance.error('interface', details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorLog.instance.error('non interceptée', error, stack);
    return true;
  };
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase();
  final repo = ContentRepository(db);
  final tts = TtsFileCache();

  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.speech());

  final transport = await AudioService.init(
    builder: () => TransportHandler(tts),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'fr.metms.lingua_balade.transport',
      androidNotificationChannelName: 'Lecture Transport',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  transport
    ..onHeard = ((w) => repo.markHeard(w.id))
    ..onFlag = ((w) => repo.markForReview(w.id));

  runApp(ProviderScope(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      databaseProvider.overrideWithValue(db),
      repositoryProvider.overrideWithValue(repo),
      ttsCacheProvider.overrideWithValue(tts),
      transportProvider.overrideWithValue(transport),
    ],
    child: const LinguaBaladeApp(),
  ));
}

class LinguaBaladeApp extends StatelessWidget {
  const LinguaBaladeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Lingua Balade',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        home: const HomeScreen(),
      );
}
