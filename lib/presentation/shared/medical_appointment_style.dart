import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../domain/entities/medical_appointment.dart';

/// Visual configuration for rendering medical appointments consistently.
class MedicalAppointmentVisualStyle {
  const MedicalAppointmentVisualStyle({
    required this.icon,
    required this.color,
  });

  /// Icon that represents the appointment type.
  final IconData icon;

  /// Accent color used for highlights and indicators.
  final Color color;

  /// Returns a soft background color derived from the accent.
  Color backgroundColor([double alpha = 0.16]) =>
      color.withValues(alpha: alpha);

  /// Resolves the style for the provided [type].
  static MedicalAppointmentVisualStyle resolve(MedicalAppointmentType type) {
    switch (type) {
      case MedicalAppointmentType.revision:
        return const MedicalAppointmentVisualStyle(
          icon: LucideIcons.clipboardList,
          color: Color(0xFF8CB8FF),
        );
      case MedicalAppointmentType.pediatrics:
        return const MedicalAppointmentVisualStyle(
          icon: LucideIcons.stethoscope,
          color: Color(0xFF65C1A9),
        );
      case MedicalAppointmentType.vaccines:
        return const MedicalAppointmentVisualStyle(
          icon: LucideIcons.syringe,
          color: Color(0xFFF6C65B),
        );
      case MedicalAppointmentType.emergency:
        return const MedicalAppointmentVisualStyle(
          icon: LucideIcons.ambulance,
          color: Color(0xFFFF8A80),
        );
    }
  }
}
