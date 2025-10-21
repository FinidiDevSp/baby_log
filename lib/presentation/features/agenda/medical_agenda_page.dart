import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/medical_appointment.dart';
import '../../../l10n/app_localizations.dart';
import 'state/medical_appointments_controller.dart';
import '../../shared/medical_appointment_style.dart';

class MedicalAgendaPage extends ConsumerStatefulWidget {
  const MedicalAgendaPage({super.key, this.initialAppointment});

  final MedicalAppointment? initialAppointment;

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
  String? _editingId;
  String? _dateErrorText;
  bool _didInitializeForm = false;
  bool _isCompleted = false;

  bool get _isEditing => _editingId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitializeForm) {
      return;
    }
    _didInitializeForm = true;

    final l10n = AppLocalizations.of(context);
    final initial = widget.initialAppointment;
    if (initial != null) {
      _editingId = initial.id;
      _selectedType = initial.type;
      _selectedDateTime = initial.scheduledAt;
      _titleController.text = initial.title;
      _notesController.text = initial.notes ?? '';
      _dateErrorText = null;
      _dateController.text = _formatDate(_selectedDateTime, l10n);
      _isCompleted = initial.isCompleted;
      return;
    }

    _applyDefaultValues(l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final style = MedicalAppointmentVisualStyle.resolve(_selectedType);
    final isEditing = _isEditing;

    Widget headerIcon() {
      final circle = Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: style.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: style.color.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          style.icon,
          size: 32,
          color: Colors.white,
        ),
      );

      if (isEditing) {
        return circle;
      }

      return Hero(
        tag: 'agenda_shortcut',
        child: circle,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        title: Text(isEditing ? l10n.agendaEditTitle : l10n.agendaTitle),
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(LucideIcons.trash2),
                  tooltip: l10n.agendaDeleteAction,
                  onPressed: _handleDeleteEditing,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Center(child: headerIcon()),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing
                          ? l10n.agendaEditTitle
                          : l10n.agendaCreateTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
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
                      initialValue: _selectedType,
                      items: MedicalAppointmentType.values
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(_typeLabel(l10n, type)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedType = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: l10n.agendaFormTypeLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _pickDateTime(l10n),
                      decoration: InputDecoration(
                        labelText: l10n.agendaFormDateTimeLabel,
                        suffixIcon: const Icon(LucideIcons.calendarClock),
                        errorText: _dateErrorText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: l10n.agendaFormNotesLabel,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _isCompleted,
                      onChanged: (value) {
                        setState(() {
                          _isCompleted = value;
                        });
                      },
                      title: Text(l10n.agendaPastIndicator),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: FilledButton(
          onPressed: () => _submitForm(l10n),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: Text(
            isEditing
                ? l10n.agendaFormSaveChanges
                : l10n.agendaFormSaveNew,
          ),
        ),
      ),
    );
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

    if (!mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) {
        final dialogTheme = Theme.of(context);
        return Theme(
          data: dialogTheme.copyWith(colorScheme: dialogTheme.colorScheme),
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
      isCompleted: _isCompleted,
    );

    if (_isEditing) {
      controller.updateAppointment(appointment);
    } else {
      controller.addAppointment(appointment);
    }

    final successMessage =
        _isEditing ? l10n.agendaUpdateSuccess : l10n.agendaCreateSuccess;

    FocusScope.of(context).unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(successMessage);
      return;
    }

    setState(() {
      _applyDefaultValues(l10n);
    });
  }

  Future<void> _handleDeleteEditing() async {
    final editingId = _editingId;
    if (editingId == null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final appointments = ref.read(medicalAppointmentsProvider);
    MedicalAppointment? appointment;
    for (final item in appointments) {
      if (item.id == editingId) {
        appointment = item;
        break;
      }
    }
    if (appointment == null) {
      return;
    }

    final deleted = await _deleteAppointment(appointment);
    if (!deleted || !mounted) {
      return;
    }
    Navigator.of(context).pop(l10n.agendaDeleteSuccess);
  }

  Future<bool> _deleteAppointment(MedicalAppointment appointment) async {
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
      return false;
    }

    ref
        .read(medicalAppointmentsProvider.notifier)
        .removeAppointment(appointment.id);
    return true;
  }

  void _applyDefaultValues(AppLocalizations l10n) {
    _editingId = null;
    _selectedType = MedicalAppointmentType.revision;
    _selectedDateTime = DateTime.now();
    _titleController.clear();
    _notesController.clear();
    _dateErrorText = null;
    _dateController.text = _formatDate(_selectedDateTime, l10n);
    _isCompleted = false;
  }

  String _formatDate(DateTime? value, AppLocalizations l10n) {
    if (value == null) {
      return '';
    }
    final formatter = DateFormat('EEE d MMM - HH:mm', l10n.localeName);
    return formatter.format(value);
  }

  String _typeLabel(
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
}
