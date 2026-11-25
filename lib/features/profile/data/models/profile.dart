/// The signed-in account, cached from the backend (`POST /auth/google`).
///
/// Read-only in the app: every field comes from the Google account and is
/// refreshed on sign-in.
class Profile {
  const Profile({
    required this.userId,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  /// `user.id` from the backend. Owner of the user's local data.
  final String userId;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  /// What to show as the user's name.
  String get name => displayName ?? email;
}
