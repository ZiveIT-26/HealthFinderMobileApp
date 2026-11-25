import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/session/current_user.dart';
import 'models/medical_card.dart';
import 'models/medical_card_data.dart';
import 'models/medical_records.dart';

/// Medical card of the signed-in user.
///
/// Screens read the whole card with [watch]. The single values are saved
/// together on "Save" of the card form ([saveCard]); each list item is
/// saved on "Save" of its own dialog (`save...`) and removed with
/// `delete...`.
///
/// Removing an item sets `deletedAt` (kept for a future backup). "Delete my
/// data" removes rows for good, see `AccountService`.
class MedicalCardRepository {
  MedicalCardRepository(this._db, this._user);

  final AppDatabase _db;
  final CurrentUser _user;

  // ---------------------------------------------------------------------------
  // Reading
  // ---------------------------------------------------------------------------

  Future<MedicalCardData> get() => _load(_user.require());

  /// Emits the card now and again after every change of its tables.
  Stream<MedicalCardData> watch() async* {
    final owner = _user.require();
    yield await _load(owner);
    final updates = _db.tableUpdates(
      TableUpdateQuery.onAllTables([
        _db.medicalCards,
        _db.chronicConditions,
        _db.allergies,
        _db.implants,
        _db.surgeries,
        _db.emergencyContacts,
      ]),
    );
    await for (final _ in updates) {
      yield await _load(owner);
    }
  }

  // ---------------------------------------------------------------------------
  // Single values
  // ---------------------------------------------------------------------------

  Future<void> saveCard(MedicalCard card) {
    final row = MedicalCardsCompanion(
      ownerUserId: Value(_user.require()),
      bloodType: Value(card.bloodType),
      insuranceCompany: Value(card.insuranceCompany),
      insuranceCompanyOther: Value(card.insuranceCompanyOther),
      gpName: Value(card.gpName),
      gpPhone: Value(card.gpPhone),
      pregnancyDueDate: Value(card.pregnancyDueDate),
      needsStepFreeAccess: Value(card.needsStepFreeAccess),
      notes: Value(card.notes),
      updatedAt: Value(DateTime.now()),
    );
    return _db.into(_db.medicalCards).insert(
          row,
          onConflict: DoUpdate((_) => row, target: [_db.medicalCards.ownerUserId]),
        );
  }

  // ---------------------------------------------------------------------------
  // Lists. `save...` inserts an item without an id and updates one with an
  // id; it returns the item's id. An update only touches a not deleted item
  // of the user's own card, otherwise it throws [StateError].
  // ---------------------------------------------------------------------------

  Future<String> saveCondition(ChronicCondition item) {
    return _db.transaction(() async {
      final cardId = await _ensureCardId();
      final row = ChronicConditionsCompanion(
        medicalCardId: Value(cardId),
        name: Value(item.name),
        since: Value(item.since),
        note: Value(item.note),
        updatedAt: Value(DateTime.now()),
      );
      final id = item.id;
      if (id == null) {
        return (await _db.into(_db.chronicConditions).insertReturning(row)).id;
      }
      final updated = await (_db.update(_db.chronicConditions)
            ..where((t) =>
                t.id.equals(id) &
                t.medicalCardId.equals(cardId) &
                t.deletedAt.isNull()))
          .write(row);
      return _checkUpdated(updated, id);
    });
  }

