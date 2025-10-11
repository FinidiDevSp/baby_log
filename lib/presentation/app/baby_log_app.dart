import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/baby_profile.dart';
import '../features/baby_form/baby_form_page.dart';
import '../features/home/empty_home_page.dart';

class BabyLogApp extends ConsumerWidget {
  const BabyLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Baby Log',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const _BabyEntryPoint(),
    );
  }
}

class _BabyEntryPoint extends ConsumerWidget {
  const _BabyEntryPoint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'No se pudo cargar la información del bebé.\n$error',
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
    return EmptyHomePage(baby: baby);
  }
}
