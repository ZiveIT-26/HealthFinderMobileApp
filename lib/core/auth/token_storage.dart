import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_user.dart';

/// Keeps the backend session in the platform secure storage
/// (Keychain on iOS, Keystore-backed encryption on Android).
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth.access_token';
  static const _userKey = 'auth.user';

  Future<void> save(AuthSession session) async {
    await _storage.write(key: _tokenKey, value: session.accessToken);
    await _storage.write(key: _userKey, value: jsonEncode(session.user.toJson()));
  }

  /// Returns the stored session, or null if there is none or it is unreadable.
  Future<AuthSession?> read() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final userJson = await _storage.read(key: _userKey);
      if (token == null || userJson == null) return null;

      return AuthSession(
        accessToken: token,
        user: AuthUser.fromJson(jsonDecode(userJson) as Map<String, dynamic>),
      );
    } catch (_) {
      // Corrupted or undecryptable data: treat as signed out.
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
