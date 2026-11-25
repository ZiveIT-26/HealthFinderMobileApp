import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../session/current_user.dart';
import 'consent.dart';
import 'consent_versions.dart';

/// Consents of the signed-in user, with their history.
///
/// Granting adds a row with the current text version; revoking sets
/// `revokedAt` on the latest row. The latest row of a type decides.
class ConsentRepository {
  ConsentRepository(this._db, this._user);

  final AppDatabase _db;
  final CurrentUser _user;

  Future<Consent?> latest(ConsentType type) async =>
      _toEntity(await _latest(_user.require(), type).getSingleOrNull());

  Stream<Consent?> watchLatest(ConsentType type) =>
      _latest(_user.require(), type).watchSingleOrNull().map(_toEntity);

  /// True if the user agreed to the current version and did not revoke it.
  Future<bool> isValid(ConsentType type) async =>
      (await latest(type))?.isValid ?? false;

  Stream<bool> watchValid(ConsentType type) =>
      watchLatest(type).map((consent) => consent?.isValid ?? false);

  Future<void> grant(ConsentType type) {
    return _db.into(_db.consents).insert(
          ConsentsCompanion.insert(
            ownerUserId: _user.require(),
            type: type,
            version: ConsentVersions.current(type),
            grantedAt: DateTime.now(),
          ),
        );
  }

  Future<void> revoke(ConsentType type) async {
    final row = await _latest(_user.require(), type).getSingleOrNull();
    if (row == null || row.revokedAt != null) return;
    await (_db.update(_db.consents)..where((t) => t.id.equals(row.id)))
        .write(ConsentsCompanion(revokedAt: Value(DateTime.now())));
  }

  SimpleSelectStatement<$ConsentsTable, ConsentRow> _latest(
    String ownerUserId,
    ConsentType type,
  ) =>
      _db.select(_db.consents)
        ..where((t) =>
            t.ownerUserId.equals(ownerUserId) & t.type.equalsValue(type))
        ..orderBy([(t) => OrderingTerm.desc(t.grantedAt)])
        ..limit(1);

  static Consent? _toEntity(ConsentRow? row) {
    if (row == null) return null;
    return Consent(
      type: row.type,
      version: row.version,
      grantedAt: row.grantedAt,
      revokedAt: row.revokedAt,
    );
  }
}
