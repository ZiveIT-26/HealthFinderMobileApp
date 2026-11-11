import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../data/profile_mock_data.dart';
import '../widgets/profile_sections.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 20),
              child: Text('Profile', style: AppTextStyles.tabTitle),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.l, AppSpacing.l, 42),
                children: [
                  for (final section in [
                    const ProfileHero(
                      name: ProfileMockData.name,
                      subtitle: ProfileMockData.subtitle,
                    ),
                    const InfoRowsCard(
                      rows: ProfileMockData.details,
                      padding: EdgeInsets.fromLTRB(14, 9, 14, 0),
                    ),
                    for (final group in ProfileMockData.groups) ...[
                      SettingsGroupTitle(group.title),
                      for (final item in group.items) SettingsRow(item: item),
                    ],
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
