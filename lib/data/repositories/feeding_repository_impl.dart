import '../../domain/entities/feeding_entry.dart';
import '../../domain/repositories/feeding_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/feeding_entry_mapper.dart';

class FeedingRepositoryImpl implements FeedingRepository {
  FeedingRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<FeedingEntry>> watchFeedings() {
    return _db.watchBottleFeedings().map(
          (rows) => rows.map(mapFeedingRowToDomain).toList(growable: false),
        );
  }

  @override
  Future<FeedingEntry> addFeeding(FeedingEntry entry) async {
    final companion = mapFeedingToCompanion(entry);
    final row = await _db.createBottleFeeding(companion);
    return mapFeedingRowToDomain(row);
  }

  @override
  Future<FeedingEntry> updateFeeding(FeedingEntry entry) async {
    final id = entry.id;
    if (id == null) {
      throw ArgumentError('Cannot update a feeding without an id.');
    }
    final companion = mapFeedingToCompanion(entry);
    final row = await _db.updateBottleFeeding(id, companion);
    return mapFeedingRowToDomain(row);
  }

  @override
  Future<void> deleteFeeding(int id) {
    return _db.deleteBottleFeeding(id);
  }
}
