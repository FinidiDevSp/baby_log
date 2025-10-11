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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BabyProfilesTable babyProfiles = $BabyProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [babyProfiles];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BabyProfilesTableTableManager get babyProfiles =>
      $$BabyProfilesTableTableManager(_db, _db.babyProfiles);
}