  Future<void> deleteCondition(String id) async {
    final cardId = await _cardId();
    if (cardId == null) return;
    final now = DateTime.now();
    await (_db.update(_db.chronicConditions)
          ..where((t) => t.id.equals(id) & t.medicalCardId.equals(cardId)))
        .write(ChronicConditionsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
        ));
  }

  Future<String> saveAllergy(Allergy item) {
    return _db.transaction(() async {
      final cardId = await _ensureCardId();
      final row = AllergiesCompanion(
        medicalCardId: Value(cardId),
        name: Value(item.name),
        kind: Value(item.kind),
        category: Value(item.category),
        reaction: Value(item.reaction),
        updatedAt: Value(DateTime.now()),
      );
      final id = item.id;
      if (id == null) {
        return (await _db.into(_db.allergies).insertReturning(row)).id;
      }
      final updated = await (_db.update(_db.allergies)
            ..where((t) =>
                t.id.equals(id) &
                t.medicalCardId.equals(cardId) &
                t.deletedAt.isNull()))
          .write(row);
      return _checkUpdated(updated, id);
    });
  }

  Future<void> deleteAllergy(String id) async {
    final cardId = await _cardId();
    if (cardId == null) return;
    final now = DateTime.now();
    await (_db.update(_db.allergies)
          ..where((t) => t.id.equals(id) & t.medicalCardId.equals(cardId)))
        .write(AllergiesCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  Future<String> saveImplant(Implant item) {
    return _db.transaction(() async {
      final cardId = await _ensureCardId();
      final row = ImplantsCompanion(
        medicalCardId: Value(cardId),
        name: Value(item.name),
        note: Value(item.note),
        updatedAt: Value(DateTime.now()),
      );
      final id = item.id;
      if (id == null) {
        return (await _db.into(_db.implants).insertReturning(row)).id;
      }
      final updated = await (_db.update(_db.implants)
            ..where((t) =>
                t.id.equals(id) &
                t.medicalCardId.equals(cardId) &
                t.deletedAt.isNull()))
          .write(row);
      return _checkUpdated(updated, id);
    });
  }

  Future<void> deleteImplant(String id) async {
    final cardId = await _cardId();
    if (cardId == null) return;
    final now = DateTime.now();
    await (_db.update(_db.implants)
          ..where((t) => t.id.equals(id) & t.medicalCardId.equals(cardId)))
        .write(ImplantsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  Future<String> saveSurgery(Surgery item) {
    return _db.transaction(() async {
      final cardId = await _ensureCardId();
      final row = SurgeriesCompanion(
        medicalCardId: Value(cardId),
        name: Value(item.name),
        year: Value(item.year),
        note: Value(item.note),
        updatedAt: Value(DateTime.now()),
      );
      final id = item.id;
      if (id == null) {
        return (await _db.into(_db.surgeries).insertReturning(row)).id;
      }
      final updated = await (_db.update(_db.surgeries)
            ..where((t) =>
                t.id.equals(id) &
                t.medicalCardId.equals(cardId) &
                t.deletedAt.isNull()))
          .write(row);
      return _checkUpdated(updated, id);
    });
  }

  Future<void> deleteSurgery(String id) async {
    final cardId = await _cardId();
    if (cardId == null) return;
    final now = DateTime.now();
    await (_db.update(_db.surgeries)
          ..where((t) => t.id.equals(id) & t.medicalCardId.equals(cardId)))
        .write(SurgeriesCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  /// Making a contact primary removes the flag from the previous primary
  /// contact first, so the "one primary per card" index is never violated.
  Future<String> saveContact(EmergencyContact item) {
    return _db.transaction(() async {
      final cardId = await _ensureCardId();
      if (item.isPrimary) {
        await (_db.update(_db.emergencyContacts)
              ..where((t) =>
                  t.medicalCardId.equals(cardId) & t.isPrimary.equals(true)))
            .write(const EmergencyContactsCompanion(isPrimary: Value(false)));
      }
      final row = EmergencyContactsCompanion(
        medicalCardId: Value(cardId),
        name: Value(item.name),
        phone: Value(item.phone),
        relation: Value(item.relation),
        isPrimary: Value(item.isPrimary),
        updatedAt: Value(DateTime.now()),
      );
      final id = item.id;
      if (id == null) {
        return (await _db.into(_db.emergencyContacts).insertReturning(row)).id;
      }
      final updated = await (_db.update(_db.emergencyContacts)
            ..where((t) =>
                t.id.equals(id) &
                t.medicalCardId.equals(cardId) &
                t.deletedAt.isNull()))
          .write(row);
      return _checkUpdated(updated, id);
    });
  }

  /// A deleted contact also loses the primary flag, so the index does not
  /// keep it reserved.
  Future<void> deleteContact(String id) async {
    final cardId = await _cardId();
    if (cardId == null) return;
    final now = DateTime.now();
    await (_db.update(_db.emergencyContacts)
          ..where((t) => t.id.equals(id) & t.medicalCardId.equals(cardId)))
        .write(EmergencyContactsCompanion(
          isPrimary: const Value(false),
          deletedAt: Value(now),
          updatedAt: Value(now),
        ));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Id of the user's card, or null if the card was never saved.
  Future<String?> _cardId() async {
    final row = await (_db.select(_db.medicalCards)
          ..where((t) => t.ownerUserId.equals(_user.require())))
        .getSingleOrNull();
    return row?.id;
  }

  /// Id of the user's card. Creates an empty card first, so a list item can
  /// be added before the card form was ever saved.
  Future<String> _ensureCardId() async {
    await _db.into(_db.medicalCards).insert(
          MedicalCardsCompanion.insert(ownerUserId: _user.require()),
          mode: InsertMode.insertOrIgnore,
        );
    return (await _cardId())!;
  }

  static String _checkUpdated(int updatedRows, String id) {
    if (updatedRows == 0) throw StateError('Medical card item $id not found');
    return id;
  }

  Future<MedicalCardData> _load(String owner) async {
    final card = await (_db.select(_db.medicalCards)
          ..where((t) => t.ownerUserId.equals(owner)))
        .getSingleOrNull();
    if (card == null) return MedicalCardData.empty;
    final cardId = card.id;

    final conditions = await (_db.select(_db.chronicConditions)
          ..where((t) => t.medicalCardId.equals(cardId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    final allergies = await (_db.select(_db.allergies)
          ..where((t) => t.medicalCardId.equals(cardId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    final implants = await (_db.select(_db.implants)
          ..where((t) => t.medicalCardId.equals(cardId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    final surgeries = await (_db.select(_db.surgeries)
          ..where((t) => t.medicalCardId.equals(cardId) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    final contacts = await (_db.select(_db.emergencyContacts)
          ..where((t) => t.medicalCardId.equals(cardId) & t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPrimary),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();

    return MedicalCardData(
      card: MedicalCard(
        bloodType: card.bloodType,
        insuranceCompany: card.insuranceCompany,
        insuranceCompanyOther: card.insuranceCompanyOther,
        gpName: card.gpName,
        gpPhone: card.gpPhone,
        pregnancyDueDate: card.pregnancyDueDate,
        needsStepFreeAccess: card.needsStepFreeAccess,
        notes: card.notes,
      ),
      conditions: [
        for (final r in conditions)
          ChronicCondition(id: r.id, name: r.name, since: r.since, note: r.note),
      ],
      allergies: [
        for (final r in allergies)
          Allergy(
            id: r.id,
            name: r.name,
            kind: r.kind,
            category: r.category,
            reaction: r.reaction,
          ),
      ],
      implants: [
        for (final r in implants) Implant(id: r.id, name: r.name, note: r.note),
      ],
      surgeries: [
        for (final r in surgeries)
          Surgery(id: r.id, name: r.name, year: r.year, note: r.note),
      ],
      contacts: [
        for (final r in contacts)
          EmergencyContact(
            id: r.id,
            name: r.name,
            phone: r.phone,
            relation: r.relation,
            isPrimary: r.isPrimary,
          ),
      ],
    );
  }
}
