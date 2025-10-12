import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/domain/entities/baby_profile.dart';
import 'package:baby_log/l10n/app_localizations.dart';
import 'package:baby_log/presentation/features/baby_form/baby_form_page.dart';
import 'package:baby_log/presentation/widgets/baby_avatar.dart';

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
      const _BabyHomeView(),
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

class _BabyHomeView extends StatelessWidget {
  const _BabyHomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          _ShortcutCarousel(),
          const SizedBox(height: 24),
          _TimelineCard(),
          const SizedBox(height: 24),
          _EventsPlaceholder(description: l10n.homeEmptyDescription),
        ],
      ),
    );
  }
}

class _ShortcutCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shortcuts = [
      _ShortcutData(
        color: const Color(0xFFF06292),
        icon: LucideIcons.milk,
        label: l10n.dashboardBottleLabel,
      ),
      _ShortcutData(
        color: const Color(0xFF4CAF50),
        icon: LucideIcons.toilet,
        label: l10n.dashboardDiaperLabel,
      ),
      _ShortcutData(
        color: const Color(0xFF1ABC9C),
        icon: LucideIcons.triangleAlert,
        label: l10n.dashboardVomitLabel,
      ),
      _ShortcutData(
        color: const Color(0xFF2D81FF),
        icon: LucideIcons.bath,
        label: l10n.dashboardBathLabel,
      ),
      _ShortcutData(
        color: const Color(0xFFFF9800),
        icon: LucideIcons.thermometer,
        label: l10n.dashboardTemperatureLabel,
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
      ),
    ];

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
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
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(data.icon, size: 26, color: Colors.white),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 88,
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
              const SizedBox(height: 4),
              Text(
                l10n.dashboardMinutesAgoZero,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final localeName = l10n.localeName;
    final dateLabel = DateFormat(
      'EEE, d MMM',
      localeName,
    ).format(DateTime.now());
    final tiles = List<_TimelineTileData>.generate(12, (index) {
      final hour = index * 2;
      return _TimelineTileData(
        hour: hour,
        background: _backgroundForHour(hour),
        icon: _iconForHour(hour),
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.dashboardTodayLabel}, $dateLabel',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 64,
                    child: Row(
                      children: [
                        for (var i = 0; i < tiles.length; i++)
                          Expanded(
                            child: _TimelineTile(
                              data: tiles[i],
                              isLast: i == tiles.length - 1,
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
}

class _TimelineTileData {
  const _TimelineTileData({
    required this.hour,
    required this.background,
    this.icon,
  });

  final int hour;
  final Color background;
  final IconData? icon;

  String get label => hour.toString().padLeft(2, '0');
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.data, required this.isLast});

  final _TimelineTileData data;
  final bool isLast;

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
      alignment: Alignment.center,
      child: data.icon == null
          ? const SizedBox.shrink()
          : Icon(
              data.icon,
              size: 20,
              color: Colors.white.withValues(alpha: 0.75),
            ),
    );
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.rockingChair,
            size: 48,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
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
  });

  final Color color;
  final IconData icon;
  final String label;
}
