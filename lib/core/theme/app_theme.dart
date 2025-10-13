import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark({Color accentColor = AppColors.primaryAccent}) {
    final base = ThemeData.dark(useMaterial3: true);
    final onAccentBrightness =
        ThemeData.estimateBrightnessForColor(accentColor);
    final onAccent =
        onAccentBrightness == Brightness.dark ? Colors.white : Colors.black87;
    final focusOverlay = accentColor.withValues(alpha: 0.12);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.scaffold,
      colorScheme: base.colorScheme.copyWith(
        primary: accentColor,
        secondary: AppColors.ctaBlue,
        surface: AppColors.surface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.surfaceVariant,
        onPrimary: onAccent,
        onSurface: Colors.white,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: 'Roboto',
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      focusColor: focusOverlay,
      hoverColor: focusOverlay,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.scaffold,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: accentColor,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: accentColor,
            width: 1.5,
          ),
        ),
        floatingLabelStyle: TextStyle(color: onAccent),
        labelStyle: base.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        hintStyle: base.textTheme.bodyMedium?.copyWith(color: Colors.white70),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: accentColor,
        secondarySelectedColor: accentColor,
        disabledColor: AppColors.outline,
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: TextStyle(color: onAccent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.6)),
        selectedShadowColor: focusOverlay,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: onAccent,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: base.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return focusOverlay;
            }
            return null;
          }),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: onAccent,
        elevation: 0,
        hoverColor: focusOverlay,
        focusColor: focusOverlay,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: focusOverlay,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: focusOverlay,
        selectionHandleColor: accentColor,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surface,
        headerBackgroundColor: accentColor,
        headerForegroundColor: onAccent,
        dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return onAccent;
          }
          if (states.contains(WidgetState.disabled)) {
            return Colors.white38;
          }
          return Colors.white;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.selected)) {
            return accentColor;
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return focusOverlay;
          }
          return Colors.transparent;
        }),
        dayOverlayColor: WidgetStateProperty.all<Color?>(focusOverlay),
        todayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return onAccent;
            }
            if (states.contains(WidgetState.disabled)) {
              return accentColor.withValues(alpha: 0.38);
            }
            return accentColor;
          },
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return accentColor;
            }
            return focusOverlay;
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surface,
        dialBackgroundColor: AppColors.surfaceVariant,
        dialHandColor: accentColor,
        entryModeIconColor: onAccent,
        dayPeriodColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected) ||
              states.contains(WidgetState.focused)) {
            return focusOverlay;
          }
          return AppColors.surfaceVariant;
        }),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return onAccent;
          }
          return Colors.white;
        }),
        hourMinuteColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected) ||
              states.contains(WidgetState.focused)) {
            return focusOverlay;
          }
          return AppColors.surfaceVariant;
        }),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return onAccent;
          }
          return Colors.white;
        }),
        helpTextStyle: base.textTheme.bodySmall?.copyWith(color: Colors.white70),
      ),
    );
  }
}
