import '../../domain/entities/baby_profile.dart';
import '../../domain/repositories/baby_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/baby_profile_mapper.dart';

class BabyRepositoryImpl implements BabyRepository {
  BabyRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<BabyProfile?> watchBaby() {
    return _db.watchBabyRow().map((row) => mapRowToDomain(row));
  }

  @override
  Future<BabyProfile?> fetchBaby() async {
    final row = await _db.fetchBabyRow();
    return mapRowToDomain(row);
  }

  @override
  Future<BabyProfile> saveBaby(BabyProfile profile) async {
    final now = DateTime.now();
    final companion = mapDomainToCompanion(profile, updatedAt: now);

    if (profile.id == null) {
      final id = await _db.createBaby(companion);
      final stored = await _getById(id);
      if (stored == null) {
        throw StateError('No se pudo obtener el bebé recién creado.');
      }
      return stored;
    }

    await _db.upsertBaby(companion);
    final stored = await _getById(profile.id!);
    if (stored == null) {
      throw StateError('No se pudo actualizar el bebé con id ${profile.id}.');
    }
    return stored;
  }

  Future<BabyProfile?> _getById(int id) async {
    final query = _db.select(_db.babyProfiles)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return mapRowToDomain(row);
  }
}
