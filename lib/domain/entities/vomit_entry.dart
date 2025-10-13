import 'package:equatable/equatable.dart';

/// Vomit amount levels that can be recorded.
enum VomitAmount { low, medium, high }

/// Domain entity that represents a vomit event.
class VomitEntry extends Equatable {
  const VomitEntry({
    this.id,
    required this.timestamp,
    required this.amount,
    this.notes,
  });

  /// Database identifier. Null when the entry has not been persisted yet.
  final int? id;

  /// When the vomit event happened.
  final DateTime timestamp;

  /// Recorded amount for the vomit event.
  final VomitAmount amount;

  /// Optional notes added by the caregiver.
  final String? notes;

  VomitEntry copyWith({
    int? id,
    DateTime? timestamp,
    VomitAmount? amount,
    String? notes,
  }) {
    return VomitEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, amount, notes];
}
