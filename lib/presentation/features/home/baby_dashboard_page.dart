import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/domain/entities/baby_profile.dart';
import 'package:baby_log/domain/entities/bath_entry.dart';
import 'package:baby_log/domain/entities/feeding_entry.dart';
import 'package:baby_log/domain/entities/stool_entry.dart';
import 'package:baby_log/domain/entities/temperature_entry.dart';
import 'package:baby_log/domain/entities/vomit_entry.dart';
import 'package:baby_log/domain/entities/pediatrician_question.dart';
import 'package:baby_log/l10n/app_localizations.dart';
import 'package:baby_log/presentation/features/baby_form/baby_form_page.dart';
import 'package:baby_log/presentation/features/questions/pediatrician_questions_page.dart';
import 'package:baby_log/presentation/widgets/baby_avatar.dart';

import 'state/bath_entries_provider.dart';
import 'state/feeding_entries_provider.dart';
import 'state/stool_entries_provider.dart';
import 'state/temperature_entries_provider.dart';
import 'state/vomit_entries_provider.dart';
import '../baths/bath_log_page.dart';
import '../diapers/stool_log_page.dart';
import '../feedings/bottle_feeding_page.dart';
import '../questions/state/pediatrician_questions_provider.dart';
import '../temperatures/temperature_log_page.dart';
import '../vomits/vomit_log_page.dart';

const _stoolAccentColor = Color(0xFF4CAF50);
const _bathAccentColor = Color(0xFF2D81FF);
const _vomitAccentColor = Color(0xFF1ABC9C);
const _temperatureAccentColor = Color(0xFFFFA726);

/// Dashboard shown once a baby profile exists.
class BabyDashboardPage extends ConsumerStatefulWidget {
  const BabyDashboardPage({super.key, required this.baby});

  /// Active baby to render.
  final BabyProfile baby;

  @override
  ConsumerState<BabyDashboardPage> createState() => _BabyDashboardPageState();
}

class _BabyDashboardPageState extends ConsumerState<BabyDashboardPage> {
  int _currentIndex = 0;

  void _openBabyProfileEditor() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BabyFormPage(existingBaby: widget.baby),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = Color(widget.baby.accentColorValue);

    final pages = <Widget>[
      _BabyHomeView(accentColor: accentColor),
      const _PlaceholderView(
        icon: LucideIcons.chartBar,
        labelKey: 'dashboardNavStats',
      ),
      const _PlaceholderView(
        icon: LucideIcons.history,
        labelKey: 'dashboardNavTimeline',
      ),
      const _PlaceholderView(
        icon: LucideIcons.ruler,
        labelKey: 'dashboardNavDevelopment',
      ),
      const _PlaceholderView(
        icon: LucideIcons.userRound,
        labelKey: 'dashboardNavAccount',
      ),
    ];

