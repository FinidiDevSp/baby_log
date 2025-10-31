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
            child: Text(l10n.timelineLoadError, textAlign: TextAlign.center),
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

      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _TimelineTable(
              categories: categories,
              accentColor: widget.accentColor,
              hourFormat: hourFormat,
              selectedDate: _selectedDate,
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: DailyDateSelector(
                selectedDate: _selectedDate,
                onPreviousDay: () => _changeDay(-1),
                onNextDay: () => _changeDay(1),
                onSelectDate: _pickDate,
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

class _TimelineTable extends StatefulWidget {
  const _TimelineTable({
    required this.categories,
    required this.accentColor,
    required this.hourFormat,
    required this.selectedDate,
  });

  final List<_TimelineCategoryData> categories;
  final Color accentColor;
  final DateFormat hourFormat;
  final DateTime selectedDate;

  @override
  State<_TimelineTable> createState() => _TimelineTableState();
}

class _TimelineTableState extends State<_TimelineTable> {
  final ScrollController _scrollController = ScrollController();
  double? _rowHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentHour();
    });
  }

  @override
  void didUpdateWidget(_TimelineTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameCalendarDay(oldWidget.selectedDate, widget.selectedDate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentHour();
      });
    }
  }

  void _scrollToCurrentHour() {
    if (!mounted || _rowHeight == null) return;

    final now = DateTime.now();
    final isToday = _isSameCalendarDay(now, widget.selectedDate);

    if (isToday && _scrollController.hasClients) {
      final currentHour = now.hour;
      final targetPosition = (currentHour * _rowHeight!) - 100;

      final clampedPosition = targetPosition.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        clampedPosition,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.outline.withValues(alpha: 0.35);
    final now = DateTime.now();
    final isToday = _isSameCalendarDay(now, widget.selectedDate);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _TimelineHeaderRow(categories: widget.categories),
            // Body con scroll unificado
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;
                  final rowHeight = availableHeight / 24;

                  // Guardar rowHeight para scroll
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _rowHeight != rowHeight) {
                      setState(() {
                        _rowHeight = rowHeight;
                      });
                    }
                  });

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: 24,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, hour) {
                          return _TimelineRow(
                            hour: hour,
                            hourLabel: widget.hourFormat.format(
                              DateTime(0, 1, 1, hour),
                            ),
                            categories: widget.categories,
                            accentColor: widget.accentColor,
                            borderColor: borderColor,
                            isLast: hour == 23,
                            rowHeight: rowHeight,
                          );
                        },
                      ),
                      // Indicador de hora actual
                      if (isToday)
                        _CurrentTimeIndicatorOverlay(
                          scrollController: _scrollController,
                          currentHour: now.hour,
                          currentMinute: now.minute,
                          accentColor: widget.accentColor,
                          rowHeight: rowHeight,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
      return const SizedBox.shrink();
    }

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 3,
        runSpacing: 3,
        children: [
          for (final event in events)
            _TimelineDot(tooltip: event.tooltip, color: accentColor),
        ],
      ),
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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fila de encabezados de categorías
class _TimelineHeaderRow extends StatelessWidget {
  const _TimelineHeaderRow({required this.categories});

  final List<_TimelineCategoryData> categories;

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.outline.withValues(alpha: 0.35);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Celda de encabezado de hora
          Container(
            width: 44,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: borderColor)),
            ),
            child: Icon(
              Icons.schedule,
              size: 18,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          // Categorías - solo iconos
          for (final category in categories)
            Expanded(child: Icon(category.icon, size: 18, color: Colors.white)),
        ],
      ),
    );
  }
}

// Fila completa del timeline (hora + datos)
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.hour,
    required this.hourLabel,
    required this.categories,
    required this.accentColor,
    required this.borderColor,
    required this.isLast,
    required this.rowHeight,
  });

  final int hour;
  final String hourLabel;
  final List<_TimelineCategoryData> categories;
  final Color accentColor;
  final Color borderColor;
  final bool isLast;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = (rowHeight * 0.4).clamp(7.0, 10.0);

    return Container(
      height: rowHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: borderColor.withValues(alpha: 0.7)),
        ),
      ),
      child: Row(
        children: [
          // Celda de hora
          Container(
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(right: BorderSide(color: borderColor)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Center(
              child: Text(
                hourLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: fontSize,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Celdas de datos
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

class _CurrentTimeIndicatorOverlay extends StatefulWidget {
  const _CurrentTimeIndicatorOverlay({
    required this.scrollController,
    required this.currentHour,
    required this.currentMinute,
    required this.accentColor,
    required this.rowHeight,
  });

  final ScrollController scrollController;
  final int currentHour;
  final int currentMinute;
  final Color accentColor;
  final double rowHeight;

  @override
  State<_CurrentTimeIndicatorOverlay> createState() =>
      _CurrentTimeIndicatorOverlayState();
}

class _CurrentTimeIndicatorOverlayState
    extends State<_CurrentTimeIndicatorOverlay> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    setState(() {}); // Rebuild para actualizar la posición
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPosition =
        (widget.currentHour * widget.rowHeight) +
        (widget.currentMinute / 60 * widget.rowHeight);

    return Positioned(
      top: topPosition,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.accentColor,
                widget.accentColor.withValues(alpha: 0),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  ':${widget.currentMinute.toString().padLeft(2, '0')}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
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
  const _TimelineEvent({required this.timestamp, required this.tooltip});

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
