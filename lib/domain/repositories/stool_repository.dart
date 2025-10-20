import '../entities/stool_entry.dart';

/// Contract for managing diaper change entries.
abstract class StoolRepository {
  /// Watches all stored diaper change entries ordered from newest to oldest.
  Stream<List<StoolEntry>> watchStools();

  /// Persists a new stool entry and returns the stored entity.
  Future<StoolEntry> addStool(StoolEntry entry);

  /// Updates an existing stool entry and returns the stored entity.
  Future<StoolEntry> updateStool(StoolEntry entry);

  /// Removes the stool entry identified by [id].
  Future<void> deleteStool(int id);
}
