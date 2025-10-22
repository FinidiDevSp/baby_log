import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/bath_entry.dart';
import '../../../domain/entities/feeding_entry.dart';
import '../../../domain/entities/stool_entry.dart';
import '../../../domain/entities/temperature_entry.dart';
import '../../../domain/entities/vomit_entry.dart';
import '../../../l10n/app_localizations.dart';
import '../../shared/daily_date_selector.dart';
import '../home/state/bath_entries_provider.dart';
import '../home/state/feeding_entries_provider.dart';
import '../home/state/stool_entries_provider.dart';
import '../home/state/temperature_entries_provider.dart';
import '../home/state/vomit_entries_provider.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key, required this.accentColor});

  final Color accentColor;

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null && !_isSameCalendarDay(picked, _selectedDate)) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final feedingsAsync = ref.watch(feedingEntriesProvider);
    final stoolsAsync = ref.watch(stoolEntriesProvider);
    final vomitsAsync = ref.watch(vomitEntriesProvider);
    final bathsAsync = ref.watch(bathEntriesProvider);
    final temperaturesAsync = ref.watch(temperatureEntriesProvider);

    final asyncValues = [
      feedingsAsync,
      stoolsAsync,
      vomitsAsync,
      bathsAsync,
      temperaturesAsync,
    ];

    final hasError = asyncValues.any((value) => value.hasError);
    final isLoading = asyncValues.any((value) => value.isLoading);

    final body = () {
      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.timelineLoadError,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      final feedings = feedingsAsync.value ?? const <FeedingEntry>[];
      final stools = stoolsAsync.value ?? const <StoolEntry>[];
      final vomits = vomitsAsync.value ?? const <VomitEntry>[];
      final baths = bathsAsync.value ?? const <BathEntry>[];
      final temperatures =
          temperaturesAsync.value ?? const <TemperatureEntry>[];

      final hourFormat = DateFormat.Hm(l10n.localeName);
      final categories = [
        _buildFeedingCategory(l10n, feedings, hourFormat),
        _buildStoolCategory(l10n, stools, hourFormat),
        _buildBathCategory(l10n, baths, hourFormat),
        _buildVomitCategory(l10n, vomits, hourFormat),
        _buildTemperatureCategory(l10n, temperatures, hourFormat),
      ];

      final hasEntries =
          categories.any((category) => category.eventsByHour.isNotEmpty);

      if (!hasEntries) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.timelineEmptyDescription,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = math.max(constraints.maxWidth, 560.0);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minWidth),
              child: _TimelineTable(
                categories: categories,
                accentColor: widget.accentColor,
                hourFormat: hourFormat,
              ),
            ),
          );
        },
      );
    }();

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.timelineTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DailyDateSelector(
                    selectedDate: _selectedDate,
                    onPreviousDay: () => _changeDay(-1),
                    onNextDay: () => _changeDay(1),
                    onSelectDate: _pickDate,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _TimelineCategoryData _buildFeedingCategory(
    AppLocalizations l10n,
    List<FeedingEntry> entries,
    DateFormat hourFormat,
  ) {
    final filtered = entries
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .map(
          (entry) => _TimelineEvent(
            timestamp: entry.timestamp,
            tooltip: _formatTooltip(
              l10n,
              hourFormat,
              entry.timestamp,
              '${entry.amountMl} ml',
              entry.notes,
            ),
          ),
        )
        .toList();

    return _TimelineCategoryData(
      icon: LucideIcons.milk,
      label: l10n.dashboardBottleLabel,
      eventsByHour: _groupByHour(filtered),
    );
  }

  _TimelineCategoryData _buildStoolCategory(
    AppLocalizations l10n,
    List<StoolEntry> entries,
    DateFormat hourFormat,
  ) {
    final filtered = entries
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .map(
          (entry) => _TimelineEvent(
            timestamp: entry.timestamp,
            tooltip: _formatTooltip(
              l10n,
              hourFormat,
              entry.timestamp,
              _stoolDescription(l10n, entry.consistency),
              entry.notes,
            ),
          ),
        )
        .toList();

    return _TimelineCategoryData(
      icon: LucideIcons.baby,
      label: l10n.dashboardDiaperLabel,
      eventsByHour: _groupByHour(filtered),
    );
  }

  _TimelineCategoryData _buildBathCategory(
    AppLocalizations l10n,
    List<BathEntry> entries,
    DateFormat hourFormat,
  ) {
    final filtered = entries
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .map(
          (entry) => _TimelineEvent(
            timestamp: entry.timestamp,
            tooltip: _formatTooltip(
              l10n,
              hourFormat,
              entry.timestamp,
              _bathDescription(l10n, entry.type),
              entry.notes,
            ),
          ),
        )
        .toList();

    return _TimelineCategoryData(
      icon: LucideIcons.bath,
      label: l10n.dashboardBathLabel,
      eventsByHour: _groupByHour(filtered),
    );
  }

  _TimelineCategoryData _buildVomitCategory(
    AppLocalizations l10n,
    List<VomitEntry> entries,
    DateFormat hourFormat,
  ) {
    final filtered = entries
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .map(
          (entry) => _TimelineEvent(
            timestamp: entry.timestamp,
            tooltip: _formatTooltip(
              l10n,
              hourFormat,
              entry.timestamp,
              _vomitDescription(l10n, entry.amount),
              entry.notes,
            ),
          ),
        )
        .toList();

    return _TimelineCategoryData(
      icon: LucideIcons.triangleAlert,
      label: l10n.dashboardVomitLabel,
      eventsByHour: _groupByHour(filtered),
    );
  }

  _TimelineCategoryData _buildTemperatureCategory(
    AppLocalizations l10n,
    List<TemperatureEntry> entries,
    DateFormat hourFormat,
  ) {
    final filtered = entries
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .map(
          (entry) => _TimelineEvent(
            timestamp: entry.timestamp,
            tooltip: _formatTooltip(
              l10n,
              hourFormat,
              entry.timestamp,
              '${entry.celsius.toStringAsFixed(1)} °C',
              entry.notes,
            ),
          ),
        )
        .toList();

    return _TimelineCategoryData(
      icon: LucideIcons.thermometer,
      label: l10n.dashboardTemperatureLabel,
      eventsByHour: _groupByHour(filtered),
    );
  }
}

