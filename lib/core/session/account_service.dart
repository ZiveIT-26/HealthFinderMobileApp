import '../../features/profile/data/models/profile.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/profile/data/user_settings_repository.dart';
import '../database/app_database.dart';
import '../storage/app_preferences.dart';
import '../storage/consent.dart';
import '../storage/consent_repository.dart';
import '../storage/secure_store.dart';
import 'current_user.dart';

/// Sign-in, sign-out and "Delete my data", all local. The backend calls
/// (Google sign-in, tokens) happen before [signIn] and are not part of it.
class AccountService {
  AccountService({
    required this._db,
    required this._currentUser,
    required this._profiles,
    required this._userSettings,
    required this._consents,
    required this._preferences,
    required this._secure,
  });

  final AppDatabase _db;
  final CurrentUser _currentUser;
  final ProfileRepository _profiles;
  final UserSettingsRepository _userSettings;
  final ConsentRepository _consents;
  final AppPreferences _preferences;
  final SecureStore _secure;

  /// At startup: whoever has a cached profile is still signed in.
  Future<void> restore() async {
    final profile = await _profiles.get();
    _currentUser.set(profile?.userId);
  }

  /// After the backend returned the account (`POST /auth/google`).
  ///
  /// Another account's profile and chat cache are replaced; its medical card
  /// and settings stay on the device for its next sign-in.
  Future<void> signIn(Profile profile) async {
    await _profiles.save(profile);
    _currentUser.set(profile.userId);
    await _userSettings.ensureCreated();

    // Terms were accepted on the device before sign-in; record them for
    // the account too.
    if (_preferences.hasAcceptedCurrentTerms &&
        !await _consents.isValid(ConsentType.terms)) {
      await _consents.grant(ConsentType.terms);
    }
  }

  /// Deletes the profile with the chat cache and the tokens. The user's
  /// medical card, settings and consents stay for the next sign-in.
  ///
  /// When reminders exist, sign-out must also cancel them.
  Future<void> signOut() async {
    await _profiles.clear();
    await _secure.clearSession();
    _currentUser.set(null);
  }

  /// "Delete my data": removes everything of the signed-in user from this
  /// device for good (no `deletedAt`), then signs out. Other accounts on the
  /// device are untouched. Data on the server needs account deletion there.
  Future<void> deleteMyData() async {
    final owner = _currentUser.require();
    await _db.transaction(() async {
      await (_db.delete(_db.personalInfos)
            ..where((t) => t.ownerUserId.equals(owner)))
          .go();
      // The lists go with the card (cascade).
      await (_db.delete(_db.medicalCards)
            ..where((t) => t.ownerUserId.equals(owner)))
          .go();
      await (_db.delete(_db.userSettingsTable)
            ..where((t) => t.ownerUserId.equals(owner)))
          .go();
      await (_db.delete(_db.consents)
            ..where((t) => t.ownerUserId.equals(owner)))
          .go();
    });
    await signOut();
  }
}
