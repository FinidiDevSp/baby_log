import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../providers.dart';

/// Preference key used to persist the selected locale.
const String localePreferenceKey = 'settings.locale';

/// Controls the active locale for the entire application.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final storedCode = prefs.getString(localePreferenceKey);
    final locale = _resolveLocale(storedCode);
    Intl.defaultLocale = locale.languageCode;
    return locale;
  }

  /// Updates the current locale, persists it and refreshes the Intl defaults.
  Future<void> updateLocale(Locale locale) async {
    if (locale == state) {
      return;
    }
    await initializeDateFormatting(locale.languageCode);
    Intl.defaultLocale = locale.languageCode;
    state = locale;
    await ref
        .read(sharedPreferencesProvider)
        .setString(localePreferenceKey, locale.languageCode);
  }

  Locale _resolveLocale(String? code) {
    if (code == null || code.isEmpty) {
      return const Locale('es');
    }
    return Locale(code);
  }
}

/// Exposes the [LocaleController] to the widget tree.
final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
