import 'consent.dart';

/// Current versions of the texts the user agrees to.
///
/// Bump a value when its text changes: stored consents for an older version
/// become invalid and the user is asked again.
abstract final class ConsentVersions {
  static const terms = 1;
  static const aiChat = 1;
  static const aiContext = 1;

  static int current(ConsentType type) => switch (type) {
        ConsentType.terms => terms,
        ConsentType.aiChat => aiChat,
        ConsentType.aiContext => aiContext,
      };
}
