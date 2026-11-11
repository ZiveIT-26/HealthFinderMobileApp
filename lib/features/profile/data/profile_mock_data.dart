/// Mock profile until the backend is ready.
library;

import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/widgets/info_rows_card.dart';

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

abstract final class ProfileMockData {
  static const name = 'Alex Morgan';
  static const subtitle = 'Košice · alex@example.com';

  static const details = [
    InfoRow('Date of birth', '1987-06-15'),
    InfoRow('Phone', '+421 900 000 000'),
    InfoRow('Blood type', 'O+'),
    InfoRow('Emergency contact', 'Taylor Morgan'),
  ];

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
        icon: Icons.description_outlined,
        title: 'Prevention & Tips',
        subtitle: 'Articles and practical health advice',
      ),
    ]),
    SettingsGroup('Account', [
      SettingsItem(
        icon: Icons.person_outline,
        title: 'Personal Information',
        subtitle: 'Name and date of birth',
      ),
      SettingsItem(
        icon: Icons.notifications_none,
        title: 'Notifications',
        subtitle: 'Medication reminder preferences',
      ),
      SettingsItem(
        icon: Icons.info_outline,
        title: 'Privacy & Data',
        subtitle: 'Privacy and saved information',
      ),
      SettingsItem(
        icon: Icons.description_outlined,
        title: 'Help & Support',
        subtitle: 'About HealthFinder',
      ),
    ]),
  ];
}
