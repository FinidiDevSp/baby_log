import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:baby_log/core/providers.dart';
import 'package:baby_log/data/local/app_database.dart';
import 'package:baby_log/presentation/app/baby_log_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('es');
  });

  testWidgets('Muestra el formulario cuando no hay bebé', (tester) async {
    final inMemoryDb = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(inMemoryDb.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(inMemoryDb)],
        child: const BabyLogApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Registrar bebé'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
