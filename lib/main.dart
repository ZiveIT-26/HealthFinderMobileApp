import 'package:material_ui/material_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/auth/auth_api.dart';
import 'core/auth/auth_controller.dart';
import 'core/auth/token_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/app.env');

  authController = AuthController(
    AuthApi(dotenv.get('BACKEND_URL')),
    TokenStorage(),
    googleServerClientId: _env('GOOGLE_SERVER_CLIENT_ID'),
    googleIosClientId: _env('GOOGLE_IOS_CLIENT_ID'),
  );
  // Read the saved session first, so the router knows where to start.
  await authController.init();

  runApp(const App());
}

String? _env(String key) {
  final value = dotenv.maybeGet(key)?.trim();
  return (value == null || value.isEmpty) ? null : value;
}
