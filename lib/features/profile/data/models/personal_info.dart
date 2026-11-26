import '../../../../core/models/unset.dart';

/// Biological sex, used for symptom assessment and medication checks.
enum Sex { female, male, other }

/// Personal data entered by the user. Local only, one per account.
class PersonalInfo {
  const PersonalInfo({
    this.displayName,
    this.dateOfBirth,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.fallbackLocation,
  });

  static const empty = PersonalInfo();

  /// Name shown in the app instead of the Google name; null uses that one.
  final String? displayName;
  final DateTime? dateOfBirth;
  final Sex? sex;
  final int? heightCm;
  final double? weightKg;

  /// Home location, used for doctor search when GPS is unavailable.
  final FallbackLocation? fallbackLocation;

  /// Same values, so a form can tell whether it has unsaved changes.
  @override
  bool operator ==(Object other) =>
      other is PersonalInfo &&
      other.displayName == displayName &&
      other.dateOfBirth == dateOfBirth &&
      other.sex == sex &&
      other.heightCm == heightCm &&
      other.weightKg == weightKg &&
      other.fallbackLocation == fallbackLocation;

  @override
  int get hashCode =>
      Object.hash(displayName, dateOfBirth, sex, heightCm, weightKg, fallbackLocation);

  PersonalInfo copyWith({
    Object? displayName = unset,
    Object? dateOfBirth = unset,
    Object? sex = unset,
    Object? heightCm = unset,
    Object? weightKg = unset,
    Object? fallbackLocation = unset,
  }) {
    return PersonalInfo(
      displayName: pick(displayName, this.displayName),
      dateOfBirth: pick(dateOfBirth, this.dateOfBirth),
      sex: pick(sex, this.sex),
      heightCm: pick(heightCm, this.heightCm),
      weightKg: pick(weightKg, this.weightKg),
      fallbackLocation: pick(fallbackLocation, this.fallbackLocation),
    );
  }
}

/// The user's home, used for doctor search when the current position is not
/// available. Set from GPS or a point on a map; [label] is its display name
/// from reverse geocoding.
class FallbackLocation {
  const FallbackLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is FallbackLocation &&
      other.label == label &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(label, latitude, longitude);
}
