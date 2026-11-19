import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  const AppSettings({
    this.lang = 'de',
    this.level = 'A1',
    this.sessionSize = 20,
    this.repeatPauseMs = 3000,
    this.recallPauseMs = 4000,
    this.speechRate = 0.45,
    this.reverseMode = false,
    this.includeExample = true,
    this.voiceConsent = false,
    this.sttModel = 'gpt-4o-mini-transcribe',
    this.chatModel = 'gpt-4o-mini',
    this.provider = 'gemini',
    this.geminiModel = 'gemini-flash-latest',
  });

  final String lang;
  final String level;
  final int sessionSize;

  /// Silence laissé pour répéter le mot à voix haute.
  final int repeatPauseMs;

  /// Silence laissé pour retrouver le mot, en mode inversé.
  final int recallPauseMs;
  final double speechRate;
  final bool reverseMode;
  final bool includeExample;
  final bool voiceConsent;
  final String sttModel;
  final String chatModel;

  /// Fournisseur du compagnon : « openai » ou « gemini ».
  final String provider;
  final String geminiModel;

  String get providerName => provider == 'gemini' ? 'Google Gemini' : 'OpenAI';

  AppSettings copyWith({
    String? lang,
    String? level,
    int? sessionSize,
    int? repeatPauseMs,
    int? recallPauseMs,
    double? speechRate,
    bool? reverseMode,
    bool? includeExample,
    bool? voiceConsent,
    String? sttModel,
    String? chatModel,
    String? provider,
    String? geminiModel,
  }) =>
      AppSettings(
        lang: lang ?? this.lang,
        level: level ?? this.level,
        sessionSize: sessionSize ?? this.sessionSize,
        repeatPauseMs: repeatPauseMs ?? this.repeatPauseMs,
        recallPauseMs: recallPauseMs ?? this.recallPauseMs,
        speechRate: speechRate ?? this.speechRate,
        reverseMode: reverseMode ?? this.reverseMode,
        includeExample: includeExample ?? this.includeExample,
        voiceConsent: voiceConsent ?? this.voiceConsent,
        sttModel: sttModel ?? this.sttModel,
        chatModel: chatModel ?? this.chatModel,
        provider: provider ?? this.provider,
        geminiModel: geminiModel ?? this.geminiModel,
      );

  static AppSettings load(SharedPreferences p) {
    const d = AppSettings();
    return AppSettings(
      lang: p.getString('lang') ?? d.lang,
      level: p.getString('level') ?? d.level,
      sessionSize: p.getInt('sessionSize') ?? d.sessionSize,
      repeatPauseMs: p.getInt('repeatPauseMs') ?? d.repeatPauseMs,
      recallPauseMs: p.getInt('recallPauseMs') ?? d.recallPauseMs,
      speechRate: p.getDouble('speechRate') ?? d.speechRate,
      reverseMode: p.getBool('reverseMode') ?? d.reverseMode,
      includeExample: p.getBool('includeExample') ?? d.includeExample,
      voiceConsent: p.getBool('voiceConsent') ?? d.voiceConsent,
      sttModel: p.getString('sttModel') ?? d.sttModel,
      chatModel: p.getString('chatModel') ?? d.chatModel,
      provider: p.getString('provider') ?? d.provider,
      geminiModel: p.getString('geminiModel') ?? d.geminiModel,
    );
  }

  Future<void> save(SharedPreferences p) async {
    await p.setString('lang', lang);
    await p.setString('level', level);
    await p.setInt('sessionSize', sessionSize);
    await p.setInt('repeatPauseMs', repeatPauseMs);
    await p.setInt('recallPauseMs', recallPauseMs);
    await p.setDouble('speechRate', speechRate);
    await p.setBool('reverseMode', reverseMode);
    await p.setBool('includeExample', includeExample);
    await p.setBool('voiceConsent', voiceConsent);
    await p.setString('sttModel', sttModel);
    await p.setString('chatModel', chatModel);
    await p.setString('provider', provider);
    await p.setString('geminiModel', geminiModel);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError('surchargé dans main()'));

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => AppSettings.load(ref.watch(sharedPrefsProvider));

  Future<void> update(AppSettings Function(AppSettings) change) async {
    state = change(state);
    await state.save(ref.read(sharedPrefsProvider));
  }
}

/// Clés d'API personnelles, une par fournisseur, chiffrées par le système
/// (Keystore Android / Trousseau iOS).
class ApiKeyStore {
  static const _storage = FlutterSecureStorage();

  String _key(String provider) => '${provider}_api_key';

  Future<String?> read(String provider) => _storage.read(key: _key(provider));

  Future<void> write(String provider, String? value) => value == null || value.trim().isEmpty
      ? _storage.delete(key: _key(provider))
      : _storage.write(key: _key(provider), value: value.trim());
}

final apiKeyStoreProvider = Provider((ref) => ApiKeyStore());
