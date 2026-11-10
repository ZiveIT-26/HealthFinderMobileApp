/// Mock medical card until the backend is ready.
library;

import '../../../core/widgets/info_rows_card.dart';

class MedicalCardSection {
  const MedicalCardSection(this.title, this.rows);

  final String title;
  final List<InfoRow> rows;
}

abstract final class MedicalCardMockData {
  static const sections = [
    MedicalCardSection('Medical Information', [
      InfoRow('Blood Type', 'O+'),
      InfoRow('Allergies', 'Penicillin, kiwi'),
      InfoRow('Medical Conditions', 'Migraine, mild asthma'),
      InfoRow(
        'Additional Notes',
        'Sensitive to strong fragrances. In an emergency, please contact my mother first.',
      ),
    ]),
    MedicalCardSection('Emergency Contact', [
      InfoRow('Contact Name', 'Taylor Morgan'),
      InfoRow('Phone Number', '+421 900 000 001'),
    ]),
    MedicalCardSection('Current Medications', [
      InfoRow('Paracetamol', '500 mg · Every day'),
      InfoRow('Vitamin D', '1000 IU · Every day'),
      InfoRow('Magnesium', '200 mg · Every 6 months'),
    ]),
    MedicalCardSection('Insurance & GP', [
      InfoRow('Insurance', 'VšZP'),
      InfoRow('Personal doctor', 'MUDr. Jana Nováková'),
    ]),
  ];

  static const storageNote = 'Information is stored locally on this device and is not '
      'shared automatically with clinicians or emergency services.';
}
