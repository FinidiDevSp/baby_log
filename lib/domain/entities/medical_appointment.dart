import 'package:equatable/equatable.dart';

/// Types of medical appointments available in the agenda.
enum MedicalAppointmentType { revision, pediatrics, vaccines, emergency }

/// Domain entity that represents a scheduled medical appointment for the baby.
class MedicalAppointment extends Equatable {
  const MedicalAppointment({
    required this.id,
    required this.title,
    required this.type,
    required this.scheduledAt,
    this.notes,
  });

  /// Unique identifier generated on the client while persistence is implemented.
  final String id;

  /// Brief summary of the appointment (e.g. "Control mensual").
  final String title;

  /// Type of appointment selected by the caregiver.
  final MedicalAppointmentType type;

  /// Exact date and time when the appointment will take place.
  final DateTime scheduledAt;

  /// Optional notes for additional context.
  final String? notes;

  /// Returns a new instance with the provided values replaced.
  MedicalAppointment copyWith({
    String? id,
    String? title,
    MedicalAppointmentType? type,
    DateTime? scheduledAt,
    String? notes,
  }) {
    return MedicalAppointment(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, title, type, scheduledAt, notes];
}
