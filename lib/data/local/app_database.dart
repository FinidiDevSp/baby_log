import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'baby_log.sqlite'));
    return NativeDatabase.createInBackground(file);
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

@DriftDatabase(tables: [BabyProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
}
