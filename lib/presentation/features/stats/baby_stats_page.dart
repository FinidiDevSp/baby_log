import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/bath_entry.dart';
import '../../../domain/entities/feeding_entry.dart';
import '../../../domain/entities/stool_entry.dart';
import '../../../domain/entities/vomit_entry.dart';
import '../../../l10n/app_localizations.dart';
import '../../features/home/state/bath_entries_provider.dart';
import '../../features/home/state/feeding_entries_provider.dart';
import '../../features/home/state/stool_entries_provider.dart';
import '../../features/home/state/vomit_entries_provider.dart';

part 'widgets/weekly_bar_chart.dart';

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime _startOfWeek(DateTime reference) {
  final normalized = DateTime(reference.year, reference.month, reference.day);
  return normalized.subtract(
    Duration(days: normalized.weekday - DateTime.monday),
  );
}

DateTime _endOfWeek(DateTime reference) {
  final start = _startOfWeek(reference);
  return start.add(const Duration(days: 6));
}

enum StatsMode { period, history }

enum StatsCategory { feeding, diapers, bath, vomit }

extension StatsCategoryX on StatsCategory {
  IconData get icon {
    switch (this) {
      case StatsCategory.feeding:
        return LucideIcons.milk;
      case StatsCategory.diapers:
        return LucideIcons.baby;
      case StatsCategory.bath:
        return LucideIcons.bath;
      case StatsCategory.vomit:
        return LucideIcons.triangleAlert;
    }
  }
}

class MetricSummary {
  const MetricSummary({required this.label, required this.value});

  final String label;
  final String value;
}

class DailyMetricPoint {
  const DailyMetricPoint({
    required this.date,
    required this.value,
    this.hasValue = true,
  });

  final DateTime date;
  final double value;
  final bool hasValue;
}

class WeeklyMetric {
  const WeeklyMetric({
    required this.id,
    required this.title,
    required this.icon,
    required this.points,
    required this.summaries,
    required this.unitSuffix,
    this.yAxisLabel,
    this.maxValueOverride,
    this.valueLabelBuilder,
  });

  final String id;
  final String title;
  final IconData icon;
  final List<DailyMetricPoint> points;
  final List<MetricSummary> summaries;
  final String unitSuffix;
  final String? yAxisLabel;
  final double? maxValueOverride;
  final String Function(DailyMetricPoint point)? valueLabelBuilder;
}

class BabyStatsPage extends ConsumerStatefulWidget {
  const BabyStatsPage({super.key, required this.accentColor});

  final Color accentColor;

  @override
  ConsumerState<BabyStatsPage> createState() => _BabyStatsPageState();
}

class _BabyStatsPageState extends ConsumerState<BabyStatsPage> {
  StatsMode _mode = StatsMode.period;
  StatsCategory _selectedCategory = StatsCategory.feeding;
  late DateTimeRange _selectedRange;
  String? _selectedMetricId;

  @override
  void initState() {
    super.initState();
    final today = _normalizedDate(DateTime.now());
    final start = _startOfWeek(today);
    final end = _endOfWeek(today);
    // Siempre usar la semana completa, sin limitar al día de hoy
    _selectedRange = DateTimeRange(start: start, end: end);
  }

  DateTime get _today => _normalizedDate(DateTime.now());

  int get _rangeLengthInDays =>
      _selectedRange.end.difference(_selectedRange.start).inDays + 1;

  List<DateTime> get _rangeDays => List.generate(
    _rangeLengthInDays,
    (index) => _selectedRange.start.add(Duration(days: index)),
  );

  DateTime _normalizedDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  void _goToPreviousRange() {
    final length = _rangeLengthInDays;
    setState(() {
      _selectedRange = DateTimeRange(
        start: _normalizedDate(
          _selectedRange.start.subtract(Duration(days: length)),
        ),
        end: _normalizedDate(
          _selectedRange.end.subtract(Duration(days: length)),
        ),
      );
    });
  }

  void _goToNextRange() {
    final length = _rangeLengthInDays;
    final today = _today;
    final proposedStart = _selectedRange.start.add(Duration(days: length));
    final proposedEnd = _selectedRange.end.add(Duration(days: length));

    // No permitir avanzar si el inicio propuesto está después de hoy
    if (proposedStart.isAfter(today)) {
      return;
    }

    // Siempre mantener el rango completo (no truncar al día de hoy)
    setState(() {
      _selectedRange = DateTimeRange(
        start: _normalizedDate(proposedStart),
        end: _normalizedDate(proposedEnd),
      );
    });
  }

  bool get _canGoForward {
    final length = _rangeLengthInDays;
    final today = _today;
    final proposedStart = _selectedRange.start.add(Duration(days: length));
    // Solo permitir avanzar si el inicio del siguiente rango no supera hoy
    return !proposedStart.isAfter(today);
  }

  Future<void> _pickDateRange() async {
    final l10n = AppLocalizations.of(context);
    final newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(_today.year - 5),
      lastDate: _today,
      initialDateRange: _selectedRange,
      helpText: l10n.statsRangePickerTitle,
    );
    if (newRange == null) {
      return;
    }

