import 'package:material_ui/material_ui.dart';

import '../../../../core/data/repositories.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/detail_heading.dart';
import '../../../../core/widgets/info_rows_card.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/pill_button.dart';
import '../../data/models/medical_card_data.dart';
import '../widgets/medical_card_hero.dart';

const _storageNote = 'Information is stored locally on this device and is not '
    'shared automatically with clinicians or emergency services.';

const _notSet = 'Not set';

class MedicalCardScreen extends StatefulWidget {
  const MedicalCardScreen({super.key});

  @override
  State<MedicalCardScreen> createState() => _MedicalCardScreenState();
}

class _MedicalCardScreenState extends State<MedicalCardScreen> {
  Stream<MedicalCardData>? _card;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repositories = RepositoriesScope.of(context);
    _card ??= repositories.currentUser.isSignedIn
        ? repositories.medicalCard.watch()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Medical Card'),
            Expanded(
              child: StreamBuilder<MedicalCardData>(
                stream: _card,
                builder: (context, snapshot) => ListView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.l, AppSpacing.m, AppSpacing.l, 30),
                  children: [
                    for (final section in [
                      const MedicalCardHero(),
                      if (snapshot.data case final data?)
                        for (final s in _sections(data)) ...[
                          DetailHeading(s.title),
                          InfoRowsCard(rows: s.rows, tinted: true),
                        ]
                      else if (_card == null)
                        Text('Sign in to see your medical card.',
                            style: AppTextStyles.caption),
                      // Not interactive yet: there is no edit screen.
                      const PillButton(
                          icon: Icons.edit_outlined,
                          label: 'Edit Medical Card'),
                      Text(_storageNote, style: AppTextStyles.caption),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: section,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Current medications are not shown yet: they come from the medications
  /// table, which is designed later.
  static List<({String title, List<InfoRow> rows})> _sections(
    MedicalCardData data,
  ) {
    final card = data.card;
    final contact = data.primaryContact;
    return [
      (
        title: 'Medical Information',
        rows: [
          InfoRow('Blood Type', card.bloodType?.label ?? _notSet),
          InfoRow('Allergies', _join(data.allergies.map((a) => a.name))),
          InfoRow(
              'Medical Conditions', _join(data.conditions.map((c) => c.name))),
          InfoRow('Implants', _join(data.implants.map((i) => i.name))),
          InfoRow(
            'Past Surgeries',
            _join(data.surgeries.map(
                (s) => s.year == null ? s.name : '${s.name} (${s.year})')),
          ),
          InfoRow('Additional Notes', card.notes ?? _notSet),
        ],
      ),
      (
        title: 'Emergency Contact',
        rows: [
          InfoRow('Contact Name', contact?.name ?? _notSet),
          InfoRow('Phone Number', contact?.phone ?? _notSet),
        ],
      ),
      (
        title: 'Insurance & GP',
        rows: [
          InfoRow('Insurance', card.insuranceName ?? _notSet),
          InfoRow('Personal doctor', card.gpName ?? _notSet),
        ],
      ),
    ];
  }

  static String _join(Iterable<String> values) =>
      values.isEmpty ? _notSet : values.join(', ');
}
