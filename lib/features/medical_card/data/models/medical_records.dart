import '../../../../core/models/unset.dart';

// Items of the medical card lists. All of them are entered by the user and
// shown as "My records".
//
// `id` is null for an item that has not been saved yet; the repository
// assigns it on insert.

class ChronicCondition {
  const ChronicCondition({this.id, required this.name, this.since, this.note});

  final String? id;
  final String name;

  /// Year the condition started.
  final int? since;
  final String? note;

  ChronicCondition copyWith({
    String? name,
    Object? since = unset,
    Object? note = unset,
  }) {
    return ChronicCondition(
      id: id,
      name: name ?? this.name,
      since: pick(since, this.since),
      note: pick(note, this.note),
    );
  }
}

/// An allergy can cause anaphylaxis, an intolerance cannot.
enum AllergyKind { allergy, intolerance }

/// Food and medication entries feed interaction checks (Epic 3).
enum AllergyCategory { medication, food, other }

class Allergy {
  const Allergy({
    this.id,
    required this.name,
    required this.kind,
    required this.category,
    this.reaction,
  });

  final String? id;
  final String name;
  final AllergyKind kind;
  final AllergyCategory category;
  final String? reaction;

  Allergy copyWith({
    String? name,
    AllergyKind? kind,
    AllergyCategory? category,
    Object? reaction = unset,
  }) {
    return Allergy(
      id: id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      category: category ?? this.category,
      reaction: pick(reaction, this.reaction),
    );
  }
}

/// Implants and medical devices: pacemaker, insulin pump, prostheses.
class Implant {
  const Implant({this.id, required this.name, this.note});

  final String? id;
  final String name;
  final String? note;

  Implant copyWith({String? name, Object? note = unset}) {
    return Implant(
      id: id,
      name: name ?? this.name,
      note: pick(note, this.note),
    );
  }
}

class Surgery {
  const Surgery({this.id, required this.name, this.year, this.note});

  final String? id;
  final String name;
  final int? year;
  final String? note;

  Surgery copyWith({
    String? name,
    Object? year = unset,
    Object? note = unset,
  }) {
    return Surgery(
      id: id,
      name: name ?? this.name,
      year: pick(year, this.year),
      note: pick(note, this.note),
    );
  }
}

class EmergencyContact {
  const EmergencyContact({
    this.id,
    required this.name,
    required this.phone,
    this.relation,
    this.isPrimary = false,
  });

  final String? id;
  final String name;
  final String phone;

  /// "Mother", "Partner".
  final String? relation;

  /// At most one primary contact per card.
  final bool isPrimary;

  EmergencyContact copyWith({
    String? name,
    String? phone,
    Object? relation = unset,
    bool? isPrimary,
  }) {
    return EmergencyContact(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: pick(relation, this.relation),
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
