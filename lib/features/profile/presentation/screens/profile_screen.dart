import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../core/data/repositories.dart';
import '../../../../core/formatting/masking.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/section_list.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../medical_card/presentation/widgets/medical_card_hero.dart';
import '../../data/models/personal_info.dart';
import '../../data/models/profile.dart';
import '../../data/profile_mock_data.dart';
import '../widgets/account_actions.dart';
import '../widgets/profile_sections.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Stream<Profile?>? _profile;

  /// For the display name set in the app.
  Stream<PersonalInfo>? _personalInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_profile != null) return;
    final repositories = RepositoriesScope.of(context);
    _profile = repositories.profile.watch();
    if (repositories.currentUser.isSignedIn) {
      _personalInfo = repositories.personalInfo.watch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: StreamBuilder<Profile?>(
          stream: _profile,
          builder: (context, profile) => StreamBuilder<PersonalInfo>(
            stream: _personalInfo,
            builder: (context, personal) =>
                _content(profile.data, personal.data?.displayName),
          ),
        ),
      ),
    );
  }

  /// [displayName] is the name set in the app; the Google name otherwise.
  Widget _content(Profile? profile, String? displayName) {
    final email = profile?.email;
    return SectionList(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.l, AppSpacing.l, AppSpacing.l, 30),
      children: [
        ProfileHero(
          name: displayName ?? profile?.name ?? 'Not signed in',
          subtitle: email == null ? '' : maskEmail(email),
          avatarUrl: profile?.avatarUrl,
          action: AppButton.icon(
            Icons.logout,
            variant: AppButtonVariant.soft,
            tooltip: 'Sign out',
            onTap: authController.signOut,
          ),
        ),
        // Quick access to the emergency information.
        MedicalCardHero(
          onTap: () => context.push(AppRoutes.medicalCard),
        ),
        for (final group in ProfileMockData.groups) ...[
          SectionTitle(group.title),
          for (final item in group.items) SettingsRow(item: item),
        ],
      ],
      belowFold: [
        AppButton.text(
          'Sign out',
          variant: AppButtonVariant.soft,
          size: AppButtonSize.large,
          expanded: true,
          onTap: authController.signOut,
        ),
        AppButton.text(
          'Delete account',
          variant: AppButtonVariant.soft,
          size: AppButtonSize.large,
          expanded: true,
          foregroundColor: AppColors.actionPink,
          onTap: () => confirmDeleteMyData(context),
        ),
      ],
    );
  }
}
