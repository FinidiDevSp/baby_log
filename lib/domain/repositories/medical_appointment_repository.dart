import '../entities/medical_appointment.dart';

/// Contract for managing medical appointments persistence.
abstract class MedicalAppointmentRepository {
  /// Returns all stored appointments ordered by scheduled date.
  Future<List<MedicalAppointment>> fetchAppointments();

  /// Watches all appointments for realtime updates.
  Stream<List<MedicalAppointment>> watchAppointments();

  /// Persists a new appointment.
  Future<void> createAppointment(MedicalAppointment appointment);

  /// Updates an existing appointment.
  Future<void> updateAppointment(MedicalAppointment appointment);

  /// Deletes the appointment identified by [id].
  Future<void> deleteAppointment(String id);
}
