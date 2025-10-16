import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/feeding_entry.dart';
import '../../../domain/entities/stool_entry.dart';
import '../../../l10n/app_localizations.dart';
import '../../features/home/state/feeding_entries_provider.dart';
import '../../features/home/state/stool_entries_provider.dart';

part 'widgets/weekly_bar_chart.dart';

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime _startOfWeek(DateTime reference) {
  final normalized = DateTime(reference.year, reference.month, reference.day);
  return normalized.subtract(Duration(days: normalized.weekday - DateTime.monday));
}

DateTime _endOfWeek(DateTime reference) {
  final start = _startOfWeek(reference);
  return start.add(const Duration(days: 6));
}

enum StatsCategory {
  feeding,
  diapers,
}

extension StatsCategoryX on StatsCategory {
  IconData get icon {
    switch (this) {
      case StatsCategory.feeding:
        return LucideIcons.milk;
      case StatsCategory.diapers:
        return LucideIcons.baby;
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
  int _weekOffset = 0;
  String? _selectedMetricId;

  DateTime get _currentWeekDate {
    final today = DateTime.now();
    return today.add(Duration(days: _weekOffset * 7));
  }

  void _goToPreviousWeek() {
    setState(() {
      _weekOffset -= 1;
    });
  }

  void _goToNextWeek() {
    if (_weekOffset >= 0) {
      return;
    }
    setState(() {
      _weekOffset += 1;
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
    final weekStart = _startOfWeek(_currentWeekDate);
    final weekEnd = _endOfWeek(_currentWeekDate);
    final weekDays =
        List.generate(7, (index) => weekStart.add(Duration(days: index)));

    final header = _StatsHeader(
      accentColor: widget.accentColor,
      category: _selectedCategory,
      onCategoryChanged: _selectCategory,
      weekStart: weekStart,
      weekEnd: weekEnd,
      canGoForward: _weekOffset < 0,
      onPreviousWeek: _goToPreviousWeek,
      onNextWeek: _goToNextWeek,
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
                weekDays: weekDays,
                weekStart: weekStart,
                weekEnd: weekEnd,
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
    required this.weekStart,
    required this.weekEnd,
    required this.canGoForward,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final Color accentColor;
  final StatsCategory category;
  final ValueChanged<StatsCategory> onCategoryChanged;
  final DateTime weekStart;
  final DateTime weekEnd;
  final bool canGoForward;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = l10n.localeName;
    final rangeFormatter = DateFormat('d MMM', locale);
    final rangeText =
        '${rangeFormatter.format(weekStart)} - ${rangeFormatter.format(weekEnd)}';

    final categories = [StatsCategory.feeding, StatsCategory.diapers];

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
                final label = item == StatsCategory.feeding
                    ? l10n.statsCategoryFeeding
                    : l10n.statsCategoryDiapers;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(item.icon,
                            size: 18,
                            color: isSelected ? accentColor : Colors.white70),
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.statsWeekLabel(rangeText),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.statsWeekSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: l10n.statsWeekPreviousTooltip,
                    onPressed: onPreviousWeek,
                    icon: const Icon(LucideIcons.chevronLeft),
                  ),
                  IconButton(
                    tooltip: l10n.statsWeekNextTooltip,
                    onPressed: canGoForward ? onNextWeek : null,
                    icon: const Icon(LucideIcons.chevronRight),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _WeekdayStrip(accentColor: accentColor, weekStart: weekStart),
        ],
      ),
    );
  }
}

class _WeekdayStrip extends StatelessWidget {
  const _WeekdayStrip({required this.accentColor, required this.weekStart});

  final Color accentColor;
  final DateTime weekStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final today = DateTime.now();
    final days =
        List.generate(7, (index) => weekStart.add(Duration(days: index)));

    return Row(
      children: days.map((day) {
        final isToday = _isSameDay(day, today);
        final dayName = DateFormat('EEE', locale).format(day);
        final displayName = dayName.substring(0, 1).toUpperCase() + dayName.substring(1);
        return Expanded(
          child: Column(
            children: [
              Text(
                displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: isToday ? accentColor.withValues(alpha: 0.18) : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isToday ? accentColor : AppColors.outline,
                    width: 1.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _CategoryContent extends ConsumerWidget {
  const _CategoryContent({
    required this.category,
    required this.accentColor,
    required this.selectedMetricId,
    required this.onMetricSelected,
    required this.weekDays,
    required this.weekStart,
    required this.weekEnd,
  });

  final StatsCategory category;
  final Color accentColor;
  final String? selectedMetricId;
  final ValueChanged<String> onMetricSelected;
  final List<DateTime> weekDays;
  final DateTime weekStart;
  final DateTime weekEnd;

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
                weekDays,
                weekStart,
                weekEnd,
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
                weekDays,
                weekStart,
                weekEnd,
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
    List<DateTime> weekDays,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.decimalPattern(locale);
    final averageFormat = NumberFormat('#,##0.0', locale);
    final rangeEnd = weekEnd.add(const Duration(days: 1));

    final weekEntries = entries.where((entry) {
      final timestamp = entry.timestamp;
      return !timestamp.isBefore(weekStart) && timestamp.isBefore(rangeEnd);
    }).toList();

    final counts = weekDays.map((day) {
      final count = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .length
          .toDouble();
      return DailyMetricPoint(date: day, value: count);
    }).toList();

    final volumes = weekDays.map((day) {
      final total = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .fold<double>(0, (sum, entry) => sum + entry.amountMl);
      return DailyMetricPoint(date: day, value: total);
    }).toList();

    final totalFeedings = counts.fold<double>(0, (sum, item) => sum + item.value);
    final totalVolume = volumes.fold<double>(0, (sum, item) => sum + item.value);

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
                '${_formatAverage(totalFeedings / weekDays.length, numberFormat, averageFormat)}x',
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
                '${_formatAverage(totalVolume / weekDays.length, numberFormat, averageFormat)} ml',
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
    List<DateTime> weekDays,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final numberFormat = NumberFormat.decimalPattern(locale);
    final averageFormat = NumberFormat('#,##0.0', locale);
    final rangeEnd = weekEnd.add(const Duration(days: 1));

    final weekEntries = entries.where((entry) {
      final timestamp = entry.timestamp;
      return !timestamp.isBefore(weekStart) && timestamp.isBefore(rangeEnd);
    }).toList();

    final counts = weekDays.map((day) {
      final count = weekEntries
          .where((entry) => _isSameDay(entry.timestamp, day))
          .length
          .toDouble();
      return DailyMetricPoint(date: day, value: count);
    }).toList();

    final consistencyValues = weekDays.map((day) {
      final dayEntries =
          weekEntries.where((entry) => _isSameDay(entry.timestamp, day)).toList();
      if (dayEntries.isEmpty) {
        return DailyMetricPoint(date: day, value: 0, hasValue: false);
      }
      final averageValue = dayEntries
              .map((entry) => _consistencyScore(entry.consistency))
              .fold<double>(0, (sum, value) => sum + value) /
          dayEntries.length;
      return DailyMetricPoint(date: day, value: averageValue);
    }).toList();

    final totalChanges = counts.fold<double>(0, (sum, item) => sum + item.value);
    final allConsistencyValues = weekEntries
        .map((entry) => _consistencyScore(entry.consistency))
        .toList();
    final double weeklyAverage = allConsistencyValues.isEmpty
        ? 0
        : allConsistencyValues.reduce((a, b) => a + b) / allConsistencyValues.length;

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
                '${_formatAverage(totalChanges / weekDays.length, numberFormat, averageFormat)}x',
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

  String _consistencyLabel(StoolConsistency consistency, AppLocalizations l10n) {
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final selectedId = widget.selectedMetricId ??
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
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: metrics.map((metric) {
            final isSelected = metric.id == selectedId;
            return _MetricCard(
              metric: metric,
              isSelected: isSelected,
              accentColor: widget.accentColor,
              onTap: () {
                widget.onMetricSelected(metric.id);
                setState(() {
                  _localSelection = metric.id;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        _MetricDetail(
          metric: selectedMetric,
          accentColor: widget.accentColor,
        ),
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
    final borderColor =
        isSelected ? accentColor : AppColors.surface.withValues(alpha: 0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  metric.icon,
                  color: isSelected ? accentColor : Colors.white60,
                ),
                Icon(
                  isSelected ? LucideIcons.circleCheck : LucideIcons.circle,
                  size: 18,
                  color: isSelected ? accentColor : Colors.white24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              metric.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: metric.summaries.map((summary) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        summary.value,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.redAccent,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
