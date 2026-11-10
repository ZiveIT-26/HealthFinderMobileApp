import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_bottom_nav.dart';

/// Каркас для вкладок: поточна вкладка + нижня навігація.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        // Повторне натискання на активну вкладку повертає її на початковий екран.
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
