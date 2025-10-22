import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class DailyDateSelector extends StatelessWidget {
  const DailyDateSelector({
    super.key,
    required this.selectedDate,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onSelectDate,
  });

  final DateTime selectedDate;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPreviousDay,
            icon: const Icon(LucideIcons.chevronLeft, size: 18),
            color: Colors.white.withValues(alpha: 0.8),
            tooltip: l10n.dashboardPreviousDayTooltip,
            style: IconButton.styleFrom(
              minimumSize: const Size(36, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: onSelectDate,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.calendar,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _resolveDateLabel(l10n, selectedDate),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onNextDay,
            icon: const Icon(LucideIcons.chevronRight, size: 18),
            color: Colors.white.withValues(alpha: 0.8),
            tooltip: l10n.dashboardNextDayTooltip,
            style: IconButton.styleFrom(
              minimumSize: const Size(36, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

String _resolveDateLabel(AppLocalizations l10n, DateTime selectedDate) {
  final now = DateTime.now();
  final isToday = _isSameDay(now, selectedDate);
  final baseLabel = DateFormat(
    "EEEE, d 'de' MMMM",
    l10n.localeName,
  ).format(selectedDate);
  if (isToday) {
    final shortLabel = DateFormat(
      "d 'de' MMMM",
      l10n.localeName,
    ).format(selectedDate);
    return '${l10n.dashboardTodayLabel}, $shortLabel';
  }
  return baseLabel;
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
