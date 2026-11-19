import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio/rhythm_reader.dart';
import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/grammar.dart';
import 'theme.dart';

final _sheetsProvider = StreamProvider.autoDispose((ref) {
  final lang = ref.watch(settingsProvider.select((s) => s.lang));
  return ref.watch(repositoryProvider).watchGrammar(lang);
});

class GrammarListScreen extends ConsumerWidget {
  const GrammarListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheets = ref.watch(_sheetsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Grammaire')),
      body: sheets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) => ListView(
          children: [
            for (final s in list)
              ListTile(
                leading: CircleAvatar(child: Text(s.level)),
                title: Text(s.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GrammarDetailScreen(sheet: GrammarContent.decode(s.body))),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GrammarDetailScreen extends ConsumerStatefulWidget {
  const GrammarDetailScreen({super.key, required this.sheet});

  final GrammarContent sheet;

  @override
  ConsumerState<GrammarDetailScreen> createState() => _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends ConsumerState<GrammarDetailScreen> {
  late final RhythmReader _reader = ref.read(rhythmReaderProvider);

  @override
  void dispose() {
    _reader.stop();
    super.dispose();
  }

  String get _locale => languageByCode(ref.read(settingsProvider).lang).ttsLocale;
  double get _rate => ref.read(settingsProvider).speechRate;

  @override
  Widget build(BuildContext context) {
    final g = widget.sheet;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(g.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(g.summaryFr, style: text.bodyLarge),
          const SizedBox(height: 16),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: _ColoredTable(sheet: g, reader: _reader, onCellTap: _tapCell)),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: _reader.playing,
            builder: (context, playing, _) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => _reader.play(g, RhythmMode.rows, _locale, _rate),
                  icon: const Icon(Icons.table_rows_outlined),
                  label: const Text('Par lignes'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () => _reader.play(g, RhythmMode.columns, _locale, _rate),
                  icon: const Icon(Icons.view_column_outlined),
                  label: const Text('Par colonnes'),
                ),
                if (g.chant != null)
                  FilledButton.tonalIcon(
                    onPressed: () => _reader.play(g, RhythmMode.chant, _locale, _rate),
                    icon: const Icon(Icons.music_note_outlined),
                    label: const Text('Rengaine ×3'),
                  ),
                if (playing)
                  OutlinedButton.icon(onPressed: _reader.stop, icon: const Icon(Icons.stop), label: const Text('Stop')),
              ],
            ),
          ),
          if (g.chant != null) ...[
            const SizedBox(height: 16),
            Text('Rengaine', style: text.titleSmall),
            Text(g.chant!, style: text.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
          ],
          if (g.examples.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Exemples', style: text.titleSmall),
            for (final e in g.examples)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.volume_up_outlined),
                title: Text(e.target),
                subtitle: Text(e.fr),
                onTap: () => _reader.say(e.target, _locale, _rate),
              ),
          ],
        ],
      ),
    );
  }

  void _tapCell(int col, String cell) {
    if (cell.trim().isEmpty || cell == '—' || widget.sheet.columnLangs[col] == 'translit') return;
    _reader.say(cell, widget.sheet.columnLangs[col] == 'fr' ? frenchTtsLocale : _locale, _rate);
  }
}

class _ColoredTable extends StatelessWidget {
  const _ColoredTable({required this.sheet, required this.reader, required this.onCellTap});

  final GrammarContent sheet;
  final RhythmReader reader;
  final void Function(int col, String cell) onCellTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<(int, int)?>(
      valueListenable: reader.highlight,
      builder: (context, hl, _) {
        Widget cell(String value, int row, int col, {bool header = false}) {
          final gender = sheet.columnGenders[col];
          final color = gender == null ? null : genderColor(gender, brightness);
          final active = hl != null && hl.$1 == row && hl.$2 == col;
          return InkWell(
            onTap: () => onCellTap(col, value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: active
                  ? scheme.primaryContainer
                  : (color != null && !header ? color.withValues(alpha: 0.10) : null),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: header || col == 0 ? FontWeight.bold : FontWeight.w500,
                  color: color ?? (col == 0 && !header ? scheme.onSurfaceVariant : null),
                ),
              ),
            ),
          );
        }

        return Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(color: scheme.outlineVariant),
          children: [
            TableRow(
              decoration: BoxDecoration(color: scheme.surfaceContainerHighest),
              children: [for (final (c, h) in sheet.headers.indexed) cell(h, -1, c, header: true)],
            ),
            for (final (r, row) in sheet.rows.indexed)
              TableRow(children: [for (final (c, v) in row.indexed) cell(v, r, c)]),
          ],
        );
      },
    );
  }
}