    final destinations = [
      _NavigationDestination(
        icon: LucideIcons.house,
        label: l10n.dashboardNavHome,
      ),
      _NavigationDestination(
        icon: LucideIcons.chartBar,
        label: l10n.dashboardNavStats,
      ),
      _NavigationDestination(
        icon: LucideIcons.history,
        label: l10n.dashboardNavTimeline,
      ),
      _NavigationDestination(
        icon: LucideIcons.ruler,
        label: l10n.dashboardNavDevelopment,
      ),
      _NavigationDestination(
        icon: LucideIcons.userRound,
        label: l10n.dashboardNavAccount,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            GestureDetector(
              onTap: _openBabyProfileEditor,
              child: BabyAvatar(
                baby: widget.baby,
                accentColor: accentColor,
                size: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.baby.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
            tooltip: l10n.dashboardSearchTooltip,
          ),
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {},
            tooltip: l10n.dashboardNotificationsTooltip,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: accentColor.withValues(alpha: 0.18),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: destinations
            .map(
              (item) => NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon, color: accentColor),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BabyHomeView extends ConsumerStatefulWidget {
  const _BabyHomeView({required this.accentColor});

  final Color accentColor;

  @override
  ConsumerState<_BabyHomeView> createState() => _BabyHomeViewState();
}

class _BabyHomeViewState extends ConsumerState<_BabyHomeView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  Future<void> _openDayPicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );

    if (picked != null && !_isSameCalendarDay(picked, _selectedDate)) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  String? _formatElapsedTime(AppLocalizations l10n, DateTime? timestamp) {
    if (timestamp == null) {
      return null;
    }
    final now = DateTime.now();
    var difference = now.difference(timestamp);
    if (difference.isNegative) {
      difference = Duration.zero;
    }
    if (difference < const Duration(minutes: 1)) {
      return l10n.dashboardElapsedJustNow;
    }
    if (difference < const Duration(hours: 1)) {
      final minutes = difference.inMinutes;
      return l10n.dashboardElapsedMinutes(minutes);
    }
    if (difference < const Duration(days: 1)) {
      final hours = difference.inHours;
      return l10n.dashboardElapsedHours(hours);
    }
    final days = difference.inDays;
    return l10n.dashboardElapsedDays(days);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final feedingsAsync = ref.watch(feedingEntriesProvider);
    final stoolsAsync = ref.watch(stoolEntriesProvider);
    final vomitsAsync = ref.watch(vomitEntriesProvider);
    final bathsAsync = ref.watch(bathEntriesProvider);
    final temperaturesAsync = ref.watch(temperatureEntriesProvider);
    final questionsAsync = ref.watch(pediatricianQuestionsProvider);
    final feedings = feedingsAsync.value ?? const <FeedingEntry>[];
    final stools = stoolsAsync.value ?? const <StoolEntry>[];
    final vomits = vomitsAsync.value ?? const <VomitEntry>[];
    final baths = bathsAsync.value ?? const <BathEntry>[];
    final temperatures = temperaturesAsync.value ?? const <TemperatureEntry>[];
    final questions = questionsAsync.value ?? const <PediatricianQuestion>[];
    final pendingQuestionsCount = questions
        .where((question) => !question.isResolved)
        .length;
    String? questionsStatus;
    if (questionsAsync.value != null) {
      questionsStatus = pendingQuestionsCount > 0
          ? l10n.dashboardQuestionsPending(pendingQuestionsCount)
          : l10n.dashboardQuestionsAllClear;
    }
    final selectedFeedings = feedings
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .toList();
    final selectedStools = stools
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .toList();
    final selectedVomits = vomits
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .toList();
    final selectedBaths = baths
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .toList();
    final selectedTemperatures = temperatures
        .where((entry) => _isSameCalendarDay(entry.timestamp, _selectedDate))
        .toList();

    void openBottleForm() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BottleFeedingPage()));
    }

