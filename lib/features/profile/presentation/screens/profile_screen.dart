import 'package:material_ui/material_ui.dart';

import '../../../../core/data/repositories.dart';
import '../../../../core/formatting/dates.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../../medical_card/data/models/medical_card_data.dart';
import '../../data/models/personal_info.dart';
import '../../data/models/profile.dart';
import '../../data/profile_mock_data.dart';
import '../widgets/profile_sections.dart';

const _notSet = 'Not set';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Stream<Profile?>? _profile;
  Stream<PersonalInfo>? _personalInfo;
  Stream<MedicalCardData>? _medicalCard;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_profile != null) return;
    final repositories = RepositoriesScope.of(context);
    _profile = repositories.profile.watch();
    if (repositories.currentUser.isSignedIn) {
      _personalInfo = repositories.personalInfo.watch();
      _medicalCard = repositories.medicalCard.watch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
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
              child: StreamBuilder<Profile?>(
                stream: _profile,
                builder: (context, profile) => StreamBuilder<PersonalInfo>(
                  stream: _personalInfo,
                  builder: (context, personal) =>
                      StreamBuilder<MedicalCardData>(
                    stream: _medicalCard,
                    builder: (context, card) => _content(
                      profile.data,
                      personal.data ?? PersonalInfo.empty,
                      card.data ?? MedicalCardData.empty,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(
    Profile? profile,
    PersonalInfo personal,
    MedicalCardData card,
  ) {
    final subtitle = [
      personal.fallbackLocation?.label,
      profile?.email,
    ].whereType<String>().join(' · ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.l, AppSpacing.l, AppSpacing.l, 42),
      children: [
        for (final section in [
          ProfileHero(
            name: profile?.name ?? 'Not signed in',
            subtitle: subtitle,
          ),
          InfoRowsCard(
            rows: [
              InfoRow(
                'Date of birth',
                personal.dateOfBirth == null
                    ? _notSet
                    : formatDate(personal.dateOfBirth!),
              ),
              InfoRow('Blood type', card.card.bloodType?.label ?? _notSet),
              InfoRow(
                'Emergency contact',
                card.primaryContact?.name ?? _notSet,
              ),
            ],
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 0),
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
    );
  }
}
