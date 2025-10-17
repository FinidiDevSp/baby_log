import 'dart:math' as math;
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:baby_log/core/providers.dart';
import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/domain/entities/baby_profile.dart';
import 'package:baby_log/domain/entities/bath_entry.dart';
import 'package:baby_log/domain/entities/feeding_entry.dart';
import 'package:baby_log/domain/entities/medical_appointment.dart';
import 'package:baby_log/domain/entities/stool_entry.dart';
import 'package:baby_log/domain/entities/temperature_entry.dart';
import 'package:baby_log/domain/entities/vomit_entry.dart';
import 'package:baby_log/domain/entities/pediatrician_question.dart';
import 'package:baby_log/l10n/app_localizations.dart';
import 'package:baby_log/presentation/features/baby_form/baby_form_page.dart';
import 'package:baby_log/presentation/features/agenda/medical_agenda_page.dart';
import 'package:baby_log/presentation/features/account/account_settings_view.dart';
import 'package:baby_log/presentation/features/questions/pediatrician_questions_page.dart';
import 'package:baby_log/presentation/widgets/baby_avatar.dart';

import 'state/bath_entries_provider.dart';
import 'state/feeding_entries_provider.dart';
import 'state/stool_entries_provider.dart';
import 'state/temperature_entries_provider.dart';
import 'state/vomit_entries_provider.dart';
import '../agenda/state/medical_appointments_controller.dart';
import '../baths/bath_log_page.dart';
import '../diapers/stool_log_page.dart';
import '../feedings/bottle_feeding_page.dart';
import '../stats/baby_stats_page.dart';
import '../questions/state/pediatrician_questions_provider.dart';
import '../temperatures/temperature_log_page.dart';
import '../vomits/vomit_log_page.dart';

