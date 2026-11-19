import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/repository.dart';
import '../data/srs.dart';
import 'new_family_screen.dart';
import 'theme.dart';
import 'transport_screen.dart';

class SituationListScreen extends ConsumerWidget {
  const SituationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices = ref.watch(situationChoicesProvider).value ?? const <(String, String, bool)>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulaire'),
        actions: [
          IconButton(
            tooltip: 'Chercher un mot',
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WordSearchScreen())),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: FilledButton.tonalIcon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewFamilyScreen())),
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle famille de mots'),
            ),
          ),
          for (final (key, label, custom) in choices)
            ListTile(
              leading: custom ? const Icon(Icons.star_outline) : null,
              title: Text(label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WordListScreen(situation: key, title: label)),
              ),
              onLongPress: custom ? () => _confirmDelete(context, ref, key, label) : null,
            ),
          if (choices.any((c) => c.$3))
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Appui long sur une famille ★ pour la supprimer.', textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String key, String label) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer « $label » ?'),
        content: const Text('Les mots ajoutés pour cette famille seront supprimés. '
            'Les mots communs avec les autres listes, et leur progression, sont conservés.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true) await ref.read(repositoryProvider).deleteTheme(key.substring(themeKeyPrefix.length));
  }
}

final _wordsProvider = StreamProvider.autoDispose.family<List<WordWithProgress>, String>((ref, situation) {
  final lang = ref.watch(settingsProvider.select((s) => s.lang));
  return ref.watch(repositoryProvider).watchWords(lang, situation);
});

class WordListScreen extends ConsumerWidget {
  const WordListScreen({super.key, required this.situation, required this.title});

  final String situation;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(_wordsProvider(situation));
    final settings = ref.watch(settingsProvider);
    final locale = languageByCode(settings.lang).ttsLocale;
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TransportScreen(initialSituation: situation)),
        ),
        icon: const Icon(Icons.directions_walk),
        label: const Text('Écouter en Transport'),
      ),
      body: words.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => ListView.separated(
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: list.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final item = list[i];
            final w = item.word;
            return ListTile(
              title: Text(
                w.note == null ? w.withArticle : '${w.withArticle} (${w.note})',
                style: TextStyle(color: genderColor(w.gender, brightness), fontWeight: FontWeight.w600),
              ),
              subtitle: Text([
                if (w.transliteration != null) '[${w.transliteration}]',
                w.translationText,
                if (w.article == null && w.pos == 'noun' && genderAbbreviation(w.gender) != null)
                  genderAbbreviation(w.gender)!,
                if (w.plural != null) 'pl. ${w.plural}',
                if (w.forms != null) w.forms!,
              ].join(' · ')),
              trailing: _BoxDots(box: item.box),
              onTap: () => ref.read(rhythmReaderProvider).say(w.withArticle, locale, settings.speechRate),
              onLongPress: () => showModalBottomSheet<void>(
                context: context,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(w.exampleTarget, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(w.exampleFr, style: const TextStyle(fontStyle: FontStyle.italic)),
                    const SizedBox(height: 16),
                    FilledButton.tonalIcon(
                      onPressed: () => ref.read(rhythmReaderProvider).say(w.exampleTarget, locale, settings.speechRate),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Écouter l\'exemple'),
                    ),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Avancement dans les boîtes de Leitner, en points.
class _BoxDots extends StatelessWidget {
  const _BoxDots({required this.box});

  final int box;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= maxBox; i++)
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(left: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= box ? color : color.withValues(alpha: 0.18),
            ),
          ),
      ],
    );
  }
}

/// Recherche d'un mot dans tout le vocabulaire (allemand ou français).
class WordSearchScreen extends ConsumerStatefulWidget {
  const WordSearchScreen({super.key});

  @override
  ConsumerState<WordSearchScreen> createState() => _WordSearchScreenState();
}

class _WordSearchScreenState extends ConsumerState<WordSearchScreen> {
  List<WordWithProgress> _results = [];
  String _query = '';

  Future<void> _search(String q) async {
    _query = q;
    final lang = ref.read(settingsProvider).lang;
    final results = await ref.read(repositoryProvider).searchWords(lang, q);
    if (mounted && q == _query) setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final locale = languageByCode(settings.lang).ttsLocale;
    final brightness = Theme.of(context).brightness;
    final labels = {for (final (k, l, _) in ref.watch(situationChoicesProvider).value ?? const <(String, String, bool)>[]) k: l};
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Mot allemand ou français', border: InputBorder.none),
          onChanged: _search,
        ),
      ),
      body: _results.isEmpty
          ? Center(child: Text(_query.trim().length < 2 ? 'Tapez au moins deux lettres.' : 'Aucun mot trouvé.'))
          : ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final w = _results[i].word;
                return ListTile(
                  title: Text(
                    w.withArticle,
                    style: TextStyle(color: genderColor(w.gender, brightness), fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text([
                    if (w.transliteration != null) '[${w.transliteration}]',
                    w.translationText,
                    if (labels[w.situation] != null) labels[w.situation]!,
                  ].join(' · ')),
                  trailing: const Icon(Icons.volume_up_outlined),
                  onTap: () => ref.read(rhythmReaderProvider).say(w.withArticle, locale, settings.speechRate),
                );
              },
            ),
    );
  }
}

