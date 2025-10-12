import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Record of a bottle feeding entry.
class FeedingEntry {
  FeedingEntry({
    required this.timestamp,
    required this.amountMl,
    this.notes,
  });

  /// When the feeding happened.
  final DateTime timestamp;

  /// Amount consumed in milliliters.
  final int amountMl;

  /// Optional notes added by the caregiver.
  final String? notes;
}

class FeedingEntriesNotifier extends StateNotifier<List<FeedingEntry>> {
  FeedingEntriesNotifier() : super(const []);

  void addFeeding(FeedingEntry entry) {
    final updated = [...state, entry]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    state = List.unmodifiable(updated);
  }
}

/// In-memory provider that stores the bottle feeding entries created during the
/// session. Persistence will be added in future iterations.
final feedingEntriesProvider =
    StateNotifierProvider<FeedingEntriesNotifier, List<FeedingEntry>>(
  (ref) => FeedingEntriesNotifier(),
);
