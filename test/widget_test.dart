import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baby_log/core/providers.dart';
import 'package:baby_log/data/local/app_database.dart';
import 'package:baby_log/l10n/app_localizations.dart';
import 'package:baby_log/presentation/app/baby_log_app.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('es');
    SharedPreferences.setMockInitialValues(const {});
  });

  setUp(() {
    binding.platformDispatcher.localeTestValue = const Locale('es');
  });

  tearDown(() {
    binding.platformDispatcher.clearLocaleTestValue();
  });

  testWidgets('Muestra el formulario cuando no hay bebé', (tester) async {
    final inMemoryDb = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(inMemoryDb.close);

    final sharedPrefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(inMemoryDb),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: const BabyLogApp(),
      ),
    );

    await tester.pumpAndSettle();

    final context = tester.element(find.byType(AppBar));
    final l10n = AppLocalizations.of(context);
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    final titleText = appBar.title as Text;
    expect(titleText.data, l10n.formCreateTitle);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
