import '../../../../core/models/unset.dart';

/// Biological sex, used for symptom assessment and medication checks.
enum Sex { female, male, other }

/// Personal data entered by the user. Local only, one per account.
class PersonalInfo {
  const PersonalInfo({
    this.dateOfBirth,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.fallbackLocation,
  });

  static const empty = PersonalInfo();

  final DateTime? dateOfBirth;
  final Sex? sex;
  final int? heightCm;
  final double? weightKg;

  /// Used for doctor search when GPS is unavailable.
  final FallbackLocation? fallbackLocation;

  PersonalInfo copyWith({
    Object? dateOfBirth = unset,
    Object? sex = unset,
    Object? heightCm = unset,
    Object? weightKg = unset,
    Object? fallbackLocation = unset,
  }) {
    return PersonalInfo(
      dateOfBirth: pick(dateOfBirth, this.dateOfBirth),
      sex: pick(sex, this.sex),
      heightCm: pick(heightCm, this.heightCm),
      weightKg: pick(weightKg, this.weightKg),
      fallbackLocation: pick(fallbackLocation, this.fallbackLocation),
    );
  }
}

/// A town or district of the Košice region, picked from a list.
class FallbackLocation {
  const FallbackLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}
