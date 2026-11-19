import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/srs.dart';
import 'companion_screen.dart';
import 'grammar_screens.dart';
import 'revision_screen.dart';
import 'settings_screen.dart';
import 'transport_screen.dart';
import 'vocabulary_screens.dart';

final _boxCountsProvider = StreamProvider.autoDispose((ref) {
  ref.watch(contentReadyProvider);
  return ref.watch(repositoryProvider).watchBoxCounts(ref.watch(settingsProvider).lang);
});

final _dueProvider = StreamProvider.autoDispose((ref) {
  ref.watch(contentReadyProvider);
  return ref.watch(repositoryProvider).watchDueCount(ref.watch(settingsProvider).lang);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(contentReadyProvider);
    final settings = ref.watch(settingsProvider);
    final lang = languageByCode(settings.lang);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lingua Balade'),
        actions: [
          IconButton(
            tooltip: 'Réglages',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: ready.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Erreur de chargement : $e'))),
        data: (_) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('${lang.nameFr} · niveau ${levelLabel(settings.level)}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const _ProgressCard(),
            const SizedBox(height: 16),
            _Tile(
              icon: Icons.directions_walk,
              title: 'Transport',
              subtitle: 'Écouter et répéter les mots, écran éteint',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransportScreen())),
            ),
            _Tile(
              icon: Icons.record_voice_over_outlined,
              title: 'Balade avec ${lang.companionName}',
              subtitle: 'Converser avec le compagnon IA (en ligne)',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanionScreen())),
            ),
            _Tile(
              icon: Icons.school_outlined,
              title: 'Révision',
              subtitle: _revisionSubtitle(ref.watch(dueRevisionCountProvider).value ?? 0, lang.companionName),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RevisionScreen())),
            ),
            _Tile(
              icon: Icons.grid_on_outlined,
              title: 'Grammaire',
              subtitle: 'Tableaux en couleurs, lus en rythme',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GrammarListScreen())),
            ),
            _Tile(
              icon: Icons.menu_book_outlined,
              title: 'Vocabulaire',
              subtitle: 'Les 1000 mots par situation',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SituationListScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

String _revisionSubtitle(int due, String companion) =>
    due == 0 ? 'Corrections et traductions de vos balades avec $companion' : '$due phrases à retravailler';

class _ProgressCard extends ConsumerWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(_boxCountsProvider).value ?? const {};
    final due = ref.watch(_dueProvider).value ?? 0;
    final total = counts.values.fold(0, (a, b) => a + b);
    final seen = total - (counts[0] ?? 0);
    final mastered = (counts[4] ?? 0) + (counts[maxBox] ?? 0);
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$seen / $total mots découverts', style: text.titleLarge),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: total == 0 ? 0 : seen / total),
            const SizedBox(height: 12),
            Text('$mastered bien ancrés · $due à revoir aujourd\'hui', style: text.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ),
      );
}
