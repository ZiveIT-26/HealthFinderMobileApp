import 'package:drift/drift.dart';

import '../../features/ai_chat/data/models/chat_cache.dart';
import '../../features/medical_card/data/models/medical_card.dart';
import '../../features/medical_card/data/models/medical_records.dart';
import '../../features/profile/data/models/personal_info.dart';
import '../storage/consent.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// The encrypted local database. Open it with `openEncryptedDatabase`.
///
/// Connection pragmas (key, foreign keys, secure delete) are set in
/// `connection.dart`, before drift uses the database.
@DriftDatabase(
  tables: [
    Profiles,
    PersonalInfos,
    MedicalCards,
    ChronicConditions,
    Allergies,
    Implants,
    Surgeries,
    EmergencyContacts,
    UserSettingsTable,
    Consents,
    Chats,
    Messages,
    Clinics,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Bump together with a new step in [migration].
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement(_onePrimaryContactPerCard);
        },
      );
}

/// At most one primary emergency contact per card, ignoring deleted ones.
const _onePrimaryContactPerCard = '''
CREATE UNIQUE INDEX emergency_contacts_one_primary
ON emergency_contacts (medical_card_id)
WHERE is_primary = 1 AND deleted_at IS NULL
''';
