import '../../domain/entities/vomit_entry.dart';
import '../../domain/repositories/vomit_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/vomit_entry_mapper.dart';

class VomitRepositoryImpl implements VomitRepository {
  VomitRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<VomitEntry>> watchVomits() {
    return _db.watchVomitEntries().map(
          (rows) => rows.map(mapVomitRowToDomain).toList(growable: false),
        );
  }

  @override
  Future<VomitEntry> addVomit(VomitEntry entry) async {
    final companion = mapVomitToCompanion(entry);
    final row = await _db.createVomitEntry(companion);
    return mapVomitRowToDomain(row);
  }
}
