import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final resolvedPath = p.join(directory.path, 'baby_log.sqlite');
    final file = File(resolvedPath);

    await file.parent.create(recursive: true);

    // Avoid opening the database on a background isolate. Some Android
    // devices were crashing when the path_provider plugin was invoked from
    // Drift's background executor, so we initialize the database directly on
    // the main isolate instead.
    return NativeDatabase(file);
  });
}

@DataClassName('BabyRow')
class BabyProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get gender => integer()();
  DateTimeColumn get birthDate => dateTime()();
  IntColumn get birthTimeMinutes => integer()();
  RealColumn get birthWeightKg => real().nullable()();
  RealColumn get birthLengthCm => real().nullable()();
  IntColumn get accentColorValue => integer()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('BottleFeedingRow')
class BottleFeedings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get amountMl => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('StoolEntryRow')
class StoolEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get consistency => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('VomitEntryRow')
class VomitEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('BathEntryRow')
class BathEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get type => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('TemperatureEntryRow')
class TemperatureEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get valueCelsius => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('PediatricianQuestionRow')
class PediatricianQuestions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().withLength(min: 1, max: 500)();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
  IntColumn get satisfaction => integer().nullable()();
  TextColumn get resolutionNote => text().nullable()();
}

@DataClassName('MedicalAppointmentRow')
class MedicalAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  IntColumn get type => integer()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    BabyProfiles,
    BottleFeedings,
    StoolEntries,
    VomitEntries,
    BathEntries,
    TemperatureEntries,
    PediatricianQuestions,
    MedicalAppointments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(bottleFeedings);
        await m.createTable(stoolEntries);
      }
      if (from < 3) {
        await m.createTable(bathEntries);
      }
      if (from < 4) {
        await m.createTable(vomitEntries);
      }
      if (from < 5) {
        await m.createTable(temperatureEntries);
      }
      if (from < 7) {
        await m.addColumn(
          pediatricianQuestions,
          pediatricianQuestions.satisfaction,
        );
        await m.addColumn(
          pediatricianQuestions,
          pediatricianQuestions.resolutionNote,
        );
      }
      if (from < 6) {
        await m.createTable(pediatricianQuestions);
      }
      if (from < 8) {
        await m.createTable(medicalAppointments);
      }
    },
  );

  Stream<BabyRow?> watchBabyRow() {
    final query = select(babyProfiles)..limit(1);
    return query.watchSingleOrNull();
  }

  Future<BabyRow?> fetchBabyRow() {
    final query = select(babyProfiles)..limit(1);
    return query.getSingleOrNull();
  }

  Future<int> createBaby(BabyProfilesCompanion entry) {
    return into(babyProfiles).insert(entry);
  }

  Future<void> upsertBaby(BabyProfilesCompanion entry) {
    return into(babyProfiles).insertOnConflictUpdate(entry);
  }

  Stream<List<BottleFeedingRow>> watchBottleFeedings() {
    final query =
        (select(bottleFeedings)..orderBy([
              (tbl) => OrderingTerm.desc(tbl.timestamp),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
            .watch();
    return query;
  }

  Future<BottleFeedingRow> createBottleFeeding(
    BottleFeedingsCompanion entry,
  ) async {
    final id = await into(bottleFeedings).insert(entry);
    final query = select(bottleFeedings)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la toma recién creada.');
    }
    return row;
  }

  Future<BottleFeedingRow> updateBottleFeeding(
    int id,
    BottleFeedingsCompanion entry,
  ) async {
    await (update(
      bottleFeedings,
    )..where((tbl) => tbl.id.equals(id))).write(entry);
    final query = select(bottleFeedings)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la toma actualizada.');
    }
    return row;
  }

  Future<void> deleteBottleFeeding(int id) async {
    await (delete(bottleFeedings)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<StoolEntryRow>> watchStoolEntries() {
    final query =
        (select(stoolEntries)..orderBy([
              (tbl) => OrderingTerm.desc(tbl.timestamp),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
            .watch();
    return query;
  }

  Future<StoolEntryRow> createStoolEntry(StoolEntriesCompanion entry) async {
    final id = await into(stoolEntries).insert(entry);
    final query = select(stoolEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener el cambio de pañal recién creado.');
    }
    return row;
  }

  Future<StoolEntryRow> updateStoolEntry(
    int id,
    StoolEntriesCompanion entry,
  ) async {
    await (update(
      stoolEntries,
    )..where((tbl) => tbl.id.equals(id))).write(entry);
    final query = select(stoolEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener el cambio de pañal actualizado.');
    }
    return row;
  }

  Future<void> deleteStoolEntry(int id) async {
    await (delete(stoolEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<VomitEntryRow>> watchVomitEntries() {
    final query =
        (select(vomitEntries)..orderBy([
              (tbl) => OrderingTerm.desc(tbl.timestamp),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
            .watch();
    return query;
  }

  Future<VomitEntryRow> createVomitEntry(VomitEntriesCompanion entry) async {
    final id = await into(vomitEntries).insert(entry);
    final query = select(vomitEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener el vómito recién creado.');
    }
    return row;
  }

  Future<VomitEntryRow> updateVomitEntry(
    int id,
    VomitEntriesCompanion entry,
  ) async {
    await (update(
      vomitEntries,
    )..where((tbl) => tbl.id.equals(id))).write(entry);
    final query = select(vomitEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener el vómito actualizado.');
    }
    return row;
  }

  Future<void> deleteVomitEntry(int id) async {
    await (delete(vomitEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<BathEntryRow>> watchBathEntries() {
    final query =
        (select(bathEntries)..orderBy([
              (tbl) => OrderingTerm.desc(tbl.timestamp),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
            .watch();
    return query;
  }

  Future<BathEntryRow> createBathEntry(BathEntriesCompanion entry) async {
    final id = await into(bathEntries).insert(entry);
    final query = select(bathEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener el baño recién creado.');
    }
    return row;
  }

  Future<BathEntryRow> updateBathEntry(
    int id,
    BathEntriesCompanion entry,
  ) async {
    await (update(bathEntries)..where((tbl) => tbl.id.equals(id))).write(entry);
    final query = select(bathEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener el baño actualizado.');
    }
    return row;
  }

  Future<void> deleteBathEntry(int id) async {
    await (delete(bathEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<TemperatureEntryRow>> watchTemperatureEntries() {
    final query =
        (select(temperatureEntries)..orderBy([
              (tbl) => OrderingTerm.desc(tbl.timestamp),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
            .watch();
    return query;
  }

  Future<TemperatureEntryRow> createTemperatureEntry(
    TemperatureEntriesCompanion entry,
  ) async {
    final id = await into(temperatureEntries).insert(entry);
    final query = select(temperatureEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la temperatura recién creada.');
    }
    return row;
  }

  Future<TemperatureEntryRow> updateTemperatureEntry(
    int id,
    TemperatureEntriesCompanion entry,
  ) async {
    await (update(
      temperatureEntries,
    )..where((tbl) => tbl.id.equals(id))).write(entry);
    final query = select(temperatureEntries)..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la temperatura actualizada.');
    }
    return row;
  }

  Future<void> deleteTemperatureEntry(int id) async {
    await (delete(temperatureEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<PediatricianQuestionRow>> watchPediatricianQuestions() {
    final query =
        (select(pediatricianQuestions)..orderBy([
              (tbl) => OrderingTerm(expression: tbl.resolved),
              (tbl) => OrderingTerm.desc(tbl.createdAt),
              (tbl) => OrderingTerm.desc(tbl.id),
            ]))
            .watch();
    return query;
  }

  Future<PediatricianQuestionRow> createPediatricianQuestion(
    PediatricianQuestionsCompanion entry,
  ) async {
    final id = await into(pediatricianQuestions).insert(entry);
    final query = select(pediatricianQuestions)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la pregunta recién creada.');
    }
    return row;
  }

  Future<PediatricianQuestionRow> updatePediatricianQuestion(
    int id,
    PediatricianQuestionsCompanion entry,
  ) async {
    await (update(pediatricianQuestions)..where((tbl) => tbl.id.equals(id)))
        .write(entry.copyWith(updatedAt: Value(DateTime.now())));
    final query = select(pediatricianQuestions)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la pregunta actualizada.');
    }
    return row;
  }

  Future<void> deletePediatricianQuestion(int id) async {
    await (delete(
      pediatricianQuestions,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<MedicalAppointmentRow>> fetchMedicalAppointments() {
    final query = (select(medicalAppointments)
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.scheduledAt),
        (tbl) => OrderingTerm.asc(tbl.id),
      ]));
    return query.get();
  }

  Stream<List<MedicalAppointmentRow>> watchMedicalAppointments() {
    final query = (select(medicalAppointments)
      ..orderBy([
        (tbl) => OrderingTerm.asc(tbl.scheduledAt),
        (tbl) => OrderingTerm.asc(tbl.id),
      ]));
    return query.watch();
  }

  Future<MedicalAppointmentRow> createMedicalAppointment(
    MedicalAppointmentsCompanion entry,
  ) async {
    await into(medicalAppointments).insert(entry);
    final query = select(medicalAppointments)
      ..where((tbl) => tbl.id.equals(entry.id.value));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la cita médica recién creada.');
    }
    return row;
  }

  Future<MedicalAppointmentRow> updateMedicalAppointment(
    String id,
    MedicalAppointmentsCompanion entry,
  ) async {
    await (update(medicalAppointments)..where((tbl) => tbl.id.equals(id)))
        .write(entry.copyWith(updatedAt: Value(DateTime.now())));
    final query = select(medicalAppointments)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) {
      throw StateError('No se pudo obtener la cita médica actualizada.');
    }
    return row;
  }

  Future<void> deleteMedicalAppointment(String id) async {
    await (delete(medicalAppointments)..where((tbl) => tbl.id.equals(id))).go();
  }
}
