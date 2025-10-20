import 'package:baby_log/core/providers.dart';
import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/domain/entities/vomit_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../l10n/app_localizations.dart';

class VomitLogPage extends ConsumerStatefulWidget {
  const VomitLogPage({super.key, this.existingEntry});

  final VomitEntry? existingEntry;

  @override
  ConsumerState<VomitLogPage> createState() => _VomitLogPageState();
}

class _VomitLogPageState extends ConsumerState<VomitLogPage> {
  late DateTime _selectedDateTime;
  late TextEditingController _notesController;
  VomitAmount? _selectedAmount;

  bool get _isEditing => widget.existingEntry != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingEntry;
    _selectedDateTime = existing?.timestamp ?? DateTime.now();
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _selectedAmount = existing?.amount ?? VomitAmount.medium;
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
    final amount = _selectedAmount;

    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vomitLogAmountValidation)),
      );
      return;
    }

    try {
      final trimmedNotes = _notesController.text.trim();
      final repository = ref.read(vomitRepositoryProvider);
      if (_isEditing) {
        final existing = widget.existingEntry!;
        await repository.updateVomit(
          existing.copyWith(
            timestamp: _selectedDateTime,
            amount: amount,
            notes: trimmedNotes.isEmpty ? null : trimmedNotes,
          ),
        );
      } else {
        await repository.addVomit(
          VomitEntry(
            timestamp: _selectedDateTime,
            amount: amount,
            notes: trimmedNotes.isEmpty ? null : trimmedNotes,
          ),
        );
      }
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
        title: Text(l10n.vomitLogTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
          children: [
            () {
              final circle = Material(
                color: Colors.transparent,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.triangleAlert,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              );
              if (_isEditing) {
                return circle;
              }
              return Hero(
                tag: 'vomit_shortcut',
                child: circle,
              );
            }(),
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
                    l10n.vomitLogAmountLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _AmountOptionButton(
                          label: l10n.vomitLogAmountLowOption,
                          isSelected: _selectedAmount == VomitAmount.low,
                          onTap: () {
                            setState(() {
                              _selectedAmount = VomitAmount.low;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _AmountOptionButton(
                          label: l10n.vomitLogAmountMediumOption,
                          isSelected: _selectedAmount == VomitAmount.medium,
                          onTap: () {
                            setState(() {
                              _selectedAmount = VomitAmount.medium;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _AmountOptionButton(
                          label: l10n.vomitLogAmountHighOption,
                          isSelected: _selectedAmount == VomitAmount.high,
                          onTap: () {
                            setState(() {
                              _selectedAmount = VomitAmount.high;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.vomitLogNotesLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l10n.vomitLogNotesHint,
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.calendar, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.clock4, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountOptionButton extends StatelessWidget {
  const _AmountOptionButton({
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

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.2)
            : AppColors.surfaceVariant,
        foregroundColor:
            isSelected ? theme.colorScheme.primary : Colors.white70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
