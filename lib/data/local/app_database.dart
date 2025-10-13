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

@DriftDatabase(
  tables: [
    BabyProfiles,
    BottleFeedings,
    StoolEntries,
    VomitEntries,
    BathEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

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
}
