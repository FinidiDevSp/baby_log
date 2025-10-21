import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/medical_appointment.dart';
import '../../../../core/providers.dart';

/// Controls the list of medical appointments backed by the local database.
class MedicalAppointmentsController extends Notifier<List<MedicalAppointment>> {
  StreamSubscription<List<MedicalAppointment>>? _subscription;

  @override
  List<MedicalAppointment> build() {
    final repository = ref.watch(medicalAppointmentRepositoryProvider);
    _subscription?.cancel();
    _subscription = repository.watchAppointments().listen((appointments) {
      state = appointments;
    });
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return const <MedicalAppointment>[];
  }

  final _random = Random();

  /// Registers a new appointment in the agenda.
  Future<void> addAppointment(MedicalAppointment appointment) {
    final repository = ref.read(medicalAppointmentRepositoryProvider);
    return repository.createAppointment(appointment);
  }

  /// Persists changes for an existing appointment.
  Future<void> updateAppointment(MedicalAppointment appointment) {
    final repository = ref.read(medicalAppointmentRepositoryProvider);
    return repository.updateAppointment(appointment);
  }

  /// Marks the appointment identified by [id] as completed or pending.
  Future<void> setAppointmentCompletion({
    required String id,
    required bool isCompleted,
  }) {
    final repository = ref.read(medicalAppointmentRepositoryProvider);
    final current = state.firstWhere(
      (appointment) => appointment.id == id,
      orElse: () {
        throw StateError('Medical appointment with id $id not found.');
      },
    );
    return repository.updateAppointment(
      current.copyWith(isCompleted: isCompleted),
    );
  }

  /// Removes the appointment identified by [id].
  Future<void> removeAppointment(String id) {
    final repository = ref.read(medicalAppointmentRepositoryProvider);
    return repository.deleteAppointment(id);
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
