import 'package:drift/drift.dart';

import '../../domain/entities/feeding_entry.dart';
import '../local/app_database.dart' as db;

FeedingEntry mapFeedingRowToDomain(db.BottleFeedingRow row) {
  return FeedingEntry(
    id: row.id,
    timestamp: row.timestamp,
    amountMl: row.amountMl,
    notes: row.notes,
  );
}

db.BottleFeedingsCompanion mapFeedingToCompanion(FeedingEntry entry) {
  return db.BottleFeedingsCompanion(
    timestamp: Value(entry.timestamp),
    amountMl: Value(entry.amountMl),
    notes: Value(entry.notes),
  );
}
