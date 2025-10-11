import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../domain/entities/baby_profile.dart';
import '../baby_form/baby_form_page.dart';

class EmptyHomePage extends ConsumerWidget {
  const EmptyHomePage({super.key, required this.baby});

  final BabyProfile baby;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Log'),
        actions: [
          IconButton(
            tooltip: 'Editar bebé',
            icon: const Icon(LucideIcons.pencil),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BabyFormPage(existingBaby: baby),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Aquí aparecerán las métricas y registros de tu bebé.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
