import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_links.dart';
import '../../../../core/data/repositories.dart';
import '../../../../core/formatting/dates.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../../../core/storage/consent.dart';
import '../../../../core/storage/settings_scope.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/card_tile.dart';
import '../../../../core/widgets/detail_page.dart';
import '../../../../core/widgets/grouped_card.dart';
import '../../../../core/widgets/section_list.dart';
import '../../../../core/widgets/section_title.dart';
import '../../data/models/user_settings.dart';
import '../widgets/account_actions.dart';
import '../widgets/settings_controls.dart';

const _languages = [
  SheetOption<String?>(null, 'System'),
  SheetOption<String?>('en', 'English'),
  SheetOption<String?>('sk', 'Slovenčina'),
];

const _themes = [
  SheetOption(ThemeMode.system, 'System'),
  SheetOption(ThemeMode.light, 'Light'),
  SheetOption(ThemeMode.dark, 'Dark'),
];

const _repeatIntervals = [
  SheetOption<int?>(null, 'Off'),
  SheetOption<int?>(10, '10 min'),
  SheetOption<int?>(15, '15 min'),
  SheetOption<int?>(30, '30 min'),
];

/// Subtitle of the Terms of use row, from the `terms` consent.
String _termsStatus(Consent? terms) => terms != null && terms.isValid
    ? 'Accepted ${formatDate(terms.grantedAt)}'
    : 'Not accepted';

String _label<T>(List<SheetOption<T>> options, T value) =>
    options.firstWhere((o) => o.value == value, orElse: () => options.first).label;

