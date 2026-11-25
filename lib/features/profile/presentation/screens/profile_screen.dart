import 'package:material_ui/material_ui.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../data/profile_mock_data.dart';
import '../widgets/profile_sections.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, 42),
                children: [
                  for (final section in [
                    // Account data from the last sign-in; rebuilds when it changes.
                    ListenableBuilder(
                      listenable: authController,
                      builder: (context, _) {
                        final user = authController.user;
                        return ProfileHero(
                          name: user?.name ?? ProfileMockData.name,
                          subtitle: user?.email ?? ProfileMockData.subtitle,
                          avatarUrl: user?.avatarUrl,
                        );
                      },
                    ),
                    const InfoRowsCard(
                      rows: ProfileMockData.details,
                      padding: EdgeInsets.fromLTRB(14, 9, 14, 0),
                    ),
                    for (final group in ProfileMockData.groups) ...[
                      SettingsGroupTitle(group.title),
                      for (final item in group.items) SettingsRow(item: item),
                    ],
                    AppButton.soft(
                      label: 'Sign out',
                      size: AppButtonSize.large,
                      expanded: true,
                      onTap: authController.signOut,
                    ),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: section,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
