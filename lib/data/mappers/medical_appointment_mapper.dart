import 'package:drift/drift.dart';

import '../../domain/entities/medical_appointment.dart';
import '../local/app_database.dart' as db;

MedicalAppointment mapMedicalAppointmentRowToDomain(
  db.MedicalAppointmentRow row,
) {
  final typeIndex = row.type;
  final type = MedicalAppointmentType
      .values[typeIndex.clamp(0, MedicalAppointmentType.values.length - 1)];

  return MedicalAppointment(
    id: row.id,
    title: row.title,
    type: type,
    scheduledAt: row.scheduledAt,
    notes: row.notes,
    isCompleted: row.isCompleted,
  );
}

db.MedicalAppointmentsCompanion mapMedicalAppointmentToCompanion(
  MedicalAppointment appointment,
) {
  return db.MedicalAppointmentsCompanion(
    id: Value(appointment.id),
    title: Value(appointment.title),
    type: Value(appointment.type.index),
    scheduledAt: Value(appointment.scheduledAt),
    notes: Value(appointment.notes),
    isCompleted: Value(appointment.isCompleted),
  );
}

List<MedicalAppointment> mapMedicalAppointmentRowsToDomain(
  List<db.MedicalAppointmentRow> rows,
) {
  return rows.map(mapMedicalAppointmentRowToDomain).toList(growable: false);
}
