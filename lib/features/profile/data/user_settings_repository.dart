import 'package:drift/drift.dart';
import 'package:material_ui/material_ui.dart' show TimeOfDay;

import '../../../core/database/app_database.dart';
import '../../../core/session/current_user.dart';
import 'models/user_settings.dart';

/// Settings of the signed-in user. Switches write immediately, there is no
/// "Save" button for them.
class UserSettingsRepository {
  UserSettingsRepository(this._db, this._user);

  final AppDatabase _db;
  final CurrentUser _user;

  /// [UserSettings.defaults] if the row does not exist yet.
  Future<UserSettings> get() async =>
      _toEntity(await _query(_user.require()).getSingleOrNull());

  Stream<UserSettings> watch() =>
      _query(_user.require()).watchSingleOrNull().map(_toEntity);

  /// Usually called with `settings.copyWith(...)` of the current value.
  ///
  /// When reminders exist, changing them must also reschedule the local
  /// notifications (see local-database--notes.md).
  Future<void> save(UserSettings settings) {
    final row = UserSettingsTableCompanion(
      ownerUserId: Value(_user.require()),
      medicationRemindersEnabled: Value(settings.medicationRemindersEnabled),
      repeatReminderMinutes: Value(settings.repeatReminderMinutes),
      moodRemindersEnabled: Value(settings.moodRemindersEnabled),
      moodReminderTime: Value(_formatTime(settings.moodReminderTime)),
      healthAlertsEnabled: Value(settings.healthAlertsEnabled),
      recommendationsEnabled: Value(settings.recommendationsEnabled),
      updatedAt: Value(DateTime.now()),
    );
    return _db.into(_db.userSettingsTable).insert(
          row,
          onConflict: DoUpdate(
            (_) => row,
            target: [_db.userSettingsTable.ownerUserId],
          ),
        );
  }

  /// Creates the row with the defaults on the user's first sign-in.
  /// Does nothing if it exists.
  Future<void> ensureCreated() {
    return _db.into(_db.userSettingsTable).insert(
          UserSettingsTableCompanion.insert(ownerUserId: _user.require()),
          mode: InsertMode.insertOrIgnore,
        );
  }

  SimpleSelectStatement<$UserSettingsTableTable, UserSettingsRow> _query(
    String ownerUserId,
  ) =>
      _db.select(_db.userSettingsTable)
        ..where((t) => t.ownerUserId.equals(ownerUserId));

  static UserSettings _toEntity(UserSettingsRow? row) {
    if (row == null) return UserSettings.defaults;
    return UserSettings(
      medicationRemindersEnabled: row.medicationRemindersEnabled,
      repeatReminderMinutes: row.repeatReminderMinutes,
      moodRemindersEnabled: row.moodRemindersEnabled,
      moodReminderTime: _parseTime(row.moodReminderTime) ??
          UserSettings.defaults.moodReminderTime,
      healthAlertsEnabled: row.healthAlertsEnabled,
      recommendationsEnabled: row.recommendationsEnabled,
    );
  }

  /// "HH:mm".
  static TimeOfDay? _parseTime(String value) {
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
