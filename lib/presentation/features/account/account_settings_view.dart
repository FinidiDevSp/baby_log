import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../l10n/app_localizations.dart';

class AccountSettingsView extends ConsumerWidget {
  const AccountSettingsView({super.key, required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeControllerProvider);
    final controller = ref.read(localeControllerProvider.notifier);

    final options = [
      _LanguageOption(Locale('es'), l10n.accountLanguageOptionSpanish),
      _LanguageOption(Locale('en'), l10n.accountLanguageOptionEnglish),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Text(
            l10n.accountSettingsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.accountSettingsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.accountLanguageTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.accountLanguageSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (final option in options) ...[
                  RadioListTile<Locale>(
                    value: option.locale,
                    groupValue: locale,
                    activeColor: accentColor,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(option.label),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      unawaited(controller.updateLocale(value));
                    },
                  ),
                  if (option != options.last)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.accountLanguageApplyHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption(this.locale, this.label);

  final Locale locale;
  final String label;
}
