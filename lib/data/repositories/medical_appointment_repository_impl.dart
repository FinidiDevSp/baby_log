import 'package:drift/drift.dart';

import '../../domain/entities/medical_appointment.dart';
import '../../domain/repositories/medical_appointment_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/medical_appointment_mapper.dart';

class MedicalAppointmentRepositoryImpl implements MedicalAppointmentRepository {
  MedicalAppointmentRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Future<void> createAppointment(MedicalAppointment appointment) async {
    final companion = mapMedicalAppointmentToCompanion(appointment).copyWith(
      createdAt: const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );
    await _db.createMedicalAppointment(companion);
  }

  @override
  Future<void> updateAppointment(MedicalAppointment appointment) async {
    final companion = mapMedicalAppointmentToCompanion(appointment);
    await _db.updateMedicalAppointment(appointment.id, companion);
  }

  @override
  Future<void> deleteAppointment(String id) {
    return _db.deleteMedicalAppointment(id);
  }

  @override
  Future<List<MedicalAppointment>> fetchAppointments() async {
    final rows = await _db.fetchMedicalAppointments();
    return mapMedicalAppointmentRowsToDomain(rows);
  }

  @override
  Stream<List<MedicalAppointment>> watchAppointments() {
    return _db.watchMedicalAppointments().map(
      mapMedicalAppointmentRowsToDomain,
    );
  }
}
