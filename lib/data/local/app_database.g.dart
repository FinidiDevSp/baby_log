// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BabyProfilesTable extends BabyProfiles
    with TableInfo<$BabyProfilesTable, BabyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BabyProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthTimeMinutesMeta = const VerificationMeta(
    'birthTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> birthTimeMinutes = GeneratedColumn<int>(
    'birth_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthWeightKgMeta = const VerificationMeta(
    'birthWeightKg',
  );
  @override
  late final GeneratedColumn<double> birthWeightKg = GeneratedColumn<double>(
    'birth_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthLengthCmMeta = const VerificationMeta(
    'birthLengthCm',
  );
  @override
  late final GeneratedColumn<double> birthLengthCm = GeneratedColumn<double>(
    'birth_length_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accentColorValueMeta = const VerificationMeta(
    'accentColorValue',
  );
  @override
  late final GeneratedColumn<int> accentColorValue = GeneratedColumn<int>(
    'accent_color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
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
    clientDefault: () => DateTime.now(),
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
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    gender,
    birthDate,
    birthTimeMinutes,
    birthWeightKg,
    birthLengthCm,
    accentColorValue,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baby_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BabyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('birth_time_minutes')) {
      context.handle(
        _birthTimeMinutesMeta,
        birthTimeMinutes.isAcceptableOrUnknown(
          data['birth_time_minutes']!,
          _birthTimeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_birthTimeMinutesMeta);
    }
    if (data.containsKey('birth_weight_kg')) {
      context.handle(
        _birthWeightKgMeta,
        birthWeightKg.isAcceptableOrUnknown(
          data['birth_weight_kg']!,
          _birthWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('birth_length_cm')) {
      context.handle(
        _birthLengthCmMeta,
        birthLengthCm.isAcceptableOrUnknown(
          data['birth_length_cm']!,
          _birthLengthCmMeta,
        ),
      );
    }
    if (data.containsKey('accent_color_value')) {
      context.handle(
        _accentColorValueMeta,
        accentColorValue.isAcceptableOrUnknown(
          data['accent_color_value']!,
          _accentColorValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accentColorValueMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BabyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BabyRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gender'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      birthTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_time_minutes'],
      )!,
      birthWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_weight_kg'],
      ),
      birthLengthCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_length_cm'],
      ),
      accentColorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accent_color_value'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BabyProfilesTable createAlias(String alias) {
    return $BabyProfilesTable(attachedDatabase, alias);
  }
}

