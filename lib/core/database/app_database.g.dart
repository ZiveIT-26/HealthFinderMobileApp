// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    displayName,
    email,
    avatarUrl,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_syncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String id;

  /// `user.id` from the backend.
  final String serverId;
  final String? displayName;
  final String email;
  final String? avatarUrl;

  /// Last sign-in.
  final DateTime syncedAt;
  const ProfileRow({
    required this.id,
    required this.serverId,
    this.displayName,
    required this.email,
    this.avatarUrl,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['server_id'] = Variable<String>(serverId);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      serverId: Value(serverId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      email: Value(email),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      syncedAt: Value(syncedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      email: serializer.fromJson<String>(json['email']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String>(serverId),
      'displayName': serializer.toJson<String?>(displayName),
      'email': serializer.toJson<String>(email),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? serverId,
    Value<String?> displayName = const Value.absent(),
    String? email,
    Value<String?> avatarUrl = const Value.absent(),
    DateTime? syncedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    displayName: displayName.present ? displayName.value : this.displayName,
    email: email ?? this.email,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverId, displayName, email, avatarUrl, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.avatarUrl == this.avatarUrl &&
          other.syncedAt == this.syncedAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> serverId;
  final Value<String?> displayName;
  final Value<String> email;
  final Value<String?> avatarUrl;
  final Value<DateTime> syncedAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    this.displayName = const Value.absent(),
    required String email,
    this.avatarUrl = const Value.absent(),
    required DateTime syncedAt,
    this.rowid = const Value.absent(),
  }) : serverId = Value(serverId),
       email = Value(email),
       syncedAt = Value(syncedAt);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<String>? avatarUrl,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? serverId,
    Value<String?>? displayName,
    Value<String>? email,
    Value<String?>? avatarUrl,
    Value<DateTime>? syncedAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalInfosTable extends PersonalInfos
    with TableInfo<$PersonalInfosTable, PersonalInfoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Sex?, String> sex =
      GeneratedColumn<String>(
        'sex',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Sex?>($PersonalInfosTable.$convertersexn);
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fallbackLocationLabelMeta =
      const VerificationMeta('fallbackLocationLabel');
  @override
  late final GeneratedColumn<String> fallbackLocationLabel =
      GeneratedColumn<String>(
        'fallback_location_label',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fallbackLatitudeMeta = const VerificationMeta(
    'fallbackLatitude',
  );
  @override
  late final GeneratedColumn<double> fallbackLatitude = GeneratedColumn<double>(
    'fallback_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fallbackLongitudeMeta = const VerificationMeta(
    'fallbackLongitude',
  );
  @override
  late final GeneratedColumn<double> fallbackLongitude =
      GeneratedColumn<double>(
        'fallback_longitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    dateOfBirth,
    sex,
    heightCm,
    weightKg,
    fallbackLocationLabel,
    fallbackLatitude,
    fallbackLongitude,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalInfoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('fallback_location_label')) {
      context.handle(
        _fallbackLocationLabelMeta,
        fallbackLocationLabel.isAcceptableOrUnknown(
          data['fallback_location_label']!,
          _fallbackLocationLabelMeta,
        ),
      );
    }
    if (data.containsKey('fallback_latitude')) {
      context.handle(
        _fallbackLatitudeMeta,
        fallbackLatitude.isAcceptableOrUnknown(
          data['fallback_latitude']!,
          _fallbackLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('fallback_longitude')) {
      context.handle(
        _fallbackLongitudeMeta,
        fallbackLongitude.isAcceptableOrUnknown(
          data['fallback_longitude']!,
          _fallbackLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalInfoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalInfoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      sex: $PersonalInfosTable.$convertersexn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        ),
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      fallbackLocationLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fallback_location_label'],
      ),
      fallbackLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fallback_latitude'],
      ),
      fallbackLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fallback_longitude'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PersonalInfosTable createAlias(String alias) {
    return $PersonalInfosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Sex, String, String> $convertersex =
      const EnumNameConverter<Sex>(Sex.values);
  static JsonTypeConverter2<Sex?, String?, String?> $convertersexn =
      JsonTypeConverter2.asNullable($convertersex);
}

class PersonalInfoRow extends DataClass implements Insertable<PersonalInfoRow> {
  final String id;

  /// `user.id` from the backend. Not a foreign key: the profile is deleted
  /// on sign-out, this data is kept.
  final String ownerUserId;
  final DateTime? dateOfBirth;
  final Sex? sex;
  final int? heightCm;
  final double? weightKg;
  final String? fallbackLocationLabel;
  final double? fallbackLatitude;
  final double? fallbackLongitude;
  final DateTime updatedAt;
  const PersonalInfoRow({
    required this.id,
    required this.ownerUserId,
    this.dateOfBirth,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.fallbackLocationLabel,
    this.fallbackLatitude,
    this.fallbackLongitude,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(
        $PersonalInfosTable.$convertersexn.toSql(sex),
      );
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<int>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || fallbackLocationLabel != null) {
      map['fallback_location_label'] = Variable<String>(fallbackLocationLabel);
    }
    if (!nullToAbsent || fallbackLatitude != null) {
      map['fallback_latitude'] = Variable<double>(fallbackLatitude);
    }
    if (!nullToAbsent || fallbackLongitude != null) {
      map['fallback_longitude'] = Variable<double>(fallbackLongitude);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonalInfosCompanion toCompanion(bool nullToAbsent) {
    return PersonalInfosCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      fallbackLocationLabel: fallbackLocationLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(fallbackLocationLabel),
      fallbackLatitude: fallbackLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(fallbackLatitude),
      fallbackLongitude: fallbackLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(fallbackLongitude),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonalInfoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalInfoRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      sex: $PersonalInfosTable.$convertersexn.fromJson(
        serializer.fromJson<String?>(json['sex']),
      ),
      heightCm: serializer.fromJson<int?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      fallbackLocationLabel: serializer.fromJson<String?>(
        json['fallbackLocationLabel'],
      ),
      fallbackLatitude: serializer.fromJson<double?>(json['fallbackLatitude']),
      fallbackLongitude: serializer.fromJson<double?>(
        json['fallbackLongitude'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'sex': serializer.toJson<String?>(
        $PersonalInfosTable.$convertersexn.toJson(sex),
      ),
      'heightCm': serializer.toJson<int?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'fallbackLocationLabel': serializer.toJson<String?>(
        fallbackLocationLabel,
      ),
      'fallbackLatitude': serializer.toJson<double?>(fallbackLatitude),
      'fallbackLongitude': serializer.toJson<double?>(fallbackLongitude),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonalInfoRow copyWith({
    String? id,
    String? ownerUserId,
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<Sex?> sex = const Value.absent(),
    Value<int?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    Value<String?> fallbackLocationLabel = const Value.absent(),
    Value<double?> fallbackLatitude = const Value.absent(),
    Value<double?> fallbackLongitude = const Value.absent(),
    DateTime? updatedAt,
  }) => PersonalInfoRow(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    sex: sex.present ? sex.value : this.sex,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    fallbackLocationLabel: fallbackLocationLabel.present
        ? fallbackLocationLabel.value
        : this.fallbackLocationLabel,
    fallbackLatitude: fallbackLatitude.present
        ? fallbackLatitude.value
        : this.fallbackLatitude,
    fallbackLongitude: fallbackLongitude.present
        ? fallbackLongitude.value
        : this.fallbackLongitude,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PersonalInfoRow copyWithCompanion(PersonalInfosCompanion data) {
    return PersonalInfoRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      sex: data.sex.present ? data.sex.value : this.sex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      fallbackLocationLabel: data.fallbackLocationLabel.present
          ? data.fallbackLocationLabel.value
          : this.fallbackLocationLabel,
      fallbackLatitude: data.fallbackLatitude.present
          ? data.fallbackLatitude.value
          : this.fallbackLatitude,
      fallbackLongitude: data.fallbackLongitude.present
          ? data.fallbackLongitude.value
          : this.fallbackLongitude,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalInfoRow(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('fallbackLocationLabel: $fallbackLocationLabel, ')
          ..write('fallbackLatitude: $fallbackLatitude, ')
          ..write('fallbackLongitude: $fallbackLongitude, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    dateOfBirth,
    sex,
    heightCm,
    weightKg,
    fallbackLocationLabel,
    fallbackLatitude,
    fallbackLongitude,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalInfoRow &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.dateOfBirth == this.dateOfBirth &&
          other.sex == this.sex &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.fallbackLocationLabel == this.fallbackLocationLabel &&
          other.fallbackLatitude == this.fallbackLatitude &&
          other.fallbackLongitude == this.fallbackLongitude &&
          other.updatedAt == this.updatedAt);
}

class PersonalInfosCompanion extends UpdateCompanion<PersonalInfoRow> {
  final Value<String> id;
  final Value<String> ownerUserId;
  final Value<DateTime?> dateOfBirth;
  final Value<Sex?> sex;
  final Value<int?> heightCm;
  final Value<double?> weightKg;
  final Value<String?> fallbackLocationLabel;
  final Value<double?> fallbackLatitude;
  final Value<double?> fallbackLongitude;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PersonalInfosCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.fallbackLocationLabel = const Value.absent(),
    this.fallbackLatitude = const Value.absent(),
    this.fallbackLongitude = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalInfosCompanion.insert({
    this.id = const Value.absent(),
    required String ownerUserId,
    this.dateOfBirth = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.fallbackLocationLabel = const Value.absent(),
    this.fallbackLatitude = const Value.absent(),
    this.fallbackLongitude = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId);
  static Insertable<PersonalInfoRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUserId,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? sex,
    Expression<int>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? fallbackLocationLabel,
    Expression<double>? fallbackLatitude,
    Expression<double>? fallbackLongitude,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (sex != null) 'sex': sex,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (fallbackLocationLabel != null)
        'fallback_location_label': fallbackLocationLabel,
      if (fallbackLatitude != null) 'fallback_latitude': fallbackLatitude,
      if (fallbackLongitude != null) 'fallback_longitude': fallbackLongitude,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalInfosCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUserId,
    Value<DateTime?>? dateOfBirth,
    Value<Sex?>? sex,
    Value<int?>? heightCm,
    Value<double?>? weightKg,
    Value<String?>? fallbackLocationLabel,
    Value<double?>? fallbackLatitude,
    Value<double?>? fallbackLongitude,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PersonalInfosCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fallbackLocationLabel:
          fallbackLocationLabel ?? this.fallbackLocationLabel,
      fallbackLatitude: fallbackLatitude ?? this.fallbackLatitude,
      fallbackLongitude: fallbackLongitude ?? this.fallbackLongitude,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(
        $PersonalInfosTable.$convertersexn.toSql(sex.value),
      );
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (fallbackLocationLabel.present) {
      map['fallback_location_label'] = Variable<String>(
        fallbackLocationLabel.value,
      );
    }
    if (fallbackLatitude.present) {
      map['fallback_latitude'] = Variable<double>(fallbackLatitude.value);
    }
    if (fallbackLongitude.present) {
      map['fallback_longitude'] = Variable<double>(fallbackLongitude.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalInfosCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('fallbackLocationLabel: $fallbackLocationLabel, ')
          ..write('fallbackLatitude: $fallbackLatitude, ')
          ..write('fallbackLongitude: $fallbackLongitude, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalCardsTable extends MedicalCards
    with TableInfo<$MedicalCardsTable, MedicalCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BloodType?, String> bloodType =
      GeneratedColumn<String>(
        'blood_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<BloodType?>($MedicalCardsTable.$converterbloodTypen);
  @override
  late final GeneratedColumnWithTypeConverter<InsuranceCompany?, String>
  insuranceCompany =
      GeneratedColumn<String>(
        'insurance_company',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<InsuranceCompany?>(
        $MedicalCardsTable.$converterinsuranceCompanyn,
      );
  static const VerificationMeta _insuranceCompanyOtherMeta =
      const VerificationMeta('insuranceCompanyOther');
  @override
  late final GeneratedColumn<String> insuranceCompanyOther =
      GeneratedColumn<String>(
        'insurance_company_other',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _gpNameMeta = const VerificationMeta('gpName');
  @override
  late final GeneratedColumn<String> gpName = GeneratedColumn<String>(
    'gp_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpPhoneMeta = const VerificationMeta(
    'gpPhone',
  );
  @override
  late final GeneratedColumn<String> gpPhone = GeneratedColumn<String>(
    'gp_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pregnancyDueDateMeta = const VerificationMeta(
    'pregnancyDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> pregnancyDueDate =
      GeneratedColumn<DateTime>(
        'pregnancy_due_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _needsStepFreeAccessMeta =
      const VerificationMeta('needsStepFreeAccess');
  @override
  late final GeneratedColumn<bool> needsStepFreeAccess = GeneratedColumn<bool>(
    'needs_step_free_access',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_step_free_access" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    bloodType,
    insuranceCompany,
    insuranceCompanyOther,
    gpName,
    gpPhone,
    pregnancyDueDate,
    needsStepFreeAccess,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_card';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicalCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('insurance_company_other')) {
      context.handle(
        _insuranceCompanyOtherMeta,
        insuranceCompanyOther.isAcceptableOrUnknown(
          data['insurance_company_other']!,
          _insuranceCompanyOtherMeta,
        ),
      );
    }
    if (data.containsKey('gp_name')) {
      context.handle(
        _gpNameMeta,
        gpName.isAcceptableOrUnknown(data['gp_name']!, _gpNameMeta),
      );
    }
    if (data.containsKey('gp_phone')) {
      context.handle(
        _gpPhoneMeta,
        gpPhone.isAcceptableOrUnknown(data['gp_phone']!, _gpPhoneMeta),
      );
    }
    if (data.containsKey('pregnancy_due_date')) {
      context.handle(
        _pregnancyDueDateMeta,
        pregnancyDueDate.isAcceptableOrUnknown(
          data['pregnancy_due_date']!,
          _pregnancyDueDateMeta,
        ),
      );
    }
    if (data.containsKey('needs_step_free_access')) {
      context.handle(
        _needsStepFreeAccessMeta,
        needsStepFreeAccess.isAcceptableOrUnknown(
          data['needs_step_free_access']!,
          _needsStepFreeAccessMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      bloodType: $MedicalCardsTable.$converterbloodTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}blood_type'],
        ),
      ),
      insuranceCompany: $MedicalCardsTable.$converterinsuranceCompanyn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}insurance_company'],
        ),
      ),
      insuranceCompanyOther: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insurance_company_other'],
      ),
      gpName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gp_name'],
      ),
      gpPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gp_phone'],
      ),
      pregnancyDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pregnancy_due_date'],
      ),
      needsStepFreeAccess: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_step_free_access'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicalCardsTable createAlias(String alias) {
    return $MedicalCardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BloodType, String, String> $converterbloodType =
      const EnumNameConverter<BloodType>(BloodType.values);
  static JsonTypeConverter2<BloodType?, String?, String?> $converterbloodTypen =
      JsonTypeConverter2.asNullable($converterbloodType);
  static JsonTypeConverter2<InsuranceCompany, String, String>
  $converterinsuranceCompany = const EnumNameConverter<InsuranceCompany>(
    InsuranceCompany.values,
  );
  static JsonTypeConverter2<InsuranceCompany?, String?, String?>
  $converterinsuranceCompanyn = JsonTypeConverter2.asNullable(
    $converterinsuranceCompany,
  );
}

class MedicalCardRow extends DataClass implements Insertable<MedicalCardRow> {
  final String id;
  final String ownerUserId;
  final BloodType? bloodType;
  final InsuranceCompany? insuranceCompany;
  final String? insuranceCompanyOther;
  final String? gpName;
  final String? gpPhone;
  final DateTime? pregnancyDueDate;
  final bool needsStepFreeAccess;
  final String? notes;
  final DateTime updatedAt;
  const MedicalCardRow({
    required this.id,
    required this.ownerUserId,
    this.bloodType,
    this.insuranceCompany,
    this.insuranceCompanyOther,
    this.gpName,
    this.gpPhone,
    this.pregnancyDueDate,
    required this.needsStepFreeAccess,
    this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    if (!nullToAbsent || bloodType != null) {
      map['blood_type'] = Variable<String>(
        $MedicalCardsTable.$converterbloodTypen.toSql(bloodType),
      );
    }
    if (!nullToAbsent || insuranceCompany != null) {
      map['insurance_company'] = Variable<String>(
        $MedicalCardsTable.$converterinsuranceCompanyn.toSql(insuranceCompany),
      );
    }
    if (!nullToAbsent || insuranceCompanyOther != null) {
      map['insurance_company_other'] = Variable<String>(insuranceCompanyOther);
    }
    if (!nullToAbsent || gpName != null) {
      map['gp_name'] = Variable<String>(gpName);
    }
    if (!nullToAbsent || gpPhone != null) {
      map['gp_phone'] = Variable<String>(gpPhone);
    }
    if (!nullToAbsent || pregnancyDueDate != null) {
      map['pregnancy_due_date'] = Variable<DateTime>(pregnancyDueDate);
    }
    map['needs_step_free_access'] = Variable<bool>(needsStepFreeAccess);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalCardsCompanion toCompanion(bool nullToAbsent) {
    return MedicalCardsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      bloodType: bloodType == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodType),
      insuranceCompany: insuranceCompany == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceCompany),
      insuranceCompanyOther: insuranceCompanyOther == null && nullToAbsent
          ? const Value.absent()
          : Value(insuranceCompanyOther),
      gpName: gpName == null && nullToAbsent
          ? const Value.absent()
          : Value(gpName),
      gpPhone: gpPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(gpPhone),
      pregnancyDueDate: pregnancyDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(pregnancyDueDate),
      needsStepFreeAccess: Value(needsStepFreeAccess),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicalCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalCardRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      bloodType: $MedicalCardsTable.$converterbloodTypen.fromJson(
        serializer.fromJson<String?>(json['bloodType']),
      ),
      insuranceCompany: $MedicalCardsTable.$converterinsuranceCompanyn.fromJson(
        serializer.fromJson<String?>(json['insuranceCompany']),
      ),
      insuranceCompanyOther: serializer.fromJson<String?>(
        json['insuranceCompanyOther'],
      ),
      gpName: serializer.fromJson<String?>(json['gpName']),
      gpPhone: serializer.fromJson<String?>(json['gpPhone']),
      pregnancyDueDate: serializer.fromJson<DateTime?>(
        json['pregnancyDueDate'],
      ),
      needsStepFreeAccess: serializer.fromJson<bool>(
        json['needsStepFreeAccess'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'bloodType': serializer.toJson<String?>(
        $MedicalCardsTable.$converterbloodTypen.toJson(bloodType),
      ),
      'insuranceCompany': serializer.toJson<String?>(
        $MedicalCardsTable.$converterinsuranceCompanyn.toJson(insuranceCompany),
      ),
      'insuranceCompanyOther': serializer.toJson<String?>(
        insuranceCompanyOther,
      ),
      'gpName': serializer.toJson<String?>(gpName),
      'gpPhone': serializer.toJson<String?>(gpPhone),
      'pregnancyDueDate': serializer.toJson<DateTime?>(pregnancyDueDate),
      'needsStepFreeAccess': serializer.toJson<bool>(needsStepFreeAccess),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalCardRow copyWith({
    String? id,
    String? ownerUserId,
    Value<BloodType?> bloodType = const Value.absent(),
    Value<InsuranceCompany?> insuranceCompany = const Value.absent(),
    Value<String?> insuranceCompanyOther = const Value.absent(),
    Value<String?> gpName = const Value.absent(),
    Value<String?> gpPhone = const Value.absent(),
    Value<DateTime?> pregnancyDueDate = const Value.absent(),
    bool? needsStepFreeAccess,
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
  }) => MedicalCardRow(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    bloodType: bloodType.present ? bloodType.value : this.bloodType,
    insuranceCompany: insuranceCompany.present
        ? insuranceCompany.value
        : this.insuranceCompany,
    insuranceCompanyOther: insuranceCompanyOther.present
        ? insuranceCompanyOther.value
        : this.insuranceCompanyOther,
    gpName: gpName.present ? gpName.value : this.gpName,
    gpPhone: gpPhone.present ? gpPhone.value : this.gpPhone,
    pregnancyDueDate: pregnancyDueDate.present
        ? pregnancyDueDate.value
        : this.pregnancyDueDate,
    needsStepFreeAccess: needsStepFreeAccess ?? this.needsStepFreeAccess,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicalCardRow copyWithCompanion(MedicalCardsCompanion data) {
    return MedicalCardRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      insuranceCompany: data.insuranceCompany.present
          ? data.insuranceCompany.value
          : this.insuranceCompany,
      insuranceCompanyOther: data.insuranceCompanyOther.present
          ? data.insuranceCompanyOther.value
          : this.insuranceCompanyOther,
      gpName: data.gpName.present ? data.gpName.value : this.gpName,
      gpPhone: data.gpPhone.present ? data.gpPhone.value : this.gpPhone,
      pregnancyDueDate: data.pregnancyDueDate.present
          ? data.pregnancyDueDate.value
          : this.pregnancyDueDate,
      needsStepFreeAccess: data.needsStepFreeAccess.present
          ? data.needsStepFreeAccess.value
          : this.needsStepFreeAccess,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalCardRow(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('bloodType: $bloodType, ')
          ..write('insuranceCompany: $insuranceCompany, ')
          ..write('insuranceCompanyOther: $insuranceCompanyOther, ')
          ..write('gpName: $gpName, ')
          ..write('gpPhone: $gpPhone, ')
          ..write('pregnancyDueDate: $pregnancyDueDate, ')
          ..write('needsStepFreeAccess: $needsStepFreeAccess, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    bloodType,
    insuranceCompany,
    insuranceCompanyOther,
    gpName,
    gpPhone,
    pregnancyDueDate,
    needsStepFreeAccess,
    notes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalCardRow &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.bloodType == this.bloodType &&
          other.insuranceCompany == this.insuranceCompany &&
          other.insuranceCompanyOther == this.insuranceCompanyOther &&
          other.gpName == this.gpName &&
          other.gpPhone == this.gpPhone &&
          other.pregnancyDueDate == this.pregnancyDueDate &&
          other.needsStepFreeAccess == this.needsStepFreeAccess &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class MedicalCardsCompanion extends UpdateCompanion<MedicalCardRow> {
  final Value<String> id;
  final Value<String> ownerUserId;
  final Value<BloodType?> bloodType;
  final Value<InsuranceCompany?> insuranceCompany;
  final Value<String?> insuranceCompanyOther;
  final Value<String?> gpName;
  final Value<String?> gpPhone;
  final Value<DateTime?> pregnancyDueDate;
  final Value<bool> needsStepFreeAccess;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicalCardsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.insuranceCompany = const Value.absent(),
    this.insuranceCompanyOther = const Value.absent(),
    this.gpName = const Value.absent(),
    this.gpPhone = const Value.absent(),
    this.pregnancyDueDate = const Value.absent(),
    this.needsStepFreeAccess = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalCardsCompanion.insert({
    this.id = const Value.absent(),
    required String ownerUserId,
    this.bloodType = const Value.absent(),
    this.insuranceCompany = const Value.absent(),
    this.insuranceCompanyOther = const Value.absent(),
    this.gpName = const Value.absent(),
    this.gpPhone = const Value.absent(),
    this.pregnancyDueDate = const Value.absent(),
    this.needsStepFreeAccess = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId);
  static Insertable<MedicalCardRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUserId,
    Expression<String>? bloodType,
    Expression<String>? insuranceCompany,
    Expression<String>? insuranceCompanyOther,
    Expression<String>? gpName,
    Expression<String>? gpPhone,
    Expression<DateTime>? pregnancyDueDate,
    Expression<bool>? needsStepFreeAccess,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (bloodType != null) 'blood_type': bloodType,
      if (insuranceCompany != null) 'insurance_company': insuranceCompany,
      if (insuranceCompanyOther != null)
        'insurance_company_other': insuranceCompanyOther,
      if (gpName != null) 'gp_name': gpName,
      if (gpPhone != null) 'gp_phone': gpPhone,
      if (pregnancyDueDate != null) 'pregnancy_due_date': pregnancyDueDate,
      if (needsStepFreeAccess != null)
        'needs_step_free_access': needsStepFreeAccess,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUserId,
    Value<BloodType?>? bloodType,
    Value<InsuranceCompany?>? insuranceCompany,
    Value<String?>? insuranceCompanyOther,
    Value<String?>? gpName,
    Value<String?>? gpPhone,
    Value<DateTime?>? pregnancyDueDate,
    Value<bool>? needsStepFreeAccess,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MedicalCardsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      bloodType: bloodType ?? this.bloodType,
      insuranceCompany: insuranceCompany ?? this.insuranceCompany,
      insuranceCompanyOther:
          insuranceCompanyOther ?? this.insuranceCompanyOther,
      gpName: gpName ?? this.gpName,
      gpPhone: gpPhone ?? this.gpPhone,
      pregnancyDueDate: pregnancyDueDate ?? this.pregnancyDueDate,
      needsStepFreeAccess: needsStepFreeAccess ?? this.needsStepFreeAccess,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(
        $MedicalCardsTable.$converterbloodTypen.toSql(bloodType.value),
      );
    }
    if (insuranceCompany.present) {
      map['insurance_company'] = Variable<String>(
        $MedicalCardsTable.$converterinsuranceCompanyn.toSql(
          insuranceCompany.value,
        ),
      );
    }
    if (insuranceCompanyOther.present) {
      map['insurance_company_other'] = Variable<String>(
        insuranceCompanyOther.value,
      );
    }
    if (gpName.present) {
      map['gp_name'] = Variable<String>(gpName.value);
    }
    if (gpPhone.present) {
      map['gp_phone'] = Variable<String>(gpPhone.value);
    }
    if (pregnancyDueDate.present) {
      map['pregnancy_due_date'] = Variable<DateTime>(pregnancyDueDate.value);
    }
    if (needsStepFreeAccess.present) {
      map['needs_step_free_access'] = Variable<bool>(needsStepFreeAccess.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalCardsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('bloodType: $bloodType, ')
          ..write('insuranceCompany: $insuranceCompany, ')
          ..write('insuranceCompanyOther: $insuranceCompanyOther, ')
          ..write('gpName: $gpName, ')
          ..write('gpPhone: $gpPhone, ')
          ..write('pregnancyDueDate: $pregnancyDueDate, ')
          ..write('needsStepFreeAccess: $needsStepFreeAccess, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChronicConditionsTable extends ChronicConditions
    with TableInfo<$ChronicConditionsTable, ChronicConditionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChronicConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _medicalCardIdMeta = const VerificationMeta(
    'medicalCardId',
  );
  @override
  late final GeneratedColumn<String> medicalCardId = GeneratedColumn<String>(
    'medical_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_card (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sinceMeta = const VerificationMeta('since');
  @override
  late final GeneratedColumn<int> since = GeneratedColumn<int>(
    'since',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalCardId,
    name,
    since,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chronic_conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChronicConditionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medical_card_id')) {
      context.handle(
        _medicalCardIdMeta,
        medicalCardId.isAcceptableOrUnknown(
          data['medical_card_id']!,
          _medicalCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalCardIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('since')) {
      context.handle(
        _sinceMeta,
        since.isAcceptableOrUnknown(data['since']!, _sinceMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChronicConditionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChronicConditionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicalCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_card_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      since: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}since'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ChronicConditionsTable createAlias(String alias) {
    return $ChronicConditionsTable(attachedDatabase, alias);
  }
}

class ChronicConditionRow extends DataClass
    implements Insertable<ChronicConditionRow> {
  final String id;
  final String medicalCardId;
  final String name;

  /// Year the condition started.
  final int? since;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ChronicConditionRow({
    required this.id,
    required this.medicalCardId,
    required this.name,
    this.since,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medical_card_id'] = Variable<String>(medicalCardId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || since != null) {
      map['since'] = Variable<int>(since);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ChronicConditionsCompanion toCompanion(bool nullToAbsent) {
    return ChronicConditionsCompanion(
      id: Value(id),
      medicalCardId: Value(medicalCardId),
      name: Value(name),
      since: since == null && nullToAbsent
          ? const Value.absent()
          : Value(since),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ChronicConditionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChronicConditionRow(
      id: serializer.fromJson<String>(json['id']),
      medicalCardId: serializer.fromJson<String>(json['medicalCardId']),
      name: serializer.fromJson<String>(json['name']),
      since: serializer.fromJson<int?>(json['since']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicalCardId': serializer.toJson<String>(medicalCardId),
      'name': serializer.toJson<String>(name),
      'since': serializer.toJson<int?>(since),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ChronicConditionRow copyWith({
    String? id,
    String? medicalCardId,
    String? name,
    Value<int?> since = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ChronicConditionRow(
    id: id ?? this.id,
    medicalCardId: medicalCardId ?? this.medicalCardId,
    name: name ?? this.name,
    since: since.present ? since.value : this.since,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ChronicConditionRow copyWithCompanion(ChronicConditionsCompanion data) {
    return ChronicConditionRow(
      id: data.id.present ? data.id.value : this.id,
      medicalCardId: data.medicalCardId.present
          ? data.medicalCardId.value
          : this.medicalCardId,
      name: data.name.present ? data.name.value : this.name,
      since: data.since.present ? data.since.value : this.since,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChronicConditionRow(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('since: $since, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicalCardId,
    name,
    since,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChronicConditionRow &&
          other.id == this.id &&
          other.medicalCardId == this.medicalCardId &&
          other.name == this.name &&
          other.since == this.since &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ChronicConditionsCompanion extends UpdateCompanion<ChronicConditionRow> {
  final Value<String> id;
  final Value<String> medicalCardId;
  final Value<String> name;
  final Value<int?> since;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ChronicConditionsCompanion({
    this.id = const Value.absent(),
    this.medicalCardId = const Value.absent(),
    this.name = const Value.absent(),
    this.since = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChronicConditionsCompanion.insert({
    this.id = const Value.absent(),
    required String medicalCardId,
    required String name,
    this.since = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicalCardId = Value(medicalCardId),
       name = Value(name);
  static Insertable<ChronicConditionRow> custom({
    Expression<String>? id,
    Expression<String>? medicalCardId,
    Expression<String>? name,
    Expression<int>? since,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalCardId != null) 'medical_card_id': medicalCardId,
      if (name != null) 'name': name,
      if (since != null) 'since': since,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChronicConditionsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicalCardId,
    Value<String>? name,
    Value<int?>? since,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ChronicConditionsCompanion(
      id: id ?? this.id,
      medicalCardId: medicalCardId ?? this.medicalCardId,
      name: name ?? this.name,
      since: since ?? this.since,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicalCardId.present) {
      map['medical_card_id'] = Variable<String>(medicalCardId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (since.present) {
      map['since'] = Variable<int>(since.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChronicConditionsCompanion(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('since: $since, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllergiesTable extends Allergies
    with TableInfo<$AllergiesTable, AllergyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllergiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _medicalCardIdMeta = const VerificationMeta(
    'medicalCardId',
  );
  @override
  late final GeneratedColumn<String> medicalCardId = GeneratedColumn<String>(
    'medical_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_card (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AllergyKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AllergyKind>($AllergiesTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<AllergyCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AllergyCategory>($AllergiesTable.$convertercategory);
  static const VerificationMeta _reactionMeta = const VerificationMeta(
    'reaction',
  );
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
    'reaction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalCardId,
    name,
    kind,
    category,
    reaction,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allergies';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllergyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medical_card_id')) {
      context.handle(
        _medicalCardIdMeta,
        medicalCardId.isAcceptableOrUnknown(
          data['medical_card_id']!,
          _medicalCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalCardIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('reaction')) {
      context.handle(
        _reactionMeta,
        reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllergyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllergyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicalCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_card_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $AllergiesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      category: $AllergiesTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      reaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reaction'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $AllergiesTable createAlias(String alias) {
    return $AllergiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AllergyKind, String, String> $converterkind =
      const EnumNameConverter<AllergyKind>(AllergyKind.values);
  static JsonTypeConverter2<AllergyCategory, String, String>
  $convertercategory = const EnumNameConverter<AllergyCategory>(
    AllergyCategory.values,
  );
}

class AllergyRow extends DataClass implements Insertable<AllergyRow> {
  final String id;
  final String medicalCardId;
  final String name;
  final AllergyKind kind;
  final AllergyCategory category;
  final String? reaction;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const AllergyRow({
    required this.id,
    required this.medicalCardId,
    required this.name,
    required this.kind,
    required this.category,
    this.reaction,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medical_card_id'] = Variable<String>(medicalCardId);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $AllergiesTable.$converterkind.toSql(kind),
      );
    }
    {
      map['category'] = Variable<String>(
        $AllergiesTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || reaction != null) {
      map['reaction'] = Variable<String>(reaction);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  AllergiesCompanion toCompanion(bool nullToAbsent) {
    return AllergiesCompanion(
      id: Value(id),
      medicalCardId: Value(medicalCardId),
      name: Value(name),
      kind: Value(kind),
      category: Value(category),
      reaction: reaction == null && nullToAbsent
          ? const Value.absent()
          : Value(reaction),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory AllergyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllergyRow(
      id: serializer.fromJson<String>(json['id']),
      medicalCardId: serializer.fromJson<String>(json['medicalCardId']),
      name: serializer.fromJson<String>(json['name']),
      kind: $AllergiesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      category: $AllergiesTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      reaction: serializer.fromJson<String?>(json['reaction']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicalCardId': serializer.toJson<String>(medicalCardId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $AllergiesTable.$converterkind.toJson(kind),
      ),
      'category': serializer.toJson<String>(
        $AllergiesTable.$convertercategory.toJson(category),
      ),
      'reaction': serializer.toJson<String?>(reaction),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  AllergyRow copyWith({
    String? id,
    String? medicalCardId,
    String? name,
    AllergyKind? kind,
    AllergyCategory? category,
    Value<String?> reaction = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => AllergyRow(
    id: id ?? this.id,
    medicalCardId: medicalCardId ?? this.medicalCardId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    category: category ?? this.category,
    reaction: reaction.present ? reaction.value : this.reaction,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  AllergyRow copyWithCompanion(AllergiesCompanion data) {
    return AllergyRow(
      id: data.id.present ? data.id.value : this.id,
      medicalCardId: data.medicalCardId.present
          ? data.medicalCardId.value
          : this.medicalCardId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      category: data.category.present ? data.category.value : this.category,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllergyRow(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('reaction: $reaction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicalCardId,
    name,
    kind,
    category,
    reaction,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllergyRow &&
          other.id == this.id &&
          other.medicalCardId == this.medicalCardId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.category == this.category &&
          other.reaction == this.reaction &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class AllergiesCompanion extends UpdateCompanion<AllergyRow> {
  final Value<String> id;
  final Value<String> medicalCardId;
  final Value<String> name;
  final Value<AllergyKind> kind;
  final Value<AllergyCategory> category;
  final Value<String?> reaction;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const AllergiesCompanion({
    this.id = const Value.absent(),
    this.medicalCardId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.category = const Value.absent(),
    this.reaction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllergiesCompanion.insert({
    this.id = const Value.absent(),
    required String medicalCardId,
    required String name,
    required AllergyKind kind,
    required AllergyCategory category,
    this.reaction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicalCardId = Value(medicalCardId),
       name = Value(name),
       kind = Value(kind),
       category = Value(category);
  static Insertable<AllergyRow> custom({
    Expression<String>? id,
    Expression<String>? medicalCardId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? category,
    Expression<String>? reaction,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalCardId != null) 'medical_card_id': medicalCardId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (category != null) 'category': category,
      if (reaction != null) 'reaction': reaction,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllergiesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicalCardId,
    Value<String>? name,
    Value<AllergyKind>? kind,
    Value<AllergyCategory>? category,
    Value<String?>? reaction,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return AllergiesCompanion(
      id: id ?? this.id,
      medicalCardId: medicalCardId ?? this.medicalCardId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      category: category ?? this.category,
      reaction: reaction ?? this.reaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicalCardId.present) {
      map['medical_card_id'] = Variable<String>(medicalCardId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AllergiesTable.$converterkind.toSql(kind.value),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $AllergiesTable.$convertercategory.toSql(category.value),
      );
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllergiesCompanion(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('category: $category, ')
          ..write('reaction: $reaction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImplantsTable extends Implants
    with TableInfo<$ImplantsTable, ImplantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImplantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _medicalCardIdMeta = const VerificationMeta(
    'medicalCardId',
  );
  @override
  late final GeneratedColumn<String> medicalCardId = GeneratedColumn<String>(
    'medical_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_card (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalCardId,
    name,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'implants';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImplantRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medical_card_id')) {
      context.handle(
        _medicalCardIdMeta,
        medicalCardId.isAcceptableOrUnknown(
          data['medical_card_id']!,
          _medicalCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalCardIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImplantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImplantRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicalCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_card_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ImplantsTable createAlias(String alias) {
    return $ImplantsTable(attachedDatabase, alias);
  }
}

class ImplantRow extends DataClass implements Insertable<ImplantRow> {
  final String id;
  final String medicalCardId;
  final String name;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ImplantRow({
    required this.id,
    required this.medicalCardId,
    required this.name,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medical_card_id'] = Variable<String>(medicalCardId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ImplantsCompanion toCompanion(bool nullToAbsent) {
    return ImplantsCompanion(
      id: Value(id),
      medicalCardId: Value(medicalCardId),
      name: Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ImplantRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImplantRow(
      id: serializer.fromJson<String>(json['id']),
      medicalCardId: serializer.fromJson<String>(json['medicalCardId']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicalCardId': serializer.toJson<String>(medicalCardId),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ImplantRow copyWith({
    String? id,
    String? medicalCardId,
    String? name,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ImplantRow(
    id: id ?? this.id,
    medicalCardId: medicalCardId ?? this.medicalCardId,
    name: name ?? this.name,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ImplantRow copyWithCompanion(ImplantsCompanion data) {
    return ImplantRow(
      id: data.id.present ? data.id.value : this.id,
      medicalCardId: data.medicalCardId.present
          ? data.medicalCardId.value
          : this.medicalCardId,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImplantRow(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicalCardId,
    name,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImplantRow &&
          other.id == this.id &&
          other.medicalCardId == this.medicalCardId &&
          other.name == this.name &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ImplantsCompanion extends UpdateCompanion<ImplantRow> {
  final Value<String> id;
  final Value<String> medicalCardId;
  final Value<String> name;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ImplantsCompanion({
    this.id = const Value.absent(),
    this.medicalCardId = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImplantsCompanion.insert({
    this.id = const Value.absent(),
    required String medicalCardId,
    required String name,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicalCardId = Value(medicalCardId),
       name = Value(name);
  static Insertable<ImplantRow> custom({
    Expression<String>? id,
    Expression<String>? medicalCardId,
    Expression<String>? name,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalCardId != null) 'medical_card_id': medicalCardId,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImplantsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicalCardId,
    Value<String>? name,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ImplantsCompanion(
      id: id ?? this.id,
      medicalCardId: medicalCardId ?? this.medicalCardId,
      name: name ?? this.name,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicalCardId.present) {
      map['medical_card_id'] = Variable<String>(medicalCardId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImplantsCompanion(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SurgeriesTable extends Surgeries
    with TableInfo<$SurgeriesTable, SurgeryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurgeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _medicalCardIdMeta = const VerificationMeta(
    'medicalCardId',
  );
  @override
  late final GeneratedColumn<String> medicalCardId = GeneratedColumn<String>(
    'medical_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_card (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalCardId,
    name,
    year,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surgeries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SurgeryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medical_card_id')) {
      context.handle(
        _medicalCardIdMeta,
        medicalCardId.isAcceptableOrUnknown(
          data['medical_card_id']!,
          _medicalCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalCardIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SurgeryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SurgeryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicalCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_card_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $SurgeriesTable createAlias(String alias) {
    return $SurgeriesTable(attachedDatabase, alias);
  }
}

class SurgeryRow extends DataClass implements Insertable<SurgeryRow> {
  final String id;
  final String medicalCardId;
  final String name;
  final int? year;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const SurgeryRow({
    required this.id,
    required this.medicalCardId,
    required this.name,
    this.year,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medical_card_id'] = Variable<String>(medicalCardId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  SurgeriesCompanion toCompanion(bool nullToAbsent) {
    return SurgeriesCompanion(
      id: Value(id),
      medicalCardId: Value(medicalCardId),
      name: Value(name),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory SurgeryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SurgeryRow(
      id: serializer.fromJson<String>(json['id']),
      medicalCardId: serializer.fromJson<String>(json['medicalCardId']),
      name: serializer.fromJson<String>(json['name']),
      year: serializer.fromJson<int?>(json['year']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicalCardId': serializer.toJson<String>(medicalCardId),
      'name': serializer.toJson<String>(name),
      'year': serializer.toJson<int?>(year),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  SurgeryRow copyWith({
    String? id,
    String? medicalCardId,
    String? name,
    Value<int?> year = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => SurgeryRow(
    id: id ?? this.id,
    medicalCardId: medicalCardId ?? this.medicalCardId,
    name: name ?? this.name,
    year: year.present ? year.value : this.year,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  SurgeryRow copyWithCompanion(SurgeriesCompanion data) {
    return SurgeryRow(
      id: data.id.present ? data.id.value : this.id,
      medicalCardId: data.medicalCardId.present
          ? data.medicalCardId.value
          : this.medicalCardId,
      name: data.name.present ? data.name.value : this.name,
      year: data.year.present ? data.year.value : this.year,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SurgeryRow(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('year: $year, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicalCardId,
    name,
    year,
    note,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SurgeryRow &&
          other.id == this.id &&
          other.medicalCardId == this.medicalCardId &&
          other.name == this.name &&
          other.year == this.year &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class SurgeriesCompanion extends UpdateCompanion<SurgeryRow> {
  final Value<String> id;
  final Value<String> medicalCardId;
  final Value<String> name;
  final Value<int?> year;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const SurgeriesCompanion({
    this.id = const Value.absent(),
    this.medicalCardId = const Value.absent(),
    this.name = const Value.absent(),
    this.year = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SurgeriesCompanion.insert({
    this.id = const Value.absent(),
    required String medicalCardId,
    required String name,
    this.year = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicalCardId = Value(medicalCardId),
       name = Value(name);
  static Insertable<SurgeryRow> custom({
    Expression<String>? id,
    Expression<String>? medicalCardId,
    Expression<String>? name,
    Expression<int>? year,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalCardId != null) 'medical_card_id': medicalCardId,
      if (name != null) 'name': name,
      if (year != null) 'year': year,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SurgeriesCompanion copyWith({
    Value<String>? id,
    Value<String>? medicalCardId,
    Value<String>? name,
    Value<int?>? year,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return SurgeriesCompanion(
      id: id ?? this.id,
      medicalCardId: medicalCardId ?? this.medicalCardId,
      name: name ?? this.name,
      year: year ?? this.year,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicalCardId.present) {
      map['medical_card_id'] = Variable<String>(medicalCardId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurgeriesCompanion(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('year: $year, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmergencyContactsTable extends EmergencyContacts
    with TableInfo<$EmergencyContactsTable, EmergencyContactRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmergencyContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _medicalCardIdMeta = const VerificationMeta(
    'medicalCardId',
  );
  @override
  late final GeneratedColumn<String> medicalCardId = GeneratedColumn<String>(
    'medical_card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medical_card (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationMeta = const VerificationMeta(
    'relation',
  );
  @override
  late final GeneratedColumn<String> relation = GeneratedColumn<String>(
    'relation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicalCardId,
    name,
    relation,
    phone,
    isPrimary,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emergency_contacts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmergencyContactRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medical_card_id')) {
      context.handle(
        _medicalCardIdMeta,
        medicalCardId.isAcceptableOrUnknown(
          data['medical_card_id']!,
          _medicalCardIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicalCardIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('relation')) {
      context.handle(
        _relationMeta,
        relation.isAcceptableOrUnknown(data['relation']!, _relationMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmergencyContactRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmergencyContactRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medicalCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_card_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      relation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EmergencyContactsTable createAlias(String alias) {
    return $EmergencyContactsTable(attachedDatabase, alias);
  }
}

class EmergencyContactRow extends DataClass
    implements Insertable<EmergencyContactRow> {
  final String id;
  final String medicalCardId;
  final String name;
  final String? relation;
  final String phone;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const EmergencyContactRow({
    required this.id,
    required this.medicalCardId,
    required this.name,
    this.relation,
    required this.phone,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['medical_card_id'] = Variable<String>(medicalCardId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || relation != null) {
      map['relation'] = Variable<String>(relation);
    }
    map['phone'] = Variable<String>(phone);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EmergencyContactsCompanion toCompanion(bool nullToAbsent) {
    return EmergencyContactsCompanion(
      id: Value(id),
      medicalCardId: Value(medicalCardId),
      name: Value(name),
      relation: relation == null && nullToAbsent
          ? const Value.absent()
          : Value(relation),
      phone: Value(phone),
      isPrimary: Value(isPrimary),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EmergencyContactRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmergencyContactRow(
      id: serializer.fromJson<String>(json['id']),
      medicalCardId: serializer.fromJson<String>(json['medicalCardId']),
      name: serializer.fromJson<String>(json['name']),
      relation: serializer.fromJson<String?>(json['relation']),
      phone: serializer.fromJson<String>(json['phone']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medicalCardId': serializer.toJson<String>(medicalCardId),
      'name': serializer.toJson<String>(name),
      'relation': serializer.toJson<String?>(relation),
      'phone': serializer.toJson<String>(phone),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EmergencyContactRow copyWith({
    String? id,
    String? medicalCardId,
    String? name,
    Value<String?> relation = const Value.absent(),
    String? phone,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EmergencyContactRow(
    id: id ?? this.id,
    medicalCardId: medicalCardId ?? this.medicalCardId,
    name: name ?? this.name,
    relation: relation.present ? relation.value : this.relation,
    phone: phone ?? this.phone,
    isPrimary: isPrimary ?? this.isPrimary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EmergencyContactRow copyWithCompanion(EmergencyContactsCompanion data) {
    return EmergencyContactRow(
      id: data.id.present ? data.id.value : this.id,
      medicalCardId: data.medicalCardId.present
          ? data.medicalCardId.value
          : this.medicalCardId,
      name: data.name.present ? data.name.value : this.name,
      relation: data.relation.present ? data.relation.value : this.relation,
      phone: data.phone.present ? data.phone.value : this.phone,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactRow(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('phone: $phone, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicalCardId,
    name,
    relation,
    phone,
    isPrimary,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmergencyContactRow &&
          other.id == this.id &&
          other.medicalCardId == this.medicalCardId &&
          other.name == this.name &&
          other.relation == this.relation &&
          other.phone == this.phone &&
          other.isPrimary == this.isPrimary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class EmergencyContactsCompanion extends UpdateCompanion<EmergencyContactRow> {
  final Value<String> id;
  final Value<String> medicalCardId;
  final Value<String> name;
  final Value<String?> relation;
  final Value<String> phone;
  final Value<bool> isPrimary;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EmergencyContactsCompanion({
    this.id = const Value.absent(),
    this.medicalCardId = const Value.absent(),
    this.name = const Value.absent(),
    this.relation = const Value.absent(),
    this.phone = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmergencyContactsCompanion.insert({
    this.id = const Value.absent(),
    required String medicalCardId,
    required String name,
    this.relation = const Value.absent(),
    required String phone,
    this.isPrimary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : medicalCardId = Value(medicalCardId),
       name = Value(name),
       phone = Value(phone);
  static Insertable<EmergencyContactRow> custom({
    Expression<String>? id,
    Expression<String>? medicalCardId,
    Expression<String>? name,
    Expression<String>? relation,
    Expression<String>? phone,
    Expression<bool>? isPrimary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicalCardId != null) 'medical_card_id': medicalCardId,
      if (name != null) 'name': name,
      if (relation != null) 'relation': relation,
      if (phone != null) 'phone': phone,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmergencyContactsCompanion copyWith({
    Value<String>? id,
    Value<String>? medicalCardId,
    Value<String>? name,
    Value<String?>? relation,
    Value<String>? phone,
    Value<bool>? isPrimary,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EmergencyContactsCompanion(
      id: id ?? this.id,
      medicalCardId: medicalCardId ?? this.medicalCardId,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      phone: phone ?? this.phone,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medicalCardId.present) {
      map['medical_card_id'] = Variable<String>(medicalCardId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (relation.present) {
      map['relation'] = Variable<String>(relation.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmergencyContactsCompanion(')
          ..write('id: $id, ')
          ..write('medicalCardId: $medicalCardId, ')
          ..write('name: $name, ')
          ..write('relation: $relation, ')
          ..write('phone: $phone, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _medicationRemindersEnabledMeta =
      const VerificationMeta('medicationRemindersEnabled');
  @override
  late final GeneratedColumn<bool> medicationRemindersEnabled =
      GeneratedColumn<bool>(
        'medication_reminders_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("medication_reminders_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _repeatReminderMinutesMeta =
      const VerificationMeta('repeatReminderMinutes');
  @override
  late final GeneratedColumn<int> repeatReminderMinutes = GeneratedColumn<int>(
    'repeat_reminder_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodRemindersEnabledMeta =
      const VerificationMeta('moodRemindersEnabled');
  @override
  late final GeneratedColumn<bool> moodRemindersEnabled = GeneratedColumn<bool>(
    'mood_reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mood_reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _moodReminderTimeMeta = const VerificationMeta(
    'moodReminderTime',
  );
  @override
  late final GeneratedColumn<String> moodReminderTime = GeneratedColumn<String>(
    'mood_reminder_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('20:00'),
  );
  static const VerificationMeta _healthAlertsEnabledMeta =
      const VerificationMeta('healthAlertsEnabled');
  @override
  late final GeneratedColumn<bool> healthAlertsEnabled = GeneratedColumn<bool>(
    'health_alerts_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("health_alerts_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _recommendationsEnabledMeta =
      const VerificationMeta('recommendationsEnabled');
  @override
  late final GeneratedColumn<bool> recommendationsEnabled =
      GeneratedColumn<bool>(
        'recommendations_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("recommendations_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    medicationRemindersEnabled,
    repeatReminderMinutes,
    moodRemindersEnabled,
    moodReminderTime,
    healthAlertsEnabled,
    recommendationsEnabled,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('medication_reminders_enabled')) {
      context.handle(
        _medicationRemindersEnabledMeta,
        medicationRemindersEnabled.isAcceptableOrUnknown(
          data['medication_reminders_enabled']!,
          _medicationRemindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('repeat_reminder_minutes')) {
      context.handle(
        _repeatReminderMinutesMeta,
        repeatReminderMinutes.isAcceptableOrUnknown(
          data['repeat_reminder_minutes']!,
          _repeatReminderMinutesMeta,
        ),
      );
    }
    if (data.containsKey('mood_reminders_enabled')) {
      context.handle(
        _moodRemindersEnabledMeta,
        moodRemindersEnabled.isAcceptableOrUnknown(
          data['mood_reminders_enabled']!,
          _moodRemindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('mood_reminder_time')) {
      context.handle(
        _moodReminderTimeMeta,
        moodReminderTime.isAcceptableOrUnknown(
          data['mood_reminder_time']!,
          _moodReminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('health_alerts_enabled')) {
      context.handle(
        _healthAlertsEnabledMeta,
        healthAlertsEnabled.isAcceptableOrUnknown(
          data['health_alerts_enabled']!,
          _healthAlertsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('recommendations_enabled')) {
      context.handle(
        _recommendationsEnabledMeta,
        recommendationsEnabled.isAcceptableOrUnknown(
          data['recommendations_enabled']!,
          _recommendationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      medicationRemindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}medication_reminders_enabled'],
      )!,
      repeatReminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_reminder_minutes'],
      ),
      moodRemindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mood_reminders_enabled'],
      )!,
      moodReminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_reminder_time'],
      )!,
      healthAlertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}health_alerts_enabled'],
      )!,
      recommendationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recommendations_enabled'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsRow extends DataClass implements Insertable<UserSettingsRow> {
  final String id;
  final String ownerUserId;
  final bool medicationRemindersEnabled;
  final int? repeatReminderMinutes;
  final bool moodRemindersEnabled;

  /// "HH:mm".
  final String moodReminderTime;
  final bool healthAlertsEnabled;
  final bool recommendationsEnabled;
  final DateTime updatedAt;
  const UserSettingsRow({
    required this.id,
    required this.ownerUserId,
    required this.medicationRemindersEnabled,
    this.repeatReminderMinutes,
    required this.moodRemindersEnabled,
    required this.moodReminderTime,
    required this.healthAlertsEnabled,
    required this.recommendationsEnabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['medication_reminders_enabled'] = Variable<bool>(
      medicationRemindersEnabled,
    );
    if (!nullToAbsent || repeatReminderMinutes != null) {
      map['repeat_reminder_minutes'] = Variable<int>(repeatReminderMinutes);
    }
    map['mood_reminders_enabled'] = Variable<bool>(moodRemindersEnabled);
    map['mood_reminder_time'] = Variable<String>(moodReminderTime);
    map['health_alerts_enabled'] = Variable<bool>(healthAlertsEnabled);
    map['recommendations_enabled'] = Variable<bool>(recommendationsEnabled);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      medicationRemindersEnabled: Value(medicationRemindersEnabled),
      repeatReminderMinutes: repeatReminderMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatReminderMinutes),
      moodRemindersEnabled: Value(moodRemindersEnabled),
      moodReminderTime: Value(moodReminderTime),
      healthAlertsEnabled: Value(healthAlertsEnabled),
      recommendationsEnabled: Value(recommendationsEnabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      medicationRemindersEnabled: serializer.fromJson<bool>(
        json['medicationRemindersEnabled'],
      ),
      repeatReminderMinutes: serializer.fromJson<int?>(
        json['repeatReminderMinutes'],
      ),
      moodRemindersEnabled: serializer.fromJson<bool>(
        json['moodRemindersEnabled'],
      ),
      moodReminderTime: serializer.fromJson<String>(json['moodReminderTime']),
      healthAlertsEnabled: serializer.fromJson<bool>(
        json['healthAlertsEnabled'],
      ),
      recommendationsEnabled: serializer.fromJson<bool>(
        json['recommendationsEnabled'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'medicationRemindersEnabled': serializer.toJson<bool>(
        medicationRemindersEnabled,
      ),
      'repeatReminderMinutes': serializer.toJson<int?>(repeatReminderMinutes),
      'moodRemindersEnabled': serializer.toJson<bool>(moodRemindersEnabled),
      'moodReminderTime': serializer.toJson<String>(moodReminderTime),
      'healthAlertsEnabled': serializer.toJson<bool>(healthAlertsEnabled),
      'recommendationsEnabled': serializer.toJson<bool>(recommendationsEnabled),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSettingsRow copyWith({
    String? id,
    String? ownerUserId,
    bool? medicationRemindersEnabled,
    Value<int?> repeatReminderMinutes = const Value.absent(),
    bool? moodRemindersEnabled,
    String? moodReminderTime,
    bool? healthAlertsEnabled,
    bool? recommendationsEnabled,
    DateTime? updatedAt,
  }) => UserSettingsRow(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    medicationRemindersEnabled:
        medicationRemindersEnabled ?? this.medicationRemindersEnabled,
    repeatReminderMinutes: repeatReminderMinutes.present
        ? repeatReminderMinutes.value
        : this.repeatReminderMinutes,
    moodRemindersEnabled: moodRemindersEnabled ?? this.moodRemindersEnabled,
    moodReminderTime: moodReminderTime ?? this.moodReminderTime,
    healthAlertsEnabled: healthAlertsEnabled ?? this.healthAlertsEnabled,
    recommendationsEnabled:
        recommendationsEnabled ?? this.recommendationsEnabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSettingsRow copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      medicationRemindersEnabled: data.medicationRemindersEnabled.present
          ? data.medicationRemindersEnabled.value
          : this.medicationRemindersEnabled,
      repeatReminderMinutes: data.repeatReminderMinutes.present
          ? data.repeatReminderMinutes.value
          : this.repeatReminderMinutes,
      moodRemindersEnabled: data.moodRemindersEnabled.present
          ? data.moodRemindersEnabled.value
          : this.moodRemindersEnabled,
      moodReminderTime: data.moodReminderTime.present
          ? data.moodReminderTime.value
          : this.moodReminderTime,
      healthAlertsEnabled: data.healthAlertsEnabled.present
          ? data.healthAlertsEnabled.value
          : this.healthAlertsEnabled,
      recommendationsEnabled: data.recommendationsEnabled.present
          ? data.recommendationsEnabled.value
          : this.recommendationsEnabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRow(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('medicationRemindersEnabled: $medicationRemindersEnabled, ')
          ..write('repeatReminderMinutes: $repeatReminderMinutes, ')
          ..write('moodRemindersEnabled: $moodRemindersEnabled, ')
          ..write('moodReminderTime: $moodReminderTime, ')
          ..write('healthAlertsEnabled: $healthAlertsEnabled, ')
          ..write('recommendationsEnabled: $recommendationsEnabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUserId,
    medicationRemindersEnabled,
    repeatReminderMinutes,
    moodRemindersEnabled,
    moodReminderTime,
    healthAlertsEnabled,
    recommendationsEnabled,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRow &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.medicationRemindersEnabled == this.medicationRemindersEnabled &&
          other.repeatReminderMinutes == this.repeatReminderMinutes &&
          other.moodRemindersEnabled == this.moodRemindersEnabled &&
          other.moodReminderTime == this.moodReminderTime &&
          other.healthAlertsEnabled == this.healthAlertsEnabled &&
          other.recommendationsEnabled == this.recommendationsEnabled &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsRow> {
  final Value<String> id;
  final Value<String> ownerUserId;
  final Value<bool> medicationRemindersEnabled;
  final Value<int?> repeatReminderMinutes;
  final Value<bool> moodRemindersEnabled;
  final Value<String> moodReminderTime;
  final Value<bool> healthAlertsEnabled;
  final Value<bool> recommendationsEnabled;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.medicationRemindersEnabled = const Value.absent(),
    this.repeatReminderMinutes = const Value.absent(),
    this.moodRemindersEnabled = const Value.absent(),
    this.moodReminderTime = const Value.absent(),
    this.healthAlertsEnabled = const Value.absent(),
    this.recommendationsEnabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String ownerUserId,
    this.medicationRemindersEnabled = const Value.absent(),
    this.repeatReminderMinutes = const Value.absent(),
    this.moodRemindersEnabled = const Value.absent(),
    this.moodReminderTime = const Value.absent(),
    this.healthAlertsEnabled = const Value.absent(),
    this.recommendationsEnabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId);
  static Insertable<UserSettingsRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUserId,
    Expression<bool>? medicationRemindersEnabled,
    Expression<int>? repeatReminderMinutes,
    Expression<bool>? moodRemindersEnabled,
    Expression<String>? moodReminderTime,
    Expression<bool>? healthAlertsEnabled,
    Expression<bool>? recommendationsEnabled,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (medicationRemindersEnabled != null)
        'medication_reminders_enabled': medicationRemindersEnabled,
      if (repeatReminderMinutes != null)
        'repeat_reminder_minutes': repeatReminderMinutes,
      if (moodRemindersEnabled != null)
        'mood_reminders_enabled': moodRemindersEnabled,
      if (moodReminderTime != null) 'mood_reminder_time': moodReminderTime,
      if (healthAlertsEnabled != null)
        'health_alerts_enabled': healthAlertsEnabled,
      if (recommendationsEnabled != null)
        'recommendations_enabled': recommendationsEnabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUserId,
    Value<bool>? medicationRemindersEnabled,
    Value<int?>? repeatReminderMinutes,
    Value<bool>? moodRemindersEnabled,
    Value<String>? moodReminderTime,
    Value<bool>? healthAlertsEnabled,
    Value<bool>? recommendationsEnabled,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      medicationRemindersEnabled:
          medicationRemindersEnabled ?? this.medicationRemindersEnabled,
      repeatReminderMinutes:
          repeatReminderMinutes ?? this.repeatReminderMinutes,
      moodRemindersEnabled: moodRemindersEnabled ?? this.moodRemindersEnabled,
      moodReminderTime: moodReminderTime ?? this.moodReminderTime,
      healthAlertsEnabled: healthAlertsEnabled ?? this.healthAlertsEnabled,
      recommendationsEnabled:
          recommendationsEnabled ?? this.recommendationsEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (medicationRemindersEnabled.present) {
      map['medication_reminders_enabled'] = Variable<bool>(
        medicationRemindersEnabled.value,
      );
    }
    if (repeatReminderMinutes.present) {
      map['repeat_reminder_minutes'] = Variable<int>(
        repeatReminderMinutes.value,
      );
    }
    if (moodRemindersEnabled.present) {
      map['mood_reminders_enabled'] = Variable<bool>(
        moodRemindersEnabled.value,
      );
    }
    if (moodReminderTime.present) {
      map['mood_reminder_time'] = Variable<String>(moodReminderTime.value);
    }
    if (healthAlertsEnabled.present) {
      map['health_alerts_enabled'] = Variable<bool>(healthAlertsEnabled.value);
    }
    if (recommendationsEnabled.present) {
      map['recommendations_enabled'] = Variable<bool>(
        recommendationsEnabled.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('medicationRemindersEnabled: $medicationRemindersEnabled, ')
          ..write('repeatReminderMinutes: $repeatReminderMinutes, ')
          ..write('moodRemindersEnabled: $moodRemindersEnabled, ')
          ..write('moodReminderTime: $moodReminderTime, ')
          ..write('healthAlertsEnabled: $healthAlertsEnabled, ')
          ..write('recommendationsEnabled: $recommendationsEnabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsentsTable extends Consents
    with TableInfo<$ConsentsTable, ConsentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
    'owner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ConsentType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ConsentType>($ConsentsTable.$convertertype);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grantedAtMeta = const VerificationMeta(
    'grantedAt',
  );
  @override
  late final GeneratedColumn<DateTime> grantedAt = GeneratedColumn<DateTime>(
    'granted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revokedAt = GeneratedColumn<DateTime>(
    'revoked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUserId,
    type,
    version,
    grantedAt,
    revokedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConsentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('granted_at')) {
      context.handle(
        _grantedAtMeta,
        grantedAt.isAcceptableOrUnknown(data['granted_at']!, _grantedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_grantedAtMeta);
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConsentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_user_id'],
      )!,
      type: $ConsentsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      grantedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}granted_at'],
      )!,
      revokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_at'],
      ),
    );
  }

  @override
  $ConsentsTable createAlias(String alias) {
    return $ConsentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ConsentType, String, String> $convertertype =
      const EnumNameConverter<ConsentType>(ConsentType.values);
}

class ConsentRow extends DataClass implements Insertable<ConsentRow> {
  final String id;
  final String ownerUserId;
  final ConsentType type;
  final int version;
  final DateTime grantedAt;
  final DateTime? revokedAt;
  const ConsentRow({
    required this.id,
    required this.ownerUserId,
    required this.type,
    required this.version,
    required this.grantedAt,
    this.revokedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    {
      map['type'] = Variable<String>($ConsentsTable.$convertertype.toSql(type));
    }
    map['version'] = Variable<int>(version);
    map['granted_at'] = Variable<DateTime>(grantedAt);
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<DateTime>(revokedAt);
    }
    return map;
  }

  ConsentsCompanion toCompanion(bool nullToAbsent) {
    return ConsentsCompanion(
      id: Value(id),
      ownerUserId: Value(ownerUserId),
      type: Value(type),
      version: Value(version),
      grantedAt: Value(grantedAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
    );
  }

  factory ConsentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsentRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      type: $ConsentsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      version: serializer.fromJson<int>(json['version']),
      grantedAt: serializer.fromJson<DateTime>(json['grantedAt']),
      revokedAt: serializer.fromJson<DateTime?>(json['revokedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'type': serializer.toJson<String>(
        $ConsentsTable.$convertertype.toJson(type),
      ),
      'version': serializer.toJson<int>(version),
      'grantedAt': serializer.toJson<DateTime>(grantedAt),
      'revokedAt': serializer.toJson<DateTime?>(revokedAt),
    };
  }

  ConsentRow copyWith({
    String? id,
    String? ownerUserId,
    ConsentType? type,
    int? version,
    DateTime? grantedAt,
    Value<DateTime?> revokedAt = const Value.absent(),
  }) => ConsentRow(
    id: id ?? this.id,
    ownerUserId: ownerUserId ?? this.ownerUserId,
    type: type ?? this.type,
    version: version ?? this.version,
    grantedAt: grantedAt ?? this.grantedAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
  );
  ConsentRow copyWithCompanion(ConsentsCompanion data) {
    return ConsentRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      type: data.type.present ? data.type.value : this.type,
      version: data.version.present ? data.version.value : this.version,
      grantedAt: data.grantedAt.present ? data.grantedAt.value : this.grantedAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRow(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('type: $type, ')
          ..write('version: $version, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('revokedAt: $revokedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerUserId, type, version, grantedAt, revokedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsentRow &&
          other.id == this.id &&
          other.ownerUserId == this.ownerUserId &&
          other.type == this.type &&
          other.version == this.version &&
          other.grantedAt == this.grantedAt &&
          other.revokedAt == this.revokedAt);
}

class ConsentsCompanion extends UpdateCompanion<ConsentRow> {
  final Value<String> id;
  final Value<String> ownerUserId;
  final Value<ConsentType> type;
  final Value<int> version;
  final Value<DateTime> grantedAt;
  final Value<DateTime?> revokedAt;
  final Value<int> rowid;
  const ConsentsCompanion({
    this.id = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.type = const Value.absent(),
    this.version = const Value.absent(),
    this.grantedAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsentsCompanion.insert({
    this.id = const Value.absent(),
    required String ownerUserId,
    required ConsentType type,
    required int version,
    required DateTime grantedAt,
    this.revokedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUserId = Value(ownerUserId),
       type = Value(type),
       version = Value(version),
       grantedAt = Value(grantedAt);
  static Insertable<ConsentRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUserId,
    Expression<String>? type,
    Expression<int>? version,
    Expression<DateTime>? grantedAt,
    Expression<DateTime>? revokedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (type != null) 'type': type,
      if (version != null) 'version': version,
      if (grantedAt != null) 'granted_at': grantedAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsentsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUserId,
    Value<ConsentType>? type,
    Value<int>? version,
    Value<DateTime>? grantedAt,
    Value<DateTime?>? revokedAt,
    Value<int>? rowid,
  }) {
    return ConsentsCompanion(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      type: type ?? this.type,
      version: version ?? this.version,
      grantedAt: grantedAt ?? this.grantedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ConsentsTable.$convertertype.toSql(type.value),
      );
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (grantedAt.present) {
      map['granted_at'] = Variable<DateTime>(grantedAt.value);
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<DateTime>(revokedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('type: $type, ')
          ..write('version: $version, ')
          ..write('grantedAt: $grantedAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, ChatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profile (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _historyFetchedAtMeta = const VerificationMeta(
    'historyFetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> historyFetchedAt =
      GeneratedColumn<DateTime>(
        'history_fetched_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    serverId,
    title,
    createdAt,
    fetchedAt,
    historyFetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('history_fetched_at')) {
      context.handle(
        _historyFetchedAtMeta,
        historyFetchedAt.isAcceptableOrUnknown(
          data['history_fetched_at']!,
          _historyFetchedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      historyFetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}history_fetched_at'],
      ),
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class ChatRow extends DataClass implements Insertable<ChatRow> {
  final String id;
  final String profileId;

  /// `sessionId` on the backend.
  final String serverId;
  final String? title;
  final DateTime createdAt;

  /// Last time the chat was in the server list.
  final DateTime fetchedAt;

  /// Null: the history was never loaded.
  final DateTime? historyFetchedAt;
  const ChatRow({
    required this.id,
    required this.profileId,
    required this.serverId,
    this.title,
    required this.createdAt,
    required this.fetchedAt,
    this.historyFetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['server_id'] = Variable<String>(serverId);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || historyFetchedAt != null) {
      map['history_fetched_at'] = Variable<DateTime>(historyFetchedAt);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      serverId: Value(serverId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      createdAt: Value(createdAt),
      fetchedAt: Value(fetchedAt),
      historyFetchedAt: historyFetchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(historyFetchedAt),
    );
  }

  factory ChatRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      serverId: serializer.fromJson<String>(json['serverId']),
      title: serializer.fromJson<String?>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      historyFetchedAt: serializer.fromJson<DateTime?>(
        json['historyFetchedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'serverId': serializer.toJson<String>(serverId),
      'title': serializer.toJson<String?>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'historyFetchedAt': serializer.toJson<DateTime?>(historyFetchedAt),
    };
  }

  ChatRow copyWith({
    String? id,
    String? profileId,
    String? serverId,
    Value<String?> title = const Value.absent(),
    DateTime? createdAt,
    DateTime? fetchedAt,
    Value<DateTime?> historyFetchedAt = const Value.absent(),
  }) => ChatRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    serverId: serverId ?? this.serverId,
    title: title.present ? title.value : this.title,
    createdAt: createdAt ?? this.createdAt,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    historyFetchedAt: historyFetchedAt.present
        ? historyFetchedAt.value
        : this.historyFetchedAt,
  );
  ChatRow copyWithCompanion(ChatsCompanion data) {
    return ChatRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      historyFetchedAt: data.historyFetchedAt.present
          ? data.historyFetchedAt.value
          : this.historyFetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('serverId: $serverId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('historyFetchedAt: $historyFetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    serverId,
    title,
    createdAt,
    fetchedAt,
    historyFetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.serverId == this.serverId &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.fetchedAt == this.fetchedAt &&
          other.historyFetchedAt == this.historyFetchedAt);
}

class ChatsCompanion extends UpdateCompanion<ChatRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<String> serverId;
  final Value<String?> title;
  final Value<DateTime> createdAt;
  final Value<DateTime> fetchedAt;
  final Value<DateTime?> historyFetchedAt;
  final Value<int> rowid;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.historyFetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String profileId,
    required String serverId,
    this.title = const Value.absent(),
    required DateTime createdAt,
    required DateTime fetchedAt,
    this.historyFetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       serverId = Value(serverId),
       createdAt = Value(createdAt),
       fetchedAt = Value(fetchedAt);
  static Insertable<ChatRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? serverId,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? historyFetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (serverId != null) 'server_id': serverId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (historyFetchedAt != null) 'history_fetched_at': historyFetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<String>? serverId,
    Value<String?>? title,
    Value<DateTime>? createdAt,
    Value<DateTime>? fetchedAt,
    Value<DateTime?>? historyFetchedAt,
    Value<int>? rowid,
  }) {
    return ChatsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      serverId: serverId ?? this.serverId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      historyFetchedAt: historyFetchedAt ?? this.historyFetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (historyFetchedAt.present) {
      map['history_fetched_at'] = Variable<DateTime>(historyFetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('serverId: $serverId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('historyFetchedAt: $historyFetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MessageRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MessageRole>($MessagesTable.$converterrole);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, chatId, position, role, body];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['text']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {chatId, position},
  ];
  @override
  MessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      role: $MessagesTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MessageRole, String, String> $converterrole =
      const EnumNameConverter<MessageRole>(MessageRole.values);
}

class MessageRow extends DataClass implements Insertable<MessageRow> {
  final String id;
  final String chatId;

  /// Index in the history array.
  final int position;
  final MessageRole role;
  final String body;
  const MessageRow({
    required this.id,
    required this.chatId,
    required this.position,
    required this.role,
    required this.body,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chat_id'] = Variable<String>(chatId);
    map['position'] = Variable<int>(position);
    {
      map['role'] = Variable<String>($MessagesTable.$converterrole.toSql(role));
    }
    map['text'] = Variable<String>(body);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      position: Value(position),
      role: Value(role),
      body: Value(body),
    );
  }

  factory MessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageRow(
      id: serializer.fromJson<String>(json['id']),
      chatId: serializer.fromJson<String>(json['chatId']),
      position: serializer.fromJson<int>(json['position']),
      role: $MessagesTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chatId': serializer.toJson<String>(chatId),
      'position': serializer.toJson<int>(position),
      'role': serializer.toJson<String>(
        $MessagesTable.$converterrole.toJson(role),
      ),
      'body': serializer.toJson<String>(body),
    };
  }

  MessageRow copyWith({
    String? id,
    String? chatId,
    int? position,
    MessageRole? role,
    String? body,
  }) => MessageRow(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    position: position ?? this.position,
    role: role ?? this.role,
    body: body ?? this.body,
  );
  MessageRow copyWithCompanion(MessagesCompanion data) {
    return MessageRow(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      position: data.position.present ? data.position.value : this.position,
      role: data.role.present ? data.role.value : this.role,
      body: data.body.present ? data.body.value : this.body,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageRow(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('position: $position, ')
          ..write('role: $role, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatId, position, role, body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageRow &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.position == this.position &&
          other.role == this.role &&
          other.body == this.body);
}

class MessagesCompanion extends UpdateCompanion<MessageRow> {
  final Value<String> id;
  final Value<String> chatId;
  final Value<int> position;
  final Value<MessageRole> role;
  final Value<String> body;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.position = const Value.absent(),
    this.role = const Value.absent(),
    this.body = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required String chatId,
    required int position,
    required MessageRole role,
    required String body,
    this.rowid = const Value.absent(),
  }) : chatId = Value(chatId),
       position = Value(position),
       role = Value(role),
       body = Value(body);
  static Insertable<MessageRow> custom({
    Expression<String>? id,
    Expression<String>? chatId,
    Expression<int>? position,
    Expression<String>? role,
    Expression<String>? body,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (position != null) 'position': position,
      if (role != null) 'role': role,
      if (body != null) 'text': body,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? chatId,
    Value<int>? position,
    Value<MessageRole>? role,
    Value<String>? body,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      position: position ?? this.position,
      role: role ?? this.role,
      body: body ?? this.body,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(
        $MessagesTable.$converterrole.toSql(role.value),
      );
    }
    if (body.present) {
      map['text'] = Variable<String>(body.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('position: $position, ')
          ..write('role: $role, ')
          ..write('body: $body, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClinicsTable extends Clinics with TableInfo<$ClinicsTable, ClinicRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClinicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES messages (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specialityMeta = const VerificationMeta(
    'speciality',
  );
  @override
  late final GeneratedColumn<String> speciality = GeneratedColumn<String>(
    'speciality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _additionalInfoMeta = const VerificationMeta(
    'additionalInfo',
  );
  @override
  late final GeneratedColumn<String> additionalInfo = GeneratedColumn<String>(
    'additional_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    position,
    name,
    speciality,
    address,
    url,
    phone,
    email,
    additionalInfo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clinics';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClinicRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('speciality')) {
      context.handle(
        _specialityMeta,
        speciality.isAcceptableOrUnknown(data['speciality']!, _specialityMeta),
      );
    } else if (isInserting) {
      context.missing(_specialityMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('additional_info')) {
      context.handle(
        _additionalInfoMeta,
        additionalInfo.isAcceptableOrUnknown(
          data['additional_info']!,
          _additionalInfoMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {messageId, position},
  ];
  @override
  ClinicRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClinicRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      speciality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speciality'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      additionalInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}additional_info'],
      ),
    );
  }

  @override
  $ClinicsTable createAlias(String alias) {
    return $ClinicsTable(attachedDatabase, alias);
  }
}

class ClinicRow extends DataClass implements Insertable<ClinicRow> {
  final String id;
  final String messageId;

  /// Order in `doctors[]`.
  final int position;
  final String name;
  final String speciality;
  final String address;
  final String url;
  final String? phone;
  final String? email;
  final String? additionalInfo;
  const ClinicRow({
    required this.id,
    required this.messageId,
    required this.position,
    required this.name,
    required this.speciality,
    required this.address,
    required this.url,
    this.phone,
    this.email,
    this.additionalInfo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    map['speciality'] = Variable<String>(speciality);
    map['address'] = Variable<String>(address);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    return map;
  }

  ClinicsCompanion toCompanion(bool nullToAbsent) {
    return ClinicsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      position: Value(position),
      name: Value(name),
      speciality: Value(speciality),
      address: Value(address),
      url: Value(url),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
    );
  }

  factory ClinicRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClinicRow(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      speciality: serializer.fromJson<String>(json['speciality']),
      address: serializer.fromJson<String>(json['address']),
      url: serializer.fromJson<String>(json['url']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'speciality': serializer.toJson<String>(speciality),
      'address': serializer.toJson<String>(address),
      'url': serializer.toJson<String>(url),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
    };
  }

  ClinicRow copyWith({
    String? id,
    String? messageId,
    int? position,
    String? name,
    String? speciality,
    String? address,
    String? url,
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> additionalInfo = const Value.absent(),
  }) => ClinicRow(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    position: position ?? this.position,
    name: name ?? this.name,
    speciality: speciality ?? this.speciality,
    address: address ?? this.address,
    url: url ?? this.url,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    additionalInfo: additionalInfo.present
        ? additionalInfo.value
        : this.additionalInfo,
  );
  ClinicRow copyWithCompanion(ClinicsCompanion data) {
    return ClinicRow(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      speciality: data.speciality.present
          ? data.speciality.value
          : this.speciality,
      address: data.address.present ? data.address.value : this.address,
      url: data.url.present ? data.url.value : this.url,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClinicRow(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('speciality: $speciality, ')
          ..write('address: $address, ')
          ..write('url: $url, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('additionalInfo: $additionalInfo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    messageId,
    position,
    name,
    speciality,
    address,
    url,
    phone,
    email,
    additionalInfo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClinicRow &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.position == this.position &&
          other.name == this.name &&
          other.speciality == this.speciality &&
          other.address == this.address &&
          other.url == this.url &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.additionalInfo == this.additionalInfo);
}

class ClinicsCompanion extends UpdateCompanion<ClinicRow> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<int> position;
  final Value<String> name;
  final Value<String> speciality;
  final Value<String> address;
  final Value<String> url;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> additionalInfo;
  final Value<int> rowid;
  const ClinicsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.speciality = const Value.absent(),
    this.address = const Value.absent(),
    this.url = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClinicsCompanion.insert({
    this.id = const Value.absent(),
    required String messageId,
    required int position,
    required String name,
    required String speciality,
    required String address,
    required String url,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId),
       position = Value(position),
       name = Value(name),
       speciality = Value(speciality),
       address = Value(address),
       url = Value(url);
  static Insertable<ClinicRow> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? speciality,
    Expression<String>? address,
    Expression<String>? url,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? additionalInfo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (speciality != null) 'speciality': speciality,
      if (address != null) 'address': address,
      if (url != null) 'url': url,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClinicsCompanion copyWith({
    Value<String>? id,
    Value<String>? messageId,
    Value<int>? position,
    Value<String>? name,
    Value<String>? speciality,
    Value<String>? address,
    Value<String>? url,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? additionalInfo,
    Value<int>? rowid,
  }) {
    return ClinicsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      position: position ?? this.position,
      name: name ?? this.name,
      speciality: speciality ?? this.speciality,
      address: address ?? this.address,
      url: url ?? this.url,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (speciality.present) {
      map['speciality'] = Variable<String>(speciality.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (additionalInfo.present) {
      map['additional_info'] = Variable<String>(additionalInfo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClinicsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('speciality: $speciality, ')
          ..write('address: $address, ')
          ..write('url: $url, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $PersonalInfosTable personalInfos = $PersonalInfosTable(this);
  late final $MedicalCardsTable medicalCards = $MedicalCardsTable(this);
  late final $ChronicConditionsTable chronicConditions =
      $ChronicConditionsTable(this);
  late final $AllergiesTable allergies = $AllergiesTable(this);
  late final $ImplantsTable implants = $ImplantsTable(this);
  late final $SurgeriesTable surgeries = $SurgeriesTable(this);
  late final $EmergencyContactsTable emergencyContacts =
      $EmergencyContactsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $ConsentsTable consents = $ConsentsTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $ClinicsTable clinics = $ClinicsTable(this);
  late final Index consentsOwnerType = Index(
    'consents_owner_type',
    'CREATE INDEX consents_owner_type ON consents (owner_user_id, type)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    personalInfos,
    medicalCards,
    chronicConditions,
    allergies,
    implants,
    surgeries,
    emergencyContacts,
    userSettingsTable,
    consents,
    chats,
    messages,
    clinics,
    consentsOwnerType,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medical_card',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chronic_conditions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medical_card',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('allergies', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medical_card',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('implants', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medical_card',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('surgeries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'medical_card',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('emergency_contacts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profile',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chats',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'messages',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('clinics', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  required String serverId,
  Value<String?> displayName,
  required String email,
  Value<String?> avatarUrl,
  required DateTime syncedAt,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> serverId,
  Value<String?> displayName,
  Value<String> email,
  Value<String?> avatarUrl,
  Value<DateTime> syncedAt,
  Value<int> rowid,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatsTable, List<ChatRow>> _chatsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chats,
    aliasName: 'profile__id__chats__profile_id',
  );

  $$ChatsTableProcessedTableManager get chatsRefs {
    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chatsRefs(
    Expression<bool> Function($$ChatsTableFilterComposer f) f,
  ) {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> chatsRefs<T extends Object>(
    Expression<T> Function($$ChatsTableAnnotationComposer a) f,
  ) {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (ProfileRow, $$ProfilesTableReferences),
          ProfileRow,
          PrefetchHooks Function({bool chatsRefs})
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                serverId: serverId,
                displayName: displayName,
                email: email,
                avatarUrl: avatarUrl,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String serverId,
                Value<String?> displayName = const Value.absent(),
                required String email,
                Value<String?> avatarUrl = const Value.absent(),
                required DateTime syncedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                serverId: serverId,
                displayName: displayName,
                email: email,
                avatarUrl: avatarUrl,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatsRefs) db.chats],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatsRefs)
                    await $_getPrefetchedDataByColumns<
                      ProfileRow,
                      $ProfilesTable,
                      ChatRow,
                      $ChatsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ProfilesTableReferences
                          ._chatsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProfilesTableReferences(db, table, p0).chatsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'profile_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, $$ProfilesTableReferences),
      ProfileRow,
      PrefetchHooks Function({bool chatsRefs})
    >;
typedef $$PersonalInfosTableCreateCompanionBuilder =
    PersonalInfosCompanion Function({
      Value<String> id,
      required String ownerUserId,
      Value<DateTime?> dateOfBirth,
      Value<Sex?> sex,
      Value<int?> heightCm,
      Value<double?> weightKg,
      Value<String?> fallbackLocationLabel,
      Value<double?> fallbackLatitude,
      Value<double?> fallbackLongitude,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PersonalInfosTableUpdateCompanionBuilder =
    PersonalInfosCompanion Function({
      Value<String> id,
      Value<String> ownerUserId,
      Value<DateTime?> dateOfBirth,
      Value<Sex?> sex,
      Value<int?> heightCm,
      Value<double?> weightKg,
      Value<String?> fallbackLocationLabel,
      Value<double?> fallbackLatitude,
      Value<double?> fallbackLongitude,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PersonalInfosTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalInfosTable> {
  $$PersonalInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Sex?, Sex, String> get sex =>
      $composableBuilder(
        column: $table.sex,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fallbackLocationLabel => $composableBuilder(
    column: $table.fallbackLocationLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fallbackLatitude => $composableBuilder(
    column: $table.fallbackLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fallbackLongitude => $composableBuilder(
    column: $table.fallbackLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalInfosTable> {
  $$PersonalInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fallbackLocationLabel => $composableBuilder(
    column: $table.fallbackLocationLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fallbackLatitude => $composableBuilder(
    column: $table.fallbackLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fallbackLongitude => $composableBuilder(
    column: $table.fallbackLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalInfosTable> {
  $$PersonalInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Sex?, String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get fallbackLocationLabel => $composableBuilder(
    column: $table.fallbackLocationLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fallbackLatitude => $composableBuilder(
    column: $table.fallbackLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fallbackLongitude => $composableBuilder(
    column: $table.fallbackLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonalInfosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalInfosTable,
          PersonalInfoRow,
          $$PersonalInfosTableFilterComposer,
          $$PersonalInfosTableOrderingComposer,
          $$PersonalInfosTableAnnotationComposer,
          $$PersonalInfosTableCreateCompanionBuilder,
          $$PersonalInfosTableUpdateCompanionBuilder,
          (
            PersonalInfoRow,
            BaseReferences<_$AppDatabase, $PersonalInfosTable, PersonalInfoRow>,
          ),
          PersonalInfoRow,
          PrefetchHooks Function()
        > {
  $$PersonalInfosTableTableManager(_$AppDatabase db, $PersonalInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<Sex?> sex = const Value.absent(),
                Value<int?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> fallbackLocationLabel = const Value.absent(),
                Value<double?> fallbackLatitude = const Value.absent(),
                Value<double?> fallbackLongitude = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalInfosCompanion(
                id: id,
                ownerUserId: ownerUserId,
                dateOfBirth: dateOfBirth,
                sex: sex,
                heightCm: heightCm,
                weightKg: weightKg,
                fallbackLocationLabel: fallbackLocationLabel,
                fallbackLatitude: fallbackLatitude,
                fallbackLongitude: fallbackLongitude,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String ownerUserId,
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<Sex?> sex = const Value.absent(),
                Value<int?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<String?> fallbackLocationLabel = const Value.absent(),
                Value<double?> fallbackLatitude = const Value.absent(),
                Value<double?> fallbackLongitude = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalInfosCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                dateOfBirth: dateOfBirth,
                sex: sex,
                heightCm: heightCm,
                weightKg: weightKg,
                fallbackLocationLabel: fallbackLocationLabel,
                fallbackLatitude: fallbackLatitude,
                fallbackLongitude: fallbackLongitude,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonalInfosTable, PersonalInfoRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PersonalInfosTable,
                    PersonalInfoRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalInfosTable,
      PersonalInfoRow,
      $$PersonalInfosTableFilterComposer,
      $$PersonalInfosTableOrderingComposer,
      $$PersonalInfosTableAnnotationComposer,
      $$PersonalInfosTableCreateCompanionBuilder,
      $$PersonalInfosTableUpdateCompanionBuilder,
      (
        PersonalInfoRow,
        BaseReferences<_$AppDatabase, $PersonalInfosTable, PersonalInfoRow>,
      ),
      PersonalInfoRow,
      PrefetchHooks Function()
    >;
typedef $$MedicalCardsTableCreateCompanionBuilder =
    MedicalCardsCompanion Function({
      Value<String> id,
      required String ownerUserId,
      Value<BloodType?> bloodType,
      Value<InsuranceCompany?> insuranceCompany,
      Value<String?> insuranceCompanyOther,
      Value<String?> gpName,
      Value<String?> gpPhone,
      Value<DateTime?> pregnancyDueDate,
      Value<bool> needsStepFreeAccess,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MedicalCardsTableUpdateCompanionBuilder =
    MedicalCardsCompanion Function({
      Value<String> id,
      Value<String> ownerUserId,
      Value<BloodType?> bloodType,
      Value<InsuranceCompany?> insuranceCompany,
      Value<String?> insuranceCompanyOther,
      Value<String?> gpName,
      Value<String?> gpPhone,
      Value<DateTime?> pregnancyDueDate,
      Value<bool> needsStepFreeAccess,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$MedicalCardsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicalCardsTable, MedicalCardRow> {
  $$MedicalCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChronicConditionsTable, List<ChronicConditionRow>>
  _chronicConditionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.chronicConditions,
        aliasName: 'medical_card__id__chronic_conditions__medical_card_id',
      );

  $$ChronicConditionsTableProcessedTableManager get chronicConditionsRefs {
    final manager = $$ChronicConditionsTableTableManager(
      $_db,
      $_db.chronicConditions,
    ).filter((f) => f.medicalCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _chronicConditionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AllergiesTable, List<AllergyRow>>
  _allergiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.allergies,
    aliasName: 'medical_card__id__allergies__medical_card_id',
  );

  $$AllergiesTableProcessedTableManager get allergiesRefs {
    final manager = $$AllergiesTableTableManager(
      $_db,
      $_db.allergies,
    ).filter((f) => f.medicalCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_allergiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImplantsTable, List<ImplantRow>>
  _implantsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.implants,
    aliasName: 'medical_card__id__implants__medical_card_id',
  );

  $$ImplantsTableProcessedTableManager get implantsRefs {
    final manager = $$ImplantsTableTableManager(
      $_db,
      $_db.implants,
    ).filter((f) => f.medicalCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_implantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SurgeriesTable, List<SurgeryRow>>
  _surgeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.surgeries,
    aliasName: 'medical_card__id__surgeries__medical_card_id',
  );

  $$SurgeriesTableProcessedTableManager get surgeriesRefs {
    final manager = $$SurgeriesTableTableManager(
      $_db,
      $_db.surgeries,
    ).filter((f) => f.medicalCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_surgeriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EmergencyContactsTable, List<EmergencyContactRow>>
  _emergencyContactsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.emergencyContacts,
        aliasName: 'medical_card__id__emergency_contacts__medical_card_id',
      );

  $$EmergencyContactsTableProcessedTableManager get emergencyContactsRefs {
    final manager = $$EmergencyContactsTableTableManager(
      $_db,
      $_db.emergencyContacts,
    ).filter((f) => f.medicalCardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emergencyContactsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicalCardsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalCardsTable> {
  $$MedicalCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BloodType?, BloodType, String> get bloodType =>
      $composableBuilder(
        column: $table.bloodType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<InsuranceCompany?, InsuranceCompany, String>
  get insuranceCompany => $composableBuilder(
    column: $table.insuranceCompany,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get insuranceCompanyOther => $composableBuilder(
    column: $table.insuranceCompanyOther,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gpName => $composableBuilder(
    column: $table.gpName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gpPhone => $composableBuilder(
    column: $table.gpPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pregnancyDueDate => $composableBuilder(
    column: $table.pregnancyDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsStepFreeAccess => $composableBuilder(
    column: $table.needsStepFreeAccess,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chronicConditionsRefs(
    Expression<bool> Function($$ChronicConditionsTableFilterComposer f) f,
  ) {
    final $$ChronicConditionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chronicConditions,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChronicConditionsTableFilterComposer(
            $db: $db,
            $table: $db.chronicConditions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> allergiesRefs(
    Expression<bool> Function($$AllergiesTableFilterComposer f) f,
  ) {
    final $$AllergiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allergies,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergiesTableFilterComposer(
            $db: $db,
            $table: $db.allergies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> implantsRefs(
    Expression<bool> Function($$ImplantsTableFilterComposer f) f,
  ) {
    final $$ImplantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.implants,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImplantsTableFilterComposer(
            $db: $db,
            $table: $db.implants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> surgeriesRefs(
    Expression<bool> Function($$SurgeriesTableFilterComposer f) f,
  ) {
    final $$SurgeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surgeries,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurgeriesTableFilterComposer(
            $db: $db,
            $table: $db.surgeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> emergencyContactsRefs(
    Expression<bool> Function($$EmergencyContactsTableFilterComposer f) f,
  ) {
    final $$EmergencyContactsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emergencyContacts,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmergencyContactsTableFilterComposer(
            $db: $db,
            $table: $db.emergencyContacts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicalCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalCardsTable> {
  $$MedicalCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insuranceCompany => $composableBuilder(
    column: $table.insuranceCompany,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insuranceCompanyOther => $composableBuilder(
    column: $table.insuranceCompanyOther,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpName => $composableBuilder(
    column: $table.gpName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpPhone => $composableBuilder(
    column: $table.gpPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pregnancyDueDate => $composableBuilder(
    column: $table.pregnancyDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsStepFreeAccess => $composableBuilder(
    column: $table.needsStepFreeAccess,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicalCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalCardsTable> {
  $$MedicalCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BloodType?, String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InsuranceCompany?, String>
  get insuranceCompany => $composableBuilder(
    column: $table.insuranceCompany,
    builder: (column) => column,
  );

  GeneratedColumn<String> get insuranceCompanyOther => $composableBuilder(
    column: $table.insuranceCompanyOther,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gpName =>
      $composableBuilder(column: $table.gpName, builder: (column) => column);

  GeneratedColumn<String> get gpPhone =>
      $composableBuilder(column: $table.gpPhone, builder: (column) => column);

  GeneratedColumn<DateTime> get pregnancyDueDate => $composableBuilder(
    column: $table.pregnancyDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsStepFreeAccess => $composableBuilder(
    column: $table.needsStepFreeAccess,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> chronicConditionsRefs<T extends Object>(
    Expression<T> Function($$ChronicConditionsTableAnnotationComposer a) f,
  ) {
    final $$ChronicConditionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.chronicConditions,
          getReferencedColumn: (t) => t.medicalCardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChronicConditionsTableAnnotationComposer(
                $db: $db,
                $table: $db.chronicConditions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> allergiesRefs<T extends Object>(
    Expression<T> Function($$AllergiesTableAnnotationComposer a) f,
  ) {
    final $$AllergiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.allergies,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AllergiesTableAnnotationComposer(
            $db: $db,
            $table: $db.allergies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> implantsRefs<T extends Object>(
    Expression<T> Function($$ImplantsTableAnnotationComposer a) f,
  ) {
    final $$ImplantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.implants,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImplantsTableAnnotationComposer(
            $db: $db,
            $table: $db.implants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> surgeriesRefs<T extends Object>(
    Expression<T> Function($$SurgeriesTableAnnotationComposer a) f,
  ) {
    final $$SurgeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.surgeries,
      getReferencedColumn: (t) => t.medicalCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurgeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.surgeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> emergencyContactsRefs<T extends Object>(
    Expression<T> Function($$EmergencyContactsTableAnnotationComposer a) f,
  ) {
    final $$EmergencyContactsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.emergencyContacts,
          getReferencedColumn: (t) => t.medicalCardId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmergencyContactsTableAnnotationComposer(
                $db: $db,
                $table: $db.emergencyContacts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MedicalCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicalCardsTable,
          MedicalCardRow,
          $$MedicalCardsTableFilterComposer,
          $$MedicalCardsTableOrderingComposer,
          $$MedicalCardsTableAnnotationComposer,
          $$MedicalCardsTableCreateCompanionBuilder,
          $$MedicalCardsTableUpdateCompanionBuilder,
          (MedicalCardRow, $$MedicalCardsTableReferences),
          MedicalCardRow,
          PrefetchHooks Function({
            bool chronicConditionsRefs,
            bool allergiesRefs,
            bool implantsRefs,
            bool surgeriesRefs,
            bool emergencyContactsRefs,
          })
        > {
  $$MedicalCardsTableTableManager(_$AppDatabase db, $MedicalCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<BloodType?> bloodType = const Value.absent(),
                Value<InsuranceCompany?> insuranceCompany =
                    const Value.absent(),
                Value<String?> insuranceCompanyOther = const Value.absent(),
                Value<String?> gpName = const Value.absent(),
                Value<String?> gpPhone = const Value.absent(),
                Value<DateTime?> pregnancyDueDate = const Value.absent(),
                Value<bool> needsStepFreeAccess = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalCardsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                bloodType: bloodType,
                insuranceCompany: insuranceCompany,
                insuranceCompanyOther: insuranceCompanyOther,
                gpName: gpName,
                gpPhone: gpPhone,
                pregnancyDueDate: pregnancyDueDate,
                needsStepFreeAccess: needsStepFreeAccess,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String ownerUserId,
                Value<BloodType?> bloodType = const Value.absent(),
                Value<InsuranceCompany?> insuranceCompany =
                    const Value.absent(),
                Value<String?> insuranceCompanyOther = const Value.absent(),
                Value<String?> gpName = const Value.absent(),
                Value<String?> gpPhone = const Value.absent(),
                Value<DateTime?> pregnancyDueDate = const Value.absent(),
                Value<bool> needsStepFreeAccess = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicalCardsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                bloodType: bloodType,
                insuranceCompany: insuranceCompany,
                insuranceCompanyOther: insuranceCompanyOther,
                gpName: gpName,
                gpPhone: gpPhone,
                pregnancyDueDate: pregnancyDueDate,
                needsStepFreeAccess: needsStepFreeAccess,
                notes: notes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicalCardsTable, MedicalCardRow>(table),
                  $$MedicalCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chronicConditionsRefs = false,
                allergiesRefs = false,
                implantsRefs = false,
                surgeriesRefs = false,
                emergencyContactsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chronicConditionsRefs) db.chronicConditions,
                    if (allergiesRefs) db.allergies,
                    if (implantsRefs) db.implants,
                    if (surgeriesRefs) db.surgeries,
                    if (emergencyContactsRefs) db.emergencyContacts,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chronicConditionsRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicalCardRow,
                          $MedicalCardsTable,
                          ChronicConditionRow,
                          $ChronicConditionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalCardsTableReferences
                              ._chronicConditionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).chronicConditionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medical_card_id',
                          typedResults: items,
                        ),
                      if (allergiesRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicalCardRow,
                          $MedicalCardsTable,
                          AllergyRow,
                          $AllergiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalCardsTableReferences
                              ._allergiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).allergiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medical_card_id',
                          typedResults: items,
                        ),
                      if (implantsRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicalCardRow,
                          $MedicalCardsTable,
                          ImplantRow,
                          $ImplantsTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalCardsTableReferences
                              ._implantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).implantsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medical_card_id',
                          typedResults: items,
                        ),
                      if (surgeriesRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicalCardRow,
                          $MedicalCardsTable,
                          SurgeryRow,
                          $SurgeriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalCardsTableReferences
                              ._surgeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).surgeriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medical_card_id',
                          typedResults: items,
                        ),
                      if (emergencyContactsRefs)
                        await $_getPrefetchedDataByColumns<
                          MedicalCardRow,
                          $MedicalCardsTable,
                          EmergencyContactRow,
                          $EmergencyContactsTable
                        >(
                          currentTable: table,
                          referencedTable: $$MedicalCardsTableReferences
                              ._emergencyContactsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicalCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).emergencyContactsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'medical_card_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicalCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicalCardsTable,
      MedicalCardRow,
      $$MedicalCardsTableFilterComposer,
      $$MedicalCardsTableOrderingComposer,
      $$MedicalCardsTableAnnotationComposer,
      $$MedicalCardsTableCreateCompanionBuilder,
      $$MedicalCardsTableUpdateCompanionBuilder,
      (MedicalCardRow, $$MedicalCardsTableReferences),
      MedicalCardRow,
      PrefetchHooks Function({
        bool chronicConditionsRefs,
        bool allergiesRefs,
        bool implantsRefs,
        bool surgeriesRefs,
        bool emergencyContactsRefs,
      })
    >;
typedef $$ChronicConditionsTableCreateCompanionBuilder =
    ChronicConditionsCompanion Function({
      Value<String> id,
      required String medicalCardId,
      required String name,
      Value<int?> since,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ChronicConditionsTableUpdateCompanionBuilder =
    ChronicConditionsCompanion Function({
      Value<String> id,
      Value<String> medicalCardId,
      Value<String> name,
      Value<int?> since,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ChronicConditionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChronicConditionsTable,
          ChronicConditionRow
        > {
  $$ChronicConditionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalCardsTable _medicalCardIdTable(_$AppDatabase db) => db
      .medicalCards
      .createAlias('chronic_conditions__medical_card_id__medical_card__id');

  $$MedicalCardsTableProcessedTableManager get medicalCardId {
    final $_column = $_itemColumn<String>('medical_card_id')!;

    final manager = $$MedicalCardsTableTableManager(
      $_db,
      $_db.medicalCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChronicConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChronicConditionsTable> {
  $$ChronicConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get since => $composableBuilder(
    column: $table.since,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalCardsTableFilterComposer get medicalCardId {
    final $$MedicalCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableFilterComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChronicConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChronicConditionsTable> {
  $$ChronicConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get since => $composableBuilder(
    column: $table.since,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalCardsTableOrderingComposer get medicalCardId {
    final $$MedicalCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChronicConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChronicConditionsTable> {
  $$ChronicConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get since =>
      $composableBuilder(column: $table.since, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$MedicalCardsTableAnnotationComposer get medicalCardId {
    final $$MedicalCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChronicConditionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChronicConditionsTable,
          ChronicConditionRow,
          $$ChronicConditionsTableFilterComposer,
          $$ChronicConditionsTableOrderingComposer,
          $$ChronicConditionsTableAnnotationComposer,
          $$ChronicConditionsTableCreateCompanionBuilder,
          $$ChronicConditionsTableUpdateCompanionBuilder,
          (ChronicConditionRow, $$ChronicConditionsTableReferences),
          ChronicConditionRow,
          PrefetchHooks Function({bool medicalCardId})
        > {
  $$ChronicConditionsTableTableManager(
    _$AppDatabase db,
    $ChronicConditionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChronicConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChronicConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChronicConditionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicalCardId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> since = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChronicConditionsCompanion(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                since: since,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String medicalCardId,
                required String name,
                Value<int?> since = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChronicConditionsCompanion.insert(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                since: since,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChronicConditionsTable, ChronicConditionRow>(
                    table,
                  ),
                  $$ChronicConditionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicalCardId,
                        referencedTable: $$ChronicConditionsTableReferences
                            ._medicalCardIdTable(db),
                        referencedColumn: $$ChronicConditionsTableReferences
                            ._medicalCardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChronicConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChronicConditionsTable,
      ChronicConditionRow,
      $$ChronicConditionsTableFilterComposer,
      $$ChronicConditionsTableOrderingComposer,
      $$ChronicConditionsTableAnnotationComposer,
      $$ChronicConditionsTableCreateCompanionBuilder,
      $$ChronicConditionsTableUpdateCompanionBuilder,
      (ChronicConditionRow, $$ChronicConditionsTableReferences),
      ChronicConditionRow,
      PrefetchHooks Function({bool medicalCardId})
    >;
typedef $$AllergiesTableCreateCompanionBuilder = AllergiesCompanion Function({
  Value<String> id,
  required String medicalCardId,
  required String name,
  required AllergyKind kind,
  required AllergyCategory category,
  Value<String?> reaction,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$AllergiesTableUpdateCompanionBuilder = AllergiesCompanion Function({
  Value<String> id,
  Value<String> medicalCardId,
  Value<String> name,
  Value<AllergyKind> kind,
  Value<AllergyCategory> category,
  Value<String?> reaction,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$AllergiesTableReferences
    extends BaseReferences<_$AppDatabase, $AllergiesTable, AllergyRow> {
  $$AllergiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalCardsTable _medicalCardIdTable(_$AppDatabase db) => db
      .medicalCards
      .createAlias('allergies__medical_card_id__medical_card__id');

  $$MedicalCardsTableProcessedTableManager get medicalCardId {
    final $_column = $_itemColumn<String>('medical_card_id')!;

    final manager = $$MedicalCardsTableTableManager(
      $_db,
      $_db.medicalCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AllergiesTableFilterComposer
    extends Composer<_$AppDatabase, $AllergiesTable> {
  $$AllergiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AllergyKind, AllergyKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<AllergyCategory, AllergyCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalCardsTableFilterComposer get medicalCardId {
    final $$MedicalCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableFilterComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergiesTableOrderingComposer
    extends Composer<_$AppDatabase, $AllergiesTable> {
  $$AllergiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalCardsTableOrderingComposer get medicalCardId {
    final $$MedicalCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllergiesTable> {
  $$AllergiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AllergyKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AllergyCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$MedicalCardsTableAnnotationComposer get medicalCardId {
    final $$MedicalCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AllergiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllergiesTable,
          AllergyRow,
          $$AllergiesTableFilterComposer,
          $$AllergiesTableOrderingComposer,
          $$AllergiesTableAnnotationComposer,
          $$AllergiesTableCreateCompanionBuilder,
          $$AllergiesTableUpdateCompanionBuilder,
          (AllergyRow, $$AllergiesTableReferences),
          AllergyRow,
          PrefetchHooks Function({bool medicalCardId})
        > {
  $$AllergiesTableTableManager(_$AppDatabase db, $AllergiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllergiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllergiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllergiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicalCardId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AllergyKind> kind = const Value.absent(),
                Value<AllergyCategory> category = const Value.absent(),
                Value<String?> reaction = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllergiesCompanion(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                kind: kind,
                category: category,
                reaction: reaction,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String medicalCardId,
                required String name,
                required AllergyKind kind,
                required AllergyCategory category,
                Value<String?> reaction = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllergiesCompanion.insert(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                kind: kind,
                category: category,
                reaction: reaction,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AllergiesTable, AllergyRow>(table),
                  $$AllergiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicalCardId,
                        referencedTable: $$AllergiesTableReferences
                            ._medicalCardIdTable(db),
                        referencedColumn: $$AllergiesTableReferences
                            ._medicalCardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AllergiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllergiesTable,
      AllergyRow,
      $$AllergiesTableFilterComposer,
      $$AllergiesTableOrderingComposer,
      $$AllergiesTableAnnotationComposer,
      $$AllergiesTableCreateCompanionBuilder,
      $$AllergiesTableUpdateCompanionBuilder,
      (AllergyRow, $$AllergiesTableReferences),
      AllergyRow,
      PrefetchHooks Function({bool medicalCardId})
    >;
typedef $$ImplantsTableCreateCompanionBuilder = ImplantsCompanion Function({
  Value<String> id,
  required String medicalCardId,
  required String name,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ImplantsTableUpdateCompanionBuilder = ImplantsCompanion Function({
  Value<String> id,
  Value<String> medicalCardId,
  Value<String> name,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$ImplantsTableReferences
    extends BaseReferences<_$AppDatabase, $ImplantsTable, ImplantRow> {
  $$ImplantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalCardsTable _medicalCardIdTable(_$AppDatabase db) => db
      .medicalCards
      .createAlias('implants__medical_card_id__medical_card__id');

  $$MedicalCardsTableProcessedTableManager get medicalCardId {
    final $_column = $_itemColumn<String>('medical_card_id')!;

    final manager = $$MedicalCardsTableTableManager(
      $_db,
      $_db.medicalCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImplantsTableFilterComposer
    extends Composer<_$AppDatabase, $ImplantsTable> {
  $$ImplantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalCardsTableFilterComposer get medicalCardId {
    final $$MedicalCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableFilterComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImplantsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImplantsTable> {
  $$ImplantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalCardsTableOrderingComposer get medicalCardId {
    final $$MedicalCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImplantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImplantsTable> {
  $$ImplantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$MedicalCardsTableAnnotationComposer get medicalCardId {
    final $$MedicalCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImplantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImplantsTable,
          ImplantRow,
          $$ImplantsTableFilterComposer,
          $$ImplantsTableOrderingComposer,
          $$ImplantsTableAnnotationComposer,
          $$ImplantsTableCreateCompanionBuilder,
          $$ImplantsTableUpdateCompanionBuilder,
          (ImplantRow, $$ImplantsTableReferences),
          ImplantRow,
          PrefetchHooks Function({bool medicalCardId})
        > {
  $$ImplantsTableTableManager(_$AppDatabase db, $ImplantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImplantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImplantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImplantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicalCardId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImplantsCompanion(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String medicalCardId,
                required String name,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImplantsCompanion.insert(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImplantsTable, ImplantRow>(table),
                  $$ImplantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicalCardId,
                        referencedTable: $$ImplantsTableReferences
                            ._medicalCardIdTable(db),
                        referencedColumn: $$ImplantsTableReferences
                            ._medicalCardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImplantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImplantsTable,
      ImplantRow,
      $$ImplantsTableFilterComposer,
      $$ImplantsTableOrderingComposer,
      $$ImplantsTableAnnotationComposer,
      $$ImplantsTableCreateCompanionBuilder,
      $$ImplantsTableUpdateCompanionBuilder,
      (ImplantRow, $$ImplantsTableReferences),
      ImplantRow,
      PrefetchHooks Function({bool medicalCardId})
    >;
typedef $$SurgeriesTableCreateCompanionBuilder = SurgeriesCompanion Function({
  Value<String> id,
  required String medicalCardId,
  required String name,
  Value<int?> year,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$SurgeriesTableUpdateCompanionBuilder = SurgeriesCompanion Function({
  Value<String> id,
  Value<String> medicalCardId,
  Value<String> name,
  Value<int?> year,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$SurgeriesTableReferences
    extends BaseReferences<_$AppDatabase, $SurgeriesTable, SurgeryRow> {
  $$SurgeriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicalCardsTable _medicalCardIdTable(_$AppDatabase db) => db
      .medicalCards
      .createAlias('surgeries__medical_card_id__medical_card__id');

  $$MedicalCardsTableProcessedTableManager get medicalCardId {
    final $_column = $_itemColumn<String>('medical_card_id')!;

    final manager = $$MedicalCardsTableTableManager(
      $_db,
      $_db.medicalCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SurgeriesTableFilterComposer
    extends Composer<_$AppDatabase, $SurgeriesTable> {
  $$SurgeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalCardsTableFilterComposer get medicalCardId {
    final $$MedicalCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableFilterComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurgeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SurgeriesTable> {
  $$SurgeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalCardsTableOrderingComposer get medicalCardId {
    final $$MedicalCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurgeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurgeriesTable> {
  $$SurgeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$MedicalCardsTableAnnotationComposer get medicalCardId {
    final $$MedicalCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SurgeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurgeriesTable,
          SurgeryRow,
          $$SurgeriesTableFilterComposer,
          $$SurgeriesTableOrderingComposer,
          $$SurgeriesTableAnnotationComposer,
          $$SurgeriesTableCreateCompanionBuilder,
          $$SurgeriesTableUpdateCompanionBuilder,
          (SurgeryRow, $$SurgeriesTableReferences),
          SurgeryRow,
          PrefetchHooks Function({bool medicalCardId})
        > {
  $$SurgeriesTableTableManager(_$AppDatabase db, $SurgeriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurgeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurgeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurgeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicalCardId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SurgeriesCompanion(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                year: year,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String medicalCardId,
                required String name,
                Value<int?> year = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SurgeriesCompanion.insert(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                year: year,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SurgeriesTable, SurgeryRow>(table),
                  $$SurgeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicalCardId,
                        referencedTable: $$SurgeriesTableReferences
                            ._medicalCardIdTable(db),
                        referencedColumn: $$SurgeriesTableReferences
                            ._medicalCardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SurgeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurgeriesTable,
      SurgeryRow,
      $$SurgeriesTableFilterComposer,
      $$SurgeriesTableOrderingComposer,
      $$SurgeriesTableAnnotationComposer,
      $$SurgeriesTableCreateCompanionBuilder,
      $$SurgeriesTableUpdateCompanionBuilder,
      (SurgeryRow, $$SurgeriesTableReferences),
      SurgeryRow,
      PrefetchHooks Function({bool medicalCardId})
    >;
typedef $$EmergencyContactsTableCreateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<String> id,
      required String medicalCardId,
      required String name,
      Value<String?> relation,
      required String phone,
      Value<bool> isPrimary,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EmergencyContactsTableUpdateCompanionBuilder =
    EmergencyContactsCompanion Function({
      Value<String> id,
      Value<String> medicalCardId,
      Value<String> name,
      Value<String?> relation,
      Value<String> phone,
      Value<bool> isPrimary,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$EmergencyContactsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContactRow
        > {
  $$EmergencyContactsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicalCardsTable _medicalCardIdTable(_$AppDatabase db) => db
      .medicalCards
      .createAlias('emergency_contacts__medical_card_id__medical_card__id');

  $$MedicalCardsTableProcessedTableManager get medicalCardId {
    final $_column = $_itemColumn<String>('medical_card_id')!;

    final manager = $$MedicalCardsTableTableManager(
      $_db,
      $_db.medicalCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicalCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmergencyContactsTableFilterComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicalCardsTableFilterComposer get medicalCardId {
    final $$MedicalCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableFilterComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmergencyContactsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relation => $composableBuilder(
    column: $table.relation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicalCardsTableOrderingComposer get medicalCardId {
    final $$MedicalCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableOrderingComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmergencyContactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmergencyContactsTable> {
  $$EmergencyContactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get relation =>
      $composableBuilder(column: $table.relation, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$MedicalCardsTableAnnotationComposer get medicalCardId {
    final $$MedicalCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicalCardId,
      referencedTable: $db.medicalCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicalCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicalCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmergencyContactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmergencyContactsTable,
          EmergencyContactRow,
          $$EmergencyContactsTableFilterComposer,
          $$EmergencyContactsTableOrderingComposer,
          $$EmergencyContactsTableAnnotationComposer,
          $$EmergencyContactsTableCreateCompanionBuilder,
          $$EmergencyContactsTableUpdateCompanionBuilder,
          (EmergencyContactRow, $$EmergencyContactsTableReferences),
          EmergencyContactRow,
          PrefetchHooks Function({bool medicalCardId})
        > {
  $$EmergencyContactsTableTableManager(
    _$AppDatabase db,
    $EmergencyContactsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmergencyContactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmergencyContactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmergencyContactsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medicalCardId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> relation = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyContactsCompanion(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                relation: relation,
                phone: phone,
                isPrimary: isPrimary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String medicalCardId,
                required String name,
                Value<String?> relation = const Value.absent(),
                required String phone,
                Value<bool> isPrimary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmergencyContactsCompanion.insert(
                id: id,
                medicalCardId: medicalCardId,
                name: name,
                relation: relation,
                phone: phone,
                isPrimary: isPrimary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmergencyContactsTable, EmergencyContactRow>(
                    table,
                  ),
                  $$EmergencyContactsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicalCardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicalCardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.medicalCardId,
                        referencedTable: $$EmergencyContactsTableReferences
                            ._medicalCardIdTable(db),
                        referencedColumn: $$EmergencyContactsTableReferences
                            ._medicalCardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmergencyContactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmergencyContactsTable,
      EmergencyContactRow,
      $$EmergencyContactsTableFilterComposer,
      $$EmergencyContactsTableOrderingComposer,
      $$EmergencyContactsTableAnnotationComposer,
      $$EmergencyContactsTableCreateCompanionBuilder,
      $$EmergencyContactsTableUpdateCompanionBuilder,
      (EmergencyContactRow, $$EmergencyContactsTableReferences),
      EmergencyContactRow,
      PrefetchHooks Function({bool medicalCardId})
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> id,
      required String ownerUserId,
      Value<bool> medicationRemindersEnabled,
      Value<int?> repeatReminderMinutes,
      Value<bool> moodRemindersEnabled,
      Value<String> moodReminderTime,
      Value<bool> healthAlertsEnabled,
      Value<bool> recommendationsEnabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> id,
      Value<String> ownerUserId,
      Value<bool> medicationRemindersEnabled,
      Value<int?> repeatReminderMinutes,
      Value<bool> moodRemindersEnabled,
      Value<String> moodReminderTime,
      Value<bool> healthAlertsEnabled,
      Value<bool> recommendationsEnabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get medicationRemindersEnabled => $composableBuilder(
    column: $table.medicationRemindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatReminderMinutes => $composableBuilder(
    column: $table.repeatReminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get moodRemindersEnabled => $composableBuilder(
    column: $table.moodRemindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodReminderTime => $composableBuilder(
    column: $table.moodReminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get healthAlertsEnabled => $composableBuilder(
    column: $table.healthAlertsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recommendationsEnabled => $composableBuilder(
    column: $table.recommendationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get medicationRemindersEnabled => $composableBuilder(
    column: $table.medicationRemindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatReminderMinutes => $composableBuilder(
    column: $table.repeatReminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get moodRemindersEnabled => $composableBuilder(
    column: $table.moodRemindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodReminderTime => $composableBuilder(
    column: $table.moodReminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get healthAlertsEnabled => $composableBuilder(
    column: $table.healthAlertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recommendationsEnabled => $composableBuilder(
    column: $table.recommendationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get medicationRemindersEnabled => $composableBuilder(
    column: $table.medicationRemindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatReminderMinutes => $composableBuilder(
    column: $table.repeatReminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get moodRemindersEnabled => $composableBuilder(
    column: $table.moodRemindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moodReminderTime => $composableBuilder(
    column: $table.moodReminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get healthAlertsEnabled => $composableBuilder(
    column: $table.healthAlertsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get recommendationsEnabled => $composableBuilder(
    column: $table.recommendationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsRow,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsRow
            >,
          ),
          UserSettingsRow,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<bool> medicationRemindersEnabled = const Value.absent(),
                Value<int?> repeatReminderMinutes = const Value.absent(),
                Value<bool> moodRemindersEnabled = const Value.absent(),
                Value<String> moodReminderTime = const Value.absent(),
                Value<bool> healthAlertsEnabled = const Value.absent(),
                Value<bool> recommendationsEnabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion(
                id: id,
                ownerUserId: ownerUserId,
                medicationRemindersEnabled: medicationRemindersEnabled,
                repeatReminderMinutes: repeatReminderMinutes,
                moodRemindersEnabled: moodRemindersEnabled,
                moodReminderTime: moodReminderTime,
                healthAlertsEnabled: healthAlertsEnabled,
                recommendationsEnabled: recommendationsEnabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String ownerUserId,
                Value<bool> medicationRemindersEnabled = const Value.absent(),
                Value<int?> repeatReminderMinutes = const Value.absent(),
                Value<bool> moodRemindersEnabled = const Value.absent(),
                Value<String> moodReminderTime = const Value.absent(),
                Value<bool> healthAlertsEnabled = const Value.absent(),
                Value<bool> recommendationsEnabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                medicationRemindersEnabled: medicationRemindersEnabled,
                repeatReminderMinutes: repeatReminderMinutes,
                moodRemindersEnabled: moodRemindersEnabled,
                moodReminderTime: moodReminderTime,
                healthAlertsEnabled: healthAlertsEnabled,
                recommendationsEnabled: recommendationsEnabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserSettingsTableTable, UserSettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserSettingsTableTable,
                    UserSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsRow,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsRow,
        BaseReferences<_$AppDatabase, $UserSettingsTableTable, UserSettingsRow>,
      ),
      UserSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$ConsentsTableCreateCompanionBuilder = ConsentsCompanion Function({
  Value<String> id,
  required String ownerUserId,
  required ConsentType type,
  required int version,
  required DateTime grantedAt,
  Value<DateTime?> revokedAt,
  Value<int> rowid,
});
typedef $$ConsentsTableUpdateCompanionBuilder = ConsentsCompanion Function({
  Value<String> id,
  Value<String> ownerUserId,
  Value<ConsentType> type,
  Value<int> version,
  Value<DateTime> grantedAt,
  Value<DateTime?> revokedAt,
  Value<int> rowid,
});

class $$ConsentsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ConsentType, ConsentType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConsentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get grantedAt => $composableBuilder(
    column: $table.grantedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConsentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsentsTable> {
  $$ConsentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ConsentType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get grantedAt =>
      $composableBuilder(column: $table.grantedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);
}

class $$ConsentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsentsTable,
          ConsentRow,
          $$ConsentsTableFilterComposer,
          $$ConsentsTableOrderingComposer,
          $$ConsentsTableAnnotationComposer,
          $$ConsentsTableCreateCompanionBuilder,
          $$ConsentsTableUpdateCompanionBuilder,
          (
            ConsentRow,
            BaseReferences<_$AppDatabase, $ConsentsTable, ConsentRow>,
          ),
          ConsentRow,
          PrefetchHooks Function()
        > {
  $$ConsentsTableTableManager(_$AppDatabase db, $ConsentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUserId = const Value.absent(),
                Value<ConsentType> type = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> grantedAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentsCompanion(
                id: id,
                ownerUserId: ownerUserId,
                type: type,
                version: version,
                grantedAt: grantedAt,
                revokedAt: revokedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String ownerUserId,
                required ConsentType type,
                required int version,
                required DateTime grantedAt,
                Value<DateTime?> revokedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentsCompanion.insert(
                id: id,
                ownerUserId: ownerUserId,
                type: type,
                version: version,
                grantedAt: grantedAt,
                revokedAt: revokedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConsentsTable, ConsentRow>(table),
                  BaseReferences<_$AppDatabase, $ConsentsTable, ConsentRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsentsTable,
      ConsentRow,
      $$ConsentsTableFilterComposer,
      $$ConsentsTableOrderingComposer,
      $$ConsentsTableAnnotationComposer,
      $$ConsentsTableCreateCompanionBuilder,
      $$ConsentsTableUpdateCompanionBuilder,
      (ConsentRow, BaseReferences<_$AppDatabase, $ConsentsTable, ConsentRow>),
      ConsentRow,
      PrefetchHooks Function()
    >;
typedef $$ChatsTableCreateCompanionBuilder = ChatsCompanion Function({
  Value<String> id,
  required String profileId,
  required String serverId,
  Value<String?> title,
  required DateTime createdAt,
  required DateTime fetchedAt,
  Value<DateTime?> historyFetchedAt,
  Value<int> rowid,
});
typedef $$ChatsTableUpdateCompanionBuilder = ChatsCompanion Function({
  Value<String> id,
  Value<String> profileId,
  Value<String> serverId,
  Value<String?> title,
  Value<DateTime> createdAt,
  Value<DateTime> fetchedAt,
  Value<DateTime?> historyFetchedAt,
  Value<int> rowid,
});

final class $$ChatsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatsTable, ChatRow> {
  $$ChatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('chats__profile_id__profile__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<MessageRow>>
  _messagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'chats__id__messages__chat_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatsTableFilterComposer extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get historyFetchedAt => $composableBuilder(
    column: $table.historyFetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get historyFetchedAt => $composableBuilder(
    column: $table.historyFetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get historyFetchedAt => $composableBuilder(
    column: $table.historyFetchedAt,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatsTable,
          ChatRow,
          $$ChatsTableFilterComposer,
          $$ChatsTableOrderingComposer,
          $$ChatsTableAnnotationComposer,
          $$ChatsTableCreateCompanionBuilder,
          $$ChatsTableUpdateCompanionBuilder,
          (ChatRow, $$ChatsTableReferences),
          ChatRow,
          PrefetchHooks Function({bool profileId, bool messagesRefs})
        > {
  $$ChatsTableTableManager(_$AppDatabase db, $ChatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<DateTime?> historyFetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatsCompanion(
                id: id,
                profileId: profileId,
                serverId: serverId,
                title: title,
                createdAt: createdAt,
                fetchedAt: fetchedAt,
                historyFetchedAt: historyFetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String profileId,
                required String serverId,
                Value<String?> title = const Value.absent(),
                required DateTime createdAt,
                required DateTime fetchedAt,
                Value<DateTime?> historyFetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatsCompanion.insert(
                id: id,
                profileId: profileId,
                serverId: serverId,
                title: title,
                createdAt: createdAt,
                fetchedAt: fetchedAt,
                historyFetchedAt: historyFetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatsTable, ChatRow>(table),
                  $$ChatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, messagesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (messagesRefs) db.messages],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$ChatsTableReferences._profileIdTable(
                          db,
                        ),
                        referencedColumn: $$ChatsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedDataByColumns<
                      ChatRow,
                      $ChatsTable,
                      MessageRow,
                      $MessagesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ChatsTableReferences
                          ._messagesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChatsTableReferences(db, table, p0).messagesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'chat_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatsTable,
      ChatRow,
      $$ChatsTableFilterComposer,
      $$ChatsTableOrderingComposer,
      $$ChatsTableAnnotationComposer,
      $$ChatsTableCreateCompanionBuilder,
      $$ChatsTableUpdateCompanionBuilder,
      (ChatRow, $$ChatsTableReferences),
      ChatRow,
      PrefetchHooks Function({bool profileId, bool messagesRefs})
    >;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  required String chatId,
  required int position,
  required MessageRole role,
  required String body,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> chatId,
  Value<int> position,
  Value<MessageRole> role,
  Value<String> body,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, MessageRow> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) =>
      db.chats.createAlias('messages__chat_id__chats__id');

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<String>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ClinicsTable, List<ClinicRow>> _clinicsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.clinics,
    aliasName: 'messages__id__clinics__message_id',
  );

  $$ClinicsTableProcessedTableManager get clinicsRefs {
    final manager = $$ClinicsTableTableManager(
      $_db,
      $_db.clinics,
    ).filter((f) => f.messageId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_clinicsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MessageRole, MessageRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> clinicsRefs(
    Expression<bool> Function($$ClinicsTableFilterComposer f) f,
  ) {
    final $$ClinicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clinics,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClinicsTableFilterComposer(
            $db: $db,
            $table: $db.clinics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> clinicsRefs<T extends Object>(
    Expression<T> Function($$ClinicsTableAnnotationComposer a) f,
  ) {
    final $$ClinicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.clinics,
      getReferencedColumn: (t) => t.messageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClinicsTableAnnotationComposer(
            $db: $db,
            $table: $db.clinics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          MessageRow,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (MessageRow, $$MessagesTableReferences),
          MessageRow,
          PrefetchHooks Function({bool chatId, bool clinicsRefs})
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chatId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<MessageRole> role = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                chatId: chatId,
                position: position,
                role: role,
                body: body,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String chatId,
                required int position,
                required MessageRole role,
                required String body,
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                chatId: chatId,
                position: position,
                role: role,
                body: body,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, MessageRow>(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false, clinicsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (clinicsRefs) db.clinics],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chatId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.chatId,
                        referencedTable: $$MessagesTableReferences._chatIdTable(
                          db,
                        ),
                        referencedColumn: $$MessagesTableReferences
                            ._chatIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (clinicsRefs)
                    await $_getPrefetchedDataByColumns<
                      MessageRow,
                      $MessagesTable,
                      ClinicRow,
                      $ClinicsTable
                    >(
                      currentTable: table,
                      referencedTable: $$MessagesTableReferences
                          ._clinicsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MessagesTableReferences(db, table, p0).clinicsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'message_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      MessageRow,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (MessageRow, $$MessagesTableReferences),
      MessageRow,
      PrefetchHooks Function({bool chatId, bool clinicsRefs})
    >;
typedef $$ClinicsTableCreateCompanionBuilder = ClinicsCompanion Function({
  Value<String> id,
  required String messageId,
  required int position,
  required String name,
  required String speciality,
  required String address,
  required String url,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> additionalInfo,
  Value<int> rowid,
});
typedef $$ClinicsTableUpdateCompanionBuilder = ClinicsCompanion Function({
  Value<String> id,
  Value<String> messageId,
  Value<int> position,
  Value<String> name,
  Value<String> speciality,
  Value<String> address,
  Value<String> url,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> additionalInfo,
  Value<int> rowid,
});

final class $$ClinicsTableReferences
    extends BaseReferences<_$AppDatabase, $ClinicsTable, ClinicRow> {
  $$ClinicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MessagesTable _messageIdTable(_$AppDatabase db) =>
      db.messages.createAlias('clinics__message_id__messages__id');

  $$MessagesTableProcessedTableManager get messageId {
    final $_column = $_itemColumn<String>('message_id')!;

    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_messageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ClinicsTableFilterComposer
    extends Composer<_$AppDatabase, $ClinicsTable> {
  $$ClinicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speciality => $composableBuilder(
    column: $table.speciality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get additionalInfo => $composableBuilder(
    column: $table.additionalInfo,
    builder: (column) => ColumnFilters(column),
  );

  $$MessagesTableFilterComposer get messageId {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClinicsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClinicsTable> {
  $$ClinicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speciality => $composableBuilder(
    column: $table.speciality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get additionalInfo => $composableBuilder(
    column: $table.additionalInfo,
    builder: (column) => ColumnOrderings(column),
  );

  $$MessagesTableOrderingComposer get messageId {
    final $$MessagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableOrderingComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClinicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClinicsTable> {
  $$ClinicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get speciality => $composableBuilder(
    column: $table.speciality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get additionalInfo => $composableBuilder(
    column: $table.additionalInfo,
    builder: (column) => column,
  );

  $$MessagesTableAnnotationComposer get messageId {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.messageId,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ClinicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClinicsTable,
          ClinicRow,
          $$ClinicsTableFilterComposer,
          $$ClinicsTableOrderingComposer,
          $$ClinicsTableAnnotationComposer,
          $$ClinicsTableCreateCompanionBuilder,
          $$ClinicsTableUpdateCompanionBuilder,
          (ClinicRow, $$ClinicsTableReferences),
          ClinicRow,
          PrefetchHooks Function({bool messageId})
        > {
  $$ClinicsTableTableManager(_$AppDatabase db, $ClinicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClinicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClinicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClinicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> speciality = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> additionalInfo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClinicsCompanion(
                id: id,
                messageId: messageId,
                position: position,
                name: name,
                speciality: speciality,
                address: address,
                url: url,
                phone: phone,
                email: email,
                additionalInfo: additionalInfo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String messageId,
                required int position,
                required String name,
                required String speciality,
                required String address,
                required String url,
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> additionalInfo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClinicsCompanion.insert(
                id: id,
                messageId: messageId,
                position: position,
                name: name,
                speciality: speciality,
                address: address,
                url: url,
                phone: phone,
                email: email,
                additionalInfo: additionalInfo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClinicsTable, ClinicRow>(table),
                  $$ClinicsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({messageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (messageId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.messageId,
                        referencedTable: $$ClinicsTableReferences
                            ._messageIdTable(db),
                        referencedColumn: $$ClinicsTableReferences
                            ._messageIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ClinicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClinicsTable,
      ClinicRow,
      $$ClinicsTableFilterComposer,
      $$ClinicsTableOrderingComposer,
      $$ClinicsTableAnnotationComposer,
      $$ClinicsTableCreateCompanionBuilder,
      $$ClinicsTableUpdateCompanionBuilder,
      (ClinicRow, $$ClinicsTableReferences),
      ClinicRow,
      PrefetchHooks Function({bool messageId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$PersonalInfosTableTableManager get personalInfos =>
      $$PersonalInfosTableTableManager(_db, _db.personalInfos);
  $$MedicalCardsTableTableManager get medicalCards =>
      $$MedicalCardsTableTableManager(_db, _db.medicalCards);
  $$ChronicConditionsTableTableManager get chronicConditions =>
      $$ChronicConditionsTableTableManager(_db, _db.chronicConditions);
  $$AllergiesTableTableManager get allergies =>
      $$AllergiesTableTableManager(_db, _db.allergies);
  $$ImplantsTableTableManager get implants =>
      $$ImplantsTableTableManager(_db, _db.implants);
  $$SurgeriesTableTableManager get surgeries =>
      $$SurgeriesTableTableManager(_db, _db.surgeries);
  $$EmergencyContactsTableTableManager get emergencyContacts =>
      $$EmergencyContactsTableTableManager(_db, _db.emergencyContacts);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$ConsentsTableTableManager get consents =>
      $$ConsentsTableTableManager(_db, _db.consents);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$ClinicsTableTableManager get clinics =>
      $$ClinicsTableTableManager(_db, _db.clinics);
}
