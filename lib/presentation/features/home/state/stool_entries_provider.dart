import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stool consistency levels that can be recorded for a diaper change.
enum StoolConsistency { liquid, soft, firm }

/// Record of a diaper change event.
class StoolEntry {
  StoolEntry({
    required this.timestamp,
    required this.consistency,
    this.notes,
  });

  /// When the diaper change happened.
  final DateTime timestamp;

  /// Consistency of the stool during the diaper change.
  final StoolConsistency consistency;

  /// Optional notes added by the caregiver.
  final String? notes;
}

class StoolEntriesNotifier extends Notifier<List<StoolEntry>> {
  @override
  List<StoolEntry> build() => const [];

  void addEntry(StoolEntry entry) {
    final updated = [...state, entry]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = List.unmodifiable(updated);
  }
}

/// In-memory provider that stores diaper change entries created during the
/// session. Persistence will be added in future iterations.
final stoolEntriesProvider =
    NotifierProvider<StoolEntriesNotifier, List<StoolEntry>>(
  StoolEntriesNotifier.new,
);
