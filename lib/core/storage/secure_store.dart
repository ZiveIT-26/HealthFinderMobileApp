import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secrets kept in the platform secure storage:
/// Keychain on iOS, Keystore-protected encryption on Android.
///
/// Only small values belong here: API tokens and the local database key.
/// See secure-storage.md in the repo root.
class SecureStore {
  SecureStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              // Available after the first unlock, so background work
              // (e.g. medication reminders) can read it while the phone is
              // locked. "this_device" keeps it out of iCloud Keychain sync.
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  final FlutterSecureStorage _storage;

  Future<String>? _databaseKey;

  // ---------------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------------

  Future<String?> readAccessToken() => _read(_Keys.accessToken);
  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _Keys.accessToken, value: token);

  Future<String?> readRefreshToken() => _read(_Keys.refreshToken);
  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _Keys.refreshToken, value: token);

  /// Removes the session tokens. Local health data and its key stay,
  /// so the data is still there after the next sign-in.
  Future<void> clearSession() async {
    await _storage.delete(key: _Keys.accessToken);
    await _storage.delete(key: _Keys.refreshToken);
  }

  // ---------------------------------------------------------------------------
  // Local database key
  // ---------------------------------------------------------------------------

  /// Key for the encrypted local database.
  ///
  /// Generated randomly on first use and returned unchanged afterwards.
  /// The result is cached, so concurrent callers get the same key.
  ///
  /// Throws if the stored key cannot be read. A failure is not cached, so the
  /// next call tries again.
  Future<String> databaseKey() async {
    final pending = _databaseKey ??= _loadOrCreateDatabaseKey();
    try {
      return await pending;
    } catch (_) {
      if (identical(_databaseKey, pending)) _databaseKey = null;
      rethrow;
    }
  }

  Future<String> _loadOrCreateDatabaseKey() async {
    // Read errors are not treated as "no key": a new key would make the
    // existing database unreadable for good. On iOS, for example, a read
    // fails before the first unlock after a reboot, and works again later.
    final existing = await _storage.read(key: _Keys.databaseKey);
    if (existing != null) return existing;

    final key = _generateKey();
    await _storage.write(key: _Keys.databaseKey, value: key);
    return key;
  }

  /// Removes the database key. Call only together with deleting the
  /// database itself, otherwise the database becomes unreadable.
  Future<void> deleteDatabaseKey() async {
    _databaseKey = null;
    await _storage.delete(key: _Keys.databaseKey);
  }

  // ---------------------------------------------------------------------------
  // Everything
  // ---------------------------------------------------------------------------

  /// Removes all values. Used on a fresh install and for "Delete local data".
  Future<void> deleteAll() async {
    _databaseKey = null;
    await _storage.deleteAll();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Reads a token, treating an unreadable one as missing.
  ///
  /// A read can fail temporarily (iOS before the first unlock after a
  /// reboot) or permanently (the platform key the value was encrypted with
  /// is gone). Either way the caller behaves as signed out. The value is not
  /// deleted, so a temporary failure does not end the session; a broken
  /// value is replaced on the next sign-in.
  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      return null;
    }
  }

  /// 32 random bytes (256 bits) as a hex string.
  static String _generateKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

abstract final class _Keys {
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
  static const databaseKey = 'databaseKey';
}
