import 'package:drift/drift.dart';

import '../../domain/entities/vomit_entry.dart';
import '../local/app_database.dart' as db;

VomitEntry mapVomitRowToDomain(db.VomitEntryRow row) {
  final amountIndex = row.amount;
  final safeIndex = amountIndex.clamp(0, VomitAmount.values.length - 1);
  final amount = VomitAmount.values[safeIndex];
  return VomitEntry(
    id: row.id,
    timestamp: row.timestamp,
    amount: amount,
    notes: row.notes,
  );
}

db.VomitEntriesCompanion mapVomitToCompanion(VomitEntry entry) {
  return db.VomitEntriesCompanion(
    timestamp: Value(entry.timestamp),
    amount: Value(entry.amount.index),
    notes: Value(entry.notes),
  );
}
