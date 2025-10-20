import 'package:drift/drift.dart';

import '../../domain/entities/stool_entry.dart';
import '../local/app_database.dart' as db;

StoolEntry mapStoolRowToDomain(db.StoolEntryRow row) {
  final consistencyIndex = row.consistency;
  final safeIndex = consistencyIndex.clamp(
    0,
    StoolConsistency.values.length - 1,
  );
  final consistency = StoolConsistency.values[safeIndex];
  return StoolEntry(
    id: row.id,
    timestamp: row.timestamp,
    consistency: consistency,
    notes: row.notes,
  );
}

db.StoolEntriesCompanion mapStoolToCompanion(StoolEntry entry) {
  return db.StoolEntriesCompanion(
    timestamp: Value(entry.timestamp),
    consistency: Value(entry.consistency.index),
    notes: Value(entry.notes),
  );
}
