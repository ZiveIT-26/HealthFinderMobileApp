import 'package:material_ui/material_ui.dart';

import 'core/data/repositories.dart';
import 'core/router/app_router.dart';
import 'core/storage/app_preferences.dart';
import 'core/storage/settings_scope.dart';
import 'core/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.preferences, required this.repositories});

  final AppPreferences preferences;
  final Repositories repositories;

  @override
  Widget build(BuildContext context) {
    return RepositoriesScope(
      repositories: repositories,
      child: SettingsScope(
        preferences: preferences,
        child: MaterialApp.router(
          title: 'Health Finder',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
