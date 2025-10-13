import 'package:equatable/equatable.dart';

/// Domain entity that represents a body temperature measurement.
class TemperatureEntry extends Equatable {
  const TemperatureEntry({
    this.id,
    required this.timestamp,
    required this.celsius,
    this.notes,
  });

  /// Database identifier. Null when the entry has not been persisted yet.
  final int? id;

  /// When the temperature was measured.
  final DateTime timestamp;

  /// Recorded temperature value in Celsius degrees.
  final double celsius;

  /// Optional notes added by the caregiver.
  final String? notes;

  TemperatureEntry copyWith({
    int? id,
    DateTime? timestamp,
    double? celsius,
    String? notes,
  }) {
    return TemperatureEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      celsius: celsius ?? this.celsius,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, timestamp, celsius, notes];
}
