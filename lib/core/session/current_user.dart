import 'package:flutter/foundation.dart';

/// Thrown when per-account data is used while nobody is signed in.
class NotSignedInException implements Exception {
  const NotSignedInException();

  @override
  String toString() => 'NotSignedInException: nobody is signed in';
}

/// Who is signed in right now: the backend `user.id`, or null.
///
/// Repositories read it to filter per-account data by `ownerUserId`, so
/// screens never deal with user ids. Only `AccountService` changes it.
class CurrentUser extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;
  bool get isSignedIn => _userId != null;

  /// The signed-in user's id. Throws [NotSignedInException] otherwise.
  String require() {
    final id = _userId;
    if (id == null) throw const NotSignedInException();
    return id;
  }

  /// Called by `AccountService` on restore, sign-in and sign-out.
  void set(String? userId) {
    if (_userId == userId) return;
    _userId = userId;
    notifyListeners();
  }
}
