import '../entities/bath_entry.dart';

/// Contract for managing bath entries.
abstract class BathRepository {
  /// Watches all stored bath entries ordered from newest to oldest.
  Stream<List<BathEntry>> watchBaths();

  /// Persists a new bath entry and returns the stored entity.
  Future<BathEntry> addBath(BathEntry entry);
}
