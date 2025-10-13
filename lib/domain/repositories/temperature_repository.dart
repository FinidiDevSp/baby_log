import '../entities/temperature_entry.dart';

/// Contract for managing temperature measurements.
abstract class TemperatureRepository {
  /// Watches all stored temperature entries ordered from newest to oldest.
  Stream<List<TemperatureEntry>> watchTemperatures();

  /// Persists a new temperature entry and returns the stored entity.
  Future<TemperatureEntry> addTemperature(TemperatureEntry entry);
}