    void openStoolForm() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const StoolLogPage()));
    }

    void openVomitForm() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const VomitLogPage()));
    }

    void openBathForm() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const BathLogPage()));
    }

    void openTemperatureForm() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const TemperatureLogPage()));
    }

    void openQuestionsPage() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PediatricianQuestionsPage()),
      );
    }

    String? bottleStatus;
    if (feedings.isNotEmpty) {
      final latestFeeding = feedings.reduce(
        (previous, current) =>
            previous.timestamp.isAfter(current.timestamp) ? previous : current,
      );
      bottleStatus = _formatElapsedTime(l10n, latestFeeding.timestamp);
    }

    String? stoolStatus;
    if (stools.isNotEmpty) {
      final latestStool = stools.reduce(
        (previous, current) =>
            previous.timestamp.isAfter(current.timestamp) ? previous : current,
      );
      stoolStatus = _formatElapsedTime(l10n, latestStool.timestamp);
    }

    String? vomitStatus;
    if (vomits.isNotEmpty) {
      final latestVomit = vomits.reduce(
        (previous, current) =>
            previous.timestamp.isAfter(current.timestamp) ? previous : current,
      );
      vomitStatus = _formatElapsedTime(l10n, latestVomit.timestamp);
    }

    String? bathStatus;
    if (baths.isNotEmpty) {
      final latestBath = baths.reduce(
        (previous, current) =>
            previous.timestamp.isAfter(current.timestamp) ? previous : current,
      );
      bathStatus = _formatElapsedTime(l10n, latestBath.timestamp);
    }

    String? temperatureStatus;
    if (temperatures.isNotEmpty) {
      final latestTemperature = temperatures.reduce(
        (previous, current) =>
            previous.timestamp.isAfter(current.timestamp) ? previous : current,
      );
      temperatureStatus = _formatElapsedTime(l10n, latestTemperature.timestamp);
    }

    final hasEntries =
        selectedFeedings.isNotEmpty ||
        selectedStools.isNotEmpty ||
        selectedVomits.isNotEmpty ||
        selectedBaths.isNotEmpty ||
        selectedTemperatures.isNotEmpty;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        children: [
          _ShortcutCarousel(
            onBottleTap: openBottleForm,
            onStoolTap: openStoolForm,
            onVomitTap: openVomitForm,
            onBathTap: openBathForm,
            onTemperatureTap: openTemperatureForm,
            onQuestionsTap: openQuestionsPage,
            bottleStatus: bottleStatus,
            stoolStatus: stoolStatus,
            vomitStatus: vomitStatus,
            bathStatus: bathStatus,
            temperatureStatus: temperatureStatus,
            questionsStatus: questionsStatus,
          ),
          const SizedBox(height: 16),
          _TimelineCard(
            accentColor: widget.accentColor,
            feedings: selectedFeedings,
            stools: selectedStools,
            vomits: selectedVomits,
            baths: selectedBaths,
            temperatures: selectedTemperatures,
            selectedDate: _selectedDate,
            onSelectDate: _openDayPicker,
            onImport: () {},
            onExport: () {},
          ),
          const SizedBox(height: 16),
          if (!hasEntries)
            _EventsPlaceholder(description: l10n.homeEmptyDescription)
          else
            _DailyLogList(
              accentColor: widget.accentColor,
              feedings: selectedFeedings,
              stools: selectedStools,
              vomits: selectedVomits,
              baths: selectedBaths,
              temperatures: selectedTemperatures,
            ),
        ],
      ),
    );
  }
}

class _ShortcutCarousel extends StatelessWidget {
  const _ShortcutCarousel({
    required this.onBottleTap,
    required this.onStoolTap,
    required this.onVomitTap,
    required this.onBathTap,
    required this.onTemperatureTap,
    required this.onQuestionsTap,
    this.bottleStatus,
    this.stoolStatus,
    this.vomitStatus,
    this.bathStatus,
    this.temperatureStatus,
    this.questionsStatus,
  });

  final VoidCallback onBottleTap;
  final VoidCallback onStoolTap;
  final VoidCallback onVomitTap;
  final VoidCallback onBathTap;
  final VoidCallback onTemperatureTap;
  final VoidCallback onQuestionsTap;
  final String? bottleStatus;
  final String? stoolStatus;
  final String? vomitStatus;
  final String? bathStatus;
  final String? temperatureStatus;
  final String? questionsStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shortcuts = [
      _ShortcutData(
        color: const Color(0xFFF06292),
        icon: LucideIcons.milk,
        label: l10n.dashboardBottleLabel,
        onTap: onBottleTap,
        heroTag: 'bottle_shortcut',
        status: bottleStatus,
      ),
      _ShortcutData(
        color: const Color(0xFF4CAF50),
        icon: LucideIcons.toilet,
        label: l10n.dashboardDiaperLabel,
        onTap: onStoolTap,
        heroTag: 'stool_shortcut',
        status: stoolStatus,
      ),
      _ShortcutData(
        color: _vomitAccentColor,
        icon: LucideIcons.triangleAlert,
        label: l10n.dashboardVomitLabel,
        onTap: onVomitTap,
        heroTag: 'vomit_shortcut',
        status: vomitStatus,
      ),
      _ShortcutData(
        color: _bathAccentColor,
        icon: LucideIcons.bath,
        label: l10n.dashboardBathLabel,
        onTap: onBathTap,
        heroTag: 'bath_shortcut',
        status: bathStatus,
      ),
      _ShortcutData(
        color: _temperatureAccentColor,
        icon: LucideIcons.thermometer,
        label: l10n.dashboardTemperatureLabel,
        onTap: onTemperatureTap,
        heroTag: 'temperature_shortcut',
        status: temperatureStatus,
      ),
      _ShortcutData(
        color: const Color(0xFFFFC542),
        icon: LucideIcons.utensils,
        label: l10n.dashboardFoodLabel,
      ),
      _ShortcutData(
        color: const Color(0xFFAF52DE),
        icon: LucideIcons.calendarCheck,
        label: l10n.dashboardMedicalAgendaLabel,
      ),
      _ShortcutData(
        color: const Color(0xFF8E8CD8),
        icon: LucideIcons.messageCircleQuestionMark,
        label: l10n.dashboardPediatricQuestionsLabel,
        onTap: onQuestionsTap,
        heroTag: 'questions_shortcut',
        status: questionsStatus,
      ),
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final item = shortcuts[index];
          return _ShortcutButton(data: item);
        },
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({required this.data});

