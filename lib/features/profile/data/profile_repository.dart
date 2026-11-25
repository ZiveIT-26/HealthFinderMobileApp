import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import 'models/profile.dart';

/// The signed-in account, cached from the backend. At most one row.
///
/// Read-only for screens: the profile is written on sign-in and deleted on
/// sign-out by `AccountService`.
class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  Future<Profile?> get() async => _toEntity(await _query().getSingleOrNull());

  Stream<Profile?> watch() => _query().watchSingleOrNull().map(_toEntity);

  /// Saves the account returned by the backend after sign-in.
  ///
  /// The same account keeps its row (and its chat cache). A different
  /// account replaces the row, which deletes the previous chat cache.
  Future<void> save(Profile profile) {
    return _db.transaction(() async {
      await (_db.delete(_db.profiles)
            ..where((t) => t.serverId.equals(profile.userId).not()))
          .go();

      final now = DateTime.now();
      await _db.into(_db.profiles).insert(
            ProfilesCompanion.insert(
              serverId: profile.userId,
              email: profile.email,
              displayName: Value(profile.displayName),
              avatarUrl: Value(profile.avatarUrl),
              syncedAt: now,
            ),
            onConflict: DoUpdate(
              (_) => ProfilesCompanion(
                email: Value(profile.email),
                displayName: Value(profile.displayName),
                avatarUrl: Value(profile.avatarUrl),
                syncedAt: Value(now),
              ),
              target: [_db.profiles.serverId],
            ),
          );
    });
  }

  /// Deletes the profile and, by cascade, the whole chat cache.
  Future<void> clear() => _db.delete(_db.profiles).go();

  SimpleSelectStatement<$ProfilesTable, ProfileRow> _query() =>
      _db.select(_db.profiles)..limit(1);

  static Profile? _toEntity(ProfileRow? row) {
    if (row == null) return null;
    return Profile(
      userId: row.serverId,
      email: row.email,
      displayName: row.displayName,
      avatarUrl: row.avatarUrl,
    );
  }
}
