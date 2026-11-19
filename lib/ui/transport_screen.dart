import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio/transport_handler.dart';
import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/database.dart';
import '../data/repository.dart';
import 'theme.dart';

class TransportScreen extends ConsumerStatefulWidget {
  const TransportScreen({super.key, this.initialSituation});

  /// Situation ou thème présélectionné (depuis une liste de vocabulaire).
  final String? initialSituation;

  @override
  ConsumerState<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends ConsumerState<TransportScreen> {
  late String? _situation = widget.initialSituation;
  (int, int)? _progress;
  String? _error;

  bool get _loaded => ref.read(transportProvider).words.isNotEmpty;

  Future<void> _start() async {
    final settings = ref.read(settingsProvider);
    final repo = ref.read(repositoryProvider);
    final transport = ref.read(transportProvider);
    setState(() {
      _error = null;
      _progress = (0, 1);
    });
    try {
      final lang = languageByCode(settings.lang);
      final cache = ref.read(ttsCacheProvider);
      for (final locale in [lang.ttsLocale, frenchTtsLocale]) {
        if (!await cache.isLanguageAvailable(locale)) {
          throw 'La voix « $locale » n\'est pas installée sur ce téléphone. '
              'Ajoutez-la dans Réglages Android › Synthèse vocale.';
        }
      }
      final words = await repo.sessionWords(lang: settings.lang, situation: _situation, size: settings.sessionSize);
      if (words.isEmpty) throw 'Aucun mot à réviser dans cette situation pour le moment.';
      await transport.load(words, settings, onProgress: (d, t) {
        if (mounted) setState(() => _progress = (d, t));
      });
      // play() ne rend la main qu'à la fin de la lecture : ne pas l'attendre.
      unawaited(transport.play());
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _progress = null);
    }
  }

  List<(String, String, bool)> get _choices => ref.watch(situationChoicesProvider).value ?? const [];

  @override
  Widget build(BuildContext context) {
    final transport = ref.watch(transportProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Transport')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String?>(
            // Reconstruit quand la liste des thèmes arrive, pour que la présélection soit valide.
            key: ValueKey(_choices.length),
            initialValue: _choices.any((c) => c.$1 == _situation) ? _situation : null,
            decoration: const InputDecoration(labelText: 'Séance', border: OutlineInputBorder()),
            items: [
              const DropdownMenuItem(value: null, child: Text('Révision du jour (toutes situations)')),
              for (final (key, label, custom) in _choices)
                DropdownMenuItem(value: key, child: Text(custom ? '★ $label' : label)),
            ],
            onChanged: _progress != null ? null : (v) => setState(() => _situation = v),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _progress != null ? null : _start,
            icon: const Icon(Icons.play_arrow),
            label: Text(_loaded ? 'Nouvelle séance' : 'Commencer la séance'),
          ),
          if (_progress != null) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progress!.$1 / _progress!.$2),
            const SizedBox(height: 8),
            Text('Préparation de l\'audio… ${_progress!.$1} / ${_progress!.$2}'
                '\nLa première fois prend un peu de temps, ensuite c\'est immédiat.'),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          if (_loaded && _progress == null) _Player(transport: transport),
          if (!_loaded && _progress == null)
            const Text(
              'Chaque mot est dit dans la langue cible, suivi d\'un silence pour le répéter à voix haute, '
              'puis de sa traduction et d\'une phrase exemple.\n\n'
              'Avec un casque Bluetooth : « précédent » rejoue le mot, « suivant » le marque à revoir.',
            ),
        ],
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.transport});

  final TransportHandler transport;

  @override
  Widget build(BuildContext context) {
    final t = transport;
    return ValueListenableBuilder<int>(
      valueListenable: t.currentWord,
      builder: (context, index, _) => ValueListenableBuilder<Set<String>>(
        valueListenable: t.flagged,
        builder: (context, flagged, _) {
          final List<Word> words = t.words;
          final current = index >= 0 ? words[index] : null;
          final brightness = Theme.of(context).brightness;
          final text = Theme.of(context).textTheme;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: current == null
                      ? const Text('Prêt…', textAlign: TextAlign.center)
                      : Column(children: [
                          Text('Mot ${index + 1} / ${words.length}', style: text.labelMedium),
                          const SizedBox(height: 8),
                          Text(
                            current.withArticle,
                            textAlign: TextAlign.center,
                            style: text.headlineMedium?.copyWith(color: genderColor(current.gender, brightness)),
                          ),
                          if (current.transliteration != null)
                            Text('[${current.transliteration}]', style: text.titleMedium?.copyWith(fontStyle: FontStyle.italic)),
                          if (current.plural != null) Text('pluriel : ${current.plural}', style: text.bodySmall),
                          if (current.forms != null) Text(current.forms!, style: text.bodySmall),
                          const SizedBox(height: 8),
                          Text(current.translationText, style: text.titleMedium, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          Text(current.exampleTarget, style: text.bodyLarge, textAlign: TextAlign.center),
                          if (current.exampleTransliteration != null)
                            Text(current.exampleTransliteration!, style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                          Text(current.exampleFr, style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                        ]),
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<PlaybackState>(
                stream: t.playbackState,
                builder: (context, snap) {
                  final playing = snap.data?.playing ?? false;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton.filledTonal(
                        tooltip: 'Rejouer le mot',
                        iconSize: 32,
                        onPressed: t.skipToPrevious,
                        icon: const Icon(Icons.replay),
                      ),
                      IconButton.filled(
                        tooltip: playing ? 'Pause' : 'Lecture',
                        iconSize: 48,
                        onPressed: playing ? t.pause : t.play,
                        icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Je ne savais pas : à revoir',
                        iconSize: 32,
                        onPressed: t.flagCurrent,
                        icon: const Icon(Icons.flag_outlined),
                      ),
                    ],
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: t.finished,
                builder: (context, done, _) => done
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Séance terminée : ${words.length - flagged.length} mots entendus, ${flagged.length} à revoir. Bravo !',
                          textAlign: TextAlign.center,
                          style: text.titleMedium,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              for (final (i, w) in words.indexed)
                ListTile(
                  dense: true,
                  selected: i == index,
                  leading: flagged.contains(w.id) ? const Icon(Icons.flag, color: Colors.orange) : Text('${i + 1}'),
                  title: Text(w.withArticle, style: TextStyle(color: genderColor(w.gender, brightness))),
                  subtitle: Text(w.translationText),
                  onTap: () => t.jumpTo(i),
                ),
            ],
          );
        },
      ),
    );
  }
}
