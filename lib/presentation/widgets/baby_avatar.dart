import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/baby_profile.dart';

/// Circular avatar that renders either the baby's photo or an initial.
class BabyAvatar extends StatelessWidget {
  const BabyAvatar({
    super.key,
    required this.baby,
    required this.accentColor,
    this.size = 40,
  });

  /// Profile information used to resolve the avatar content.
  final BabyProfile baby;

  /// Accent color applied when the avatar shows an initial.
  final Color accentColor;

  /// Render size of the avatar in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = baby.photoPath;

    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _InitialAvatar(
              name: baby.name,
              accentColor: accentColor,
              size: size,
            ),
          ),
        );
      }
    }

    return _InitialAvatar(
      name: baby.name,
      accentColor: accentColor,
      size: size,
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({
    required this.name,
    required this.accentColor,
    required this.size,
  });

  final String name;
  final Color accentColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isNotEmpty
        ? String.fromCharCode(trimmed.runes.first).toUpperCase()
        : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: accentColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
