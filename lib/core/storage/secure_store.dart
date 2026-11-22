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
  /// If a stored key cannot be read (see [_read]), a new one is generated.
  /// The existing database then cannot be opened with it and has to be
  /// recreated by the database layer.
  Future<String> databaseKey() => _databaseKey ??= _loadOrCreateDatabaseKey();

  Future<String> _loadOrCreateDatabaseKey() async {
    final existing = await _read(_Keys.databaseKey);
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

  /// Reads a value, treating an unreadable one as missing.
  ///
  /// A value can become unreadable when the platform key it was encrypted
  /// with is gone (e.g. Android data restored on another device). The broken
  /// value is deleted so it does not fail again on every read.
  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      await _storage.delete(key: key);
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
