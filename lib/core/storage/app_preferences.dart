import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consent_versions.dart';

/// Typed access to small, non-secret device settings stored in
/// shared_preferences. They are shared by every account on the device.
///
/// Settings that belong to the user (reminders, server notifications) and
/// consents live in the local database, per account.
///
/// All values are loaded into memory once in [create], so getters are
/// synchronous. Setters write to disk and then notify listeners, so widgets
/// listening through `SettingsScope.of` rebuild after a change.
/// See docs/storage/preferences.md for what each key means.
class AppPreferences extends ChangeNotifier {
  AppPreferences._(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static Future<AppPreferences> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: _Keys.all,
      ),
    );
    return AppPreferences._(prefs);
  }

  // ---------------------------------------------------------------------------
  // General
  // ---------------------------------------------------------------------------

  bool get firstLaunchDone => _prefs.getBool(_Keys.firstLaunchDone) ?? false;
  Future<void> setFirstLaunchDone(bool value) =>
      _setBool(_Keys.firstLaunchDone, value);

  bool get onboardingCompleted =>
      _prefs.getBool(_Keys.onboardingCompleted) ?? false;
  Future<void> setOnboardingCompleted(bool value) =>
      _setBool(_Keys.onboardingCompleted, value);

  String? get lastSeenAppVersion => _prefs.getString(_Keys.lastSeenAppVersion);
  Future<void> setLastSeenAppVersion(String value) =>
      _setString(_Keys.lastSeenAppVersion, value);

  /// `null` means follow the system language.
  Locale? get locale {
    final code = _prefs.getString(_Keys.locale);
    return code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale? value) =>
      _setStringOrRemove(_Keys.locale, value?.languageCode);

  /// [ThemeMode.system] is stored as "no value".
  ThemeMode get themeMode {
    final name = _prefs.getString(_Keys.themeMode);
    return ThemeMode.values.asNameMap()[name] ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode value) => _setStringOrRemove(
        _Keys.themeMode,
        value == ThemeMode.system ? null : value.name,
      );

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  bool get notificationPermissionAsked =>
      _prefs.getBool(_Keys.notificationPermissionAsked) ?? false;
  Future<void> setNotificationPermissionAsked(bool value) =>
      _setBool(_Keys.notificationPermissionAsked, value);

  // ---------------------------------------------------------------------------
  // Privacy & Data
  // ---------------------------------------------------------------------------

  /// Terms accepted on this device, before sign-in. `null` means not
  /// accepted yet. After sign-in, the acceptance is also recorded in the
  /// account's consents in the database.
  int? get termsAcceptedVersion => _prefs.getInt(_Keys.termsAcceptedVersion);
  Future<void> setTermsAcceptedVersion(int value) =>
      _setInt(_Keys.termsAcceptedVersion, value);

  /// Whether the current terms ([ConsentVersions.terms]) are accepted.
  bool get hasAcceptedCurrentTerms =>
      (termsAcceptedVersion ?? 0) >= ConsentVersions.terms;

  bool get appLockEnabled => _prefs.getBool(_Keys.appLockEnabled) ?? false;
  Future<void> setAppLockEnabled(bool value) =>
      _setBool(_Keys.appLockEnabled, value);

  /// Initial state of "Remember for this chat" on the assistant's location
  /// card: on, the choice answers the next searches of the chat by itself.
  bool get chatLocationRemember =>
      _prefs.getBool(_Keys.chatLocationRemember) ?? true;
  Future<void> setChatLocationRemember(bool value) =>
      _setBool(_Keys.chatLocationRemember, value);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
    notifyListeners();
  }

  Future<void> _setString(String key, String value) async {
    await _prefs.setString(key, value);
    notifyListeners();
  }

  Future<void> _setInt(String key, int value) async {
    await _prefs.setInt(key, value);
    notifyListeners();
  }

  Future<void> _remove(String key) async {
    await _prefs.remove(key);
    notifyListeners();
  }

  Future<void> _setStringOrRemove(String key, String? value) =>
      value == null ? _remove(key) : _setString(key, value);
}

abstract final class _Keys {
  // General
  static const firstLaunchDone = 'firstLaunchDone';
  static const onboardingCompleted = 'onboardingCompleted';
  static const lastSeenAppVersion = 'lastSeenAppVersion';
  static const locale = 'locale';
  static const themeMode = 'themeMode';

  // Notifications
  static const notificationPermissionAsked = 'notificationPermissionAsked';

  // Privacy & Data
  static const termsAcceptedVersion = 'termsAcceptedVersion';
  static const appLockEnabled = 'appLockEnabled';
  static const chatLocationRemember = 'chatLocationRemember';

  static const all = <String>{
    firstLaunchDone,
    onboardingCompleted,
    lastSeenAppVersion,
    locale,
    themeMode,
    notificationPermissionAsked,
    termsAcceptedVersion,
    appLockEnabled,
    chatLocationRemember,
  };
}
