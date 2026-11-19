import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../companion/llm_factory.dart';
import '../companion/theme_generator.dart';
import '../core/error_log.dart';
import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import '../data/repository.dart';
import 'theme.dart';
import 'vocabulary_screens.dart';

/// Nouvelle famille de mots : l'IA propose une liste, l'utilisateur la vérifie,
/// retire ce qu'il ne veut pas, puis l'ajoute au vocabulaire.
class NewFamilyScreen extends ConsumerStatefulWidget {
  const NewFamilyScreen({super.key});

  @override
  ConsumerState<NewFamilyScreen> createState() => _NewFamilyScreenState();
}

class _NewFamilyScreenState extends ConsumerState<NewFamilyScreen> {
  final _description = TextEditingController();
  final _title = TextEditingController();
  double _count = 40;
  bool _loading = false;
  bool _saving = false;
  String? _error;
  List<ThemeEntry> _entries = [];
  Set<int> _selected = {};
  Set<String> _known = {};

  @override
  void dispose() {
    _description.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _propose() async {
    final description = _description.text.trim();
    if (description.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final settings = ref.read(settingsProvider);
      final client = await buildLlmClient(settings, ref.read(apiKeyStoreProvider));
      final result = await generateThemeVocabulary(
        client,
        theme: description,
        languageName: languageByCode(settings.lang).nameFr.toLowerCase(),
        level: levelLabel(settings.level),
        count: _count.round(),
        transliterate: languageByCode(settings.lang).transliterated,
      );
      final known = await ref.read(repositoryProvider).knownWords(settings.lang, result.entries.map((e) => e.word));
      await ErrorLog.instance.note('famille proposée « ${result.title} » : ${result.entries.length} mots');
      if (!mounted) return;
      setState(() {
        _entries = result.entries;
        _selected = {for (var i = 0; i < result.entries.length; i++) i};
        _known = known;
        _title.text = result.title;
      });
    } catch (e, s) {
      await ErrorLog.instance.error('nouvelle famille de mots', e, s);
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final settings = ref.read(settingsProvider);
    final title = _title.text.trim().isEmpty ? _description.text.trim() : _title.text.trim();
    setState(() => _saving = true);
    try {
      final chosen = [for (final (i, e) in _entries.indexed) if (_selected.contains(i)) e];
      final key = await ref.read(repositoryProvider).createTheme(
            lang: settings.lang,
            label: title,
            entries: chosen,
            genderOf: (a) => genderFromArticle(settings.lang, a),
            articleIsGender: articleIsGender(settings.lang),
          );
      await ErrorLog.instance.note('famille « $title » ajoutée : ${chosen.length} mots');
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WordListScreen(situation: key, title: title)));
    } catch (e, s) {
      await ErrorLog.instance.error('ajout de la famille de mots', e, s);
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final hasList = _entries.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle famille de mots')),
      bottomNavigationBar: hasList
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton.icon(
                  onPressed: _selected.isEmpty || _saving || _loading ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: Text('Ajouter ${_selected.length} mots'),
                ),
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _description,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Famille de mots ou situation',
              hintText: 'ex. : aliments et épices pour cuisiner ; une course cycliste',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text('Nombre de mots : ${_count.round()}', style: text.titleSmall),
          Slider(
            value: _count,
            min: 10,
            max: 100,
            divisions: 18,
            label: '${_count.round()}',
            onChanged: _loading ? null : (v) => setState(() => _count = v),
          ),
          FilledButton.tonalIcon(
            onPressed: _loading ? null : _propose,
            icon: _loading
                ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(hasList ? Icons.refresh : Icons.auto_awesome),
            label: Text(_loading ? 'L\'IA prépare la liste…' : hasList ? 'Autre proposition' : 'Proposer la liste'),
          ),
          if (_loading)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Comptez une demi-minute à deux minutes selon le nombre de mots.', style: text.bodySmall),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: TextStyle(color: scheme.error)),
            ),
          if (hasList) ...[
            const Divider(height: 32),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Nom de la famille', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Text(
                  '${_entries.length} mots proposés · ${_known.length} déjà dans vos listes',
                  style: text.labelMedium,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selected = _selected.length == _entries.length
                    ? {}
                    : {for (var i = 0; i < _entries.length; i++) i}),
                child: Text(_selected.length == _entries.length ? 'Tout décocher' : 'Tout cocher'),
              ),
            ]),
            for (final (i, e) in _entries.indexed)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _selected.contains(i),
                onChanged: (v) => setState(() => v == true ? _selected.add(i) : _selected.remove(i)),
                title: Text(
                  e.article == null || articleIsGender(ref.read(settingsProvider).lang)
                      ? e.word
                      : '${e.article} ${e.word}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: genderColor(genderFromArticle(ref.read(settingsProvider).lang, e.article), brightness),
                  ),
                ),
                subtitle: Text([
                  if (e.transliteration != null) '[${e.transliteration}]',
                  e.translations.join(', '),
                  if (articleIsGender(ref.read(settingsProvider).lang) && genderAbbreviation(e.article) != null)
                    genderAbbreviation(e.article)!,
                  if (e.plural != null) 'pl. ${e.plural}',
                  if (_known.contains(e.word.toLowerCase())) 'déjà connu',
                ].join(' · ')),
              ),
          ],
        ],
      ),
    );
  }
}