  final _ShortcutData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: data.onTap,
            child: _ShortcutCircle(data: data),
          ),
        ),
        const SizedBox(height: 3),
        SizedBox(
          width: 75,
          child: Column(
            children: [
              Text(
                data.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (data.status != null) ...[
                const SizedBox(height: 2),
                Text(
                  data.status!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ShortcutCircle extends StatelessWidget {
  const _ShortcutCircle({required this.data});

  final _ShortcutData data;

  @override
  Widget build(BuildContext context) {
    final circle = Ink(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
      child: Center(child: Icon(data.icon, size: 24, color: Colors.white)),
    );

    if (data.heroTag == null) {
      return circle;
    }

    return Hero(
      tag: data.heroTag!,
      child: Material(color: Colors.transparent, child: circle),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.feedings,
    required this.stools,
    required this.vomits,
    required this.baths,
    required this.temperatures,
    required this.accentColor,
    required this.selectedDate,
    required this.onSelectDate,
    this.onImport,
    this.onExport,
  });

  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;
  final Color accentColor;
  final DateTime selectedDate;
  final VoidCallback onSelectDate;
  final VoidCallback? onImport;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final localeName = l10n.localeName;
    final now = DateTime.now();
    final isToday = _isSameDay(now, selectedDate);
    final dateLabel = DateFormat('EEE, d MMM', localeName).format(selectedDate);
    final headerText = isToday
        ? '${l10n.dashboardTodayLabel}, $dateLabel'
        : dateLabel;
    final feedingsByHour = _groupFeedings(feedings);
    final stoolsByHour = _groupStools(stools);
    final vomitsByHour = _groupVomits(vomits);
    final bathsByHour = _groupBaths(baths);
    final temperaturesByHour = _groupTemperatures(temperatures);
    final tiles = List<_TimelineTileData>.generate(12, (index) {
      final hour = index * 2;
      return _TimelineTileData(
        hour: hour,
        background: _backgroundForHour(hour),
        icon: _iconForHour(hour),
        feedings: feedingsByHour[hour] ?? const [],
        stools: stoolsByHour[hour] ?? const [],
        vomits: vomitsByHour[hour] ?? const [],
        baths: bathsByHour[hour] ?? const [],
        temperatures: temperaturesByHour[hour] ?? const [],
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Tooltip(
                  message: l10n.dashboardChangeDayTooltip,
                  child: TextButton(
                    onPressed: onSelectDate,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      backgroundColor: AppColors.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            headerText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          LucideIcons.chevronDown,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _TimelineActionButton(
                icon: LucideIcons.import,
                tooltip: l10n.dashboardImportTooltip,
                onPressed: onImport,
              ),
              const SizedBox(width: 4),
              _TimelineActionButton(
                icon: LucideIcons.upload,
                tooltip: l10n.dashboardExportTooltip,
                onPressed: onExport,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        for (var i = 0; i < tiles.length; i++)
                          Expanded(
                            child: _TimelineTile(
                              data: tiles[i],
                              isLast: i == tiles.length - 1,
                              accentColor: accentColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        for (var i = 0; i < tiles.length; i++)
                          Expanded(
                            child: Center(
                              child: Text(
                                tiles[i].label,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _TimelineActionButton extends StatelessWidget {
  const _TimelineActionButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      tooltip: tooltip,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(8),
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      icon: Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.8)),
    );
  }
}

class _TimelineTileData {
  const _TimelineTileData({
    required this.hour,
    required this.background,
    this.icon,
    this.feedings = const [],
    this.stools = const [],
    this.vomits = const [],
    this.baths = const [],
    this.temperatures = const [],
  });

  final int hour;
  final Color background;
  final IconData? icon;
  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;

  String get label => hour.toString().padLeft(2, '0');
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.data,
    required this.isLast,
    required this.accentColor,
  });

  final _TimelineTileData data;
  final bool isLast;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data.background,
        border: Border(
          right: BorderSide(
            color: isLast
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          if (data.icon != null)
            Positioned(
              top: 6,
              left: 0,
              right: 0,
              child: Icon(
                data.icon,
                size: 14,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          if (data.feedings.isNotEmpty ||
              data.stools.isNotEmpty ||
              data.vomits.isNotEmpty ||
              data.baths.isNotEmpty ||
              data.temperatures.isNotEmpty)
            Positioned(
              bottom: 2,
              left: 0,
              right: 0,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (data.feedings.isNotEmpty)
                    _TimelineEventBadge(
                      icon: LucideIcons.milk,
                      count: data.feedings.length,
                      color: accentColor,
                    ),
                  if (data.stools.isNotEmpty)
                    _TimelineEventBadge(
                      icon: LucideIcons.toilet,
                      count: data.stools.length,
                      color: _stoolAccentColor,
                    ),
                  if (data.vomits.isNotEmpty)
                    _TimelineEventBadge(
                      icon: LucideIcons.triangleAlert,
                      count: data.vomits.length,
                      color: _vomitAccentColor,
                    ),
                  if (data.baths.isNotEmpty)
                    _TimelineEventBadge(
                      icon: LucideIcons.bath,
                      count: data.baths.length,
                      color: _bathAccentColor,
                    ),
                  if (data.temperatures.isNotEmpty)
                    _TimelineEventBadge(
                      icon: LucideIcons.thermometer,
                      count: data.temperatures.length,
                      color: _temperatureAccentColor,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineEventBadge extends StatelessWidget {
  const _TimelineEventBadge({
    required this.icon,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showCount = count > 1;

    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: EdgeInsets.symmetric(horizontal: showCount ? 6 : 0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: showCount
            ? Text(
                '$count',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(icon, size: 10, color: color),
      ),
    );
  }
}

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Map<int, List<FeedingEntry>> _groupFeedings(List<FeedingEntry> feedings) {
  final map = <int, List<FeedingEntry>>{};
  for (final entry in feedings) {
    final tileHour = (entry.timestamp.hour ~/ 2) * 2;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<StoolEntry>> _groupStools(List<StoolEntry> stools) {
  final map = <int, List<StoolEntry>>{};
  for (final entry in stools) {
    final tileHour = (entry.timestamp.hour ~/ 2) * 2;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<VomitEntry>> _groupVomits(List<VomitEntry> vomits) {
  final map = <int, List<VomitEntry>>{};
  for (final entry in vomits) {
    final tileHour = (entry.timestamp.hour ~/ 2) * 2;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<BathEntry>> _groupBaths(List<BathEntry> baths) {
  final map = <int, List<BathEntry>>{};
  for (final entry in baths) {
    final tileHour = (entry.timestamp.hour ~/ 2) * 2;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<TemperatureEntry>> _groupTemperatures(
  List<TemperatureEntry> temperatures,
) {
  final map = <int, List<TemperatureEntry>>{};
  for (final entry in temperatures) {
    final tileHour = (entry.timestamp.hour ~/ 2) * 2;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
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

Color _backgroundForHour(int hour) {
  if (hour < 6 || hour >= 22) {
    return const Color(0xFF13141D);
  }
  if ((hour >= 6 && hour < 8) || (hour >= 20 && hour < 22)) {
    return const Color(0xFF191B24);
  }
  if (hour >= 8 && hour < 18) {
    return const Color(0xFF20232C);
  }
  return const Color(0xFF181A23);
}

IconData? _iconForHour(int hour) {
  if (hour == 0 || hour == 22) {
    return LucideIcons.moonStar;
  }
  if (hour == 6) {
    return LucideIcons.sunrise;
  }
  if (hour == 12) {
    return LucideIcons.sunMedium;
  }
  if (hour == 20) {
    return LucideIcons.sunset;
  }
  return null;
}

class _EventsPlaceholder extends StatelessWidget {
  const _EventsPlaceholder({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.rockingChair,
            size: 44,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _DailyLogList extends StatefulWidget {
  const _DailyLogList({
    required this.feedings,
    required this.stools,
    required this.vomits,
    required this.baths,
    required this.temperatures,
    required this.accentColor,
  });

  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;
  final Color accentColor;

  @override
  State<_DailyLogList> createState() => _DailyLogListState();
}

class _DailyLogListState extends State<_DailyLogList>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.Hm(l10n.localeName);
    final totalMl = widget.feedings.fold<int>(
      0,
      (sum, entry) => sum + entry.amountMl,
    );
    final stoolCount = widget.stools.length;
    final vomitCount = widget.vomits.length;
    final bathCount = widget.baths.length;
    final temperatureCount = widget.temperatures.length;
    final latestTemperature = widget.temperatures.isEmpty
        ? null
        : widget.temperatures.reduce(
            (previous, current) => previous.timestamp.isAfter(current.timestamp)
                ? previous
                : current,
          );
    final temperatureSummaryValue = latestTemperature == null
        ? '0 · ${l10n.temperatureLogValueUnit}'
        : '$temperatureCount · ${latestTemperature.celsius.toStringAsFixed(1)} ${l10n.temperatureLogValueUnit}';
    final entries = [
      ...widget.feedings.map(_DailyLogEntry.feeding),
      ...widget.stools.map(_DailyLogEntry.stool),
      ...widget.vomits.map(_DailyLogEntry.vomit),
      ...widget.baths.map(_DailyLogEntry.bath),
      ...widget.temperatures.map(_DailyLogEntry.temperature),
    ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final summaryItems = [
      _SummaryData(
        icon: LucideIcons.milk,
        label: l10n.dashboardBottleLabel,
        value: '$totalMl',
      ),
      _SummaryData(
        icon: LucideIcons.toilet,
        label: l10n.dashboardDiaperLabel,
        value: stoolCount.toString(),
      ),
      _SummaryData(
        icon: LucideIcons.bath,
        label: l10n.dashboardBathLabel,
        value: bathCount.toString(),
      ),
      _SummaryData(
        icon: LucideIcons.triangleAlert,
        label: l10n.dashboardVomitLabel,
        value: vomitCount.toString(),
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homeLogListTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < summaryItems.length; i++) ...[
                Expanded(child: _SummaryBadge(data: summaryItems[i])),
                if (i != summaryItems.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ListView.separated(
                      itemCount: entries.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => Divider(
                        height: 14,
                        thickness: 1,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final timeLabel = dateFormat.format(entry.timestamp);

                        switch (entry.type) {
                          case _DailyLogType.feeding:
                            final feeding = entry.feeding!;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: widget.accentColor.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LucideIcons.milk,
                                    size: 18,
                                    color: widget.accentColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeLabel,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${feeding.amountMl} ${l10n.bottleLogAmountUnit}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if ((feeding.notes ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          feeding.notes!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          case _DailyLogType.stool:
                            final stool = entry.stool!;
                            final description = _stoolDescription(
                              l10n,
                              stool.consistency,
                            );
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: _stoolAccentColor.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.toilet,
                                    size: 18,
                                    color: _stoolAccentColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeLabel,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        description,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if ((stool.notes ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          stool.notes!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          case _DailyLogType.vomit:
                            final vomit = entry.vomit!;
                            final description = _vomitDescription(
                              l10n,
                              vomit.amount,
                            );
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: _vomitAccentColor.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.triangleAlert,
                                    size: 18,
                                    color: _vomitAccentColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeLabel,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        description,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if ((vomit.notes ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          vomit.notes!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          case _DailyLogType.bath:
                            final bath = entry.bath!;
                            final description = _bathDescription(
                              l10n,
                              bath.type,
                            );
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: _bathAccentColor.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.bath,
                                    size: 18,
                                    color: _bathAccentColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeLabel,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        description,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if ((bath.notes ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          bath.notes!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                          case _DailyLogType.temperature:
                            final temperature = entry.temperature!;
                            final valueLabel =
                                '${temperature.celsius.toStringAsFixed(1)} ${l10n.temperatureLogValueUnit}';
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: _temperatureAccentColor.withValues(
                                      alpha: 0.18,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.thermometer,
                                    size: 18,
                                    color: _temperatureAccentColor,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeLabel,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        valueLabel,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      if ((temperature.notes ?? '')
                                          .isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          temperature.notes!,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.white70),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

enum _DailyLogType { feeding, stool, vomit, bath, temperature }

class _DailyLogEntry {
  _DailyLogEntry.feeding(FeedingEntry entry)
    : feeding = entry,
      stool = null,
      vomit = null,
      bath = null,
      temperature = null,
      type = _DailyLogType.feeding,
      timestamp = entry.timestamp;

  _DailyLogEntry.stool(StoolEntry entry)
    : feeding = null,
      stool = entry,
      vomit = null,
      bath = null,
      temperature = null,
      type = _DailyLogType.stool,
      timestamp = entry.timestamp;

  _DailyLogEntry.vomit(VomitEntry entry)
    : feeding = null,
      stool = null,
      vomit = entry,
      bath = null,
      temperature = null,
      type = _DailyLogType.vomit,
      timestamp = entry.timestamp;

  _DailyLogEntry.bath(BathEntry entry)
    : feeding = null,
      stool = null,
      vomit = null,
      bath = entry,
      temperature = null,
      type = _DailyLogType.bath,
      timestamp = entry.timestamp;

  _DailyLogEntry.temperature(TemperatureEntry entry)
    : feeding = null,
      stool = null,
      vomit = null,
      bath = null,
      temperature = entry,
      type = _DailyLogType.temperature,
      timestamp = entry.timestamp;

  final FeedingEntry? feeding;
  final StoolEntry? stool;
  final VomitEntry? vomit;
  final BathEntry? bath;
  final TemperatureEntry? temperature;
  final _DailyLogType type;
  final DateTime timestamp;
}

class _SummaryData {
  const _SummaryData({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _SummaryBadge extends StatelessWidget {
  const _SummaryBadge({required this.data});

  final _SummaryData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      label: data.label,
      value: data.value,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                data.icon,
                size: 18,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 8),
              Text(
                data.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.icon, required this.labelKey});

  final IconData icon;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = _resolveLabel(l10n, labelKey);

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.white.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  String _resolveLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'dashboardNavStats':
        return l10n.dashboardNavStats;
      case 'dashboardNavTimeline':
        return l10n.dashboardNavTimeline;
      case 'dashboardNavDevelopment':
        return l10n.dashboardNavDevelopment;
      case 'dashboardNavAccount':
        return l10n.dashboardNavAccount;
      default:
        return l10n.dashboardNavHome;
    }
  }
}

class _NavigationDestination {
  const _NavigationDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _ShortcutData {
  const _ShortcutData({
    required this.color,
    required this.icon,
    required this.label,
    this.onTap,
    this.heroTag,
    this.status,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? heroTag;
  final String? status;
}
