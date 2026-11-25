import 'package:material_ui/material_ui.dart' show TimeOfDay;

import '../../../../core/models/unset.dart';

/// Settings that belong to the user, one set per account.
///
/// Device settings (language, theme, app lock) are in `AppPreferences`.
class UserSettings {
  const UserSettings({
    this.medicationRemindersEnabled = true,
    this.repeatReminderMinutes,
    this.moodRemindersEnabled = true,
    this.moodReminderTime = const TimeOfDay(hour: 20, minute: 0),
    this.healthAlertsEnabled = true,
    this.recommendationsEnabled = false,
  });

  /// Values for an account that has not changed anything yet.
  static const defaults = UserSettings();

  final bool medicationRemindersEnabled;

  /// Repeat an unmarked medication reminder after this many minutes.
  /// `null` means no repeat.
  final int? repeatReminderMinutes;
  final bool moodRemindersEnabled;
  final TimeOfDay moodReminderTime;

  /// Sent by the server; the backend does not store it yet.
  final bool healthAlertsEnabled;

  /// Sent by the server; the backend does not store it yet.
  final bool recommendationsEnabled;

  UserSettings copyWith({
    bool? medicationRemindersEnabled,
    Object? repeatReminderMinutes = unset,
    bool? moodRemindersEnabled,
    TimeOfDay? moodReminderTime,
    bool? healthAlertsEnabled,
    bool? recommendationsEnabled,
  }) {
    return UserSettings(
      medicationRemindersEnabled:
          medicationRemindersEnabled ?? this.medicationRemindersEnabled,
      repeatReminderMinutes:
          pick(repeatReminderMinutes, this.repeatReminderMinutes),
      moodRemindersEnabled: moodRemindersEnabled ?? this.moodRemindersEnabled,
      moodReminderTime: moodReminderTime ?? this.moodReminderTime,
      healthAlertsEnabled: healthAlertsEnabled ?? this.healthAlertsEnabled,
      recommendationsEnabled:
          recommendationsEnabled ?? this.recommendationsEnabled,
    );
  }
}
