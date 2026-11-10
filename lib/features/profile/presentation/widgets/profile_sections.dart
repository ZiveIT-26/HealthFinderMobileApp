import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../data/profile_mock_data.dart';

/// Top card with avatar, name and subtitle.
class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key, required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 22),
      decoration: BoxDecoration(
        gradient: AppGradients.detailHero,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 10),
        ],
      ),
      child: Row(
        spacing: 15,
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person_outline, size: 20, color: AppColors.brand),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(name, style: AppTextStyles.heroName),
                Text(subtitle, style: AppTextStyles.meta),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Uppercase group title: "MY HEALTH", "ACCOUNT".
class SettingsGroupTitle extends StatelessWidget {
  const SettingsGroupTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 9, 2, 0),
      child: Text(title.toUpperCase(), style: AppTextStyles.groupTitle),
    );
  }
}

/// Settings row: icon tile, title, subtitle and a chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.item});

  final SettingsItem item;

  @override
  Widget build(BuildContext context) {
    final route = item.route;
    final radius = BorderRadius.circular(22);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 20),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: route == null ? null : () => context.push(route),
          child: Container(
            constraints: const BoxConstraints(minHeight: 75),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              spacing: 13,
              children: [
                Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    color: AppColors.soft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(item.icon, size: 20, color: AppColors.brand),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xxs,
                    children: [
                      Text(item.title, style: AppTextStyles.settingsTitle),
                      Text(item.subtitle, style: AppTextStyles.settingsSubtitle),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20, color: AppColors.chatText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