/// Settings: app preferences, notifications, privacy and help, one scroll.
///
/// Device settings (language, theme, app lock) are in [AppPreferences],
/// per-account ones in `user_settings` and `consents`. Everything is saved
/// as soon as it changes.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Repositories? _repositories;
  Stream<UserSettings>? _settings;
  Stream<bool>? _aiChat;
  Stream<bool>? _aiContext;
  Stream<Consent?>? _terms;
  final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_repositories != null) return;
    final repositories = _repositories = RepositoriesScope.of(context);
    if (repositories.currentUser.isSignedIn) {
      _settings = repositories.userSettings.watch();
      _aiChat = repositories.consents.watchValid(ConsentType.aiChat);
      _aiContext = repositories.consents.watchValid(ConsentType.aiContext);
      _terms = repositories.consents.watchLatest(ConsentType.terms);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferences = SettingsScope.of(context);
    return DetailPage(
      title: 'Settings',
      body: StreamBuilder<UserSettings>(
        stream: _settings,
        builder: (context, settings) => StreamBuilder<bool>(
          stream: _aiChat,
          builder: (context, aiChat) => StreamBuilder<bool>(
            stream: _aiContext,
            builder: (context, aiContext) => _content(
              preferences,
              settings.data,
              aiChat: aiChat.data ?? false,
              aiContext: aiContext.data ?? false,
            ),
          ),
        ),
      ),
    );
  }

  /// [settings] is null until loaded or when signed out: the per-account
  /// rows are then disabled.
  Widget _content(
    AppPreferences preferences,
    UserSettings? settings, {
    required bool aiChat,
    required bool aiContext,
  }) {
    final hasAccount = settings != null;
    final s = settings ?? UserSettings.defaults;

    return SectionList(
      children: [
        const SectionTitle('App preferences'),
        GroupedCard(children: [
          SettingsValueTile(
            title: 'Language',
            value: _label(_languages, preferences.locale?.languageCode),
            onTap: () => _pickLanguage(preferences),
          ),
          SettingsValueTile(
            title: 'Theme',
            value: _label(_themes, preferences.themeMode),
            onTap: () => _pickTheme(preferences),
          ),
        ]),
        const SectionTitle('Notifications'),
        GroupedCard(children: [
          SettingsSwitchTile(
            title: 'Medication reminders',
            subtitle: 'At the times of your schedule',
            value: s.medicationRemindersEnabled,
            enabled: hasAccount,
            onChanged: (v) => _update((current) => current.copyWith(medicationRemindersEnabled: v)),
          ),
          SettingsValueTile(
            title: 'Repeat if not marked',
            subtitle: 'Remind again until the dose is marked',
            value: _label(_repeatIntervals, s.repeatReminderMinutes),
            enabled: hasAccount && s.medicationRemindersEnabled,
            onTap: () => _pickRepeat(s),
          ),
          SettingsSwitchTile(
            title: 'Mood check-in',
            subtitle: 'A daily reminder to log your mood',
            value: s.moodRemindersEnabled,
            enabled: hasAccount,
            onChanged: (v) => _update((current) => current.copyWith(moodRemindersEnabled: v)),
          ),
          SettingsValueTile(
            title: 'Check-in time',
            value: MaterialLocalizations.of(context)
                .formatTimeOfDay(s.moodReminderTime, alwaysUse24HourFormat: true),
            enabled: hasAccount && s.moodRemindersEnabled,
            onTap: () => _pickCheckInTime(s),
          ),
          SettingsSwitchTile(
            title: 'Health alerts',
            subtitle: 'Heatwaves, pollen and air quality',
            value: s.healthAlertsEnabled,
            enabled: hasAccount,
            onChanged: (v) => _update((current) => current.copyWith(healthAlertsEnabled: v)),
          ),
          SettingsSwitchTile(
            title: 'Tips & recommendations',
            value: s.recommendationsEnabled,
            enabled: hasAccount,
            onChanged: (v) => _update((current) => current.copyWith(recommendationsEnabled: v)),
          ),
        ]),
        const SectionTitle('Privacy & Data'),
        GroupedCard(children: [
          SettingsSwitchTile(
            title: 'AI chat data processing',
            subtitle: 'Your messages are processed on our server',
            value: aiChat,
            enabled: hasAccount,
            onChanged: _setAiChat,
          ),
          SettingsSwitchTile(
            title: 'Share medical card with AI',
            subtitle: 'Sent with your questions as context',
            value: aiChat && aiContext,
            enabled: hasAccount && aiChat,
            onChanged: (v) => _setConsent(ConsentType.aiContext, v),
          ),
          SettingsSwitchTile(
            title: 'Remember location in a chat',
            subtitle: 'Where to search for doctors is asked once per chat. '
                'Off: before every search',
            value: preferences.chatLocationRemember,
            onChanged: preferences.setChatLocationRemember,
          ),
          SettingsSwitchTile(
            title: 'App lock',
            subtitle: 'Face ID or fingerprint to open the app',
            value: preferences.appLockEnabled,
            onChanged: preferences.setAppLockEnabled,
          ),
          SettingsLinkTile(
            title: 'Privacy policy',
            external: true,
            onTap: _linkAction(AppLinks.privacyPolicy),
          ),
          StreamBuilder<Consent?>(
            stream: _terms,
            builder: (context, terms) => SettingsLinkTile(
              title: 'Terms of use',
              subtitle: _termsStatus(terms.data),
              external: true,
              onTap: _linkAction(AppLinks.termsOfUse),
            ),
          ),
          CardTile(
            title: 'Delete local data',
            subtitle: 'Personal information, medical card and settings '
                'on this device',
            titleColor: AppColors.actionPink,
            enabled: hasAccount,
            onTap: () => confirmDeleteMyData(context),
            trailing: const Icon(
              Icons.delete_outline,
              size: 20,
              color: AppColors.actionPink,
            ),
          ),
        ]),
        const SectionTitle('Help & Support'),
        GroupedCard(children: [
          SettingsLinkTile(
            title: 'FAQ',
            external: true,
            onTap: _linkAction(AppLinks.faq),
          ),
          SettingsLinkTile(
            title: 'Contact support',
            external: true,
            onTap: _linkAction(
              AppLinks.supportEmail == null
                  ? null
                  : 'mailto:${AppLinks.supportEmail}',
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: _packageInfo,
            builder: (context, info) => CardTile(
              title: 'App version',
              trailing: Text(
                info.data == null ? '—' : info.data!.version,
                style: AppTextStyles.detailRowValue,
              ),
            ),
          ),
        ]),
      ],
    );
  }

  /// Applies [change] to the stored settings, not to the last value the
  /// screen received, so two quick changes do not overwrite each other.
  Future<void> _update(UserSettings Function(UserSettings) change) async {
    final repository = _repositories!.userSettings;
    await repository.save(change(await repository.get()));
  }

  Future<void> _setConsent(ConsentType type, bool granted) {
    final consents = _repositories!.consents;
    return granted ? consents.grant(type) : consents.revoke(type);
  }

  /// The medical card is only sent through the chat, so turning the chat
  /// off revokes it too.
  Future<void> _setAiChat(bool granted) async {
    await _setConsent(ConsentType.aiChat, granted);
    if (!granted) await _setConsent(ConsentType.aiContext, false);
  }

  Future<void> _pickLanguage(AppPreferences preferences) async {
    final picked = await showOptionsSheet(
      context: context,
      title: 'Language',
      options: _languages,
      selected: preferences.locale?.languageCode,
      note: 'System uses the language of your phone. '
          'Only English and Slovak are available.',
    );
    if (picked == null) return;
    final code = picked.value;
    await preferences.setLocale(code == null ? null : Locale(code));
  }

  Future<void> _pickTheme(AppPreferences preferences) async {
    final picked = await showOptionsSheet(
      context: context,
      title: 'Theme',
      options: _themes,
      selected: preferences.themeMode,
    );
    if (picked != null) await preferences.setThemeMode(picked.value);
  }

  Future<void> _pickRepeat(UserSettings settings) async {
    final picked = await showOptionsSheet(
      context: context,
      title: 'Repeat if not marked',
      options: _repeatIntervals,
      selected: settings.repeatReminderMinutes,
    );
    if (picked != null) {
      await _update((current) => current.copyWith(repeatReminderMinutes: picked.value));
    }
  }

  Future<void> _pickCheckInTime(UserSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: settings.moodReminderTime,
      helpText: 'Mood check-in time',
    );
    if (picked != null) await _update((current) => current.copyWith(moodReminderTime: picked));
  }

  VoidCallback? _linkAction(String? url) =>
      url == null ? null : () => _open(url);

  Future<void> _open(String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link.')),
      );
    }
  }
}
