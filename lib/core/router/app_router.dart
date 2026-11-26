import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';
import '../../features/ai_chat/screens/ai_chat_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/clinics/presentation/screens/clinic_details_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/medical_card/presentation/screens/medical_card_screen.dart';
import '../../features/profile/presentation/screens/home_location_screen.dart';
import '../../features/profile/presentation/screens/personal_info_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';

/// Root navigator. Routes with parentNavigatorKey: _rootKey
/// open above the bottom navigation (without it).
final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: AppRoutes.home,
  // Re-run redirect whenever the user signs in or out.
  refreshListenable: authController,
  redirect: (context, state) {
    final onLogin = state.matchedLocation == AppRoutes.login;
    if (!authController.isSignedIn) return onLogin ? null : AppRoutes.login;
    if (onLogin) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    // Above the tabs (no bottom navigation).
    GoRoute(
      path: AppRoutes.homeLocation,
      builder: (context, state) => const HomeLocationScreen(),
    ),
    // Three tabs with bottom navigation. Each tab keeps its own state.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.chat,
              builder: (context, state) => const AiChatScreen(),
              routes: [
                GoRoute(
                  path: 'clinic/:clinicId',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => ClinicDetailsScreen(
                    clinicId: state.pathParameters['clinicId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'medical-card',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => const MedicalCardScreen(),
                ),
                GoRoute(
                  path: 'personal-info',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => const PersonalInfoScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  parentNavigatorKey: _rootKey,
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
