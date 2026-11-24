import 'app_preferences.dart';
import 'secure_store.dart';

/// Creates the app's storages once at startup and runs first-launch cleanup.
class AppStorage {
  const AppStorage._({required this.preferences, required this.secure});

  final AppPreferences preferences;
  final SecureStore secure;

  static Future<AppStorage> init() async {
    final preferences = await AppPreferences.create();
    final secure = SecureStore();

    // On iOS the Keychain survives uninstalling the app, while
    // shared_preferences does not. A missing flag therefore means a fresh
    // install, and anything left in secure storage belongs to an old one.
    if (!preferences.firstLaunchDone) {
      await secure.deleteAll();
      await preferences.setFirstLaunchDone(true);
    }

    return AppStorage._(preferences: preferences, secure: secure);
  }
}
