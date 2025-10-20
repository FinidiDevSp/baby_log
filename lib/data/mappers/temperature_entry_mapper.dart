import 'package:drift/drift.dart';

import '../../domain/entities/temperature_entry.dart';
import '../local/app_database.dart' as db;

TemperatureEntry mapTemperatureRowToDomain(db.TemperatureEntryRow row) {
  return TemperatureEntry(
    id: row.id,
    timestamp: row.timestamp,
    celsius: row.valueCelsius,
    notes: row.notes,
  );
}

db.TemperatureEntriesCompanion mapTemperatureToCompanion(
  TemperatureEntry entry,
) {
  return db.TemperatureEntriesCompanion(
    timestamp: Value(entry.timestamp),
    valueCelsius: Value(entry.celsius),
    notes: Value(entry.notes),
  );
}
