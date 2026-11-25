import 'consent_versions.dart';

/// Kinds of consent the user can give. Stored by name in the `consents` table.
enum ConsentType { terms, aiChat, aiContext }

/// One grant of a consent, as stored in the `consents` table of the local
/// database. A new grant adds a new row; revoking sets [revokedAt].
class Consent {
  const Consent({
    required this.type,
    required this.version,
    required this.grantedAt,
    this.revokedAt,
  });

  final ConsentType type;

  /// Version of the consent text the user agreed to.
  final int version;
  final DateTime grantedAt;

  /// `null` while the consent is active.
  final DateTime? revokedAt;

  /// True if the consent is active and covers the current text version.
  bool get isValid =>
      revokedAt == null && version >= ConsentVersions.current(type);
}
