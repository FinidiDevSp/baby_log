import 'package:equatable/equatable.dart';

/// Domain entity that represents a bottle feeding event.
class FeedingEntry extends Equatable {
  const FeedingEntry({
    this.id,
    required this.timestamp,
    required this.amountMl,
    this.notes,
  });

  /// Database identifier. Null when the entry has not been persisted yet.
  final int? id;

  /// When the feeding happened.
  final DateTime timestamp;

  /// Amount consumed in milliliters.
  final int amountMl;

  /// Optional notes added by the caregiver.
  final String? notes;

  FeedingEntry copyWith({
    int? id,
    DateTime? timestamp,
    int? amountMl,
    String? notes,
  }) {
    return FeedingEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      amountMl: amountMl ?? this.amountMl,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, amountMl, notes];
}
