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
}
