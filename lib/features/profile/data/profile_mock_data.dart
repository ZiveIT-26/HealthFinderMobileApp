/// Mock profile until the backend is ready.
library;

import 'package:material_ui/material_ui.dart';

import '../../../core/router/app_routes.dart';

class SettingsItem {
  const SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// Where the row leads; null while the screen does not exist yet.
  final String? route;
}

class SettingsGroup {
  const SettingsGroup(this.title, this.items);

  final String title;
  final List<SettingsItem> items;
}

/// Menu of the profile screen. The profile data itself comes from the
/// repositories.
abstract final class ProfileMockData {
  static const groups = [
    SettingsGroup('My health', [
      SettingsItem(
        icon: Icons.shield_outlined,
        title: 'Medical Card',
        subtitle: 'Blood type, allergies, conditions, medications',
        route: AppRoutes.medicalCard,
      ),
      SettingsItem(
        icon: Icons.block,
        title: 'My Medications',
        subtitle: 'Schedules and reminders',
      ),
      SettingsItem(
        icon: Icons.sentiment_satisfied_outlined,
        title: 'Mood Diary',
        subtitle: 'Mood history and notes',
      ),
      SettingsItem(
        icon: Icons.description_outlined,
        title: 'Prevention & Tips',
        subtitle: 'Articles and practical health advice',
      ),
    ]),
    SettingsGroup('Account', [
      SettingsItem(
        icon: Icons.person_outline,
        title: 'Personal Information',
        subtitle: 'Name, date of birth, height, weight, location',
        route: AppRoutes.personalInfo,
      ),
      SettingsItem(
        icon: Icons.settings_outlined,
        title: 'Settings',
        subtitle: 'Notifications, privacy, language, help',
        route: AppRoutes.settings,
      ),
    ]),
  ];
}
