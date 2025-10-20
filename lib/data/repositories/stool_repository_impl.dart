import '../../domain/entities/stool_entry.dart';
import '../../domain/repositories/stool_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/stool_entry_mapper.dart';

class StoolRepositoryImpl implements StoolRepository {
  StoolRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<StoolEntry>> watchStools() {
    return _db.watchStoolEntries().map(
          (rows) => rows.map(mapStoolRowToDomain).toList(growable: false),
        );
  }

  @override
  Future<StoolEntry> addStool(StoolEntry entry) async {
    final companion = mapStoolToCompanion(entry);
    final row = await _db.createStoolEntry(companion);
    return mapStoolRowToDomain(row);
  }

  @override
  Future<StoolEntry> updateStool(StoolEntry entry) async {
    final id = entry.id;
    if (id == null) {
      throw ArgumentError('Cannot update a stool entry without an id.');
    }
    final companion = mapStoolToCompanion(entry);
    final row = await _db.updateStoolEntry(id, companion);
    return mapStoolRowToDomain(row);
  }

  @override
  Future<void> deleteStool(int id) {
    return _db.deleteStoolEntry(id);
  }
}