    final normalizedStart = _normalizedDate(newRange.start);
    final normalizedEnd = _normalizedDate(newRange.end);
    final inclusiveLength =
        normalizedEnd.difference(normalizedStart).inDays + 1;
    if (inclusiveLength > 30) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.statsRangeTooLongMessage)));
      return;
    }

    setState(() {
      _selectedRange = DateTimeRange(
        start: normalizedStart,
        end: normalizedEnd,
      );
    });
  }

  void _selectCategory(StatsCategory category) {
    if (_selectedCategory == category) {
      return;
    }
    setState(() {
      _selectedCategory = category;
      _selectedMetricId = null;
    });
  }

  void _selectMetric(String metricId) {
    setState(() {
      _selectedMetricId = metricId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rangeStart = _selectedRange.start;
    final rangeEnd = _selectedRange.end;
    final rangeDays = _rangeDays;

    final header = _StatsHeader(
      accentColor: widget.accentColor,
      category: _selectedCategory,
      onCategoryChanged: _selectCategory,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      canGoForward: _canGoForward,
      onPreviousRange: _goToPreviousRange,
      onNextRange: _goToNextRange,
      onRangeTap: _pickDateRange,
      mode: _mode,
      onModeChanged: (StatsMode newMode) {
        setState(() {
          _mode = newMode;
        });
      },
    );

    // Key única para forzar animación cuando cambie el rango o modo
    final contentKey = ValueKey(
      '${_mode.name}_${rangeStart.toIso8601String()}_${rangeEnd.toIso8601String()}_${_selectedCategory.name}',
    );

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.02, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _mode == StatsMode.period
                    ? _CategoryContent(
                        key: contentKey,
                        category: _selectedCategory,
                        accentColor: widget.accentColor,
                        selectedMetricId: _selectedMetricId,
                        onMetricSelected: _selectMetric,
                        days: rangeDays,
                        rangeStart: rangeStart,
                        rangeEnd: rangeEnd,
                      )
                    : _HistoryStatsView(
                        key: contentKey,
                        category: _selectedCategory,
                        accentColor: widget.accentColor,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({
    required this.accentColor,
    required this.mode,
    required this.onModeChanged,
    required this.category,
    required this.onCategoryChanged,
    required this.rangeStart,
    required this.rangeEnd,
    required this.canGoForward,
    required this.onPreviousRange,
    required this.onNextRange,
    required this.onRangeTap,
  });

  final Color accentColor;
  final StatsMode mode;
  final ValueChanged<StatsMode> onModeChanged;
  final StatsCategory category;
  final ValueChanged<StatsCategory> onCategoryChanged;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final bool canGoForward;
  final VoidCallback onPreviousRange;
  final VoidCallback onNextRange;
  final VoidCallback onRangeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = l10n.localeName;
    final rangeFormatter = DateFormat('d MMM', locale);
    final rangeText =
        '${rangeFormatter.format(rangeStart)} - ${rangeFormatter.format(rangeEnd)}';

    final categories = const [
      StatsCategory.feeding,
      StatsCategory.diapers,
      StatsCategory.bath,
      StatsCategory.vomit,
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Segmented Button para cambiar entre Período e Historial
          SegmentedButton<StatsMode>(
            segments: const [
              ButtonSegment<StatsMode>(
                value: StatsMode.period,
                label: Text('Período'),
                icon: Icon(Icons.calendar_month, size: 18),
              ),
              ButtonSegment<StatsMode>(
                value: StatsMode.history,
                label: Text('Historial'),
                icon: Icon(Icons.insights, size: 18),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (Set<StatsMode> newSelection) {
              onModeChanged(newSelection.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return accentColor.withValues(alpha: 0.2);
                }
                return AppColors.surface;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return accentColor;
                }
                return Colors.white70;
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Categorías (siempre visibles)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((item) {
                final isSelected = category == item;
                final label = () {
                  switch (item) {
                    case StatsCategory.feeding:
                      return l10n.statsCategoryFeeding;
                    case StatsCategory.diapers:
                      return l10n.statsCategoryDiapers;
                    case StatsCategory.bath:
                      return l10n.statsCategoryBath;
                    case StatsCategory.vomit:
                      return l10n.statsCategoryVomit;
                  }
                }();
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 18,
                          color: isSelected ? accentColor : Colors.white70,
                        ),
                        const SizedBox(width: 8),
                        Text(label),
                      ],
                    ),
                    onSelected: (_) => onCategoryChanged(item),
                    selectedColor: accentColor.withValues(alpha: 0.18),
                    backgroundColor: AppColors.surface,
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected ? accentColor : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Selector de rango (solo visible en modo Período)
          if (mode == StatsMode.period)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Botón rango anterior
                  IconButton(
                    onPressed: onPreviousRange,
                    icon: const Icon(LucideIcons.chevronLeft, size: 18),
                    color: Colors.white.withValues(alpha: 0.8),
                    tooltip: l10n.statsWeekPreviousTooltip,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Rango central (clickable)
                  Expanded(
                    child: InkWell(
                      onTap: onRangeTap,
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
                                rangeText,
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

                  // Botón rango siguiente
                  IconButton(
                    onPressed: canGoForward ? onNextRange : null,
                    icon: const Icon(LucideIcons.chevronRight, size: 18),
                    color: canGoForward
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.3),
                    tooltip: l10n.statsWeekNextTooltip,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(36, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryContent extends ConsumerWidget {
  const _CategoryContent({
    super.key,
    required this.category,
    required this.accentColor,
    required this.selectedMetricId,
    required this.onMetricSelected,
    required this.days,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final StatsCategory category;
  final Color accentColor;
  final String? selectedMetricId;
  final ValueChanged<String> onMetricSelected;
  final List<DateTime> days;
  final DateTime rangeStart;
  final DateTime rangeEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (category) {
      case StatsCategory.feeding:
        final asyncEntries = ref.watch(feedingEntriesProvider);
        return asyncEntries.when(
          data: (entries) {
            return _StatsContent(
              accentColor: accentColor,
              metrics: _buildFeedingMetrics(
                context,
                entries,
                days,
                rangeStart,
                rangeEnd,
              ),
              selectedMetricId: selectedMetricId,
              onMetricSelected: onMetricSelected,
            );
          },
          error: (error, stackTrace) => _StatsError(message: '$error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      case StatsCategory.diapers:
        final asyncEntries = ref.watch(stoolEntriesProvider);
        return asyncEntries.when(
          data: (entries) {
            return _StatsContent(
              accentColor: accentColor,
              metrics: _buildDiaperMetrics(
                context,
                entries,
                days,
                rangeStart,
                rangeEnd,
              ),
              selectedMetricId: selectedMetricId,
              onMetricSelected: onMetricSelected,
            );
          },
          error: (error, stackTrace) => _StatsError(message: '$error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      case StatsCategory.bath:
        final asyncEntries = ref.watch(bathEntriesProvider);
        return asyncEntries.when(
          data: (entries) {
            return _StatsContent(
              accentColor: accentColor,
              metrics: _buildBathMetrics(
                context,
                entries,
                days,
                rangeStart,
                rangeEnd,
              ),
              selectedMetricId: selectedMetricId,
              onMetricSelected: onMetricSelected,
            );
          },
          error: (error, stackTrace) => _StatsError(message: '$error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      case StatsCategory.vomit:
        final asyncEntries = ref.watch(vomitEntriesProvider);
        return asyncEntries.when(
          data: (entries) {
            return _StatsContent(
              accentColor: accentColor,
              metrics: _buildVomitMetrics(
                context,
                entries,
                days,
                rangeStart,
                rangeEnd,
              ),
              selectedMetricId: selectedMetricId,
              onMetricSelected: onMetricSelected,
            );
          },
          error: (error, stackTrace) => _StatsError(message: '$error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
    }
  }

  List<WeeklyMetric> _buildFeedingMetrics(
    BuildContext context,
    List<FeedingEntry> entries,
    List<DateTime> days,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.decimalPattern(locale);
    final averageFormat = NumberFormat('#,##0.0', locale);
    final rangeEndExclusive = rangeEnd.add(const Duration(days: 1));

    final weekEntries = entries.where((entry) {
      final timestamp = entry.timestamp;
      return !timestamp.isBefore(rangeStart) &&
          timestamp.isBefore(rangeEndExclusive);
    }).toList();

    final counts = days.map((day) {
      final count = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .length
          .toDouble();
      return DailyMetricPoint(date: day, value: count);
    }).toList();

    final volumes = days.map((day) {
      final total = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .fold<double>(0, (sum, entry) => sum + entry.amountMl);
      return DailyMetricPoint(date: day, value: total);
    }).toList();

    final totalFeedings = counts.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );
    final totalVolume = volumes.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );

    final metrics = <WeeklyMetric>[
      WeeklyMetric(
        id: 'feedings_count',
        title: l10n.statsFeedingCountTitle,
        icon: LucideIcons.hash,
        unitSuffix: 'x',
        points: counts,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricTotalLabel,
            value: '${numberFormat.format(totalFeedings)}x',
          ),
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value:
                '${_formatAverage(totalFeedings / days.length, numberFormat, averageFormat)}x',
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisTimes,
      ),
      WeeklyMetric(
        id: 'feedings_volume',
        title: l10n.statsFeedingVolumeTitle,
        icon: LucideIcons.cupSoda,
        unitSuffix: ' ml',
        points: volumes,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricTotalLabel,
            value: '${numberFormat.format(totalVolume)} ml',
          ),
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value:
                '${_formatAverage(totalVolume / days.length, numberFormat, averageFormat)} ml',
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisVolume,
      ),
    ];

    return metrics;
  }

  List<WeeklyMetric> _buildDiaperMetrics(
    BuildContext context,
    List<StoolEntry> entries,
    List<DateTime> days,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.decimalPattern(locale);
    final averageFormat = NumberFormat('#,##0.0', locale);
    final rangeEndExclusive = rangeEnd.add(const Duration(days: 1));

    final weekEntries = entries.where((entry) {
      final timestamp = entry.timestamp;
      return !timestamp.isBefore(rangeStart) &&
          timestamp.isBefore(rangeEndExclusive);
    }).toList();

    final counts = days.map((day) {
      final count = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .length
          .toDouble();
      return DailyMetricPoint(date: day, value: count);
    }).toList();

    final consistencyValues = days.map((day) {
      final dayEntries = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .toList();
      if (dayEntries.isEmpty) {
        return DailyMetricPoint(date: day, value: 0, hasValue: false);
      }
      final averageValue =
          dayEntries
              .map((entry) => _consistencyScore(entry.consistency))
              .fold<double>(0, (sum, value) => sum + value) /
          dayEntries.length;
      return DailyMetricPoint(date: day, value: averageValue);
    }).toList();

    final totalChanges = counts.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );
    final allConsistencyValues = weekEntries
        .map((entry) => _consistencyScore(entry.consistency))
        .toList();
    final double weeklyAverage = allConsistencyValues.isEmpty
        ? 0
        : allConsistencyValues.reduce((a, b) => a + b) /
              allConsistencyValues.length;

    final dominantConsistency = _dominantConsistency(weekEntries);

    final metrics = <WeeklyMetric>[
      WeeklyMetric(
        id: 'diapers_count',
        title: l10n.statsDiaperCountTitle,
        icon: LucideIcons.sparkles,
        unitSuffix: 'x',
        points: counts,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricTotalLabel,
            value: '${numberFormat.format(totalChanges)}x',
          ),
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value:
                '${_formatAverage(totalChanges / days.length, numberFormat, averageFormat)}x',
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisTimes,
      ),
      WeeklyMetric(
        id: 'diapers_consistency',
        title: l10n.statsDiaperConsistencyTitle,
        icon: LucideIcons.gauge,
        unitSuffix: '',
        points: consistencyValues,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value: _consistencyLabelFromScore(weeklyAverage, l10n),
          ),
          MetricSummary(
            label: l10n.statsMetricDominantLabel,
            value: dominantConsistency == null
                ? l10n.statsMetricEmptyValue
                : _consistencyLabel(dominantConsistency, l10n),
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisConsistency,
        maxValueOverride: 3,
        valueLabelBuilder: (point) {
          if (!point.hasValue) {
            return l10n.statsMetricEmptyValue;
          }
          return _consistencyLabelFromScore(point.value, l10n);
        },
      ),
    ];

    return metrics;
  }

  List<WeeklyMetric> _buildBathMetrics(
    BuildContext context,
    List<BathEntry> entries,
    List<DateTime> days,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.decimalPattern(locale);
    final averageFormat = NumberFormat('#,##0.0', locale);
    final rangeEndExclusive = rangeEnd.add(const Duration(days: 1));

    final rangeEntries = entries.where((entry) {
      final timestamp = entry.timestamp;
      return !timestamp.isBefore(rangeStart) &&
          timestamp.isBefore(rangeEndExclusive);
    }).toList();

    final counts = days.map((day) {
      final count = rangeEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .length
          .toDouble();
      return DailyMetricPoint(date: day, value: count);
    }).toList();

    final totalBaths = counts.fold<double>(0, (sum, item) => sum + item.value);
    final fullCount = rangeEntries
        .where((entry) => entry.type == BathType.full)
        .length
        .toDouble();
    final quickCount = rangeEntries
        .where((entry) => entry.type == BathType.quick)
        .length
        .toDouble();

    final metrics = <WeeklyMetric>[
      WeeklyMetric(
        id: 'baths_count',
        title: l10n.statsBathCountTitle,
        icon: LucideIcons.bath,
        unitSuffix: 'x',
        points: counts,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricTotalLabel,
            value: '${numberFormat.format(totalBaths)}x',
          ),
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value:
                '${_formatAverage(totalBaths / days.length, numberFormat, averageFormat)}x',
          ),
          MetricSummary(
            label: l10n.bathLogTypeFullOption,
            value: '${numberFormat.format(fullCount)}x',
          ),
          MetricSummary(
            label: l10n.bathLogTypeQuickOption,
            value: '${numberFormat.format(quickCount)}x',
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisTimes,
      ),
    ];

    return metrics;
  }

  List<WeeklyMetric> _buildVomitMetrics(
    BuildContext context,
    List<VomitEntry> entries,
    List<DateTime> days,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.decimalPattern(locale);
    final averageFormat = NumberFormat('#,##0.0', locale);
    final rangeEndExclusive = rangeEnd.add(const Duration(days: 1));

    final rangeEntries = entries.where((entry) {
      final timestamp = entry.timestamp;
      return !timestamp.isBefore(rangeStart) &&
          timestamp.isBefore(rangeEndExclusive);
    }).toList();

    final counts = days.map((day) {
      final count = rangeEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .length
          .toDouble();
      return DailyMetricPoint(date: day, value: count);
    }).toList();

    final intensityValues = days.map((day) {
      final dayEntries = rangeEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .toList();
      if (dayEntries.isEmpty) {
        return DailyMetricPoint(date: day, value: 0, hasValue: false);
      }
      final averageValue =
          dayEntries
              .map((entry) => _vomitScore(entry.amount))
              .fold<double>(0, (sum, value) => sum + value) /
          dayEntries.length;
      return DailyMetricPoint(date: day, value: averageValue);
    }).toList();

    final totalVomits = counts.fold<double>(0, (sum, item) => sum + item.value);
    final lowCount = rangeEntries
        .where((entry) => entry.amount == VomitAmount.low)
        .length
        .toDouble();
    final mediumCount = rangeEntries
        .where((entry) => entry.amount == VomitAmount.medium)
        .length
        .toDouble();
    final highCount = rangeEntries
        .where((entry) => entry.amount == VomitAmount.high)
        .length
        .toDouble();
    final allScores = rangeEntries
        .map((entry) => _vomitScore(entry.amount))
        .toList();
    final averageScore = allScores.isEmpty
        ? 0.0
        : allScores.reduce((a, b) => a + b) / allScores.length;
    final dominantAmount = _dominantVomitAmount(rangeEntries);

    final metrics = <WeeklyMetric>[
      WeeklyMetric(
        id: 'vomits_count',
        title: l10n.statsVomitCountTitle,
        icon: LucideIcons.triangleAlert,
        unitSuffix: 'x',
        points: counts,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricTotalLabel,
            value: '${numberFormat.format(totalVomits)}x',
          ),
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value:
                '${_formatAverage(totalVomits / days.length, numberFormat, averageFormat)}x',
          ),
          MetricSummary(
            label: l10n.vomitLogAmountHighOption,
            value: '${numberFormat.format(highCount)}x',
          ),
          MetricSummary(
            label: l10n.vomitLogAmountMediumOption,
            value: '${numberFormat.format(mediumCount)}x',
          ),
          MetricSummary(
            label: l10n.vomitLogAmountLowOption,
            value: '${numberFormat.format(lowCount)}x',
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisTimes,
      ),
      WeeklyMetric(
        id: 'vomits_intensity',
        title: l10n.statsVomitIntensityTitle,
        icon: LucideIcons.activity,
        unitSuffix: '',
        points: intensityValues,
        summaries: [
          MetricSummary(
            label: l10n.statsMetricDailyAverageLabel,
            value: _vomitLabelFromScore(averageScore, l10n),
          ),
          MetricSummary(
            label: l10n.statsMetricDominantLabel,
            value: dominantAmount == null
                ? l10n.statsMetricEmptyValue
                : _vomitLabel(dominantAmount, l10n),
          ),
        ],
        yAxisLabel: l10n.statsChartYAxisIntensity,
        maxValueOverride: 3,
        valueLabelBuilder: (point) {
          if (!point.hasValue) {
            return l10n.statsMetricEmptyValue;
          }
          return _vomitLabelFromScore(point.value, l10n);
        },
      ),
    ];

    return metrics;
  }

  double _consistencyScore(StoolConsistency consistency) {
    switch (consistency) {
      case StoolConsistency.liquid:
        return 1;
      case StoolConsistency.soft:
        return 2;
      case StoolConsistency.firm:
        return 3;
    }
  }

  StoolConsistency? _dominantConsistency(List<StoolEntry> entries) {
    if (entries.isEmpty) {
      return null;
    }
    final counts = <StoolConsistency, int>{};
    for (final entry in entries) {
      counts.update(entry.consistency, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  String _consistencyLabel(
    StoolConsistency consistency,
    AppLocalizations l10n,
  ) {
    switch (consistency) {
      case StoolConsistency.liquid:
        return l10n.statsConsistencyLiquid;
      case StoolConsistency.soft:
        return l10n.statsConsistencySoft;
      case StoolConsistency.firm:
        return l10n.statsConsistencyFirm;
    }
  }

  String _consistencyLabelFromScore(double score, AppLocalizations l10n) {
    if (score <= 1.5) {
      return l10n.statsConsistencyLiquid;
    }
    if (score < 2.5) {
      return l10n.statsConsistencySoft;
    }
    return l10n.statsConsistencyFirm;
  }

  double _vomitScore(VomitAmount amount) {
    switch (amount) {
      case VomitAmount.low:
        return 1.0;
      case VomitAmount.medium:
        return 2.0;
      case VomitAmount.high:
        return 3.0;
    }
  }

  VomitAmount? _dominantVomitAmount(List<VomitEntry> entries) {
    if (entries.isEmpty) {
      return null;
    }
    final counts = <VomitAmount, int>{};
    for (final entry in entries) {
      counts.update(entry.amount, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  String _vomitLabel(VomitAmount amount, AppLocalizations l10n) {
    switch (amount) {
      case VomitAmount.low:
        return l10n.vomitLogAmountLowOption;
      case VomitAmount.medium:
        return l10n.vomitLogAmountMediumOption;
      case VomitAmount.high:
        return l10n.vomitLogAmountHighOption;
    }
  }

  String _vomitLabelFromScore(double score, AppLocalizations l10n) {
    if (score <= 1.5) {
      return l10n.vomitLogAmountLowOption;
    }
    if (score < 2.5) {
      return l10n.vomitLogAmountMediumOption;
    }
    return l10n.vomitLogAmountHighOption;
  }

  String _formatAverage(
    double value,
    NumberFormat decimalFormat,
    NumberFormat averageFormat,
  ) {
    if (value == 0) {
      return '0';
    }
    final difference = (value - value.round()).abs();
    if (difference < 0.05) {
      return decimalFormat.format(value.round());
    }
    return averageFormat.format(value);
  }
}

class _StatsContent extends StatefulWidget {
  const _StatsContent({
    required this.accentColor,
    required this.metrics,
    required this.selectedMetricId,
    required this.onMetricSelected,
  });

  final Color accentColor;
  final List<WeeklyMetric> metrics;
  final String? selectedMetricId;
  final ValueChanged<String> onMetricSelected;

  @override
  State<_StatsContent> createState() => _StatsContentState();
}

class _StatsContentState extends State<_StatsContent> {
  String? _localSelection;

  @override
  void didUpdateWidget(covariant _StatsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.metrics != widget.metrics) {
      _localSelection = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final metrics = widget.metrics;
    if (metrics.isEmpty) {
      return Center(
        child: Text(
          l10n.statsEmptyState,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    final selectedId =
        widget.selectedMetricId ??
        _localSelection ??
        (metrics.isNotEmpty ? metrics.first.id : null);
    _localSelection = selectedId;

    final selectedMetric = metrics.firstWhere(
      (metric) => metric.id == selectedId,
      orElse: () => metrics.first,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < metrics.length; i++) ...[
              Expanded(
                child: _MetricCard(
                  metric: metrics[i],
                  isSelected: metrics[i].id == selectedId,
                  accentColor: widget.accentColor,
                  onTap: () {
                    widget.onMetricSelected(metrics[i].id);
                    setState(() {
                      _localSelection = metrics[i].id;
                    });
                  },
                ),
              ),
              if (i < metrics.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
        const SizedBox(height: 24),
        _MetricDetail(metric: selectedMetric, accentColor: widget.accentColor),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.metric,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  final WeeklyMetric metric;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? accentColor
        : AppColors.surface.withValues(alpha: 0.25);

    // Solo mostrar los primeros 2 summaries para mantener compacto
    final displaySummaries = metric.summaries.take(2).toList();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con icono y título
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: 0.18)
                        : AppColors.surface.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    metric.icon,
                    color: isSelected ? accentColor : Colors.white70,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    metric.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Valores principales (solo 2)
            ...displaySummaries.map((summary) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        summary.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      summary.value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Footer con indicador de selección
            if (displaySummaries.isNotEmpty) const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isSelected) ...[
                  Icon(LucideIcons.check, size: 14, color: accentColor),
                  const SizedBox(width: 4),
                  Text(
                    'Seleccionado',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Ver detalle',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 12,
                    color: Colors.white38,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricDetail extends StatelessWidget {
  const _MetricDetail({required this.metric, required this.accentColor});

  final WeeklyMetric metric;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Icon(metric.icon, color: accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  metric.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          WeeklyBarChart(
            points: metric.points,
            accentColor: accentColor,
            unitSuffix: metric.unitSuffix,
            yAxisLabel: metric.yAxisLabel,
            maxValueOverride: metric.maxValueOverride,
            valueLabelBuilder: metric.valueLabelBuilder,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LegendDot(
                color: accentColor,
                label: l10n.statsChartLegendSelected,
              ),
              const SizedBox(width: 16),
              _LegendDot(
                color: Colors.white54,
                dash: true,
                label: l10n.statsChartLegendTrend,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget para la vista de Historial General
class _HistoryStatsView extends ConsumerWidget {
  const _HistoryStatsView({
    super.key,
    required this.accentColor,
    required this.category,
  });

  final Color accentColor;
  final StatsCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card de Mapa de Calor
          _HeatMapCard(accentColor: accentColor, category: category),
          const SizedBox(height: 16),

          // Card de Tendencias
          _TrendsCard(accentColor: accentColor),
          const SizedBox(height: 16),

          // Card de Resumen Total
          _TotalSummaryCard(accentColor: accentColor),
        ],
      ),
    );
  }
}

// Mapa de Calor con datos reales
class _HeatMapCard extends ConsumerWidget {
  const _HeatMapCard({required this.accentColor, required this.category});

  final Color accentColor;
  final StatsCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // Obtener datos según la categoría
    final heatMapData = _calculateHeatMapData(ref, category);
    final maxCount = heatMapData.values.isEmpty
        ? 0
        : heatMapData.values.reduce((a, b) => a > b ? a : b);
    final peakHour = maxCount > 0
        ? heatMapData.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : -1;

    final categoryLabel = switch (category) {
      StatsCategory.feeding => l10n.statsCategoryFeeding,
      StatsCategory.diapers => l10n.statsCategoryDiapers,
      StatsCategory.bath => l10n.statsCategoryBath,
      StatsCategory.vomit => l10n.statsCategoryVomit,
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.flame, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mapa de calor - $categoryLabel',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Mapa de calor visual
          _HeatMapGrid(
            data: heatMapData,
            maxCount: maxCount,
            accentColor: accentColor,
          ),
          const SizedBox(height: 16),
          // Información del pico
          if (peakHour >= 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.trendingUp, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pico de actividad: ${peakHour.toString().padLeft(2, '0')}:00h ($maxCount eventos)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Map<int, int> _calculateHeatMapData(WidgetRef ref, StatsCategory category) {
    final Map<int, int> hourCounts = {};

    // Inicializar todas las horas en 0
    for (int i = 0; i < 24; i++) {
      hourCounts[i] = 0;
    }

    switch (category) {
      case StatsCategory.feeding:
        final entries = ref.watch(feedingEntriesProvider).value ?? [];
        for (final entry in entries) {
          final hour = entry.timestamp.hour;
          hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
        }
        break;
      case StatsCategory.diapers:
        final entries = ref.watch(stoolEntriesProvider).value ?? [];
        for (final entry in entries) {
          final hour = entry.timestamp.hour;
          hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
        }
        break;
      case StatsCategory.bath:
        final entries = ref.watch(bathEntriesProvider).value ?? [];
        for (final entry in entries) {
          final hour = entry.timestamp.hour;
          hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
        }
        break;
      case StatsCategory.vomit:
        final entries = ref.watch(vomitEntriesProvider).value ?? [];
        for (final entry in entries) {
          final hour = entry.timestamp.hour;
          hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
        }
        break;
    }

    return hourCounts;
  }
}

// Widget para visualizar el grid del mapa de calor
class _HeatMapGrid extends StatelessWidget {
  const _HeatMapGrid({
    required this.data,
    required this.maxCount,
    required this.accentColor,
  });

  final Map<int, int> data;
  final int maxCount;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int hour = 0; hour < 24; hour++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _HeatMapRow(
              hour: hour,
              count: data[hour] ?? 0,
              maxCount: maxCount,
              accentColor: accentColor,
            ),
          ),
      ],
    );
  }
}

// Fila individual del mapa de calor
class _HeatMapRow extends StatelessWidget {
  const _HeatMapRow({
    required this.hour,
    required this.count,
    required this.maxCount,
    required this.accentColor,
  });

  final int hour;
  final int count;
  final int maxCount;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intensity = maxCount > 0 ? count / maxCount : 0.0;
    final barColor = count == 0
        ? AppColors.scaffold
        : accentColor.withValues(alpha: 0.2 + (intensity * 0.8));

    return Row(
      children: [
        // Hora
        SizedBox(
          width: 40,
          child: Text(
            '${hour.toString().padLeft(2, '0')}h',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Barra de calor
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              if (count > 0)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        count.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: intensity > 0.5 ? Colors.white : accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// Card de Tendencias
class _TrendsCard extends ConsumerWidget {
  const _TrendsCard({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));
    final previous30Days = now.subtract(const Duration(days: 60));

    // Cargar datos
    final feedingsAsync = ref.watch(feedingEntriesProvider);
    final stoolsAsync = ref.watch(stoolEntriesProvider);
    final bathsAsync = ref.watch(bathEntriesProvider);
    final vomitsAsync = ref.watch(vomitEntriesProvider);

    if (feedingsAsync.isLoading ||
        stoolsAsync.isLoading ||
        bathsAsync.isLoading ||
        vomitsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final feedings = feedingsAsync.value ?? [];
    final stools = stoolsAsync.value ?? [];
    final baths = bathsAsync.value ?? [];
    final vomits = vomitsAsync.value ?? [];

    // Calcular métricas
    final trends = _calculateTrends(
      feedings: feedings,
      stools: stools,
      baths: baths,
      vomits: vomits,
      last30Days: last30Days,
      previous30Days: previous30Days,
      now: now,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.trendingUp, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Text(
                'Tendencias últimos 30 días',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (final trend in trends) ...[
            _TrendRow(trend: trend, accentColor: accentColor),
            if (trend != trends.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  List<_TrendData> _calculateTrends({
    required List<FeedingEntry> feedings,
    required List<StoolEntry> stools,
    required List<BathEntry> baths,
    required List<VomitEntry> vomits,
    required DateTime last30Days,
    required DateTime previous30Days,
    required DateTime now,
  }) {
    // Biberones
    final feedingsLast30 = feedings
        .where(
          (e) => e.timestamp.isAfter(last30Days) && e.timestamp.isBefore(now),
        )
        .length;
    final feedingsPrevious30 = feedings
        .where(
          (e) =>
              e.timestamp.isAfter(previous30Days) &&
              e.timestamp.isBefore(last30Days),
        )
        .length;
    final feedingsAvg = feedingsLast30 / 30;
    final feedingsTrend = _calculateTrendPercentage(
      feedingsLast30,
      feedingsPrevious30,
    );

    // Pañales
    final stoolsLast30 = stools
        .where(
          (e) => e.timestamp.isAfter(last30Days) && e.timestamp.isBefore(now),
        )
        .length;
    final stoolsPrevious30 = stools
        .where(
          (e) =>
              e.timestamp.isAfter(previous30Days) &&
              e.timestamp.isBefore(last30Days),
        )
        .length;
    final stoolsAvg = stoolsLast30 / 30;
    final stoolsTrend = _calculateTrendPercentage(
      stoolsLast30,
      stoolsPrevious30,
    );

    // Baños
    final bathsLast30 = baths
        .where(
          (e) => e.timestamp.isAfter(last30Days) && e.timestamp.isBefore(now),
        )
        .length;
    final bathsPrevious30 = baths
        .where(
          (e) =>
              e.timestamp.isAfter(previous30Days) &&
              e.timestamp.isBefore(last30Days),
        )
        .length;
    final bathsAvg = bathsLast30 / 30;
    final bathsTrend = _calculateTrendPercentage(bathsLast30, bathsPrevious30);

    // Vómitos
    final vomitsLast30 = vomits
        .where(
          (e) => e.timestamp.isAfter(last30Days) && e.timestamp.isBefore(now),
        )
        .length;
    final vomitsPrevious30 = vomits
        .where(
          (e) =>
              e.timestamp.isAfter(previous30Days) &&
              e.timestamp.isBefore(last30Days),
        )
        .length;
    final vomitsAvg = vomitsLast30 / 30;
    final vomitsTrend = _calculateTrendPercentage(
      vomitsLast30,
      vomitsPrevious30,
    );

    return [
      _TrendData(
        icon: LucideIcons.milk,
        label: 'Biberones',
        average: feedingsAvg,
        trend: feedingsTrend,
      ),
      _TrendData(
        icon: LucideIcons.baby,
        label: 'Cambios de pañal',
        average: stoolsAvg,
        trend: stoolsTrend,
      ),
      _TrendData(
        icon: LucideIcons.bath,
        label: 'Baños',
        average: bathsAvg,
        trend: bathsTrend,
      ),
      _TrendData(
        icon: LucideIcons.triangleAlert,
        label: 'Vómitos',
        average: vomitsAvg,
        trend: vomitsTrend,
      ),
    ];
  }

  double _calculateTrendPercentage(int current, int previous) {
    if (previous == 0) return current > 0 ? 100.0 : 0.0;
    return ((current - previous) / previous) * 100;
  }
}

class _TrendData {
  const _TrendData({
    required this.icon,
    required this.label,
    required this.average,
    required this.trend,
  });

  final IconData icon;
  final String label;
  final double average;
  final double trend;
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({required this.trend, required this.accentColor});

  final _TrendData trend;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = trend.trend > 0;
    final isNeutral = trend.trend.abs() < 5;
    final trendColor = isNeutral
        ? Colors.white.withValues(alpha: 0.6)
        : isPositive
        ? Colors.green
        : Colors.red;
    final trendIcon = isNeutral
        ? Icons.trending_flat
        : isPositive
        ? Icons.trending_up
        : Icons.trending_down;

    return Row(
      children: [
        Icon(trend.icon, size: 18, color: accentColor.withValues(alpha: 0.8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trend.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${trend.average.toStringAsFixed(1)}/día promedio',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(trendIcon, size: 16, color: trendColor),
            const SizedBox(width: 4),
            Text(
              isNeutral
                  ? 'Estable'
                  : '${trend.trend.abs().toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: trendColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Card de Resumen Total
class _TotalSummaryCard extends ConsumerWidget {
  const _TotalSummaryCard({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Cargar todos los datos
    final feedingsAsync = ref.watch(feedingEntriesProvider);
    final stoolsAsync = ref.watch(stoolEntriesProvider);
    final bathsAsync = ref.watch(bathEntriesProvider);
    final vomitsAsync = ref.watch(vomitEntriesProvider);

    if (feedingsAsync.isLoading ||
        stoolsAsync.isLoading ||
        bathsAsync.isLoading ||
        vomitsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final feedings = feedingsAsync.value ?? [];
    final stools = stoolsAsync.value ?? [];
    final baths = bathsAsync.value ?? [];
    final vomits = vomitsAsync.value ?? [];

    // Calcular totales
    final totalFeedings = feedings.length;
    final totalStools = stools.length;
    final totalBaths = baths.length;
    final totalVomits = vomits.length;

    // Calcular días registrados
    final allTimestamps = [
      ...feedings.map((e) => e.timestamp),
      ...stools.map((e) => e.timestamp),
      ...baths.map((e) => e.timestamp),
      ...vomits.map((e) => e.timestamp),
    ];

    final daysWithRecords = allTimestamps.isEmpty
        ? 0
        : _calculateUniqueDays(allTimestamps);

    final firstRecord = allTimestamps.isEmpty
        ? null
        : allTimestamps.reduce((a, b) => a.isBefore(b) ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Text(
                'Resumen total',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Días registrados
          _SummaryItem(
            icon: Icons.calendar_today,
            label: 'Días registrados',
            value: daysWithRecords.toString(),
            accentColor: accentColor,
          ),
          if (firstRecord != null) ...[
            const SizedBox(height: 12),
            _SummaryItem(
              icon: Icons.history,
              label: 'Primer registro',
              value: _formatDate(firstRecord),
              accentColor: accentColor,
            ),
          ],
          const Divider(height: 24),
          // Totales por categoría
          _SummaryItem(
            icon: LucideIcons.milk,
            label: 'Total biberones',
            value: totalFeedings.toString(),
            accentColor: accentColor,
          ),
          const SizedBox(height: 12),
          _SummaryItem(
            icon: LucideIcons.baby,
            label: 'Total cambios',
            value: totalStools.toString(),
            accentColor: accentColor,
          ),
          const SizedBox(height: 12),
          _SummaryItem(
            icon: LucideIcons.bath,
            label: 'Total baños',
            value: totalBaths.toString(),
            accentColor: accentColor,
          ),
          const SizedBox(height: 12),
          _SummaryItem(
            icon: LucideIcons.triangleAlert,
            label: 'Total vómitos',
            value: totalVomits.toString(),
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }

  int _calculateUniqueDays(List<DateTime> timestamps) {
    final uniqueDates = <String>{};
    for (final timestamp in timestamps) {
      final date =
          '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
      uniqueDates.add(date);
    }
    return uniqueDates.length;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Ayer';
    if (difference < 7) return 'Hace $difference días';
    if (difference < 30) return 'Hace ${(difference / 7).floor()} semanas';
    if (difference < 365) {
      return 'Hace ${(difference / 30).floor()} meses';
    }
    return 'Hace ${(difference / 365).floor()} años';
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: accentColor.withValues(alpha: 0.8)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: accentColor,
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    this.dash = false,
  });

  final Color color;
  final String label;
  final bool dash;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CustomPaint(
            painter: _LegendPainter(color: color, dash: dash),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _LegendPainter extends CustomPainter {
  _LegendPainter({required this.color, required this.dash});

  final Color color;
  final bool dash;

  @override
  void paint(Canvas canvas, Size size) {
    if (dash) {
      final dashWidth = 4.0;
      final dashSpace = 2.0;
      double startX = 0;
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, size.height / 2),
          Offset(math.min(startX + dashWidth, size.width), size.height / 2),
          paint,
        );
        startX += dashWidth + dashSpace;
      }
    } else {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LegendPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dash != dash;
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
        textAlign: TextAlign.center,
      ),
    );
  }
}
