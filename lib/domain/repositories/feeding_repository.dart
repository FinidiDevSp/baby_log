import '../entities/feeding_entry.dart';

/// Contract for managing bottle feeding entries.
abstract class FeedingRepository {
  /// Watches all stored bottle feeding entries ordered from newest to oldest.
  Stream<List<FeedingEntry>> watchFeedings();

  /// Persists a new feeding entry and returns the stored entity.
  Future<FeedingEntry> addFeeding(FeedingEntry entry);
}
