import '../../features/medical_card/data/medical_card_repository.dart';
import '../../features/medical_card/data/models/medical_card.dart';
import '../../features/medical_card/data/models/medical_records.dart';
import '../../features/profile/data/models/personal_info.dart';
import '../../features/profile/data/models/profile.dart';
import '../../features/profile/data/personal_info_repository.dart';
import 'account_service.dart';

/// Temporary, debug builds only: signs in a local test account and fills
/// its medical card with the former mock data, so the screens have
/// something to show before Google sign-in exists. Remove together with the
/// call in `main.dart` once sign-in is implemented.
///
/// The id is the backend's test user (`POST /auth/test-login`).
Future<void> signInDevelopmentAccount({
  required AccountService account,
  required PersonalInfoRepository personalInfo,
  required MedicalCardRepository medicalCard,
}) async {
  await account.signIn(
    const Profile(
      userId: '00000000-0000-0000-0000-000000000001',
      email: 'test@healthfinder.local',
      displayName: 'Alex Morgan',
    ),
  );

  // Seed only an untouched card, never over the user's own changes.
  final existing = await medicalCard.get();
  final untouched = existing.card.bloodType == null &&
      existing.conditions.isEmpty &&
      existing.allergies.isEmpty &&
      existing.contacts.isEmpty;
  if (!untouched) return;

  await personalInfo.save(
    PersonalInfo(
      dateOfBirth: DateTime(1987, 6, 15),
      fallbackLocation: const FallbackLocation(
        label: 'Košice',
        latitude: 48.7164,
        longitude: 21.2611,
      ),
    ),
  );
  await medicalCard.saveCard(
    const MedicalCard(
      bloodType: BloodType.oPositive,
      insuranceCompany: InsuranceCompany.vszp,
      gpName: 'MUDr. Jana Nováková',
      notes: 'Sensitive to strong fragrances. In an emergency, please '
          'contact my mother first.',
    ),
  );
  await medicalCard.saveAllergy(
    const Allergy(
      name: 'Penicillin',
      kind: AllergyKind.allergy,
      category: AllergyCategory.medication,
    ),
  );
  await medicalCard.saveAllergy(
    const Allergy(
      name: 'Kiwi',
      kind: AllergyKind.allergy,
      category: AllergyCategory.food,
    ),
  );
  await medicalCard.saveCondition(const ChronicCondition(name: 'Migraine'));
  await medicalCard.saveCondition(const ChronicCondition(name: 'Mild asthma'));
  await medicalCard.saveContact(
    const EmergencyContact(
      name: 'Taylor Morgan',
      phone: '+421 900 000 001',
      isPrimary: true,
    ),
  );
}
