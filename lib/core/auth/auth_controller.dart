import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../data/repositories.dart';
import '../network/authorized_client.dart';
import '../session/dev_account.dart';
import '../storage/secure_store.dart';
import 'auth_api.dart';
import 'auth_user.dart';

/// App-wide auth state. Created in main() before runApp.
late final AuthController authController;

/// Runs the sign-in flows against Google and the backend.
///
/// Flow: Google account picker -> Google ID token -> POST /auth/google
/// -> backend JWT into [SecureStore], account into `AccountService.signIn`
/// (the cached profile is refreshed on every sign-in).
/// Storage and sign-out are done by `AccountService`; this class only adds
/// the network part and keeps the token in memory for API calls.
/// The backend issues a 90-day token without refresh, so a 401 signs the user out.
class AuthController extends ChangeNotifier {
  AuthController(
    this._api,
    this._secure,
    this._repositories, {
    this.googleServerClientId,
    this.googleIosClientId,
  });

  final AuthApi _api;
  final SecureStore _secure;
  final Repositories _repositories;

  /// Web OAuth client ID; the backend checks the ID token audience against it.
  final String? googleServerClientId;

  /// iOS OAuth client ID (optional if set in Info.plist as GIDClientID).
  final String? googleIosClientId;

  /// Kept in memory: every secure storage read goes through a platform channel.
  String? _accessToken;
  Future<void>? _googleInit;

  /// Signed in = a token and a cached profile.
  bool get isSignedIn =>
      _accessToken != null && _repositories.currentUser.isSignedIn;

  /// Restores the session at startup. Call once before runApp.
  ///
  /// Without a readable token the user is treated as signed out, but the
  /// cached profile is not deleted: on iOS the read can fail only until the
  /// first unlock, and the next sign-in to the same account keeps its chat cache.
  Future<void> init() async {
    final token = await _secure.readAccessToken();
    if (token == null) return;

    try {
      await _repositories.account.restore();
    } catch (error) {
      // The database could not be opened (for example, on iOS the key is not
      // readable before the first unlock). Start as signed out.
      debugPrint('Could not restore the session: $error');
      return;
    }
    if (_repositories.currentUser.isSignedIn) _accessToken = token;
  }

  /// Interactive Google sign-in. Returns normally if the user cancels.
  /// Throws [AuthException] on any other failure.
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount account;
    try {
      await _ensureGoogleInitialized();
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // Misconfiguration (SHA-1, package name, client IDs) can also look like this.
        debugPrint('Google sign-in canceled: ${e.description}');
        return;
      }
      debugPrint('Google sign-in failed: ${e.code} ${e.description}');
      throw const AuthException('Google sign-in failed. Please try again.');
    }

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const AuthException('Google did not return an ID token.');
    }

    final session = await _api.signInWithGoogle(idToken);
    await _secure.writeAccessToken(session.accessToken);
    await _repositories.account.signIn(session.profile);
    _setToken(session.accessToken);
  }

  /// Debug only: the backend test user (POST /auth/test-login) with the
  /// sample medical card from `dev_account.dart`.
  Future<void> signInForTesting() async {
    final session = await _api.signInForTesting();
    await _secure.writeAccessToken(session.accessToken);
    // Same user id as the backend test user; also seeds an untouched card.
    await signInDevelopmentAccount(
      account: _repositories.account,
      personalInfo: _repositories.personalInfo,
      medicalCard: _repositories.medicalCard,
    );
    _setToken(session.accessToken);
  }

  /// Deletes the profile, chat cache and tokens (see `AccountService.signOut`).
  /// The medical card stays on the device for the next sign-in.
  Future<void> signOut() async {
    await _repositories.account.signOut();
    _setToken(null);

    // Forget the Google account so the picker is shown next time.
    if (_googleInit != null) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        debugPrint('Google sign-out failed: $e');
      }
    }
  }

  /// HTTP client for backend calls that need the user's token.
  http.Client createClient() => AuthorizedClient(
        token: () => _accessToken,
        onUnauthorized: _onUnauthorized,
      );

  void _onUnauthorized(String rejectedToken) {
    // Ignore late 401s for a token that has already been replaced.
    if (_accessToken == rejectedToken) signOut();
  }

  void _setToken(String? token) {
    _accessToken = token;
    notifyListeners();
  }

  /// GoogleSignIn.initialize may be called only once per app run.
  Future<void> _ensureGoogleInitialized() async {
    try {
      await (_googleInit ??= GoogleSignIn.instance.initialize(
        serverClientId: googleServerClientId,
        clientId: googleIosClientId,
      ));
    } catch (_) {
      _googleInit = null; // allow a retry after a failed init
      rethrow;
    }
  }
}
