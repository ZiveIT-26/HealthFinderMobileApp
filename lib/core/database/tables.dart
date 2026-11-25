import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../features/ai_chat/data/models/chat_cache.dart';
import '../../features/medical_card/data/models/medical_card.dart';
import '../../features/medical_card/data/models/medical_records.dart';
import '../../features/profile/data/models/personal_info.dart';
import '../storage/consent.dart';

// Tables of the local database. Fields and reasons: docs/storage/
// database-schema.md. Table names follow that document; row classes end in
// "Row" so they do not clash with the entities the repositories return.
//
// Enums are stored by name (textEnum), dates as ISO-8601 text (build.yaml).

const _uuid = Uuid();

/// New random UUID for a primary key. Public because drift copies the
/// `clientDefault` expression into the generated part of `app_database.dart`,
/// where a private function of this file is not visible.
String newId() => _uuid.v4();

// -----------------------------------------------------------------------------
// Account
// -----------------------------------------------------------------------------

/// The signed-in account, cached from the backend. At most one row.
/// Deleting it on sign-out deletes the chat cache (cascade).
@DataClassName('ProfileRow')
class Profiles extends Table {
  @override
  String get tableName => 'profile';

  TextColumn get id => text().clientDefault(newId)();

  /// `user.id` from the backend.
  TextColumn get serverId => text().unique()();
  TextColumn get displayName => text().nullable()();
  TextColumn get email => text()();
  TextColumn get avatarUrl => text().nullable()();

  /// Last sign-in.
  DateTimeColumn get syncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PersonalInfoRow')
class PersonalInfos extends Table {
  @override
  String get tableName => 'personal_info';

  TextColumn get id => text().clientDefault(newId)();

  /// `user.id` from the backend. Not a foreign key: the profile is deleted
  /// on sign-out, this data is kept.
  TextColumn get ownerUserId => text().unique()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get sex => textEnum<Sex>().nullable()();
  IntColumn get heightCm => integer().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get fallbackLocationLabel => text().nullable()();
  RealColumn get fallbackLatitude => real().nullable()();
  RealColumn get fallbackLongitude => real().nullable()();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// -----------------------------------------------------------------------------
// Medical card
// -----------------------------------------------------------------------------

@DataClassName('MedicalCardRow')
class MedicalCards extends Table {
  @override
  String get tableName => 'medical_card';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get ownerUserId => text().unique()();
  TextColumn get bloodType => textEnum<BloodType>().nullable()();
  TextColumn get insuranceCompany => textEnum<InsuranceCompany>().nullable()();
  TextColumn get insuranceCompanyOther => text().nullable()();
  TextColumn get gpName => text().nullable()();
  TextColumn get gpPhone => text().nullable()();
  DateTimeColumn get pregnancyDueDate => dateTime().nullable()();
  BoolColumn get needsStepFreeAccess =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        "CHECK (insurance_company_other IS NULL "
            "OR insurance_company = 'other')",
      ];
}

@DataClassName('ChronicConditionRow')
class ChronicConditions extends Table {
  @override
  String get tableName => 'chronic_conditions';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get medicalCardId => text()
      .references(MedicalCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();

  /// Year the condition started.
  IntColumn get since => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AllergyRow')
class Allergies extends Table {
  @override
  String get tableName => 'allergies';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get medicalCardId => text()
      .references(MedicalCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get kind => textEnum<AllergyKind>()();
  TextColumn get category => textEnum<AllergyCategory>()();
  TextColumn get reaction => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ImplantRow')
class Implants extends Table {
  @override
  String get tableName => 'implants';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get medicalCardId => text()
      .references(MedicalCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SurgeryRow')
class Surgeries extends Table {
  @override
  String get tableName => 'surgeries';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get medicalCardId => text()
      .references(MedicalCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get year => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// At most one primary contact per card: a partial unique index created in
/// the migration (`AppDatabase`), drift has no column API for it.
@DataClassName('EmergencyContactRow')
class EmergencyContacts extends Table {
  @override
  String get tableName => 'emergency_contacts';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get medicalCardId => text()
      .references(MedicalCards, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get relation => text().nullable()();
  TextColumn get phone => text()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// -----------------------------------------------------------------------------
// Settings
// -----------------------------------------------------------------------------

@DataClassName('UserSettingsRow')
class UserSettingsTable extends Table {
  @override
  String get tableName => 'user_settings';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get ownerUserId => text().unique()();
  BoolColumn get medicationRemindersEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get repeatReminderMinutes => integer().nullable()();
  BoolColumn get moodRemindersEnabled =>
      boolean().withDefault(const Constant(true))();

  /// "HH:mm".
  TextColumn get moodReminderTime =>
      text().withDefault(const Constant('20:00'))();
  BoolColumn get healthAlertsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get recommendationsEnabled =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per grant. Revoking sets [revokedAt]; granting again adds a row.
@DataClassName('ConsentRow')
@TableIndex(name: 'consents_owner_type', columns: {#ownerUserId, #type})
class Consents extends Table {
  @override
  String get tableName => 'consents';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get ownerUserId => text()();
  TextColumn get type => textEnum<ConsentType>()();
  IntColumn get version => integer()();
  DateTimeColumn get grantedAt => dateTime()();
  DateTimeColumn get revokedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// -----------------------------------------------------------------------------
// AI chat cache
// -----------------------------------------------------------------------------

@DataClassName('ChatRow')
class Chats extends Table {
  @override
  String get tableName => 'chats';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// `sessionId` on the backend.
  TextColumn get serverId => text().unique()();
  TextColumn get title => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  /// Last time the chat was in the server list.
  DateTimeColumn get fetchedAt => dateTime()();

  /// Null: the history was never loaded.
  DateTimeColumn get historyFetchedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MessageRow')
class Messages extends Table {
  @override
  String get tableName => 'messages';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get chatId =>
      text().references(Chats, #id, onDelete: KeyAction.cascade)();

  /// Index in the history array.
  IntColumn get position => integer()();
  TextColumn get role => textEnum<MessageRole>()();

  // `text` is taken by the column builder method, so the getter has another
  // name; the column is still called "text".
  TextColumn get body => text().named('text')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {chatId, position},
      ];
}

/// Snapshot of `payload.doctors` of an assistant message. Not deduplicated.
@DataClassName('ClinicRow')
class Clinics extends Table {
  @override
  String get tableName => 'clinics';

  TextColumn get id => text().clientDefault(newId)();
  TextColumn get messageId =>
      text().references(Messages, #id, onDelete: KeyAction.cascade)();

  /// Order in `doctors[]`.
  IntColumn get position => integer()();
  TextColumn get name => text()();
  TextColumn get speciality => text()();
  TextColumn get address => text()();
  TextColumn get url => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get additionalInfo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {messageId, position},
      ];
}
