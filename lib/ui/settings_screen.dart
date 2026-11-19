import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../companion/llm_client.dart';
import '../companion/llm_factory.dart';

import '../core/error_log.dart';
import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _keyController = TextEditingController();
  bool _keySaved = false;

  /// Vérification de la clé collée en cours.
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _refreshKey();
  }

  Future<void> _refreshKey() async {
    final k = await ref.read(apiKeyStoreProvider).read(ref.read(settingsProvider).provider);
    if (mounted) setState(() => _keySaved = k != null);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _set(AppSettings Function(AppSettings) change) => ref.read(settingsProvider.notifier).update(change);

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 5)));
  }

  /// Page du fournisseur où l'on crée sa clé (il faut s'y connecter avec son propre compte).
  static String _keyPage(String provider) =>
      provider == 'gemini' ? 'https://aistudio.google.com/apikey' : 'https://platform.openai.com/api-keys';

  Future<void> _openKeyPage(String provider) async {
    final ok = await launchUrl(Uri.parse(_keyPage(provider)), mode: LaunchMode.externalApplication);
    if (!ok) _snack('Impossible d\'ouvrir le navigateur. Allez sur ${_keyPage(provider)}');
  }

  /// Colle la clé copiée, l'enregistre, puis vérifie qu'elle fonctionne par un court appel.
  Future<void> _pasteKey() async {
    final s = ref.read(settingsProvider);
    final store = ref.read(apiKeyStoreProvider);
    final pasted = (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim() ?? '';
    if (pasted.isEmpty) {
      _snack('Le presse-papiers est vide : copiez d\'abord la clé sur la page ${s.providerName}.');
      return;
    }
    // Pas de contrôle du préfixe : les fournisseurs changent parfois la forme des clés.
    // C'est l'appel de test qui dit si la clé est bonne.
    if (pasted.length < 20 || pasted.contains(RegExp(r'\s'))) {
      _snack('Ce texte ne ressemble pas à une clé d\'API (${pasted.length} caractères). '
          'Sur la page ${s.providerName}, touchez l\'icône de copie à côté de la clé, puis réessayez.');
      return;
    }
    setState(() => _checking = true);
    await store.write(s.provider, pasted);
    // La clé ne reste pas dans le presse-papiers, où d'autres applications pourraient la lire.
    await Clipboard.setData(const ClipboardData(text: ''));
    try {
      final client = await buildLlmClient(s, store);
      await client.chat([const ChatMessage('user', 'Réponds seulement : OK')], maxTokens: 16);
      _snack('Clé ${s.providerName} vérifiée et enregistrée. Le compagnon est prêt.');
    } on ApiException catch (e) {
      if (e.message.startsWith('Clé d\'API refusée')) {
        await store.write(s.provider, null);
        _snack('${s.providerName} refuse cette clé. Vérifiez que vous l\'avez copiée en entier.');
      } else {
        _snack('Clé enregistrée, mais le test n\'a pas abouti : ${e.message}');
      }
    } catch (e) {
      _snack('Clé enregistrée, mais le test n\'a pas abouti : $e');
    } finally {
      if (mounted) setState(() => _checking = false);
      await _refreshKey();
    }
  }


  @override
  Widget build(BuildContext context) {
    final s = ref.watch(settingsProvider);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Langue & niveau', style: text.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: s.lang,
            decoration: const InputDecoration(labelText: 'Langue étudiée', border: OutlineInputBorder()),
            items: [
              for (final l in targetLanguages)
                DropdownMenuItem(
                  value: l.code,
                  enabled: l.hasContent,
                  child: Text(l.hasContent ? l.nameFr : '${l.nameFr} (bientôt)'),
                ),
            ],
            onChanged: (v) => _set((s) => s.copyWith(lang: v)),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [for (final l in levels) ButtonSegment(value: l, label: Text(levelLabel(l)))],
            selected: {s.level},
            onSelectionChanged: (v) => _set((s) => s.copyWith(level: v.first)),
          ),
          const Divider(height: 32),
          Text('Transport', style: text.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mots par séance'),
            trailing: DropdownButton<int>(
              value: s.sessionSize,
              items: [for (final n in [10, 20, 30, 50]) DropdownMenuItem(value: n, child: Text('$n'))],
              onChanged: (v) => _set((s) => s.copyWith(sessionSize: v)),
            ),
          ),
          _SliderTile(
            label: 'Silence pour répéter : ${(s.repeatPauseMs / 1000).toStringAsFixed(1)} s',
            value: s.repeatPauseMs.toDouble(),
            min: 1500,
            max: 6000,
            divisions: 9,
            onChanged: (v) => _set((s) => s.copyWith(repeatPauseMs: v.round())),
          ),
          _SliderTile(
            label: 'Silence pour chercher (mode inversé) : ${(s.recallPauseMs / 1000).toStringAsFixed(1)} s',
            value: s.recallPauseMs.toDouble(),
            min: 2000,
            max: 8000,
            divisions: 12,
            onChanged: (v) => _set((s) => s.copyWith(recallPauseMs: v.round())),
          ),
          _SliderTile(
            label: 'Débit de la voix : ${s.speechRate.toStringAsFixed(2)}',
            value: s.speechRate,
            min: 0.25,
            max: 0.7,
            divisions: 9,
            onChanged: (v) => _set((s) => s.copyWith(speechRate: double.parse(v.toStringAsFixed(2)))),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mode inversé'),
            subtitle: const Text('Français d\'abord, à vous de retrouver le mot'),
            value: s.reverseMode,
            onChanged: (v) => _set((s) => s.copyWith(reverseMode: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Phrase exemple'),
            value: s.includeExample,
            onChanged: (v) => _set((s) => s.copyWith(includeExample: v)),
          ),
          TextButton.icon(
            onPressed: () async {
              await ref.read(ttsCacheProvider).clear();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Audio effacé : il sera régénéré.')));
              }
            },
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Régénérer l\'audio (après un changement de voix)'),
          ),
          const Divider(height: 32),
          Text('Compagnon IA', style: text.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'gemini', label: Text('Google Gemini')),
              ButtonSegment(value: 'openai', label: Text('OpenAI')),
            ],
            selected: {s.provider},
            onSelectionChanged: (v) async {
              await ref.read(settingsProvider.notifier).update((s) => s.copyWith(provider: v.first, voiceConsent: false));
              _keyController.clear();
              await _refreshKey();
            },
          ),
          const SizedBox(height: 12),
          Text(
            s.provider == 'gemini'
                ? 'Créez une clé gratuite avec votre compte Google, copiez-la, puis revenez ici et collez-la.'
                : 'Créez une clé avec votre compte OpenAI (un moyen de paiement est nécessaire), copiez-la, puis collez-la ici.',
            style: text.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _openKeyPage(s.provider),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Créer ma clé'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _checking ? null : _pasteKey,
                icon: _checking
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.content_paste),
                label: Text(_checking ? 'Vérification…' : 'Coller ma clé'),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          TextField(
            controller: _keyController,
            obscureText: true,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Ou saisissez la clé ${s.providerName}',
              helperText: _keySaved
                  ? 'Une clé est enregistrée (chiffrée).'
                  : s.provider == 'gemini'
                      ? 'À créer sur aistudio.google.com/apikey'
                      : 'À créer sur platform.openai.com',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: 'Enregistrer',
                icon: const Icon(Icons.save_outlined),
                onPressed: () async {
                  await ref.read(apiKeyStoreProvider).write(s.provider, _keyController.text);
                  _keyController.clear();
                  await _refreshKey();
                },
              ),
            ),
          ),
          if (_keySaved)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  await ref.read(apiKeyStoreProvider).write(s.provider, null);
                  if (mounted) setState(() => _keySaved = false);
                },
                child: const Text('Supprimer la clé'),
              ),
            ),
          const SizedBox(height: 12),
          if (s.provider == 'gemini')
            _ModelField(
              key: const ValueKey('gemini'),
              label: 'Modèle Gemini (voix et conversation)',
              value: s.geminiModel,
              onSubmitted: (v) => _set((s) => s.copyWith(geminiModel: v)),
            )
          else ...[
            _ModelField(
              key: const ValueKey('stt'),
              label: 'Modèle de transcription',
              value: s.sttModel,
              onSubmitted: (v) => _set((s) => s.copyWith(sttModel: v)),
            ),
            const SizedBox(height: 12),
            _ModelField(
              key: const ValueKey('chat'),
              label: 'Modèle de conversation',
              value: s.chatModel,
              onSubmitted: (v) => _set((s) => s.copyWith(chatModel: v)),
            ),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Envoi de la voix à ${s.providerName} accepté'),
            value: s.voiceConsent,
            onChanged: (v) => _set((s) => s.copyWith(voiceConsent: v)),
          ),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Journal des erreurs'),
            subtitle: const Text('Pour signaler un problème'),
            onTap: () => _showJournal(context),
          ),
        ],
      ),
    );
  }

  Future<void> _showJournal(BuildContext context) async {
    final text = await ErrorLog.instance.read();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Journal des erreurs'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(text.isEmpty ? 'Aucune erreur enregistrée.' : text, style: const TextStyle(fontSize: 12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ErrorLog.instance.clear();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Effacer'),
          ),
          TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: text)),
            child: const Text('Copier'),
          ),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Slider(value: value.clamp(min, max), min: min, max: max, divisions: divisions, onChanged: onChanged),
        ],
      );
}

class _ModelField extends StatelessWidget {
  const _ModelField({super.key, required this.label, required this.value, required this.onSubmitted});

  final String label;
  final String value;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) => TextFormField(
        initialValue: value,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        onFieldSubmitted: (v) {
          if (v.trim().isNotEmpty) onSubmitted(v.trim());
        },
      );
}
