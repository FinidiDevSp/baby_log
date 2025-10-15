import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/medical_appointment.dart';
import '../../../l10n/app_localizations.dart';
import 'state/medical_appointments_controller.dart';

class MedicalAgendaPage extends ConsumerStatefulWidget {
  const MedicalAgendaPage({super.key});

  @override
  ConsumerState<MedicalAgendaPage> createState() => _MedicalAgendaPageState();
}

class _MedicalAgendaPageState extends ConsumerState<MedicalAgendaPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();

  MedicalAppointmentType _selectedType = MedicalAppointmentType.revision;
  DateTime? _selectedDateTime;
  bool _isFormVisible = false;
  String? _editingId;
  String? _dateErrorText;

  bool get _isEditing => _editingId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appointments = ref.watch(medicalAppointmentsProvider);
    final locale = l10n.localeName;
    final sortedAppointments = List<MedicalAppointment>.from(appointments)
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final todayItems = sortedAppointments
        .where((item) => _isSameDay(item.scheduledAt, todayDate))
        .toList();
    final upcomingItems = sortedAppointments
        .where(
          (item) =>
              !_isSameDay(item.scheduledAt, todayDate) &&
              item.scheduledAt.isAfter(todayDate),
        )
        .toList();
    final pastItems = sortedAppointments
        .where((item) => item.scheduledAt.isBefore(todayDate))
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.agendaTitle),
        actions: [
          IconButton(
            onPressed: () => _startCreateFlow(l10n),
            tooltip: l10n.agendaNewAppointmentTooltip,
            icon: const Icon(LucideIcons.plus),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isFormVisible
                  ? _AgendaFormCard(
                      key: const ValueKey('agenda_form'),
                      formKey: _formKey,
                      titleController: _titleController,
                      notesController: _notesController,
                      dateController: _dateController,
                      selectedType: _selectedType,
                      dateErrorText: _dateErrorText,
                      isEditing: _isEditing,
                      onCancel: _cancelEditing,
                      onSave: () => _submitForm(l10n),
                      onPickDateTime: () => _pickDateTime(l10n),
                      onTypeChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                      typeLabelBuilder: (type) => _typeLabel(l10n, type),
                    )
                  : const SizedBox.shrink(),
            ),
            if (_isFormVisible) const SizedBox(height: 20),
            if (todayItems.isNotEmpty)
              _AgendaSection(
                label: l10n.agendaSectionToday,
                appointments: todayItems,
                typeLabelBuilder: (type) => _typeLabel(l10n, type),
                locale: locale,
                onEdit: _startEditFlow,
                onDelete: _deleteAppointment,
              ),
            if (todayItems.isNotEmpty &&
                (upcomingItems.isNotEmpty || pastItems.isNotEmpty))
              const SizedBox(height: 24),
            if (upcomingItems.isNotEmpty)
              _AgendaSection(
                label: l10n.agendaSectionUpcoming,
                appointments: upcomingItems,
                typeLabelBuilder: (type) => _typeLabel(l10n, type),
                locale: locale,
                onEdit: _startEditFlow,
                onDelete: _deleteAppointment,
              ),
            if (upcomingItems.isNotEmpty && pastItems.isNotEmpty)
              const SizedBox(height: 24),
            if (pastItems.isNotEmpty)
              _AgendaSection(
                label: l10n.agendaSectionPast,
                appointments: pastItems,
                typeLabelBuilder: (type) => _typeLabel(l10n, type),
                locale: locale,
                onEdit: _startEditFlow,
                onDelete: _deleteAppointment,
                showPastIndicator: true,
              ),
            if (todayItems.isEmpty &&
                upcomingItems.isEmpty &&
                pastItems.isEmpty)
              _AgendaEmptyState(
                iconColor: theme.colorScheme.primary,
                description: l10n.agendaEmptyDescription,
              ),
          ],
        ),
      ),
    );
  }

  void _startCreateFlow(AppLocalizations l10n) {
    setState(() {
      _isFormVisible = true;
      _editingId = null;
      _selectedType = MedicalAppointmentType.revision;
      _selectedDateTime = DateTime.now();
      _titleController.clear();
      _notesController.clear();
      _dateErrorText = null;
      _dateController.text = _formatDate(_selectedDateTime, l10n);
    });
  }

  void _startEditFlow(MedicalAppointment appointment) {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isFormVisible = true;
      _editingId = appointment.id;
      _selectedType = appointment.type;
      _selectedDateTime = appointment.scheduledAt;
      _titleController.text = appointment.title;
      _notesController.text = appointment.notes ?? '';
      _dateErrorText = null;
      _dateController.text = _formatDate(_selectedDateTime, l10n);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scrollableState = Scrollable.of(context);
      scrollableState?.position.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickDateTime(AppLocalizations l10n) async {
    final initial = _selectedDateTime ?? DateTime.now();
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null) {
      return;
    }

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (pickedTime == null) {
      return;
    }

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _dateErrorText = null;
      _dateController.text = _formatDate(_selectedDateTime, l10n);
    });
  }

  void _cancelEditing() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isFormVisible = false;
      _editingId = null;
      _dateErrorText = null;
    });
  }

  void _submitForm(AppLocalizations l10n) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDateTime == null) {
      setState(() {
        _dateErrorText = l10n.agendaFormDateTimeError;
      });
      return;
    }

    final controller = ref.read(medicalAppointmentsProvider.notifier);
    final trimmedTitle = _titleController.text.trim();
    final trimmedNotes = _notesController.text.trim();
    final appointment = MedicalAppointment(
      id: _editingId ?? controller.nextId(),
      title: trimmedTitle,
      type: _selectedType,
      scheduledAt: _selectedDateTime!,
      notes: trimmedNotes.isEmpty ? null : trimmedNotes,
    );

    if (_isEditing) {
      controller.updateAppointment(appointment);
    } else {
      controller.addAppointment(appointment);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? l10n.agendaUpdateSuccess
              : l10n.agendaCreateSuccess,
        ),
      ),
    );

    FocusScope.of(context).unfocus();
    setState(() {
      _isFormVisible = false;
      _editingId = null;
      _dateErrorText = null;
    });
  }

  Future<void> _deleteAppointment(MedicalAppointment appointment) async {
    final l10n = AppLocalizations.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.agendaDeleteConfirmTitle),
          content: Text(l10n.agendaDeleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.agendaDeleteConfirmCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.agendaDeleteConfirmAccept),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    ref
        .read(medicalAppointmentsProvider.notifier)
        .removeAppointment(appointment.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.agendaDeleteSuccess)),
    );
  }

  String _formatDate(DateTime? value, AppLocalizations l10n) {
    if (value == null) {
      return '';
    }
    final formatter = DateFormat('EEE d MMM · HH:mm', l10n.localeName);
    return formatter.format(value);
  }

  bool _isSameDay(DateTime date, DateTime reference) {
    return date.year == reference.year &&
        date.month == reference.month &&
        date.day == reference.day;
  }

  String _typeLabel(AppLocalizations l10n, MedicalAppointmentType type) {
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
}