class _TimelineTable extends StatelessWidget {
  const _TimelineTable({
    required this.categories,
    required this.accentColor,
    required this.hourFormat,
  });

  final List<_TimelineCategoryData> categories;
  final Color accentColor;
  final DateFormat hourFormat;

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.outline.withValues(alpha: 0.35);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TimelineHeader(categories: categories),
          for (var hour = 0; hour < 24; hour++)
            _TimelineRow(
              hour: hour,
              categories: categories,
              accentColor: accentColor,
              borderColor: borderColor,
              hourLabel: hourFormat.format(DateTime(0, 1, 1, hour)),
              isLast: hour == 23,
            ),
        ],
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({required this.categories});

  final List<_TimelineCategoryData> categories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final borderColor = AppColors.outline.withValues(alpha: 0.35);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              l10n.timelineHourColumn,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final category in categories)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category.icon, size: 20, color: Colors.white),
                  const SizedBox(height: 6),
                  Text(
                    category.label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.hour,
    required this.categories,
    required this.accentColor,
    required this.borderColor,
    required this.hourLabel,
    required this.isLast,
  });

  final int hour;
  final List<_TimelineCategoryData> categories;
  final Color accentColor;
  final Color borderColor;
  final String hourLabel;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: borderColor.withValues(alpha: 0.7)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              hourLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          for (final category in categories)
            Expanded(
              child: _TimelineCell(
                events: category.eventsByHour[hour] ?? const [],
                accentColor: accentColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineCell extends StatelessWidget {
  const _TimelineCell({required this.events, required this.accentColor});

  final List<_TimelineEvent> events;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox(height: 24);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final event in events)
          _TimelineDot(tooltip: event.tooltip, color: accentColor),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.tooltip, required this.color});

  final String tooltip;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: Theme.of(context).textTheme.bodySmall,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineCategoryData {
  const _TimelineCategoryData({
    required this.icon,
    required this.label,
    required this.eventsByHour,
  });

  final IconData icon;
  final String label;
  final Map<int, List<_TimelineEvent>> eventsByHour;
}

class _TimelineEvent {
  const _TimelineEvent({
    required this.timestamp,
    required this.tooltip,
  });

  final DateTime timestamp;
  final String tooltip;
}

Map<int, List<_TimelineEvent>> _groupByHour(List<_TimelineEvent> events) {
  final grouped = <int, List<_TimelineEvent>>{};
  for (final event in events) {
    final hour = event.timestamp.hour;
    grouped.putIfAbsent(hour, () => []).add(event);
  }
  return grouped;
}

String _formatTooltip(
  AppLocalizations l10n,
  DateFormat hourFormat,
  DateTime timestamp,
  String detail,
  String? notes,
) {
  final buffer = StringBuffer()
    ..write(hourFormat.format(timestamp))
    ..write(' · ')
    ..write(detail);
  final trimmedNotes = notes?.trim();
  if (trimmedNotes != null && trimmedNotes.isNotEmpty) {
    buffer
      ..write('\n')
      ..write(l10n.timelineNotesPrefix(trimmedNotes));
  }
  return buffer.toString();
}

String _stoolDescription(AppLocalizations l10n, StoolConsistency consistency) {
  switch (consistency) {
    case StoolConsistency.liquid:
      return l10n.stoolLogConsistencyLiquidDescription;
    case StoolConsistency.soft:
      return l10n.stoolLogConsistencySoftDescription;
    case StoolConsistency.firm:
      return l10n.stoolLogConsistencyFirmDescription;
  }
}

String _vomitDescription(AppLocalizations l10n, VomitAmount amount) {
  switch (amount) {
    case VomitAmount.low:
      return l10n.vomitLogAmountLowDescription;
    case VomitAmount.medium:
      return l10n.vomitLogAmountMediumDescription;
    case VomitAmount.high:
      return l10n.vomitLogAmountHighDescription;
  }
}

String _bathDescription(AppLocalizations l10n, BathType type) {
  switch (type) {
    case BathType.full:
      return l10n.bathLogTypeFullDescription;
    case BathType.quick:
      return l10n.bathLogTypeQuickDescription;
  }
}

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
