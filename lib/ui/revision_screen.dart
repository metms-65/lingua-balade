import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/database.dart';

final _revisionsProvider = StreamProvider.autoDispose<List<RevisionItem>>((ref) {
  final lang = ref.watch(settingsProvider.select((s) => s.lang));
  return ref.watch(repositoryProvider).watchRevisions(lang);
});

final dueRevisionCountProvider = StreamProvider.autoDispose<int>((ref) {
  ref.watch(contentReadyProvider);
  final lang = ref.watch(settingsProvider.select((s) => s.lang));
  return ref.watch(repositoryProvider).watchDueRevisionCount(lang);
});

/// Corrections et traductions recueillies pendant les balades, à retravailler.
class RevisionScreen extends ConsumerWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(_revisionsProvider);
    final due = ref.watch(dueRevisionCountProvider).value ?? 0;
    final settings = ref.watch(settingsProvider);
    final locale = languageByCode(settings.lang).ttsLocale;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Révision')),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => list.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Les corrections de Lukas et les phrases que vous lui demandez de traduire '
                    'arriveront ici, pour les retravailler.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FilledButton.icon(
                    onPressed: due == 0
                        ? null
                        : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _PracticeScreen())),
                    icon: const Icon(Icons.school_outlined),
                    label: Text(due == 0 ? 'Tout est révisé pour aujourd\'hui' : 'S\'entraîner ($due)'),
                  ),
                  const SizedBox(height: 16),
                  Text('${list.length} phrases recueillies · glisser pour supprimer', style: text.labelMedium),
                  const SizedBox(height: 8),
                  for (final item in list)
                    Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: const Icon(Icons.delete_outline),
                      ),
                      onDismissed: (_) => ref.read(repositoryProvider).deleteRevision(item.id),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(item.kind == 'correction' ? Icons.lightbulb_outline : Icons.translate),
                        title: Text(item.answer, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(item.kind == 'correction' ? 'Vous aviez dit : ${item.prompt}' : item.prompt),
                        trailing: IconButton(
                          tooltip: 'Écouter',
                          icon: const Icon(Icons.volume_up_outlined),
                          onPressed: () => ref.read(rhythmReaderProvider).say(item.answer, locale, settings.speechRate),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _PracticeScreen extends ConsumerStatefulWidget {
  const _PracticeScreen();

  @override
  ConsumerState<_PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<_PracticeScreen> {
  List<RevisionItem>? _queue;
  int _index = 0;
  bool _revealed = false;
  int _known = 0;

  @override
  void initState() {
    super.initState();
    ref.read(repositoryProvider).dueRevisions(ref.read(settingsProvider).lang).then((q) {
      if (mounted) setState(() => _queue = q);
    });
  }

  void _say(String text) {
    final s = ref.read(settingsProvider);
    ref.read(rhythmReaderProvider).say(text, languageByCode(s.lang).ttsLocale, s.speechRate);
  }

  Future<void> _answer(bool known) async {
    await ref.read(repositoryProvider).answerRevision(_queue![_index], known: known);
    setState(() {
      if (known) _known++;
      _index++;
      _revealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final queue = _queue;
    final text = Theme.of(context).textTheme;
    final target = languageByCode(ref.watch(settingsProvider).lang).nameFr.toLowerCase();
    if (queue == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (_index >= queue.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Entraînement')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Terminé !', style: text.headlineSmall),
              const SizedBox(height: 8),
              Text('$_known / ${queue.length} trouvées du premier coup. Les autres reviendront bientôt.', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Retour')),
            ]),
          ),
        ),
      );
    }

    final item = queue[_index];
    final isCorrection = item.kind == 'correction';
    return Scaffold(
      appBar: AppBar(title: Text('Entraînement ${_index + 1} / ${queue.length}')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(isCorrection ? 'Comment le dire correctement ?' : 'Comment dit-on en $target ?', style: text.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                isCorrection ? item.prompt : '« ${item.prompt} »',
                style: text.headlineSmall?.copyWith(
                  decoration: isCorrection ? TextDecoration.lineThrough : null,
                  decorationColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Dites votre réponse à voix haute, puis vérifiez.', style: text.bodySmall),
          const SizedBox(height: 24),
          if (!_revealed)
            FilledButton.tonal(
              onPressed: () {
                setState(() => _revealed = true);
                _say(item.answer);
              },
              child: const Text('Voir la réponse'),
            )
          else ...[
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(item.answer, style: text.headlineSmall),
                subtitle: item.explanation == null || item.explanation!.isEmpty ? null : Text(item.explanation!),
                trailing: IconButton(
                  tooltip: 'Réécouter',
                  icon: const Icon(Icons.volume_up_outlined),
                  onPressed: () => _say(item.answer),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _answer(false),
                  icon: const Icon(Icons.replay),
                  label: const Text('À revoir'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _answer(true),
                  icon: const Icon(Icons.check),
                  label: const Text('Je savais'),
                ),
              ),
            ]),
          ],
        ],
      ),
    );
  }
}
