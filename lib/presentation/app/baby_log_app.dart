import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';

import '../../core/providers.dart';
import '../../core/theme/theme_controller.dart';
import '../../domain/entities/baby_profile.dart';
import '../features/baby_form/baby_form_page.dart';
import '../features/home/baby_dashboard_page.dart';

class BabyLogApp extends ConsumerWidget {
  const BabyLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: theme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return const Locale('es');
        }
        for (final supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('es');
      },
      home: const _BabyEntryPoint(),
    );
  }
}

class _BabyEntryPoint extends ConsumerWidget {
  const _BabyEntryPoint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    ref.listen(babyStreamProvider, (_, next) {
      next.whenData((baby) {
        final controller = ref.read(themeControllerProvider.notifier);
        if (baby == null) {
          controller.reset();
          return;
        }
        controller.updateAccent(Color(baby.accentColorValue));
      });
    });

    final asyncBaby = ref.watch(babyStreamProvider);

    return asyncBaby.when(
      data: (baby) => _resolveHome(baby),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.homeLoadError(error.toString()),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resolveHome(BabyProfile? baby) {
    if (baby == null) {
      return const BabyFormPage(existingBaby: null);
    }
    return BabyDashboardPage(baby: baby);
  }
}
