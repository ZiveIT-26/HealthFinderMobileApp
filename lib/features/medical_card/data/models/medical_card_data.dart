import 'medical_card.dart';
import 'medical_records.dart';

/// The whole medical card of the user: the single values and all lists.
class MedicalCardData {
  const MedicalCardData({
    this.card = MedicalCard.empty,
    this.conditions = const [],
    this.allergies = const [],
    this.implants = const [],
    this.surgeries = const [],
    this.contacts = const [],
  });

  static const empty = MedicalCardData();

  final MedicalCard card;
  final List<ChronicCondition> conditions;
  final List<Allergy> allergies;
  final List<Implant> implants;
  final List<Surgery> surgeries;

  /// The primary contact comes first.
  final List<EmergencyContact> contacts;

  EmergencyContact? get primaryContact {
    for (final contact in contacts) {
      if (contact.isPrimary) return contact;
    }
    return contacts.isEmpty ? null : contacts.first;
  }
}
