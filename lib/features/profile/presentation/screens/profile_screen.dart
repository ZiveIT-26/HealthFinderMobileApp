import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          Text('Profile', style: AppTextStyles.pageTitle),
          const SizedBox(height: AppSpacing.l),
          // TODO: тимчасовий рядок замість SettingsRow з Figma
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.field),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.field),
              ),
              title: Text('Medical Card', style: AppTextStyles.label),
              subtitle: Text(
                'Blood type, allergies, conditions, medications',
                style: AppTextStyles.meta,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.medicalCard),
            ),
          ),
        ],
      ),
    );
  }
}