typedef _TypeLabelBuilder = String Function(MedicalAppointmentType type);

typedef _AppointmentAction = Future<void> Function(MedicalAppointment appointment);

class _AgendaFormCard extends StatelessWidget {
  const _AgendaFormCard({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.notesController,
    required this.dateController,
    required this.selectedType,
    required this.dateErrorText,
    required this.isEditing,
    required this.onCancel,
    required this.onSave,
    required this.onPickDateTime,
    required this.onTypeChanged,
    required this.typeLabelBuilder,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController notesController;
  final TextEditingController dateController;
  final MedicalAppointmentType selectedType;
  final String? dateErrorText;
  final bool isEditing;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final VoidCallback onPickDateTime;
  final ValueChanged<MedicalAppointmentType> onTypeChanged;
  final _TypeLabelBuilder typeLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? l10n.agendaEditTitle : l10n.agendaCreateTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: l10n.agendaFormTitleLabel,
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.agendaFormTitleError;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<MedicalAppointmentType>(
              value: selectedType,
              items: MedicalAppointmentType.values
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(typeLabelBuilder(type)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onTypeChanged(value);
                }
              },
              decoration: InputDecoration(
                labelText: l10n.agendaFormTypeLabel,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dateController,
              readOnly: true,
              onTap: onPickDateTime,
              decoration: InputDecoration(
                labelText: l10n.agendaFormDateTimeLabel,
                suffixIcon: const Icon(LucideIcons.calendarClock),
                errorText: dateErrorText,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: l10n.agendaFormNotesLabel,
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: Text(l10n.agendaFormCancel),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: onSave,
                  child: Text(
                    isEditing
                        ? l10n.agendaFormSaveChanges
                        : l10n.agendaFormSaveNew,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AgendaSection extends StatelessWidget {
  const _AgendaSection({
    required this.label,
    required this.appointments,
    required this.typeLabelBuilder,
    required this.locale,
    required this.onEdit,
    required this.onDelete,
    this.showPastIndicator = false,
  });

  final String label;
  final List<MedicalAppointment> appointments;
  final _TypeLabelBuilder typeLabelBuilder;
  final String locale;
  final void Function(MedicalAppointment) onEdit;
  final _AppointmentAction onDelete;
  final bool showPastIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('d MMM · HH:mm', locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final dateLabel = dateFormatter.format(appointment.scheduledAt);
              final typeLabel = typeLabelBuilder(appointment.type);
              final notes = appointment.notes;

              return Dismissible(
                key: ValueKey(appointment.id),
                background: _SwipeBackground(
                  icon: LucideIcons.penLine,
                  label: AppLocalizations.of(context).agendaEditAction,
                  alignment: Alignment.centerLeft,
                  color: Colors.white.withValues(alpha: 0.08),
                  padding: const EdgeInsets.only(left: 20),
                ),
                secondaryBackground: _SwipeBackground(
                  icon: LucideIcons.trash2,
                  label: AppLocalizations.of(context).agendaDeleteAction,
                  alignment: Alignment.centerRight,
                  color: Colors.red.withValues(alpha: 0.18),
                  padding: const EdgeInsets.only(right: 20),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    onEdit(appointment);
                    return false;
                  }

                  await onDelete(appointment);
                  return false;
                },
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAF52DE).withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.calendarCheck,
                      color: Color(0xFFAF52DE),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    appointment.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('$typeLabel · $dateLabel'),
                      if (notes != null && notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          notes,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                      if (showPastIndicator) ...[
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context).agendaPastIndicator,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => Divider(
              height: 1,
              thickness: 1,
              color: Colors.white.withValues(alpha: 0.08),
            ),
            itemCount: appointments.length,
          ),
        ),
      ],
    );
  }
}

class _AgendaEmptyState extends StatelessWidget {
  const _AgendaEmptyState({
    required this.iconColor,
    required this.description,
  });

  final Color iconColor;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.calendarClock,
            size: 52,
            color: iconColor.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 18),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.icon,
    required this.label,
    required this.alignment,
    required this.color,
    required this.padding,
  });

  final IconData icon;
  final String label;
  final Alignment alignment;
  final Color color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: alignment,
      padding: padding,
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment == Alignment.centerLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
