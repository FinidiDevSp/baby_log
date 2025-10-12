import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../home/state/feeding_entries_provider.dart';

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

  Future<void> _pickDateTime(BuildContext context) async {
    final datePicked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (datePicked == null) {
      return;
    }

    final timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (timePicked == null) {
      return;
    }

    setState(() {
      _selectedDateTime = DateTime(
        datePicked.year,
        datePicked.month,
        datePicked.day,
        timePicked.hour,
        timePicked.minute,
      );
    });
  }

  void _incrementAmount(int delta) {
    final newAmount = (_amount + delta).clamp(0, 1000);
    _amountController.text = newAmount.toString();
    setState(() {});
  }

  void _save(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final amount = _amount;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bottleLogAmountValidation)),
      );
      return;
    }

    ref.read(feedingEntriesProvider.notifier).addFeeding(
          FeedingEntry(
            timestamp: _selectedDateTime,
            amountMl: amount,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          ),
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dateLabel = DateFormat.yMMMMd(l10n.localeName).format(
      _selectedDateTime,
    );
    final timeLabel = DateFormat.Hm(l10n.localeName).format(
      _selectedDateTime,
    );
    final formattedDate = '$dateLabel · $timeLabel';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bottleLogTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                l10n.bottleLogDateTimeLabel,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () => _pickDateTime(context),
                icon: const Icon(LucideIcons.calendarClock),
                label: Text(formattedDate),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.bottleLogAmountLabel,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.minus),
                      tooltip: l10n.bottleLogDecreaseTooltip,
                      onPressed: () => _incrementAmount(-5),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixText: l10n.bottleLogAmountUnit,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.plus),
                      tooltip: l10n.bottleLogIncreaseTooltip,
                      onPressed: () => _incrementAmount(5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.bottleLogNotesLabel,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _notesController,
                  maxLines: null,
                  expands: true,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: l10n.bottleLogNotesHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
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
