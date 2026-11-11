import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_chat/presentation/screens/ai_chat_screen.dart';
import '../../features/clinics/presentation/screens/clinic_details_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/medical_card/presentation/screens/medical_card_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';

/// Root navigator. Routes with parentNavigatorKey: _rootKey
/// open above the bottom navigation (without it).
final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: AppRoutes.home,
  routes: [
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
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
