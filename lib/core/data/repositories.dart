import 'package:flutter/widgets.dart';

import '../../features/ai_chat/data/chat_cache_repository.dart';
import '../../features/medical_card/data/medical_card_repository.dart';
import '../../features/profile/data/personal_info_repository.dart';
import '../../features/profile/data/profile_repository.dart';
import '../../features/profile/data/user_settings_repository.dart';
import '../session/account_service.dart';
import '../session/current_user.dart';
import '../storage/app_storage.dart';
import '../storage/consent_repository.dart';

/// All repositories of the app, created once at startup over one database.
class Repositories {
  factory Repositories(AppStorage storage) {
    final db = storage.database;
    final currentUser = CurrentUser();
    final profile = ProfileRepository(db);
    final userSettings = UserSettingsRepository(db, currentUser);
    final consents = ConsentRepository(db, currentUser);
    return Repositories._(
      currentUser: currentUser,
      profile: profile,
      personalInfo: PersonalInfoRepository(db, currentUser),
      medicalCard: MedicalCardRepository(db, currentUser),
      userSettings: userSettings,
      consents: consents,
      chatCache: ChatCacheRepository(db),
      account: AccountService(
        db: db,
        currentUser: currentUser,
        profiles: profile,
        userSettings: userSettings,
        consents: consents,
        preferences: storage.preferences,
        secure: storage.secure,
      ),
    );
  }

  const Repositories._({
    required this.currentUser,
    required this.profile,
    required this.personalInfo,
    required this.medicalCard,
    required this.userSettings,
    required this.consents,
    required this.chatCache,
    required this.account,
  });

  final CurrentUser currentUser;
  final ProfileRepository profile;
  final PersonalInfoRepository personalInfo;
  final MedicalCardRepository medicalCard;
  final UserSettingsRepository userSettings;
  final ConsentRepository consents;
  final ChatCacheRepository chatCache;
  final AccountService account;
}

/// Makes [Repositories] available to the widget tree, like `SettingsScope`.
///
/// `RepositoriesScope.of(context)` does not rebuild on data changes: screens
/// subscribe to the repositories' `watch` streams instead. To react to
/// sign-in and sign-out, listen to `currentUser` (a `ChangeNotifier`).
class RepositoriesScope extends InheritedWidget {
  const RepositoriesScope({
    super.key,
    required this.repositories,
    required super.child,
  });

  final Repositories repositories;

  static Repositories of(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<RepositoriesScope>();
    assert(scope != null, 'No RepositoriesScope found in context');
    return scope!.repositories;
  }

  @override
  bool updateShouldNotify(RepositoriesScope oldWidget) =>
      repositories != oldWidget.repositories;
}
