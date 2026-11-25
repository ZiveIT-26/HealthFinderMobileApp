import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../network/authorized_client.dart';
import 'auth_api.dart';
import 'auth_user.dart';
import 'token_storage.dart';

/// App-wide auth state. Created in main() before runApp.
late final AuthController authController;

/// Holds the backend session and runs the sign-in / sign-out flows.
///
/// Flow: Google account picker -> Google ID token -> POST /auth/google
/// -> backend JWT saved in secure storage -> sent as Bearer on API calls.
/// The backend issues a 90-day token without refresh, so a 401 signs the user out.
class AuthController extends ChangeNotifier {
  AuthController(
    this._api,
    this._storage, {
    this.googleServerClientId,
    this.googleIosClientId,
  });

  final AuthApi _api;
  final TokenStorage _storage;

  /// Web OAuth client ID; the backend checks the ID token audience against it.
  final String? googleServerClientId;

  /// iOS OAuth client ID (optional if set in Info.plist as GIDClientID).
  final String? googleIosClientId;

  AuthSession? _session;
  Future<void>? _googleInit;

  AuthUser? get user => _session?.user;
  bool get isSignedIn => _session != null;

  /// Restores a saved session. Call once before runApp.
  Future<void> init() async {
    _session = await _storage.read();
  }

  /// Interactive Google sign-in. Returns normally if the user cancels.
  /// Throws [AuthException] on any other failure.
  Future<void> signInWithGoogle() async {
    final google = GoogleSignIn.instance;

    final GoogleSignInAccount account;
    try {
      await _ensureGoogleInitialized();
      account = await google.authenticate();
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

    await _setSession(await _api.signInWithGoogle(idToken));
  }

  /// Dev-only shortcut, see POST /auth/test-login.
  Future<void> signInForTesting() async {
    await _setSession(await _api.signInForTesting());
  }

  Future<void> signOut() async {
    _session = null;
    await _storage.clear();
    notifyListeners();

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
        token: () => _session?.accessToken,
        onUnauthorized: _onUnauthorized,
      );

  void _onUnauthorized(String rejectedToken) {
    // Ignore late 401s for a token that has already been replaced.
    if (_session?.accessToken == rejectedToken) signOut();
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

  /// Called on every sign-in. The backend refreshes name, email and avatar
  /// from the Google account, so the cached user is overwritten each time.
  Future<void> _setSession(AuthSession session) async {
    await _storage.save(session);
    _session = session;
    notifyListeners();
  }
}
