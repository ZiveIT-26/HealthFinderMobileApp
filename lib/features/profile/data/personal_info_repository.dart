import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/session/current_user.dart';
import 'models/personal_info.dart';

/// Personal data of the signed-in user. Written on "Save" of its form.
class PersonalInfoRepository {
  PersonalInfoRepository(this._db, this._user);

  final AppDatabase _db;
  final CurrentUser _user;

  /// [PersonalInfo.empty] until the user saves something.
  Future<PersonalInfo> get() async =>
      _toEntity(await _query(_user.require()).getSingleOrNull());

  Stream<PersonalInfo> watch() =>
      _query(_user.require()).watchSingleOrNull().map(_toEntity);

  Future<void> save(PersonalInfo info) {
    final location = info.fallbackLocation;
    final row = PersonalInfosCompanion(
      ownerUserId: Value(_user.require()),
      dateOfBirth: Value(info.dateOfBirth),
      sex: Value(info.sex),
      heightCm: Value(info.heightCm),
      weightKg: Value(info.weightKg),
      fallbackLocationLabel: Value(location?.label),
      fallbackLatitude: Value(location?.latitude),
      fallbackLongitude: Value(location?.longitude),
      updatedAt: Value(DateTime.now()),
    );
    return _db.into(_db.personalInfos).insert(
          row,
          onConflict: DoUpdate(
            (_) => row,
            target: [_db.personalInfos.ownerUserId],
          ),
        );
  }

  SimpleSelectStatement<$PersonalInfosTable, PersonalInfoRow> _query(
    String ownerUserId,
  ) =>
      _db.select(_db.personalInfos)
        ..where((t) => t.ownerUserId.equals(ownerUserId));

  static PersonalInfo _toEntity(PersonalInfoRow? row) {
    if (row == null) return PersonalInfo.empty;
    final label = row.fallbackLocationLabel;
    final lat = row.fallbackLatitude;
    final lon = row.fallbackLongitude;
    return PersonalInfo(
      dateOfBirth: row.dateOfBirth,
      sex: row.sex,
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      fallbackLocation: label != null && lat != null && lon != null
          ? FallbackLocation(label: label, latitude: lat, longitude: lon)
          : null,
    );
  }
}
