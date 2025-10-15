import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/medical_appointment.dart';

/// Controls the in-memory list of medical appointments while persistence is
/// being defined in later iterations.
class MedicalAppointmentsController extends Notifier<List<MedicalAppointment>> {
  @override
  List<MedicalAppointment> build() {
    return const <MedicalAppointment>[];
  }

  final _random = Random();

  /// Registers a new appointment in the agenda.
  void addAppointment(MedicalAppointment appointment) {
    state = [...state, appointment];
  }

  /// Persists changes for an existing appointment.
  void updateAppointment(MedicalAppointment appointment) {
    state = [
      for (final existing in state)
        if (existing.id == appointment.id) appointment else existing,
    ];
  }

  /// Removes the appointment identified by [id].
  void removeAppointment(String id) {
    state = state.where((appointment) => appointment.id != id).toList();
  }

  /// Generates a simple unique identifier.
  String nextId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final suffix = _random.nextInt(1 << 20);
    return '$timestamp-$suffix';
  }
}

/// Provides access to the agenda controller.
final medicalAppointmentsProvider =
    NotifierProvider<MedicalAppointmentsController, List<MedicalAppointment>>(
  MedicalAppointmentsController.new,
);
