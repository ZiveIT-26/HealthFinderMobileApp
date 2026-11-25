import '../../features/profile/data/models/profile.dart';

/// Response of `POST /auth/google` and `POST /auth/test-login`:
/// the backend JWT and the account it belongs to.
class AuthSession {
  const AuthSession({required this.accessToken, required this.profile});

  final String accessToken;
  final Profile profile;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthSession(
      accessToken: json['accessToken'] as String,
      profile: Profile(
        userId: user['id'] as String,
        email: user['email'] as String,
        displayName: user['displayName'] as String?,
        avatarUrl: user['avatarUrl'] as String?,
      ),
    );
  }
}

/// Sign-in failure with a message that can be shown to the user.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
