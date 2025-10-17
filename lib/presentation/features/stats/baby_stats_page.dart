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
  StatsCategory _selectedCategory = StatsCategory.feeding;
  late DateTimeRange _selectedRange;
  String? _selectedMetricId;

  @override
  void initState() {
    super.initState();
    final today = _normalizedDate(DateTime.now());
    final start = _startOfWeek(today);
    final end = _endOfWeek(today);
    _selectedRange = DateTimeRange(
      start: start,
      end: end.isAfter(today) ? today : end,
    );
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
    if (proposedStart.isAfter(today)) {
      return;
    }
    final clampedEnd = proposedEnd.isAfter(today) ? today : proposedEnd;
    final clampedStart = proposedEnd.isAfter(today)
        ? today.subtract(Duration(days: length - 1))
        : proposedStart;
    setState(() {
      _selectedRange = DateTimeRange(
        start: _normalizedDate(clampedStart),
        end: _normalizedDate(clampedEnd),
      );
    });
  }

  bool get _canGoForward {
    return _selectedRange.end.isBefore(_today);
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
    final l10n = AppLocalizations.of(context);
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
    );

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            header,
            const SizedBox(height: 8),
            Expanded(
              child: _CategoryContent(
                category: _selectedCategory,
                accentColor: widget.accentColor,
                selectedMetricId: _selectedMetricId,
                onMetricSelected: _selectMetric,
                days: rangeDays,
                rangeStart: rangeStart,
                rangeEnd: rangeEnd,
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
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: onRangeTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.calendarRange,
                            size: 18,
                            color: accentColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l10n.statsWeekLabel(rangeText),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: l10n.statsWeekPreviousTooltip,
                    onPressed: onPreviousRange,
                    icon: const Icon(LucideIcons.chevronLeft),
                  ),
                  IconButton(
                    tooltip: l10n.statsWeekNextTooltip,
                    onPressed: canGoForward ? onNextRange : null,
                    icon: const Icon(LucideIcons.chevronRight),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryContent extends ConsumerWidget {
  const _CategoryContent({
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

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: 0.18)
                        : AppColors.surface.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    metric.icon,
                    color: isSelected ? accentColor : Colors.white70,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    metric.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  isSelected ? LucideIcons.check : LucideIcons.plus,
                  size: 18,
                  color: isSelected ? accentColor : Colors.white38,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...metric.summaries.map((summary) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        summary.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      summary.value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
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
