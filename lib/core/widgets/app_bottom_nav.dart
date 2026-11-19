
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Bottom navigation: Home / Chat / Profile.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.chat_bubble_outline, label: 'Chat'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
            vertical: isLandscape ? AppSpacing.xs : AppSpacing.m,
          ),
          child: Row(
            spacing: isLandscape ? AppSpacing.s : AppSpacing.m,
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: _items[i].icon,
                    label: _items[i].label,
                    isActive: i == currentIndex,
                    isLandscape: isLandscape,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isLandscape,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLandscape;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.field);

    return Material(
      color: isActive ? AppColors.soft : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(
            isLandscape ? AppSpacing.xxs : AppSpacing.s,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xxs,
            children: [
              Icon(
                icon,
                size: isLandscape ? 19 : 22,
                color: AppColors.navIcon,
              ),
              Text(
                label,
                style: AppTextStyles.meta.copyWith(
                  color: isActive ? AppColors.brand : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
