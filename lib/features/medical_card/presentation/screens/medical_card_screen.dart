import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../../core/data/repositories.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/card_tile.dart';
import '../../../../core/widgets/date_field.dart';
import '../../../../core/widgets/detail_page.dart';
import '../../../../core/widgets/draft_form.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../../../core/widgets/inline_text_field.dart';
import '../../../../core/widgets/section_list.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../../core/widgets/tag.dart';
import '../../../profile/data/models/personal_info.dart';
import '../../data/models/medical_card.dart';
import '../../data/models/medical_card_data.dart';
import '../../data/models/medical_records.dart';
import '../widgets/medical_list_section.dart';

const _storageNote = 'Information is stored locally on this device and is not '
    'shared automatically with clinicians or emergency services.';

/// Medical card. Every entry is self-reported and shown as is, never
/// assessed.
///
/// The single values are edited in place and kept in a draft; "Save" in the
/// header appears when the draft differs from the stored card and writes it
/// in one go. The lists are shown one row per item.
class MedicalCardScreen extends StatefulWidget {
  const MedicalCardScreen({super.key});

  @override
  State<MedicalCardScreen> createState() => _MedicalCardScreenState();
}

class _MedicalCardScreenState extends State<MedicalCardScreen>
    with DraftForm<MedicalCardScreen, MedicalCard> {
  Repositories? _repositories;
  StreamSubscription<MedicalCardData>? _cardSubscription;
  StreamSubscription<PersonalInfo>? _personalSubscription;

  MedicalCardData? _data;

  /// For the sex: pregnancy is shown only for women.
  PersonalInfo _personal = PersonalInfo.empty;

  final _insurerName = TextEditingController();
  final _gpName = TextEditingController();
  final _gpPhone = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_repositories != null) return;
    final repositories = _repositories = RepositoriesScope.of(context);
    if (!repositories.currentUser.isSignedIn) return;
    _cardSubscription = repositories.medicalCard.watch().listen(_onCard);
    _personalSubscription = repositories.personalInfo
        .watch()
        .listen((info) => setState(() => _personal = info));
  }

  @override
  void dispose() {
    _cardSubscription?.cancel();
    _personalSubscription?.cancel();
    _insurerName.dispose();
    _gpName.dispose();
    _gpPhone.dispose();
    super.dispose();
  }

  void _onCard(MedicalCardData data) {
    _data = data;
    receiveStored(data.card);
  }

  @override
  void onDraftReset(MedicalCard card) {
    _insurerName.text = card.insuranceCompanyOther ?? '';
    _gpName.text = card.gpName ?? '';
    _gpPhone.text = card.gpPhone ?? '';
  }

  @override
  Future<void> writeDraft(MedicalCard draft) =>
      _repositories!.medicalCard.saveCard(draft);

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return DetailPage(
      title: 'Medical Card',
      action: saveButton,
      body: SectionList(
        children: [
          if (data != null)
            ..._sections(data, draft!)
          else if (_cardSubscription == null)
            Text('Sign in to see your medical card.', style: AppTextStyles.body),
          Text(_storageNote, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  /// Current medications are not shown yet: they come from the medications
  /// table, which is designed later.
  List<Widget> _sections(MedicalCardData data, MedicalCard card) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = card.pregnancyDueDate;

    return [
      const SectionTitle('Medical information'),
      InfoRowsCard(rows: [
        InfoRow.control(
          'Blood type',
          AppDropdown<BloodType?>(
            value: card.bloodType,
            options: [
              (null, 'Not set'),
              for (final type in BloodType.values) (type, type.label),
            ],
            onChanged: (value) => edit((c) => c.copyWith(bloodType: value)),
          ),
        ),
        // Only for women. A passed due date is kept but not shown.
        if (_personal.sex == Sex.female)
          InfoRow.control(
            'Pregnancy due date',
            DateField(
              value: dueDate != null && card.isPregnantOn(today) ? dueDate : null,
              firstDate: today,
              lastDate: today.add(const Duration(days: 300)),
              onChanged: (value) =>
                  edit((c) => c.copyWith(pregnancyDueDate: value)),
            ),
          ),
        InfoRow.control(
          'Step-free access',
          AppSwitch(
            value: card.needsStepFreeAccess,
            onChanged: (value) =>
                edit((c) => c.copyWith(needsStepFreeAccess: value)),
          ),
        ),
      ]),
      ..._lists(data),
      const SectionTitle('Insurance & GP'),
      InfoRowsCard(rows: [
        InfoRow.control(
          'Insurance',
          AppDropdown<InsuranceCompany?>(
            value: card.insuranceCompany,
            options: [
              (null, 'Not set'),
              for (final company in InsuranceCompany.values)
                (company, company.label),
            ],
            onChanged: (value) {
              // The model drops the insurer name for any other choice.
              if (value != InsuranceCompany.other) _insurerName.clear();
              edit((c) => c.copyWith(insuranceCompany: value));
            },
          ),
        ),
        if (card.insuranceCompany == InsuranceCompany.other)
          InfoRow.field(
            'Insurer name',
            InlineTextField(
              controller: _insurerName,
              textAlign: TextAlign.left,
              onChanged: (value) =>
                  edit((c) => c.copyWith(insuranceCompanyOther: value)),
            ),
          ),
        InfoRow.field(
          'Personal doctor',
          InlineTextField(
            controller: _gpName,
            textAlign: TextAlign.left,
            onChanged: (value) => edit((c) => c.copyWith(gpName: value)),
          ),
        ),
        InfoRow.field(
          "Doctor's phone",
          InlineTextField.phone(
            controller: _gpPhone,
            textAlign: TextAlign.left,
            onChanged: (value) => edit((c) => c.copyWith(gpPhone: value)),
          ),
        ),
      ]),
    ];
  }

  static List<Widget> _lists(MedicalCardData data) => [
        MedicalListSection(title: 'Allergies & intolerances', items: [
          for (final a in data.allergies)
            CardTile(
              title: a.name,
              subtitle: _details([a.category.label, a.reaction]),
              trailing: Tag(a.kind.label),
            ),
        ]),
        MedicalListSection(title: 'Chronic conditions', items: [
          for (final c in data.conditions)
            CardTile(
              title: c.name,
              subtitle: _details([if (c.since != null) 'Since ${c.since}', c.note]),
            ),
        ]),
        MedicalListSection(title: 'Implants & devices', items: [
          for (final i in data.implants) CardTile(title: i.name, subtitle: i.note),
        ]),
        MedicalListSection(title: 'Past surgeries', items: [
          for (final s in data.surgeries)
            CardTile(title: s.name, subtitle: _details([s.year?.toString(), s.note])),
        ]),
        MedicalListSection(title: 'Emergency contacts', items: [
          for (final c in _primaryFirst(data.contacts))
            CardTile(
              title: c.name,
              subtitle: _details([c.relation, c.phone]),
              trailing: c.isPrimary ? const Tag('Primary') : null,
            ),
        ]),
      ];

  /// "Food · Rash"; null when every part is empty.
  static String? _details(List<String?> parts) {
    final text = parts.whereType<String>().where((p) => p.isNotEmpty).join(' · ');
    return text.isEmpty ? null : text;
  }

  static List<EmergencyContact> _primaryFirst(List<EmergencyContact> contacts) =>
      [...contacts.where((c) => c.isPrimary), ...contacts.where((c) => !c.isPrimary)];
}

extension on AllergyKind {
  String get label => switch (this) {
        AllergyKind.allergy => 'Allergy',
        AllergyKind.intolerance => 'Intolerance',
      };
}

extension on AllergyCategory {
  String get label => switch (this) {
        AllergyCategory.medication => 'Medication',
        AllergyCategory.food => 'Food',
        AllergyCategory.other => 'Other',
      };
}
