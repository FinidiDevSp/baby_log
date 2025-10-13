import '../../domain/entities/temperature_entry.dart';
import '../../domain/repositories/temperature_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/temperature_entry_mapper.dart';

class TemperatureRepositoryImpl implements TemperatureRepository {
  TemperatureRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<TemperatureEntry>> watchTemperatures() {
    return _db.watchTemperatureEntries().map(
          (rows) => rows.map(mapTemperatureRowToDomain).toList(growable: false),
        );
  }

  @override
  Future<TemperatureEntry> addTemperature(TemperatureEntry entry) async {
    final companion = mapTemperatureToCompanion(entry);
    final row = await _db.createTemperatureEntry(companion);
    return mapTemperatureRowToDomain(row);
  }
}
