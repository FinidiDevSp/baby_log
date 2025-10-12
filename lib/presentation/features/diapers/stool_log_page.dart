import 'package:baby_log/core/providers.dart';
import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/domain/entities/stool_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../l10n/app_localizations.dart';

class StoolLogPage extends ConsumerStatefulWidget {
  const StoolLogPage({super.key});

  @override
  ConsumerState<StoolLogPage> createState() => _StoolLogPageState();
}

class _StoolLogPageState extends ConsumerState<StoolLogPage> {
  late DateTime _selectedDateTime;
  StoolConsistency? _selectedConsistency;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final datePicked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 1)),
    );

    if (datePicked == null) {
      return;
    }

    setState(() {
      _selectedDateTime = DateTime(
        datePicked.year,
        datePicked.month,
        datePicked.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
    });
  }

  Future<void> _pickTime(BuildContext context) async {
    final timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (timePicked == null) {
      return;
    }

    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        timePicked.hour,
        timePicked.minute,
      );
    });
  }

  Future<void> _save(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final consistency = _selectedConsistency;

    if (consistency == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.stoolLogConsistencyValidation)),
      );
      return;
    }

    try {
      await ref.read(stoolRepositoryProvider).addStool(
            StoolEntry(
              timestamp: _selectedDateTime,
              consistency: consistency,
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSaveError('$error'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = l10n.localeName;
    final timeLabel = DateFormat.Hm(locale).format(_selectedDateTime);
    final formattedDate =
        DateFormat('EEE, d MMM', locale).format(_selectedDateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        title: Text(l10n.stoolLogTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Center(
              child: Hero(
                tag: 'stool_shortcut',
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.toilet,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
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
                        child: _DateSelectorButton(
                          label: formattedDate,
                          onTap: () => _pickDate(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _TimeSelectorButton(
                        label: timeLabel,
                        onTap: () => _pickTime(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.stoolLogConsistencyLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ConsistencyOptionButton(
                        label: l10n.stoolLogConsistencyLiquidOption,
                        isSelected: _selectedConsistency == StoolConsistency.liquid,
                        onTap: () {
                          setState(() {
                            _selectedConsistency = StoolConsistency.liquid;
                          });
                        },
                      ),
                      _ConsistencyOptionButton(
                        label: l10n.stoolLogConsistencySoftOption,
                        isSelected: _selectedConsistency == StoolConsistency.soft,
                        onTap: () {
                          setState(() {
                            _selectedConsistency = StoolConsistency.soft;
                          });
                        },
                      ),
                      _ConsistencyOptionButton(
                        label: l10n.stoolLogConsistencyFirmOption,
                        isSelected: _selectedConsistency == StoolConsistency.firm,
                        onTap: () {
                          setState(() {
                            _selectedConsistency = StoolConsistency.firm;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.stoolLogNotesLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l10n.stoolLogNotesHint,
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: FilledButton(
          onPressed: () => _save(context),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: Text(l10n.formSaveButton),
        ),
      ),
    );
  }
}

class _DateSelectorButton extends StatelessWidget {
  const _DateSelectorButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            LucideIcons.calendar,
            size: 18,
            color: Colors.white.withValues(alpha: 0.75),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
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
    );
  }
}

class _TimeSelectorButton extends StatelessWidget {
  const _TimeSelectorButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.clock3,
            size: 18,
            color: Colors.white.withValues(alpha: 0.75),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsistencyOptionButton extends StatelessWidget {
  const _ConsistencyOptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      selectedColor: theme.colorScheme.primary,
      backgroundColor: AppColors.surfaceVariant,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
