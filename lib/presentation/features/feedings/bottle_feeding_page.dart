import 'package:baby_log/core/providers.dart';
import 'package:baby_log/core/theme/app_colors.dart';
import 'package:baby_log/domain/entities/feeding_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../l10n/app_localizations.dart';

class BottleFeedingPage extends ConsumerStatefulWidget {
  const BottleFeedingPage({super.key});

  @override
  ConsumerState<BottleFeedingPage> createState() => _BottleFeedingPageState();
}

class _BottleFeedingPageState extends ConsumerState<BottleFeedingPage> {
  late DateTime _selectedDateTime;
  late TextEditingController _amountController;
  late TextEditingController _notesController;

  int get _amount => int.tryParse(_amountController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
    _amountController = TextEditingController(text: '120');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
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

  void _incrementAmount(int delta) {
    final newAmount = (_amount + delta).clamp(0, 999);
    _amountController.text = newAmount.toString();
    setState(() {});
  }

  Future<void> _save(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final amount = _amount;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bottleLogAmountValidation)),
      );
      return;
    }

    try {
      await ref.read(feedingRepositoryProvider).addFeeding(
            FeedingEntry(
              timestamp: _selectedDateTime,
              amountMl: amount,
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
    final timeLabel = DateFormat.Hm(l10n.localeName).format(
      _selectedDateTime,
    );
    final formattedDate =
        DateFormat('EEE, d MMM', l10n.localeName).format(_selectedDateTime);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        title: Text(l10n.bottleLogTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Center(
              child: Hero(
                tag: 'bottle_shortcut',
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    LucideIcons.milk,
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
                    l10n.bottleLogAmountLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _AmountActionButton(
                        icon: LucideIcons.minus,
                        tooltip: l10n.bottleLogDecreaseTooltip,
                        onPressed: () => _incrementAmount(-5),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          SizedBox(
                            width: 88,
                            child: TextField(
                              controller: _amountController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.bottleLogAmountUnit,
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      _AmountActionButton(
                        icon: LucideIcons.plus,
                        tooltip: l10n.bottleLogIncreaseTooltip,
                        onPressed: () => _incrementAmount(5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.bottleLogNotesLabel,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: l10n.bottleLogNotesHint,
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

class _AmountActionButton extends StatelessWidget {
  const _AmountActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        foregroundColor: theme.colorScheme.primary,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
      ),
      icon: Icon(icon, size: 20),
    );
  }
}
