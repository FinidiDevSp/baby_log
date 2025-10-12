import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'app_colors.dart';
import 'app_theme.dart';

const _accentCacheKey = 'theme.accent_argb';

/// Controla el tema dinamico de la aplicacion y expone el color de acento.
class ThemeController extends Notifier<ThemeData> {
  late Color _accentColor;

  /// Color de acento actualmente aplicado al tema.
  Color get accentColor => _accentColor;

  @override
  ThemeData build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final storedValue = prefs.getInt(_accentCacheKey);
    _accentColor =
        storedValue != null ? Color(storedValue) : AppColors.primaryAccent;
    return AppTheme.dark(accentColor: _accentColor);
  }

  /// Actualiza el color de acento, lo persiste y reconstruye el tema global.
  void updateAccent(Color color) {
    if (color.toARGB32() == _accentColor.toARGB32()) {
      return;
    }
    _accentColor = color;
    ref
        .read(sharedPreferencesProvider)
        .setInt(_accentCacheKey, color.toARGB32());
    state = AppTheme.dark(accentColor: color);
  }

  /// Restablece el tema al color de fabrica y borra la preferencia local.
  void reset() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.remove(_accentCacheKey);
    _accentColor = AppColors.primaryAccent;
    state = AppTheme.dark(accentColor: _accentColor);
  }
}

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeData>(ThemeController.new);
