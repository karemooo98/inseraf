import 'package:shared_preferences/shared_preferences.dart';

/// Minimal wrapper around SharedPreferences with an in-memory fallback to avoid
/// platform channel crashes if prefs are not yet available.
class AppPreferences {
  AppPreferences(this._store);

  static const String _onboardingKey = 'has_seen_onboarding_v1';

  final _BoolStore _store;

  bool get hasSeenOnboarding => _store.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingSeen() => _store.setBool(_onboardingKey, true);

  /// Attempts to load native SharedPreferences; falls back to an in-memory
  /// store if the platform channel is unavailable.
  static Future<AppPreferences> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return AppPreferences(_SharedPrefsStore(prefs));
    } catch (_) {
      return AppPreferences(_MemoryStore());
    }
  }
}

abstract class _BoolStore {
  bool? getBool(String key);
  Future<void> setBool(String key, bool value);
}

class _SharedPrefsStore implements _BoolStore {
  _SharedPrefsStore(this._prefs);
  final SharedPreferences _prefs;

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
}

class _MemoryStore implements _BoolStore {
  final Map<String, bool> _data = <String, bool>{};

  @override
  bool? getBool(String key) => _data[key];

  @override
  Future<void> setBool(String key, bool value) async {
    _data[key] = value;
  }
}
