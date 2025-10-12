import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:baby_log/l10n/app_localizations.dart';

import '../../../domain/entities/baby_profile.dart';
import '../baby_form/baby_form_page.dart';

class EmptyHomePage extends ConsumerWidget {
  const EmptyHomePage({super.key, required this.baby});

  final BabyProfile baby;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.homeEditBabyTooltip,
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
      body: Center(
        child: Text(
          l10n.homeEmptyDescription,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
