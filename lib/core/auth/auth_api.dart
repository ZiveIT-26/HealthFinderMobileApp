import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_user.dart';

/// Backend auth endpoints (see HealthFinderBackend/docs/API.md).
class AuthApi {
  AuthApi(this.baseUrl);

  final String baseUrl;

  /// POST /auth/google: exchanges a Google ID token for a backend JWT.
  Future<AuthSession> signInWithGoogle(String idToken) =>
      _post('/auth/google', {'idToken': idToken});

  /// POST /auth/test-login: works only when the backend has TEST_AUTH_ENABLED=true.
  Future<AuthSession> signInForTesting() => _post('/auth/test-login', null);

  Future<AuthSession> _post(String path, Map<String, dynamic>? body) async {
    final http.Response res;
    try {
      res = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: body == null ? null : jsonEncode(body),
      );
    } on http.ClientException catch (e) {
      debugPrint('Auth request to $baseUrl$path failed: $e');
      throw const AuthException('Could not reach the server. Check your connection.');
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      debugPrint('Auth request to $baseUrl$path: ${res.statusCode} ${res.body}');
      throw AuthException(switch (res.statusCode) {
        401 => 'Google sign-in was rejected by the server.',
        403 => 'This sign-in method is disabled on the server.',
        _ => 'Sign-in failed (${res.statusCode}).',
      });
    }

    return AuthSession.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
