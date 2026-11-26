import 'dart:async';

import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/data/repositories.dart';
import '../../../../core/formatting/masking.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/date_field.dart';
import '../../../../core/widgets/detail_page.dart';
import '../../../../core/widgets/draft_form.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../../../core/widgets/inline_text_field.dart';
import '../../../../core/widgets/placeholder_text.dart';
import '../../../../core/widgets/section_list.dart';
import '../../data/models/personal_info.dart';
import '../../data/models/profile.dart';

/// Personal Information from `personal_info`, edited in place like the
/// medical card: "Save" in the header writes all changes at once.
///
/// The display name replaces the Google name in the app only. The email is
/// the account's and shown masked. The home location opens the map
/// (`HomeLocationScreen`), which saves it by itself.
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen>
    with DraftForm<PersonalInfoScreen, PersonalInfo> {
  Repositories? _repositories;
  StreamSubscription<PersonalInfo>? _subscription;
  StreamSubscription<Profile?>? _profileSubscription;

  /// Account from Google: the email and the default name.
  Profile? _profile;

  final _displayName = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_repositories != null) return;
    final repositories = _repositories = RepositoriesScope.of(context);
    if (!repositories.currentUser.isSignedIn) return;
    _subscription = repositories.personalInfo.watch().listen(receiveStored);
    _profileSubscription = repositories.profile
        .watch()
        .listen((profile) => setState(() => _profile = profile));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _profileSubscription?.cancel();
    _displayName.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  @override
  void onDraftReset(PersonalInfo info) {
    _displayName.text = info.displayName ?? '';
    _height.text = info.heightCm?.toString() ?? '';
    _weight.text = info.weightKg == null ? '' : _number(info.weightKg!);
  }

  @override
  Future<void> writeDraft(PersonalInfo draft) =>
      _repositories!.personalInfo.save(draft);

  @override
  Widget build(BuildContext context) {
    final info = draft;
    return DetailPage(
      title: 'Personal Information',
      action: saveButton,
      body: SectionList(
        children: [
          if (info != null) _form(info),
        ],
      ),
    );
  }

  Widget _form(PersonalInfo info) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final email = _profile?.email;

    return InfoRowsCard(rows: [
      InfoRow.field(
        'Display name',
        InlineTextField(
          controller: _displayName,
          textAlign: TextAlign.left,
          // Empty: the Google name is used.
          hint: _profile?.displayName ?? 'Not set',
          onChanged: (value) => edit((i) => i.copyWith(displayName: value)),
        ),
      ),
      InfoRow('Email', email == null ? null : maskEmail(email)),
      InfoRow.control(
        'Date of birth',
        DateField(
          value: info.dateOfBirth,
          firstDate: DateTime(1900),
          lastDate: today,
          initialDate: DateTime(today.year - 30, today.month, today.day),
          onChanged: (value) => edit((i) => i.copyWith(dateOfBirth: value)),
        ),
      ),
      InfoRow.control(
        'Sex',
        AppDropdown<Sex?>(
          value: info.sex,
          options: [
            (null, 'Not set'),
            for (final sex in Sex.values) (sex, sex.label),
          ],
          onChanged: (value) => edit((i) => i.copyWith(sex: value)),
        ),
      ),
      InfoRow.field(
        'Height',
        InlineTextField(
          controller: _height,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          suffix: 'cm',
          onChanged: (value) => edit(
            (i) => i.copyWith(heightCm: value == null ? null : int.parse(value)),
          ),
        ),
      ),
      InfoRow.field(
        'Weight',
        InlineTextField(
          controller: _weight,
          textAlign: TextAlign.left,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // Up to 3 digits, then one decimal; comma or dot.
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}([.,]\d?)?')),
          ],
          suffix: 'kg',
          onChanged: (value) => edit(
            (i) => i.copyWith(weightKg: _parseWeight(value)),
          ),
        ),
      ),
      InfoRow.control(
        'Home location',
        _HomeLocationValue(
          label: info.fallbackLocation?.label,
          onTap: _editHomeLocation,
        ),
      ),
    ]);
  }

  /// The map screen saves the home location by itself. Unsaved changes on
  /// this page then get the new value too, so their "Save" keeps it.
  Future<void> _editHomeLocation() async {
    await context.push(AppRoutes.homeLocation);
    if (!mounted) return;
    final stored = await _repositories!.personalInfo.get();
    if (!mounted || draft == null) return;
    edit((i) => i.copyWith(fallbackLocation: stored.fallbackLocation));
  }

  /// "72,5" -> 72.5. Null for empty or a lone separator.
  static double? _parseWeight(String? value) =>
      value == null ? null : double.tryParse(value.replaceAll(',', '.'));

  /// "72" instead of "72.0".
  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

/// The home location's name, or "Set on map", with a chevron: opens the map.
class _HomeLocationValue extends StatelessWidget {
  const _HomeLocationValue({required this.label, required this.onTap});

  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Flexible(
            child: label == null
                ? const PlaceholderText('Set on map', textAlign: TextAlign.right)
                : Text(
                    label,
                    style: AppTextStyles.detailRowValue,
                    textAlign: TextAlign.right,
                  ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.secondaryText),
        ],
      ),
    );
  }
}

extension on Sex {
  String get label => switch (this) {
        Sex.female => 'Female',
        Sex.male => 'Male',
        Sex.other => 'Other',
      };
}