const _stoolAccentColor = Color(0xFF4CAF50);
const _bathAccentColor = Color(0xFF2D81FF);
const _vomitAccentColor = Color(0xFF1ABC9C);
const _temperatureAccentColor = Color(0xFFFFA726);
const _appointmentAccentColor = Color(0xFFAF52DE);
const double _timelineTileBaseHeight = 70.0;
const double _timelineMarkerSize = 18.0;
const double _timelineMarkerTop = 38.0;
const double _timelineMarkerSpacing = 20.0;

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

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
      BabyStatsPage(accentColor: accentColor),
      const _PlaceholderView(
        icon: LucideIcons.history,
        labelKey: 'dashboardNavTimeline',
      ),
      const _PlaceholderView(
        icon: LucideIcons.ruler,
        labelKey: 'dashboardNavDevelopment',
      ),
      AccountSettingsView(accentColor: accentColor),
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
  double _dayDragDelta = 0;
  bool _isDraggingDay = false;
  int _lastDayAnimationDirection = 0;

  Future<void> _handleImport() async {
    final l10n = AppLocalizations.of(context);

    try {
      final selection = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        withData: true,
      );

      if (selection == null || selection.files.isEmpty) {
        return;
      }

      final pickedFile = selection.files.first;
      final bytes = pickedFile.bytes;

      if (bytes == null) {
        throw StateError(l10n.dashboardImportReadError);
      }

      final importer = ref.read(csvImportServiceProvider);
      final result = await importer.importCsv(bytes);

      if (!mounted) {
        return;
      }

      final summary = l10n.dashboardImportSummary(result.total);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(summary)),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final errorMessage =
          error is StateError ? error.message : error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dashboardImportError(errorMessage))),
      );
    }
  }

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
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null && !_isSameCalendarDay(picked, _selectedDate)) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
        _lastDayAnimationDirection = 0;
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

  String? _resolveAgendaStatus(
    AppLocalizations l10n,
    List<MedicalAppointment> appointments, {
    required DateTime reference,
  }) {
    if (appointments.isEmpty) {
      return null;
    }
    final upcoming =
        appointments
            .where(
              (appointment) => !appointment.scheduledAt.isBefore(reference),
            )
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    if (upcoming.isEmpty) {
      return null;
    }
    final next = upcoming.first;
    final today = DateTime(reference.year, reference.month, reference.day);
    final nextDate = DateTime(
      next.scheduledAt.year,
      next.scheduledAt.month,
      next.scheduledAt.day,
    );
    final difference = nextDate.difference(today).inDays;
    if (difference <= 0) {
      return l10n.dashboardAgendaStatusToday;
    }
    if (difference == 1) {
      return l10n.dashboardAgendaStatusTomorrow;
    }
    return l10n.dashboardAgendaStatusInDays(difference);
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
      _lastDayAnimationDirection = delta;
    });
  }

  void _handleDayDragStart(DragStartDetails details) {
    _isDraggingDay = true;
    _dayDragDelta = 0;
  }

  void _handleDayDragUpdate(DragUpdateDetails details) {
    if (!_isDraggingDay) {
      return;
    }
    _dayDragDelta += details.primaryDelta ?? 0;
  }

  void _handleDayDragEnd(DragEndDetails details) {
    if (!_isDraggingDay) {
      return;
    }
    final threshold = 60.0;
    if (_dayDragDelta.abs() > threshold) {
      _changeDay(_dayDragDelta < 0 ? 1 : -1);
    }
    _isDraggingDay = false;
    _dayDragDelta = 0;
  }

  void _handleDayDragCancel() {
    _isDraggingDay = false;
    _dayDragDelta = 0;
  }

  Widget _buildDayTransition(
    Widget child,
    Animation<double> animation,
    ValueKey<DateTime> currentKey,
  ) {
    final direction = _lastDayAnimationDirection;
    if (direction == 0) {
      return FadeTransition(opacity: animation, child: child);
    }
    final isIncoming = child.key == currentKey;
    final horizontalOffset = direction > 0
        ? (isIncoming ? 1.0 : -1.0)
        : (isIncoming ? -1.0 : 1.0);
    final curvedAnimation = animation.drive(
      CurveTween(curve: Curves.easeInOutCubic),
    );
    final slideAnimation = Tween<Offset>(
      begin: Offset(horizontalOffset, 0),
      end: Offset.zero,
    ).animate(curvedAnimation);
    final fadeAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(curvedAnimation);
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(opacity: fadeAnimation, child: child),
    );
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
    final appointments = ref.watch(medicalAppointmentsProvider);
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
    final selectedAppointments = appointments
        .where((entry) => _isSameCalendarDay(entry.scheduledAt, _selectedDate))
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

    final agendaStatus = _resolveAgendaStatus(
      l10n,
      appointments,
      reference: DateTime.now(),
    );

    final hasEntries =
        selectedFeedings.isNotEmpty ||
        selectedStools.isNotEmpty ||
        selectedVomits.isNotEmpty ||
        selectedBaths.isNotEmpty ||
        selectedTemperatures.isNotEmpty ||
        selectedAppointments.isNotEmpty;

    final daySectionKey = ValueKey(_selectedDate);

    final dayContent = Column(
      key: daySectionKey,
      children: [
        _TimelineCard(
          accentColor: widget.accentColor,
          feedings: selectedFeedings,
          stools: selectedStools,
          vomits: selectedVomits,
          baths: selectedBaths,
          temperatures: selectedTemperatures,
          selectedDate: _selectedDate,
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
            appointments: selectedAppointments,
          ),
      ],
    );

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
            onAgendaTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MedicalAgendaPage()),
              );
            },
            onQuestionsTap: openQuestionsPage,
            bottleStatus: bottleStatus,
            stoolStatus: stoolStatus,
            vomitStatus: vomitStatus,
            bathStatus: bathStatus,
            temperatureStatus: temperatureStatus,
            agendaStatus: agendaStatus,
            questionsStatus: questionsStatus,
          ),
          const SizedBox(height: 12),
          _TimelineHeader(
            selectedDate: _selectedDate,
            onSelectDate: _openDayPicker,
            onImport: _handleImport,
            onExport: () {},
          ),
          const SizedBox(height: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: _handleDayDragStart,
            onHorizontalDragUpdate: _handleDayDragUpdate,
            onHorizontalDragEnd: _handleDayDragEnd,
            onHorizontalDragCancel: _handleDayDragCancel,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) =>
                  _buildDayTransition(child, animation, daySectionKey),
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    for (final child in previousChildren) child,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: dayContent,
            ),
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
    required this.onAgendaTap,
    required this.onQuestionsTap,
    this.bottleStatus,
    this.stoolStatus,
    this.vomitStatus,
    this.bathStatus,
    this.temperatureStatus,
    this.agendaStatus,
    this.questionsStatus,
  });

  final VoidCallback onBottleTap;
  final VoidCallback onStoolTap;
  final VoidCallback onVomitTap;
  final VoidCallback onBathTap;
  final VoidCallback onTemperatureTap;
  final VoidCallback onAgendaTap;
  final VoidCallback onQuestionsTap;
  final String? bottleStatus;
  final String? stoolStatus;
  final String? vomitStatus;
  final String? bathStatus;
  final String? temperatureStatus;
  final String? agendaStatus;
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
        color: _appointmentAccentColor,
        icon: LucideIcons.calendarCheck,
        label: l10n.dashboardMedicalAgendaLabel,
        onTap: onAgendaTap,
        heroTag: 'agenda_shortcut',
        status: agendaStatus,
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
        const SizedBox(height: 2),
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
    this.appointments = const <MedicalAppointment>[],
    required this.accentColor,
    required this.selectedDate,
  });

  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;
  final List<MedicalAppointment> appointments;
  final Color accentColor;
  final DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = _isSameDay(now, selectedDate);
    final feedingsByHour = _groupFeedings(feedings);
    final stoolsByHour = _groupStools(stools);
    final vomitsByHour = _groupVomits(vomits);
    final bathsByHour = _groupBaths(baths);
    final temperaturesByHour = _groupTemperatures(temperatures);
    final appointmentsByHour = _groupAppointments(appointments);
    final tiles = List<_TimelineTileData>.generate(24, (index) {
      final hour = index;
      final feedingsForHour = feedingsByHour[hour] ?? const <FeedingEntry>[];
      final stoolsForHour = stoolsByHour[hour] ?? const <StoolEntry>[];
      final vomitsForHour = vomitsByHour[hour] ?? const <VomitEntry>[];
      final bathsForHour = bathsByHour[hour] ?? const <BathEntry>[];
      final temperaturesForHour =
          temperaturesByHour[hour] ?? const <TemperatureEntry>[];
      final appointmentsForHour =
          appointmentsByHour[hour] ?? const <MedicalAppointment>[];
      final markers = _buildMarkersForHour(
        hour: hour,
        feedings: feedingsForHour,
        stools: stoolsForHour,
        vomits: vomitsForHour,
        baths: bathsForHour,
        temperatures: temperaturesForHour,
        appointments: appointmentsForHour,
      );
      return _TimelineTileData(
        hour: hour,
        background: _backgroundForHour(hour),
        icon: _iconForHour(hour),
        markers: markers,
        stackDepth: _calculateStackDepth(markers),
      );
    });

    final maxStackDepth = tiles.fold<int>(1, (value, tile) {
      final depth = math.max(tile.stackDepth, 1);
      return math.max(value, depth);
    });
    final timelineHeight =
        _timelineTileBaseHeight + (maxStackDepth - 1) * _timelineMarkerSpacing;
    final showCurrentIndicator = isToday;
    final currentPositionRatio = (now.hour * 60 + now.minute) / (24 * 60);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final tileWidth = totalWidth / tiles.length;
                final indicatorLeft = (totalWidth * currentPositionRatio)
                    .clamp(0.0, math.max(totalWidth - 2, 0.0))
                    .toDouble();

                return SizedBox(
                  height: timelineHeight,
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < tiles.length; i++)
                            SizedBox(
                              width: tileWidth,
                              child: _TimelineTile(
                                data: tiles[i],
                                isLast: i == tiles.length - 1,
                              ),
                            ),
                        ],
                      ),
                      if (showCurrentIndicator)
                        Positioned(
                          left: indicatorLeft,
                          top: 0,
                          bottom: 0,
                          child: Container(width: 2, color: accentColor),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<_TimelineEventMarker> _buildMarkersForHour({
    required int hour,
    required List<FeedingEntry> feedings,
    required List<StoolEntry> stools,
    required List<VomitEntry> vomits,
    required List<BathEntry> baths,
    required List<TemperatureEntry> temperatures,
    required List<MedicalAppointment> appointments,
  }) {
    final markers = <_TimelineEventMarker>[];

    void addMarker(DateTime timestamp, IconData icon, Color color) {
      final minutes = ((timestamp.hour - hour) * 60 + timestamp.minute).clamp(
        0,
        59,
      );
      final position = minutes / 60;
      markers.add(
        _TimelineEventMarker(icon: icon, color: color, position: position),
      );
    }

    for (final entry in feedings) {
      addMarker(entry.timestamp, LucideIcons.milk, accentColor);
    }
    for (final entry in stools) {
      addMarker(entry.timestamp, LucideIcons.toilet, _stoolAccentColor);
    }
    for (final entry in vomits) {
      addMarker(entry.timestamp, LucideIcons.triangleAlert, _vomitAccentColor);
    }
    for (final entry in baths) {
      addMarker(entry.timestamp, LucideIcons.bath, _bathAccentColor);
    }
    for (final entry in temperatures) {
      addMarker(
        entry.timestamp,
        LucideIcons.thermometer,
        _temperatureAccentColor,
      );
    }
    for (final entry in appointments) {
      addMarker(
        entry.scheduledAt,
        LucideIcons.calendarCheck,
        _appointmentAccentColor,
      );
    }

    markers.sort((a, b) => a.position.compareTo(b.position));
    return markers;
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({
    required this.selectedDate,
    required this.onSelectDate,
    this.onImport,
    this.onExport,
  });

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
    );
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
    this.markers = const [],
    this.stackDepth = 1,
  });

  final int hour;
  final Color background;
  final IconData? icon;
  final List<_TimelineEventMarker> markers;
  final int stackDepth;

  String get label => hour.toString().padLeft(2, '0');
  bool get hasLabel => hour.isEven;
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.data,
    required this.isLast,
  });

  final _TimelineTileData data;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPosition(double position) {
          final raw = position * constraints.maxWidth - _timelineMarkerSize / 2;
          const min = 2.0;
          final max = (constraints.maxWidth - _timelineMarkerSize - 2.0);
          final clampedMax = max < min ? min : max;
          final clamped = raw.clamp(min, clampedMax);
          return clamped.toDouble();
        }

        final placements = _assignMarkerLevels(data.markers);
        final iconTop = data.hasLabel ? 26.0 : 10.0;

        return Container(
          color: data.background,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (!isLast)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              if (data.hasLabel)
                Positioned(
                  top: 6,
                  left: 0,
                  right: 0,
                  child: Text(
                    data.label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              if (data.icon != null)
                Positioned(
                  top: iconTop,
                  left: 0,
                  right: 0,
                  child: Icon(
                    data.icon,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              for (final placement in placements)
                Positioned(
                  top:
                      _timelineMarkerTop +
                      placement.level * _timelineMarkerSpacing,
                  left: horizontalPosition(placement.marker.position),
                  child: _TimelineMarker(
                    icon: placement.marker.icon,
                    color: placement.marker.color,
                    size: _timelineMarkerSize,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MarkerLayoutEntry {
  const _MarkerLayoutEntry({required this.marker, required this.level});

  final _TimelineEventMarker marker;
  final int level;
}

class _TimelineEventMarker {
  const _TimelineEventMarker({
    required this.icon,
    required this.color,
    required this.position,
  });

  final IconData icon;
  final Color color;
  final double position;
}

class _TimelineMarker extends StatelessWidget {
  const _TimelineMarker({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: size * 0.55, color: color),
    );
  }
}

int _calculateStackDepth(List<_TimelineEventMarker> markers) {
  if (markers.isEmpty) {
    return 1;
  }
  final grouped = <int, int>{};
  for (final marker in markers) {
    final key = (marker.position * 1000).round();
    final current = grouped[key] ?? 0;
    grouped[key] = current + 1;
  }
  return grouped.values.fold<int>(1, math.max);
}

List<_MarkerLayoutEntry> _assignMarkerLevels(
  List<_TimelineEventMarker> markers,
) {
  const precision = 1000;
  final counters = <int, int>{};
  final placements = <_MarkerLayoutEntry>[];
  for (final marker in markers) {
    final key = (marker.position * precision).round();
    final level = counters[key] ?? 0;
    placements.add(_MarkerLayoutEntry(marker: marker, level: level));
    counters[key] = level + 1;
  }
  return placements;
}

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Map<int, List<FeedingEntry>> _groupFeedings(List<FeedingEntry> feedings) {
  final map = <int, List<FeedingEntry>>{};
  for (final entry in feedings) {
    final tileHour = entry.timestamp.hour;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<StoolEntry>> _groupStools(List<StoolEntry> stools) {
  final map = <int, List<StoolEntry>>{};
  for (final entry in stools) {
    final tileHour = entry.timestamp.hour;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<VomitEntry>> _groupVomits(List<VomitEntry> vomits) {
  final map = <int, List<VomitEntry>>{};
  for (final entry in vomits) {
    final tileHour = entry.timestamp.hour;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<BathEntry>> _groupBaths(List<BathEntry> baths) {
  final map = <int, List<BathEntry>>{};
  for (final entry in baths) {
    final tileHour = entry.timestamp.hour;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<TemperatureEntry>> _groupTemperatures(
  List<TemperatureEntry> temperatures,
) {
  final map = <int, List<TemperatureEntry>>{};
  for (final entry in temperatures) {
    final tileHour = entry.timestamp.hour;
    map.putIfAbsent(tileHour, () => []).add(entry);
  }
  return map;
}

Map<int, List<MedicalAppointment>> _groupAppointments(
  List<MedicalAppointment> appointments,
) {
  final map = <int, List<MedicalAppointment>>{};
  for (final entry in appointments) {
    final tileHour = entry.scheduledAt.hour;
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

String _appointmentTypeLabel(
  AppLocalizations l10n,
  MedicalAppointmentType type,
) {
  switch (type) {
    case MedicalAppointmentType.revision:
      return l10n.agendaTypeRevision;
    case MedicalAppointmentType.pediatrics:
      return l10n.agendaTypePediatrics;
    case MedicalAppointmentType.vaccines:
      return l10n.agendaTypeVaccines;
    case MedicalAppointmentType.emergency:
      return l10n.agendaTypeEmergency;
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
      width: double.infinity,
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
    this.appointments = const <MedicalAppointment>[],
    required this.accentColor,
  });

  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;
  final List<MedicalAppointment> appointments;
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
      ...widget.appointments.map(_DailyLogEntry.appointment),
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

    Widget buildEntryRow({
      required IconData icon,
      required Color color,
      required List<Widget> content,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
          const SizedBox(width: 12),
          _LogActionsMenu(
            editColor: widget.accentColor,
            deleteColor: theme.colorScheme.error,
            editLabel: l10n.homeLogEditAction,
            deleteLabel: l10n.homeLogDeleteAction,
            tooltip: l10n.homeLogActionsTooltip,
          ),
        ],
      );
    }

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
                            return buildEntryRow(
                              icon: LucideIcons.milk,
                              color: widget.accentColor,
                              content: [
                                Text(
                                  timeLabel,
                                  style: theme.textTheme.titleSmall?.copyWith(
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          case _DailyLogType.stool:
                            final stool = entry.stool!;
                            final description = _stoolDescription(
                              l10n,
                              stool.consistency,
                            );
                            return buildEntryRow(
                              icon: LucideIcons.toilet,
                              color: _stoolAccentColor,
                              content: [
                                Text(
                                  timeLabel,
                                  style: theme.textTheme.titleSmall?.copyWith(
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          case _DailyLogType.vomit:
                            final vomit = entry.vomit!;
                            final description = _vomitDescription(
                              l10n,
                              vomit.amount,
                            );
                            return buildEntryRow(
                              icon: LucideIcons.triangleAlert,
                              color: _vomitAccentColor,
                              content: [
                                Text(
                                  timeLabel,
                                  style: theme.textTheme.titleSmall?.copyWith(
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          case _DailyLogType.bath:
                            final bath = entry.bath!;
                            final description = _bathDescription(
                              l10n,
                              bath.type,
                            );
                            return buildEntryRow(
                              icon: LucideIcons.bath,
                              color: _bathAccentColor,
                              content: [
                                Text(
                                  timeLabel,
                                  style: theme.textTheme.titleSmall?.copyWith(
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          case _DailyLogType.temperature:
                            final temperature = entry.temperature!;
                            final valueLabel =
                                '${temperature.celsius.toStringAsFixed(1)} ${l10n.temperatureLogValueUnit}';
                            return buildEntryRow(
                              icon: LucideIcons.thermometer,
                              color: _temperatureAccentColor,
                              content: [
                                Text(
                                  timeLabel,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  valueLabel,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                if ((temperature.notes ?? '').isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    temperature.notes!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          case _DailyLogType.appointment:
                            final appointment = entry.appointment!;
                            final typeLabel = _appointmentTypeLabel(
                              l10n,
                              appointment.type,
                            );
                            final notes = appointment.notes ?? '';
                            return buildEntryRow(
                              icon: LucideIcons.calendarCheck,
                              color: _appointmentAccentColor,
                              content: [
                                Text(
                                  timeLabel,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.title,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  typeLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                if (notes.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    notes,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
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

enum _DailyLogType { feeding, stool, vomit, bath, temperature, appointment }

class _DailyLogEntry {
  _DailyLogEntry.feeding(FeedingEntry entry)
    : feeding = entry,
      stool = null,
      vomit = null,
      bath = null,
      temperature = null,
      appointment = null,
      type = _DailyLogType.feeding,
      timestamp = entry.timestamp;

  _DailyLogEntry.stool(StoolEntry entry)
    : feeding = null,
      stool = entry,
      vomit = null,
      bath = null,
      temperature = null,
      appointment = null,
      type = _DailyLogType.stool,
      timestamp = entry.timestamp;

  _DailyLogEntry.vomit(VomitEntry entry)
    : feeding = null,
      stool = null,
      vomit = entry,
      bath = null,
      temperature = null,
      appointment = null,
      type = _DailyLogType.vomit,
      timestamp = entry.timestamp;

  _DailyLogEntry.bath(BathEntry entry)
    : feeding = null,
      stool = null,
      vomit = null,
      bath = entry,
      temperature = null,
      appointment = null,
      type = _DailyLogType.bath,
      timestamp = entry.timestamp;

  _DailyLogEntry.temperature(TemperatureEntry entry)
    : feeding = null,
      stool = null,
      vomit = null,
      bath = null,
      temperature = entry,
      appointment = null,
      type = _DailyLogType.temperature,
      timestamp = entry.timestamp;

  _DailyLogEntry.appointment(MedicalAppointment entry)
    : feeding = null,
      stool = null,
      vomit = null,
      bath = null,
      temperature = null,
      appointment = entry,
      type = _DailyLogType.appointment,
      timestamp = entry.scheduledAt;

  final FeedingEntry? feeding;
  final StoolEntry? stool;
  final VomitEntry? vomit;
  final BathEntry? bath;
  final TemperatureEntry? temperature;
  final MedicalAppointment? appointment;
  final _DailyLogType type;
  final DateTime timestamp;
}

enum _LogActionMenuOption { edit, delete }

class _LogActionsMenu extends StatelessWidget {
  const _LogActionsMenu({
    required this.editColor,
    required this.deleteColor,
    required this.editLabel,
    required this.deleteLabel,
    required this.tooltip,
  });

  final Color editColor;
  final Color deleteColor;
  final String editLabel;
  final String deleteLabel;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_LogActionMenuOption>(
      tooltip: tooltip,
      offset: const Offset(0, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (_) {},
      itemBuilder: (context) => [
        PopupMenuItem<_LogActionMenuOption>(
          value: _LogActionMenuOption.edit,
          child: Row(
            children: [
              Icon(LucideIcons.pencil, size: 16, color: editColor),
              const SizedBox(width: 12),
              Text(editLabel),
            ],
          ),
        ),
        PopupMenuItem<_LogActionMenuOption>(
          value: _LogActionMenuOption.delete,
          child: Row(
            children: [
              Icon(LucideIcons.trash2, size: 16, color: deleteColor),
              const SizedBox(width: 12),
              Text(deleteLabel),
            ],
          ),
        ),
      ],
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.flipHorizontal,
          size: 18,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
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
