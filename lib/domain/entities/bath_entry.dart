import 'package:equatable/equatable.dart';

/// Types of bath sessions that can be logged.
enum BathType { full, quick }

/// Domain entity representing a bath event for the baby.
class BathEntry extends Equatable {
  const BathEntry({
    this.id,
    required this.timestamp,
    required this.type,
    this.notes,
  });

  /// Database identifier. Null when the entry has not been persisted yet.
  final int? id;

  /// When the bath happened.
  final DateTime timestamp;

  /// Type of bath performed.
  final BathType type;

  /// Optional notes added by the caregiver.
  final String? notes;

  BathEntry copyWith({
    int? id,
    DateTime? timestamp,
    BathType? type,
    String? notes,
  }) {
    return BathEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, type, notes];
}
