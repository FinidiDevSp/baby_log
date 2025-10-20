import '../../domain/entities/bath_entry.dart';
import '../../domain/repositories/bath_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/bath_entry_mapper.dart';

class BathRepositoryImpl implements BathRepository {
  BathRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<BathEntry>> watchBaths() {
    return _db.watchBathEntries().map(
      (rows) => rows.map(mapBathRowToDomain).toList(growable: false),
    );
  }

  @override
  Future<BathEntry> addBath(BathEntry entry) async {
    final companion = mapBathToCompanion(entry);
    final row = await _db.createBathEntry(companion);
    return mapBathRowToDomain(row);
  }

  @override
  Future<BathEntry> updateBath(BathEntry entry) async {
    final id = entry.id;
    if (id == null) {
      throw ArgumentError('Cannot update a bath entry without an id.');
    }
    final companion = mapBathToCompanion(entry);
    final row = await _db.updateBathEntry(id, companion);
    return mapBathRowToDomain(row);
  }

  @override
  Future<void> deleteBath(int id) {
    return _db.deleteBathEntry(id);
  }
}
