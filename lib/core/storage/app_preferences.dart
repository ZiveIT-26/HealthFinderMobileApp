import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consent_versions.dart';

/// Typed access to small, non-secret settings stored in shared_preferences.
///
/// All values are loaded into memory once in [create], so getters are
/// synchronous. Setters write to disk and then notify listeners, so widgets
/// listening through `SettingsScope.of` rebuild after a change.
/// See preferences.md in the repo root for what each key means.
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

  bool get medicationRemindersEnabled =>
      _prefs.getBool(_Keys.medicationRemindersEnabled) ?? true;
  Future<void> setMedicationRemindersEnabled(bool value) =>
      _setBool(_Keys.medicationRemindersEnabled, value);

  /// `null` means do not repeat.
  int? get repeatReminderMinutes => _prefs.getInt(_Keys.repeatReminderMinutes);
  Future<void> setRepeatReminderMinutes(int? value) =>
      _setIntOrRemove(_Keys.repeatReminderMinutes, value);

  bool get moodRemindersEnabled =>
      _prefs.getBool(_Keys.moodRemindersEnabled) ?? true;
  Future<void> setMoodRemindersEnabled(bool value) =>
      _setBool(_Keys.moodRemindersEnabled, value);

  /// Stored as "HH:mm".
  TimeOfDay get moodReminderTime =>
      _parseTime(_prefs.getString(_Keys.moodReminderTime)) ??
      const TimeOfDay(hour: 20, minute: 0);

  Future<void> setMoodReminderTime(TimeOfDay value) =>
      _setString(_Keys.moodReminderTime, _formatTime(value));

  bool get healthAlertsEnabled =>
      _prefs.getBool(_Keys.healthAlertsEnabled) ?? true;
  Future<void> setHealthAlertsEnabled(bool value) =>
      _setBool(_Keys.healthAlertsEnabled, value);

  bool get recommendationsEnabled =>
      _prefs.getBool(_Keys.recommendationsEnabled) ?? false;
  Future<void> setRecommendationsEnabled(bool value) =>
      _setBool(_Keys.recommendationsEnabled, value);

  // ---------------------------------------------------------------------------
  // Privacy & Data
  // ---------------------------------------------------------------------------

  /// `null` means the terms have not been accepted yet.
  int? get termsAcceptedVersion => _prefs.getInt(_Keys.termsAcceptedVersion);
  Future<void> setTermsAcceptedVersion(int value) =>
      _setInt(_Keys.termsAcceptedVersion, value);

  /// Whether the current terms ([ConsentVersions.terms]) are accepted.
  bool get hasAcceptedCurrentTerms =>
      (termsAcceptedVersion ?? 0) >= ConsentVersions.terms;

  /// Whether the AI chat may be used under the current consent text.
  bool get hasAiChatConsent => aiChatConsent.isValidFor(ConsentVersions.aiChat);

  /// Whether the medical card and medications may be sent to the chat.
  bool get hasAiContextConsent =>
      aiContextConsent.isValidFor(ConsentVersions.aiContext);

  Consent get aiChatConsent => _readConsent(
        _Keys.aiChatConsent,
        _Keys.aiChatConsentAt,
        _Keys.aiChatConsentVersion,
      );

  Future<void> grantAiChatConsent(int version) => _writeConsent(
        _Keys.aiChatConsent,
        _Keys.aiChatConsentAt,
        _Keys.aiChatConsentVersion,
        version,
      );

  Future<void> revokeAiChatConsent() => _clearConsent(
        _Keys.aiChatConsent,
        _Keys.aiChatConsentAt,
        _Keys.aiChatConsentVersion,
      );

  Consent get aiContextConsent => _readConsent(
        _Keys.aiContextConsent,
        _Keys.aiContextConsentAt,
        _Keys.aiContextConsentVersion,
      );

  Future<void> grantAiContextConsent(int version) => _writeConsent(
        _Keys.aiContextConsent,
        _Keys.aiContextConsentAt,
        _Keys.aiContextConsentVersion,
        version,
      );

  Future<void> revokeAiContextConsent() => _clearConsent(
        _Keys.aiContextConsent,
        _Keys.aiContextConsentAt,
        _Keys.aiContextConsentVersion,
      );

  bool get appLockEnabled => _prefs.getBool(_Keys.appLockEnabled) ?? false;
  Future<void> setAppLockEnabled(bool value) =>
      _setBool(_Keys.appLockEnabled, value);

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

  Future<void> _setIntOrRemove(String key, int? value) =>
      value == null ? _remove(key) : _setInt(key, value);

  Consent _readConsent(String grantedKey, String atKey, String versionKey) {
    final at = _prefs.getString(atKey);
    return Consent(
      granted: _prefs.getBool(grantedKey) ?? false,
      grantedAt: at == null ? null : DateTime.tryParse(at),
      version: _prefs.getInt(versionKey),
    );
  }

  Future<void> _writeConsent(
    String grantedKey,
    String atKey,
    String versionKey,
    int version,
  ) async {
    await _prefs.setBool(grantedKey, true);
    await _prefs.setString(atKey, DateTime.now().toUtc().toIso8601String());
    await _prefs.setInt(versionKey, version);
    notifyListeners();
  }

  Future<void> _clearConsent(
    String grantedKey,
    String atKey,
    String versionKey,
  ) async {
    await _prefs.setBool(grantedKey, false);
    await _prefs.remove(atKey);
    await _prefs.remove(versionKey);
    notifyListeners();
  }

  static TimeOfDay? _parseTime(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';
}

/// A stored consent: whether it was given, when, and for which text version.
class Consent {
  const Consent({required this.granted, this.grantedAt, this.version});

  final bool granted;
  final DateTime? grantedAt;
  final int? version;

  /// True only if consent was given for [currentVersion] or newer.
  /// When the consent text changes, bump the version to ask again.
  bool isValidFor(int currentVersion) =>
      granted && version != null && version! >= currentVersion;
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
  static const medicationRemindersEnabled = 'medicationRemindersEnabled';
  static const repeatReminderMinutes = 'repeatReminderMinutes';
  static const moodRemindersEnabled = 'moodRemindersEnabled';
  static const moodReminderTime = 'moodReminderTime';
  static const healthAlertsEnabled = 'healthAlertsEnabled';
  static const recommendationsEnabled = 'recommendationsEnabled';

  // Privacy & Data
  static const termsAcceptedVersion = 'termsAcceptedVersion';
  static const aiChatConsent = 'aiChatConsent';
  static const aiChatConsentAt = 'aiChatConsentAt';
  static const aiChatConsentVersion = 'aiChatConsentVersion';
  static const aiContextConsent = 'aiContextConsent';
  static const aiContextConsentAt = 'aiContextConsentAt';
  static const aiContextConsentVersion = 'aiContextConsentVersion';
  static const appLockEnabled = 'appLockEnabled';

  static const all = <String>{
    firstLaunchDone,
    onboardingCompleted,
    lastSeenAppVersion,
    locale,
    themeMode,
    notificationPermissionAsked,
    medicationRemindersEnabled,
    repeatReminderMinutes,
    moodRemindersEnabled,
    moodReminderTime,
    healthAlertsEnabled,
    recommendationsEnabled,
    termsAcceptedVersion,
    aiChatConsent,
    aiChatConsentAt,
    aiChatConsentVersion,
    aiContextConsent,
    aiContextConsentAt,
    aiContextConsentVersion,
    appLockEnabled,
  };
}
