import '../../../../core/models/unset.dart';

enum BloodType {
  aPositive('A+'),
  aNegative('A-'),
  bPositive('B+'),
  bNegative('B-'),
  abPositive('AB+'),
  abNegative('AB-'),
  oPositive('O+'),
  oNegative('O-');

  const BloodType(this.label);

  final String label;
}

/// Slovak health insurers. The database stores the enum name, the UI shows
/// [label].
enum InsuranceCompany {
  vszp('VšZP'),
  dovera('Dôvera'),
  union('Union'),
  other('Other');

  const InsuranceCompany(this.label);

  final String label;
}

/// The single-value part of the medical card. One per account.
///
/// The lists (conditions, allergies, implants, surgeries, contacts) are
/// separate entities, see `medical_records.dart`.
class MedicalCard {
  const MedicalCard({
    this.bloodType,
    this.insuranceCompany,
    this.insuranceCompanyOther,
    this.gpName,
    this.gpPhone,
    this.pregnancyDueDate,
    this.needsStepFreeAccess = false,
    this.notes,
  }) : assert(
          insuranceCompanyOther == null ||
              insuranceCompany == InsuranceCompany.other,
          'insuranceCompanyOther is only used with InsuranceCompany.other',
        );

  static const empty = MedicalCard();

  final BloodType? bloodType;
  final InsuranceCompany? insuranceCompany;

  /// Name of the insurer when [insuranceCompany] is [InsuranceCompany.other].
  final String? insuranceCompanyOther;
  final String? gpName;
  final String? gpPhone;
  final DateTime? pregnancyDueDate;

  /// Default of the barrier-free filter in doctor search (Epic 4).
  final bool needsStepFreeAccess;
  final String? notes;

  /// The due date is kept, but the pregnancy is not shown after it.
  bool isPregnantOn(DateTime day) {
    final due = pregnancyDueDate;
    if (due == null) return false;
    final date = DateTime(day.year, day.month, day.day);
    return !date.isAfter(DateTime(due.year, due.month, due.day));
  }

  /// Insurer name for the UI.
  String? get insuranceName => insuranceCompany == InsuranceCompany.other
      ? insuranceCompanyOther
      : insuranceCompany?.label;

  /// Changing the insurer away from `other` clears [insuranceCompanyOther],
  /// so a stale name is never kept.
  MedicalCard copyWith({
    Object? bloodType = unset,
    Object? insuranceCompany = unset,
    Object? insuranceCompanyOther = unset,
    Object? gpName = unset,
    Object? gpPhone = unset,
    Object? pregnancyDueDate = unset,
    bool? needsStepFreeAccess,
    Object? notes = unset,
  }) {
    final company =
        pick<InsuranceCompany?>(insuranceCompany, this.insuranceCompany);
    final other =
        pick<String?>(insuranceCompanyOther, this.insuranceCompanyOther);
    return MedicalCard(
      bloodType: pick(bloodType, this.bloodType),
      insuranceCompany: company,
      insuranceCompanyOther: company == InsuranceCompany.other ? other : null,
      gpName: pick(gpName, this.gpName),
      gpPhone: pick(gpPhone, this.gpPhone),
      pregnancyDueDate: pick(pregnancyDueDate, this.pregnancyDueDate),
      needsStepFreeAccess: needsStepFreeAccess ?? this.needsStepFreeAccess,
      notes: pick(notes, this.notes),
    );
  }
}
