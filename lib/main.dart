import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/data/repositories.dart';
import 'core/session/dev_account.dart';
import 'core/storage/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/app.env');
  final storage = await AppStorage.init();
  final repositories = Repositories(storage);

  try {
    await repositories.account.restore();
  } catch (error) {
    // The database could not be opened (for example, on iOS the key is not
    // readable before the first unlock). Start as signed out.
    debugPrint('Could not restore the session: $error');
  }

  // Temporary until Google sign-in exists, see dev_account.dart.
  if (kDebugMode && !repositories.currentUser.isSignedIn) {
    await signInDevelopmentAccount(
      account: repositories.account,
      personalInfo: repositories.personalInfo,
      medicalCard: repositories.medicalCard,
    );
  }

  runApp(App(preferences: storage.preferences, repositories: repositories));
}
