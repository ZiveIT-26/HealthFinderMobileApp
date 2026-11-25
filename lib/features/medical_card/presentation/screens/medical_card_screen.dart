import 'package:health_finder/core/widgets/app_button.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/detail_heading.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../../../core/widgets/page_header.dart';
import '../../data/medical_card_mock_data.dart';
import '../widgets/medical_card_hero.dart';

class MedicalCardScreen extends StatelessWidget {
  const MedicalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Medical Card'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, 30),
                children: [
                  for (final section in [
                    const MedicalCardHero(),
                    for (final s in MedicalCardMockData.sections) ...[
                      DetailHeading(s.title),
                      InfoRowsCard(rows: s.rows, tinted: true),
                    ],
                    // Not interactive yet: there is no edit screen.
                    AppButton.text('Edit Medical Card', leading: Icon(Icons.edit_outlined)),
                    Text(MedicalCardMockData.storageNote, style: AppTextStyles.caption),
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
