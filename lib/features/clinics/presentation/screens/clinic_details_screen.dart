import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/detail_heading.dart';
import '../../../../core/widgets/page_header.dart';
import '../../data/clinic_mock_data.dart';
import '../widgets/clinic_sections.dart';

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen({super.key, required this.clinicId});

  /// Clinic id from the route: /chat/clinic/:clinicId
  final String clinicId;

  @override
  Widget build(BuildContext context) {
    final clinic = ClinicMockData.byId(clinicId);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Clinic Details'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.s, AppSpacing.l, 40),
                children: [
                  for (final section in [
                    ClinicHero(clinic: clinic),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: ClinicActions(),
                    ),
                    const DetailHeading('About the clinic'),
                    Text(clinic.about, style: AppTextStyles.detailBody),
                    const DetailHeading('Contact information'),
                    ClinicContacts(clinic: clinic),
                    const DetailHeading('Opening hours'),
                    ClinicOpeningHours(hours: clinic.openingHours),
                    const DetailHeading('Information source'),
                    ClinicSource(clinic: clinic),
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
