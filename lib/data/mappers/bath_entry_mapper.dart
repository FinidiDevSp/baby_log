import 'package:drift/drift.dart';

import '../../domain/entities/bath_entry.dart';
import '../local/app_database.dart' as db;

BathEntry mapBathRowToDomain(db.BathEntryRow row) {
  final typeIndex = row.type;
  final safeIndex = typeIndex.clamp(0, BathType.values.length - 1) as int;
  final type = BathType.values[safeIndex];
  return BathEntry(
    id: row.id,
    timestamp: row.timestamp,
    type: type,
    notes: row.notes,
  );
}

db.BathEntriesCompanion mapBathToCompanion(BathEntry entry) {
  return db.BathEntriesCompanion(
    timestamp: Value(entry.timestamp),
    type: Value(entry.type.index),
    notes: Value(entry.notes),
  );
}
