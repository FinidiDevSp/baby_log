import 'package:equatable/equatable.dart';

/// Stool consistency levels that can be recorded for a diaper change.
enum StoolConsistency { liquid, soft, firm }

/// Domain entity that represents a diaper change event.
class StoolEntry extends Equatable {
  const StoolEntry({
    this.id,
    required this.timestamp,
    required this.consistency,
    this.notes,
  });

  /// Database identifier. Null when the entry has not been persisted yet.
  final int? id;

  /// When the diaper change happened.
  final DateTime timestamp;

  /// Consistency of the stool during the diaper change.
  final StoolConsistency consistency;

  /// Optional notes added by the caregiver.
  final String? notes;

  StoolEntry copyWith({
    int? id,
    DateTime? timestamp,
    StoolConsistency? consistency,
    String? notes,
  }) {
    return StoolEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      consistency: consistency ?? this.consistency,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, consistency, notes];
}
