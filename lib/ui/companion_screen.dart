import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../companion/companion_controller.dart';
import '../core/languages.dart';
import '../core/providers.dart';
import '../core/settings.dart';
import 'settings_screen.dart';

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({super.key});

  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  final _scroll = ScrollController();
  bool? _hasKey;

  @override
  void initState() {
    super.initState();
    ref.read(transportProvider).pause();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
  }

  Future<void> _prepare() async {
    final key = await ref.read(apiKeyStoreProvider).read(ref.read(settingsProvider).provider);
    if (!mounted) return;
    setState(() => _hasKey = key != null && key.isNotEmpty);
    if (_hasKey != true) return;
    if (!ref.read(settingsProvider).voiceConsent && !await _askConsent()) {
      if (mounted) Navigator.pop(context);
      return;
    }
    await ref.read(companionProvider.notifier).start();
  }

  Future<bool> _askConsent() async {
    final provider = ref.read(settingsProvider).providerName;
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Votre voix et $provider'),
        content: Text(
          'Pour converser, vos enregistrements vocaux et le texte de la conversation sont envoyés à $provider '
          '(serveurs aux États-Unis) pour être transcrits et traités. Les enregistrements sont supprimés du téléphone '
          'dès la transcription faite. Rien n\'est envoyé tant que vous n\'appuyez pas sur le micro.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Refuser')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('J\'accepte')),
        ],
      ),
    );
    if (ok == true) await ref.read(settingsProvider.notifier).update((s) => s.copyWith(voiceConsent: true));
    return ok == true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companionProvider);
    final controller = ref.read(companionProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final lang = languageByCode(settings.lang);
    ref.listen(companionProvider.select((s) => s.turns.length), (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });

    if (_hasKey == false) {
      return Scaffold(
        appBar: AppBar(title: Text('Balade avec ${lang.companionName}')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Le compagnon a besoin d\'une clé d\'API Google Gemini (aistudio.google.com/apikey) '
              'ou OpenAI (platform.openai.com). Elle reste chiffrée sur votre téléphone.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                await _prepare();
              },
              child: const Text('Ouvrir les réglages'),
            ),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Balade avec ${lang.companionName}'),
        actions: [
          IconButton(tooltip: 'Recommencer', onPressed: controller.reset, icon: const Icon(Icons.restart_alt)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(children: [
              Text('Niveau', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(spacing: 6, children: [
                  for (final l in levels)
                    ChoiceChip(
                      label: Text(levelLabel(l)),
                      selected: settings.level == l,
                      onSelected: (_) => ref.read(settingsProvider.notifier).update((s) => s.copyWith(level: l)),
                    ),
                ]),
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              children: [
                for (final t in state.turns)
                  _Bubble(
                    turn: t,
                    showTranslation: settings.level == 'A0',
                    targetName: lang.nameFr.toLowerCase(),
                    onListen: controller.speakText,
                  ),
                if (state.summary != null) _SummaryCard(summary: state.summary!),
              ],
            ),
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(state.error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(children: [
              Text(_statusLabel(state.status, lang.companionName), style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Réécouter',
                    onPressed: state.busy ? null : controller.replayLast,
                    icon: const Icon(Icons.replay),
                  ),
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: state.status == CompanionStatus.recording ? Colors.red : null,
                      ),
                      onPressed: state.busy ? null : controller.togglePushToTalk,
                      child: Icon(state.status == CompanionStatus.recording ? Icons.send : Icons.mic, size: 44),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Terminer et voir le bilan',
                    onPressed: state.busy || !state.turns.any((t) => t.fromUser) ? null : controller.endWalk,
                    icon: const Icon(Icons.flag_circle_outlined),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  String _statusLabel(CompanionStatus s, String name) => switch (s) {
        CompanionStatus.idle => 'Appuyez sur le micro pour parler',
        CompanionStatus.recording => 'Je vous écoute… appuyez pour envoyer',
        CompanionStatus.transcribing => 'Transcription…',
        CompanionStatus.thinking => '$name réfléchit…',
        CompanionStatus.speaking => '$name parle…',
        CompanionStatus.summarizing => 'Préparation du bilan…',
      };
}

class _Bubble extends StatefulWidget {
  const _Bubble({required this.turn, required this.showTranslation, required this.targetName, required this.onListen});

  final Turn turn;

  /// Traduction affichée d'office (niveau débutant).
  final bool showTranslation;
  final String targetName;
  final Future<void> Function(String text) onListen;

  @override
  State<_Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<_Bubble> {
  late bool _translated = widget.showTranslation;

  @override
  Widget build(BuildContext context) {
    final t = widget.turn;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width * 0.82;

    Widget feedback(IconData icon, String label, String sentence, String? note) => Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
          constraints: BoxConstraints(maxWidth: width),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 18, color: scheme.tertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: text.labelMedium?.copyWith(color: scheme.tertiary)),
                Text(sentence, style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                if (note != null && note.isNotEmpty) Text(note, style: text.bodyMedium),
              ]),
            ),
            IconButton(
              tooltip: 'Écouter',
              visualDensity: VisualDensity.compact,
              onPressed: () => widget.onListen(sentence),
              icon: const Icon(Icons.volume_up_outlined),
            ),
          ]),
        );

    final bubble = Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      constraints: BoxConstraints(maxWidth: width),
      decoration: BoxDecoration(
        color: t.fromUser ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.text, style: text.bodyLarge),
        if (t.transliteration != null)
          Text('[${t.transliteration}]', style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
        if (!t.fromUser) ...[
          if (_translated && t.translationFr != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(t.translationFr!, style: text.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: scheme.onSurfaceVariant)),
            ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            if (t.translationFr != null)
              TextButton.icon(
                onPressed: () => setState(() => _translated = !_translated),
                icon: const Icon(Icons.translate, size: 18),
                label: Text(_translated ? 'Masquer' : 'Traduction'),
              ),
            IconButton(
              tooltip: 'Réécouter',
              visualDensity: VisualDensity.compact,
              onPressed: () => widget.onListen(t.text),
              icon: const Icon(Icons.volume_up_outlined, size: 20),
            ),
          ]),
        ] else
          const SizedBox(height: 6),
      ]),
    );

    return Align(
      alignment: t.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: t.fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            bubble,
            if (t.suggestion != null) feedback(Icons.translate, 'En ${widget.targetName}', t.suggestion!.target, null),
            if (t.correction != null)
              feedback(Icons.lightbulb_outline, 'Plus juste', t.correction!.correct, t.correction!.explanation),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final WalkSummary summary;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bilan de la balade', style: text.titleLarge),
          if (summary.encouragement.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(summary.encouragement, style: text.bodyLarge),
          ],
          for (final e in summary.errors) ...[
            const SizedBox(height: 12),
            Text('« ${e.said} »', style: text.bodyMedium?.copyWith(decoration: TextDecoration.lineThrough)),
            Text('→ ${e.correct}', style: text.titleSmall),
            Text(e.explanation, style: text.bodyMedium),
          ],
          if (summary.wordsToReview.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('À réviser : ${summary.wordsToReview.join(', ')}', style: text.bodyMedium),
          ],
          if (summary.flagged.isNotEmpty)
            Text('Ajoutés à vos révisions Transport : ${summary.flagged.join(', ')}', style: text.bodySmall),
        ]),
      ),
    );
  }
}
