import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/locale_controller.dart';
import 'core/providers.dart';
import 'presentation/app/baby_log_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final storedLocale =
      sharedPreferences.getString(localePreferenceKey) ?? 'es';
  await initializeDateFormatting(storedLocale);
  Intl.defaultLocale = storedLocale;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const BabyLogApp(),
    ),
  );
}