class BabyRow extends DataClass implements Insertable<BabyRow> {
  final int id;
  final String name;
  final int gender;
  final DateTime birthDate;
  final int birthTimeMinutes;
  final double? birthWeightKg;
  final double? birthLengthCm;
  final int accentColorValue;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BabyRow({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.birthTimeMinutes,
    this.birthWeightKg,
    this.birthLengthCm,
    required this.accentColorValue,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['gender'] = Variable<int>(gender);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['birth_time_minutes'] = Variable<int>(birthTimeMinutes);
    if (!nullToAbsent || birthWeightKg != null) {
      map['birth_weight_kg'] = Variable<double>(birthWeightKg);
    }
    if (!nullToAbsent || birthLengthCm != null) {
      map['birth_length_cm'] = Variable<double>(birthLengthCm);
    }
    map['accent_color_value'] = Variable<int>(accentColorValue);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BabyProfilesCompanion toCompanion(bool nullToAbsent) {
    return BabyProfilesCompanion(
      id: Value(id),
      name: Value(name),
      gender: Value(gender),
      birthDate: Value(birthDate),
      birthTimeMinutes: Value(birthTimeMinutes),
      birthWeightKg: birthWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(birthWeightKg),
      birthLengthCm: birthLengthCm == null && nullToAbsent
          ? const Value.absent()
          : Value(birthLengthCm),
      accentColorValue: Value(accentColorValue),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BabyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BabyRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gender: serializer.fromJson<int>(json['gender']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      birthTimeMinutes: serializer.fromJson<int>(json['birthTimeMinutes']),
      birthWeightKg: serializer.fromJson<double?>(json['birthWeightKg']),
      birthLengthCm: serializer.fromJson<double?>(json['birthLengthCm']),
      accentColorValue: serializer.fromJson<int>(json['accentColorValue']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gender': serializer.toJson<int>(gender),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'birthTimeMinutes': serializer.toJson<int>(birthTimeMinutes),
      'birthWeightKg': serializer.toJson<double?>(birthWeightKg),
      'birthLengthCm': serializer.toJson<double?>(birthLengthCm),
      'accentColorValue': serializer.toJson<int>(accentColorValue),
      'photoPath': serializer.toJson<String?>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BabyRow copyWith({
    int? id,
    String? name,
    int? gender,
    DateTime? birthDate,
    int? birthTimeMinutes,
    Value<double?> birthWeightKg = const Value.absent(),
    Value<double?> birthLengthCm = const Value.absent(),
    int? accentColorValue,
    Value<String?> photoPath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BabyRow(
    id: id ?? this.id,
    name: name ?? this.name,
    gender: gender ?? this.gender,
    birthDate: birthDate ?? this.birthDate,
    birthTimeMinutes: birthTimeMinutes ?? this.birthTimeMinutes,
    birthWeightKg: birthWeightKg.present
        ? birthWeightKg.value
        : this.birthWeightKg,
    birthLengthCm: birthLengthCm.present
        ? birthLengthCm.value
        : this.birthLengthCm,
    accentColorValue: accentColorValue ?? this.accentColorValue,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BabyRow copyWithCompanion(BabyProfilesCompanion data) {
    return BabyRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      birthTimeMinutes: data.birthTimeMinutes.present
          ? data.birthTimeMinutes.value
          : this.birthTimeMinutes,
      birthWeightKg: data.birthWeightKg.present
          ? data.birthWeightKg.value
          : this.birthWeightKg,
      birthLengthCm: data.birthLengthCm.present
          ? data.birthLengthCm.value
          : this.birthLengthCm,
      accentColorValue: data.accentColorValue.present
          ? data.accentColorValue.value
          : this.accentColorValue,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BabyRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthTimeMinutes: $birthTimeMinutes, ')
          ..write('birthWeightKg: $birthWeightKg, ')
          ..write('birthLengthCm: $birthLengthCm, ')
          ..write('accentColorValue: $accentColorValue, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    gender,
    birthDate,
    birthTimeMinutes,
    birthWeightKg,
    birthLengthCm,
    accentColorValue,
    photoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BabyRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.gender == this.gender &&
          other.birthDate == this.birthDate &&
          other.birthTimeMinutes == this.birthTimeMinutes &&
          other.birthWeightKg == this.birthWeightKg &&
          other.birthLengthCm == this.birthLengthCm &&
          other.accentColorValue == this.accentColorValue &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BabyProfilesCompanion extends UpdateCompanion<BabyRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> gender;
  final Value<DateTime> birthDate;
  final Value<int> birthTimeMinutes;
  final Value<double?> birthWeightKg;
  final Value<double?> birthLengthCm;
  final Value<int> accentColorValue;
  final Value<String?> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BabyProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthTimeMinutes = const Value.absent(),
    this.birthWeightKg = const Value.absent(),
    this.birthLengthCm = const Value.absent(),
    this.accentColorValue = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BabyProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int gender,
    required DateTime birthDate,
    required int birthTimeMinutes,
    this.birthWeightKg = const Value.absent(),
    this.birthLengthCm = const Value.absent(),
    required int accentColorValue,
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       gender = Value(gender),
       birthDate = Value(birthDate),
       birthTimeMinutes = Value(birthTimeMinutes),
       accentColorValue = Value(accentColorValue);
  static Insertable<BabyRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? gender,
    Expression<DateTime>? birthDate,
    Expression<int>? birthTimeMinutes,
    Expression<double>? birthWeightKg,
    Expression<double>? birthLengthCm,
    Expression<int>? accentColorValue,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (birthTimeMinutes != null) 'birth_time_minutes': birthTimeMinutes,
      if (birthWeightKg != null) 'birth_weight_kg': birthWeightKg,
      if (birthLengthCm != null) 'birth_length_cm': birthLengthCm,
      if (accentColorValue != null) 'accent_color_value': accentColorValue,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BabyProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? gender,
    Value<DateTime>? birthDate,
    Value<int>? birthTimeMinutes,
    Value<double?>? birthWeightKg,
    Value<double?>? birthLengthCm,
    Value<int>? accentColorValue,
    Value<String?>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BabyProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthTimeMinutes: birthTimeMinutes ?? this.birthTimeMinutes,
      birthWeightKg: birthWeightKg ?? this.birthWeightKg,
      birthLengthCm: birthLengthCm ?? this.birthLengthCm,
      accentColorValue: accentColorValue ?? this.accentColorValue,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (birthTimeMinutes.present) {
      map['birth_time_minutes'] = Variable<int>(birthTimeMinutes.value);
    }
    if (birthWeightKg.present) {
      map['birth_weight_kg'] = Variable<double>(birthWeightKg.value);
    }
    if (birthLengthCm.present) {
      map['birth_length_cm'] = Variable<double>(birthLengthCm.value);
    }
    if (accentColorValue.present) {
      map['accent_color_value'] = Variable<int>(accentColorValue.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BabyProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthTimeMinutes: $birthTimeMinutes, ')
          ..write('birthWeightKg: $birthWeightKg, ')
          ..write('birthLengthCm: $birthLengthCm, ')
          ..write('accentColorValue: $accentColorValue, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BottleFeedingsTable extends BottleFeedings
    with TableInfo<$BottleFeedingsTable, BottleFeedingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BottleFeedingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    amountMl,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bottle_feedings';
  @override
  VerificationContext validateIntegrity(
    Insertable<BottleFeedingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BottleFeedingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BottleFeedingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BottleFeedingsTable createAlias(String alias) {
    return $BottleFeedingsTable(attachedDatabase, alias);
  }
}

class BottleFeedingRow extends DataClass
    implements Insertable<BottleFeedingRow> {
  final int id;
  final DateTime timestamp;
  final int amountMl;
  final String? notes;
  final DateTime createdAt;
  const BottleFeedingRow({
    required this.id,
    required this.timestamp,
    required this.amountMl,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['amount_ml'] = Variable<int>(amountMl);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BottleFeedingsCompanion toCompanion(bool nullToAbsent) {
    return BottleFeedingsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      amountMl: Value(amountMl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory BottleFeedingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BottleFeedingRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'amountMl': serializer.toJson<int>(amountMl),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BottleFeedingRow copyWith({
    int? id,
    DateTime? timestamp,
    int? amountMl,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => BottleFeedingRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    amountMl: amountMl ?? this.amountMl,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  BottleFeedingRow copyWithCompanion(BottleFeedingsCompanion data) {
    return BottleFeedingRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BottleFeedingRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('amountMl: $amountMl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, amountMl, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BottleFeedingRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.amountMl == this.amountMl &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class BottleFeedingsCompanion extends UpdateCompanion<BottleFeedingRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> amountMl;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const BottleFeedingsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BottleFeedingsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int amountMl,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : timestamp = Value(timestamp),
       amountMl = Value(amountMl);
  static Insertable<BottleFeedingRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? amountMl,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (amountMl != null) 'amount_ml': amountMl,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BottleFeedingsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? amountMl,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return BottleFeedingsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      amountMl: amountMl ?? this.amountMl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BottleFeedingsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('amountMl: $amountMl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StoolEntriesTable extends StoolEntries
    with TableInfo<$StoolEntriesTable, StoolEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoolEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consistencyMeta = const VerificationMeta(
    'consistency',
  );
  @override
  late final GeneratedColumn<int> consistency = GeneratedColumn<int>(
    'consistency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    consistency,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stool_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoolEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('consistency')) {
      context.handle(
        _consistencyMeta,
        consistency.isAcceptableOrUnknown(
          data['consistency']!,
          _consistencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consistencyMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoolEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoolEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      consistency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consistency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoolEntriesTable createAlias(String alias) {
    return $StoolEntriesTable(attachedDatabase, alias);
  }
}

class StoolEntryRow extends DataClass implements Insertable<StoolEntryRow> {
  final int id;
  final DateTime timestamp;
  final int consistency;
  final String? notes;
  final DateTime createdAt;
  const StoolEntryRow({
    required this.id,
    required this.timestamp,
    required this.consistency,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['consistency'] = Variable<int>(consistency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StoolEntriesCompanion toCompanion(bool nullToAbsent) {
    return StoolEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      consistency: Value(consistency),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory StoolEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoolEntryRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      consistency: serializer.fromJson<int>(json['consistency']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'consistency': serializer.toJson<int>(consistency),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StoolEntryRow copyWith({
    int? id,
    DateTime? timestamp,
    int? consistency,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => StoolEntryRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    consistency: consistency ?? this.consistency,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  StoolEntryRow copyWithCompanion(StoolEntriesCompanion data) {
    return StoolEntryRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      consistency: data.consistency.present
          ? data.consistency.value
          : this.consistency,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoolEntryRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('consistency: $consistency, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, consistency, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoolEntryRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.consistency == this.consistency &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class StoolEntriesCompanion extends UpdateCompanion<StoolEntryRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> consistency;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const StoolEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.consistency = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StoolEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int consistency,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : timestamp = Value(timestamp),
       consistency = Value(consistency);
  static Insertable<StoolEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? consistency,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (consistency != null) 'consistency': consistency,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StoolEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? consistency,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return StoolEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      consistency: consistency ?? this.consistency,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (consistency.present) {
      map['consistency'] = Variable<int>(consistency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoolEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('consistency: $consistency, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VomitEntriesTable extends VomitEntries
    with TableInfo<$VomitEntriesTable, VomitEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VomitEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    amount,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vomit_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<VomitEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VomitEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VomitEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VomitEntriesTable createAlias(String alias) {
    return $VomitEntriesTable(attachedDatabase, alias);
  }
}

class VomitEntryRow extends DataClass implements Insertable<VomitEntryRow> {
  final int id;
  final DateTime timestamp;
  final int amount;
  final String? notes;
  final DateTime createdAt;
  const VomitEntryRow({
    required this.id,
    required this.timestamp,
    required this.amount,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{
      'id': Variable<int>(id),
      'timestamp': Variable<DateTime>(timestamp),
      'amount': Variable<int>(amount),
      'created_at': Variable<DateTime>(createdAt),
    };
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  VomitEntriesCompanion toCompanion(bool nullToAbsent) {
    return VomitEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      amount: Value(amount),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory VomitEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VomitEntryRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      amount: serializer.fromJson<int>(json['amount']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'amount': serializer.toJson<int>(amount),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VomitEntryRow copyWith({
    int? id,
    DateTime? timestamp,
    int? amount,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => VomitEntryRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    amount: amount ?? this.amount,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  VomitEntryRow copyWithCompanion(VomitEntriesCompanion data) {
    return VomitEntryRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      amount: data.amount.present ? data.amount.value : this.amount,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VomitEntryRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('amount: $amount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, amount, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VomitEntryRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.amount == this.amount &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class VomitEntriesCompanion extends UpdateCompanion<VomitEntryRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> amount;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const VomitEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.amount = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VomitEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int amount,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : timestamp = Value(timestamp),
       amount = Value(amount);
  static Insertable<VomitEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? amount,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (amount != null) 'amount': amount,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VomitEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? amount,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return VomitEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VomitEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('amount: $amount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BathEntriesTable extends BathEntries
    with TableInfo<$BathEntriesTable, BathEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BathEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [id, timestamp, type, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bath_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<BathEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BathEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BathEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BathEntriesTable createAlias(String alias) {
    return $BathEntriesTable(attachedDatabase, alias);
  }
}

class BathEntryRow extends DataClass implements Insertable<BathEntryRow> {
  final int id;
  final DateTime timestamp;
  final int type;
  final String? notes;
  final DateTime createdAt;
  const BathEntryRow({
    required this.id,
    required this.timestamp,
    required this.type,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['type'] = Variable<int>(type);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BathEntriesCompanion toCompanion(bool nullToAbsent) {
    return BathEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      type: Value(type),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory BathEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BathEntryRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      type: serializer.fromJson<int>(json['type']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'type': serializer.toJson<int>(type),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BathEntryRow copyWith({
    int? id,
    DateTime? timestamp,
    int? type,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => BathEntryRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    type: type ?? this.type,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  BathEntryRow copyWithCompanion(BathEntriesCompanion data) {
    return BathEntryRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      type: data.type.present ? data.type.value : this.type,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BathEntryRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, type, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BathEntryRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.type == this.type &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class BathEntriesCompanion extends UpdateCompanion<BathEntryRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> type;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const BathEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.type = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BathEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int type,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : timestamp = Value(timestamp),
       type = Value(type);
  static Insertable<BathEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? type,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BathEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? type,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return BathEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BathEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BabyProfilesTable babyProfiles = $BabyProfilesTable(this);
  late final $BottleFeedingsTable bottleFeedings = $BottleFeedingsTable(this);
  late final $StoolEntriesTable stoolEntries = $StoolEntriesTable(this);
  late final $VomitEntriesTable vomitEntries = $VomitEntriesTable(this);
  late final $BathEntriesTable bathEntries = $BathEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    babyProfiles,
    bottleFeedings,
    stoolEntries,
    vomitEntries,
    bathEntries,
  ];
}

typedef $$BabyProfilesTableCreateCompanionBuilder =
    BabyProfilesCompanion Function({
      Value<int> id,
      required String name,
      required int gender,
      required DateTime birthDate,
      required int birthTimeMinutes,
      Value<double?> birthWeightKg,
      Value<double?> birthLengthCm,
      required int accentColorValue,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$BabyProfilesTableUpdateCompanionBuilder =
    BabyProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> gender,
      Value<DateTime> birthDate,
      Value<int> birthTimeMinutes,
      Value<double?> birthWeightKg,
      Value<double?> birthLengthCm,
      Value<int> accentColorValue,
      Value<String?> photoPath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BabyProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BabyProfilesTable> {
  $$BabyProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthTimeMinutes => $composableBuilder(
    column: $table.birthTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthLengthCm => $composableBuilder(
    column: $table.birthLengthCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accentColorValue => $composableBuilder(
    column: $table.accentColorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
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
}

class $$BabyProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BabyProfilesTable> {
  $$BabyProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthTimeMinutes => $composableBuilder(
    column: $table.birthTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthLengthCm => $composableBuilder(
    column: $table.birthLengthCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accentColorValue => $composableBuilder(
    column: $table.accentColorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
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
}

class $$BabyProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BabyProfilesTable> {
  $$BabyProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<int> get birthTimeMinutes => $composableBuilder(
    column: $table.birthTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get birthLengthCm => $composableBuilder(
    column: $table.birthLengthCm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accentColorValue => $composableBuilder(
    column: $table.accentColorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BabyProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BabyProfilesTable,
          BabyRow,
          $$BabyProfilesTableFilterComposer,
          $$BabyProfilesTableOrderingComposer,
          $$BabyProfilesTableAnnotationComposer,
          $$BabyProfilesTableCreateCompanionBuilder,
          $$BabyProfilesTableUpdateCompanionBuilder,
          (BabyRow, BaseReferences<_$AppDatabase, $BabyProfilesTable, BabyRow>),
          BabyRow,
          PrefetchHooks Function()
        > {
  $$BabyProfilesTableTableManager(_$AppDatabase db, $BabyProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BabyProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BabyProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BabyProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> gender = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<int> birthTimeMinutes = const Value.absent(),
                Value<double?> birthWeightKg = const Value.absent(),
                Value<double?> birthLengthCm = const Value.absent(),
                Value<int> accentColorValue = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BabyProfilesCompanion(
                id: id,
                name: name,
                gender: gender,
                birthDate: birthDate,
                birthTimeMinutes: birthTimeMinutes,
                birthWeightKg: birthWeightKg,
                birthLengthCm: birthLengthCm,
                accentColorValue: accentColorValue,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int gender,
                required DateTime birthDate,
                required int birthTimeMinutes,
                Value<double?> birthWeightKg = const Value.absent(),
                Value<double?> birthLengthCm = const Value.absent(),
                required int accentColorValue,
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BabyProfilesCompanion.insert(
                id: id,
                name: name,
                gender: gender,
                birthDate: birthDate,
                birthTimeMinutes: birthTimeMinutes,
                birthWeightKg: birthWeightKg,
                birthLengthCm: birthLengthCm,
                accentColorValue: accentColorValue,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BabyProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BabyProfilesTable,
      BabyRow,
      $$BabyProfilesTableFilterComposer,
      $$BabyProfilesTableOrderingComposer,
      $$BabyProfilesTableAnnotationComposer,
      $$BabyProfilesTableCreateCompanionBuilder,
      $$BabyProfilesTableUpdateCompanionBuilder,
      (BabyRow, BaseReferences<_$AppDatabase, $BabyProfilesTable, BabyRow>),
      BabyRow,
      PrefetchHooks Function()
    >;
typedef $$BottleFeedingsTableCreateCompanionBuilder =
    BottleFeedingsCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int amountMl,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$BottleFeedingsTableUpdateCompanionBuilder =
    BottleFeedingsCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> amountMl,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$BottleFeedingsTableFilterComposer
    extends Composer<_$AppDatabase, $BottleFeedingsTable> {
  $$BottleFeedingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BottleFeedingsTableOrderingComposer
    extends Composer<_$AppDatabase, $BottleFeedingsTable> {
  $$BottleFeedingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BottleFeedingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BottleFeedingsTable> {
  $$BottleFeedingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BottleFeedingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BottleFeedingsTable,
          BottleFeedingRow,
          $$BottleFeedingsTableFilterComposer,
          $$BottleFeedingsTableOrderingComposer,
          $$BottleFeedingsTableAnnotationComposer,
          $$BottleFeedingsTableCreateCompanionBuilder,
          $$BottleFeedingsTableUpdateCompanionBuilder,
          (
            BottleFeedingRow,
            BaseReferences<
              _$AppDatabase,
              $BottleFeedingsTable,
              BottleFeedingRow
            >,
          ),
          BottleFeedingRow,
          PrefetchHooks Function()
        > {
  $$BottleFeedingsTableTableManager(
    _$AppDatabase db,
    $BottleFeedingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BottleFeedingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BottleFeedingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BottleFeedingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> amountMl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BottleFeedingsCompanion(
                id: id,
                timestamp: timestamp,
                amountMl: amountMl,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int amountMl,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BottleFeedingsCompanion.insert(
                id: id,
                timestamp: timestamp,
                amountMl: amountMl,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BottleFeedingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BottleFeedingsTable,
      BottleFeedingRow,
      $$BottleFeedingsTableFilterComposer,
      $$BottleFeedingsTableOrderingComposer,
      $$BottleFeedingsTableAnnotationComposer,
      $$BottleFeedingsTableCreateCompanionBuilder,
      $$BottleFeedingsTableUpdateCompanionBuilder,
      (
        BottleFeedingRow,
        BaseReferences<_$AppDatabase, $BottleFeedingsTable, BottleFeedingRow>,
      ),
      BottleFeedingRow,
      PrefetchHooks Function()
    >;
typedef $$StoolEntriesTableCreateCompanionBuilder =
    StoolEntriesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int consistency,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$StoolEntriesTableUpdateCompanionBuilder =
    StoolEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> consistency,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

typedef $$VomitEntriesTableCreateCompanionBuilder =
    VomitEntriesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int amount,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$VomitEntriesTableUpdateCompanionBuilder =
    VomitEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> amount,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$StoolEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoolEntriesTable> {
  $$StoolEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consistency => $composableBuilder(
    column: $table.consistency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoolEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoolEntriesTable> {
  $$StoolEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consistency => $composableBuilder(
    column: $table.consistency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoolEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoolEntriesTable> {
  $$StoolEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get consistency => $composableBuilder(
    column: $table.consistency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StoolEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoolEntriesTable,
          StoolEntryRow,
          $$StoolEntriesTableFilterComposer,
          $$StoolEntriesTableOrderingComposer,
          $$StoolEntriesTableAnnotationComposer,
          $$StoolEntriesTableCreateCompanionBuilder,
          $$StoolEntriesTableUpdateCompanionBuilder,
          (
            StoolEntryRow,
            BaseReferences<_$AppDatabase, $StoolEntriesTable, StoolEntryRow>,
          ),
          StoolEntryRow,
          PrefetchHooks Function()
        > {
  $$StoolEntriesTableTableManager(_$AppDatabase db, $StoolEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoolEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoolEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoolEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> consistency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StoolEntriesCompanion(
                id: id,
                timestamp: timestamp,
                consistency: consistency,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int consistency,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StoolEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                consistency: consistency,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoolEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoolEntriesTable,
      StoolEntryRow,
      $$StoolEntriesTableFilterComposer,
      $$StoolEntriesTableOrderingComposer,
      $$StoolEntriesTableAnnotationComposer,
      $$StoolEntriesTableCreateCompanionBuilder,
      $$StoolEntriesTableUpdateCompanionBuilder,
      (
        StoolEntryRow,
        BaseReferences<_$AppDatabase, $StoolEntriesTable, StoolEntryRow>,
      ),
      StoolEntryRow,
      PrefetchHooks Function()
    >;
class $$VomitEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $VomitEntriesTable> {
  $$VomitEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VomitEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $VomitEntriesTable> {
  $$VomitEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VomitEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VomitEntriesTable> {
  $$VomitEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VomitEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VomitEntriesTable,
          VomitEntryRow,
          $$VomitEntriesTableFilterComposer,
          $$VomitEntriesTableOrderingComposer,
          $$VomitEntriesTableAnnotationComposer,
          $$VomitEntriesTableCreateCompanionBuilder,
          $$VomitEntriesTableUpdateCompanionBuilder,
          (
            VomitEntryRow,
            BaseReferences<_$AppDatabase, $VomitEntriesTable, VomitEntryRow>,
          ),
          VomitEntryRow,
          PrefetchHooks Function()
        > {
  $$VomitEntriesTableTableManager(_$AppDatabase db, $VomitEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VomitEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VomitEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VomitEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VomitEntriesCompanion(
                id: id,
                timestamp: timestamp,
                amount: amount,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int amount,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VomitEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                amount: amount,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (results, base) => BaseReferences(
            $db: db,
            $table: table,
            referencingTable: base,
            results: results,
          ),
          prefetchHooksCallback: () => const PrefetchHooks(),
        ),
      );
}

typedef $$VomitEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VomitEntriesTable,
      VomitEntryRow,
      $$VomitEntriesTableFilterComposer,
      $$VomitEntriesTableOrderingComposer,
      $$VomitEntriesTableAnnotationComposer,
      $$VomitEntriesTableCreateCompanionBuilder,
      $$VomitEntriesTableUpdateCompanionBuilder,
      (
        VomitEntryRow,
        BaseReferences<_$AppDatabase, $VomitEntriesTable, VomitEntryRow>,
      ),
      VomitEntryRow,
      PrefetchHooks Function()
    >;

typedef $$BathEntriesTableCreateCompanionBuilder =
    BathEntriesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int type,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$BathEntriesTableUpdateCompanionBuilder =
    BathEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> type,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$BathEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $BathEntriesTable> {
  $$BathEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BathEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $BathEntriesTable> {
  $$BathEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BathEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BathEntriesTable> {
  $$BathEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BathEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BathEntriesTable,
          BathEntryRow,
          $$BathEntriesTableFilterComposer,
          $$BathEntriesTableOrderingComposer,
          $$BathEntriesTableAnnotationComposer,
          $$BathEntriesTableCreateCompanionBuilder,
          $$BathEntriesTableUpdateCompanionBuilder,
          (
            BathEntryRow,
            BaseReferences<_$AppDatabase, $BathEntriesTable, BathEntryRow>,
          ),
          BathEntryRow,
          PrefetchHooks Function()
        > {
  $$BathEntriesTableTableManager(_$AppDatabase db, $BathEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BathEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BathEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BathEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BathEntriesCompanion(
                id: id,
                timestamp: timestamp,
                type: type,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int type,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BathEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                type: type,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BathEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BathEntriesTable,
      BathEntryRow,
      $$BathEntriesTableFilterComposer,
      $$BathEntriesTableOrderingComposer,
      $$BathEntriesTableAnnotationComposer,
      $$BathEntriesTableCreateCompanionBuilder,
      $$BathEntriesTableUpdateCompanionBuilder,
      (
        BathEntryRow,
        BaseReferences<_$AppDatabase, $BathEntriesTable, BathEntryRow>,
      ),
      BathEntryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BabyProfilesTableTableManager get babyProfiles =>
      $$BabyProfilesTableTableManager(_db, _db.babyProfiles);
  $$BottleFeedingsTableTableManager get bottleFeedings =>
      $$BottleFeedingsTableTableManager(_db, _db.bottleFeedings);
  $$StoolEntriesTableTableManager get stoolEntries =>
      $$StoolEntriesTableTableManager(_db, _db.stoolEntries);
  $$VomitEntriesTableTableManager get vomitEntries =>
      $$VomitEntriesTableTableManager(_db, _db.vomitEntries);
  $$BathEntriesTableTableManager get bathEntries =>
      $$BathEntriesTableTableManager(_db, _db.bathEntries);
}
