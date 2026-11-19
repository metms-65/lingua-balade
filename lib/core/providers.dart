import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio/rhythm_reader.dart';
import '../audio/transport_handler.dart';
import '../audio/tts_files.dart';
import '../data/database.dart';
import '../data/repository.dart';
import 'languages.dart';
import 'settings.dart';

/// Objets créés dans main() avant le lancement de l'interface.
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('surchargé dans main()'));
final ttsCacheProvider = Provider<TtsFileCache>((ref) => throw UnimplementedError('surchargé dans main()'));
final transportProvider = Provider<TransportHandler>((ref) => throw UnimplementedError('surchargé dans main()'));

final repositoryProvider = Provider((ref) => ContentRepository(ref.watch(databaseProvider)));

final rhythmReaderProvider = Provider((ref) {
  final reader = RhythmReader();
  ref.onDispose(reader.stop);
  return reader;
});

/// Situations intégrées et thèmes de l'utilisateur, pour le Vocabulaire et le Transport :
/// (clé, libellé, thème de l'utilisateur ?), les thèmes d'abord.
final situationChoicesProvider = StreamProvider.autoDispose<List<(String, String, bool)>>((ref) {
  ref.watch(contentReadyProvider);
  final lang = ref.watch(settingsProvider.select((s) => s.lang));
  return ref.watch(repositoryProvider).watchThemes(lang).map((themes) => [
        for (final t in themes) ('$themeKeyPrefix${t.id}', t.label, true),
        for (final e in situationLabels.entries) (e.key, e.value, false),
      ]);
});

/// Importe le contenu de la langue choisie (au premier lancement ou après une mise à jour).
final contentReadyProvider = FutureProvider<void>((ref) async {
  final lang = ref.watch(settingsProvider.select((s) => s.lang));
  await ref.watch(repositoryProvider).importContent(lang);
});
