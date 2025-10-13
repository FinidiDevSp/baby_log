import '../entities/vomit_entry.dart';

/// Contract for managing vomit entries.
abstract class VomitRepository {
  /// Watches all stored vomit entries ordered from newest to oldest.
  Stream<List<VomitEntry>> watchVomits();

  /// Persists a new vomit entry and returns the stored entity.
  Future<VomitEntry> addVomit(VomitEntry entry);
}
