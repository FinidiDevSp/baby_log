import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_of_day_utils.dart';
import '../../../domain/entities/baby_profile.dart';
import '../../../domain/value_objects/baby_gender.dart';

class BabyFormPage extends ConsumerStatefulWidget {
  const BabyFormPage({super.key, required this.existingBaby});

  final BabyProfile? existingBaby;

  @override
  ConsumerState<BabyFormPage> createState() => _BabyFormPageState();
}

class _BabyFormPageState extends ConsumerState<BabyFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  BabyGender _selectedGender = BabyGender.girl;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  Color _accentColor = AppColors.primaryAccent;
  String? _photoPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final baby = widget.existingBaby;
    _nameController = TextEditingController(text: baby?.name ?? '');
    _weightController = TextEditingController(
      text: baby?.birthWeightKg != null
          ? baby!.birthWeightKg!.toStringAsFixed(2)
          : '',
    );
    _heightController = TextEditingController(
      text: baby?.birthLengthCm != null
          ? baby!.birthLengthCm!.toStringAsFixed(1)
          : '',
    );

    if (baby != null) {
      _selectedGender = baby.gender;
      _birthDate = baby.birthDate;
      _birthTime = timeOfDayFromMinutes(baby.birthTimeMinutes);
      _accentColor = Color(baby.accentColorValue);
      _photoPath = baby.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingBaby != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar bebé' : 'Registrar bebé')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCard(context),
                const SizedBox(height: 24),
                _buildNameField(),
                const SizedBox(height: 24),
                _buildDateAndTimePickers(context),
                const SizedBox(height: 24),
                _buildMeasurements(),
                const SizedBox(height: 24),
                _buildInterfaceColor(),
                const SizedBox(height: 32),
                _buildSaveButton(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _GenderOption(
                  label: BabyGender.boy.label,
                  icon: LucideIcons.mars,
                  selected: _selectedGender == BabyGender.boy,
                  onTap: () => setState(() {
                    _selectedGender = BabyGender.boy;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              _PhotoSelector(
                accentColor: _accentColor,
                photoPath: _photoPath,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La selección de imagen llegará pronto.'),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderOption(
                  label: BabyGender.girl.label,
                  icon: LucideIcons.venus,
                  selected: _selectedGender == BabyGender.girl,
                  onTap: () => setState(() {
                    _selectedGender = BabyGender.girl;
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nombre del bebé', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          maxLength: 50,
          decoration: const InputDecoration(
            hintText: 'Escribe el nombre',
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El nombre es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateAndTimePickers(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy', 'es');
    final birthDateLabel = _birthDate != null
        ? dateFormat.format(_birthDate!)
        : 'Selecciona la fecha';
    final birthTimeLabel = _birthTime != null
        ? _birthTime!.format(context)
        : 'Selecciona la hora';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nacimiento', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SelectableTile(
                icon: LucideIcons.calendarDays,
                label: 'Fecha',
                value: birthDateLabel,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SelectableTile(
                icon: LucideIcons.clock8,
                label: 'Hora',
                value: birthTimeLabel,
                onTap: () => _selectTime(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMeasurements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Medidas al nacer',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  hintText: 'Ej. 3.20',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  hintText: 'Ej. 50.5',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterfaceColor() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.palette),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Color de la interfaz',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Próximamente podrás elegir otros tonos.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _accentColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(bool isEditing) {
    return ElevatedButton(
      onPressed: _isSaving ? null : () => _onSave(isEditing),
      child: _isSaving
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Guardar'),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _birthDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: 'Fecha de nacimiento',
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final initialTime = _birthTime ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: 'Hora de nacimiento',
    );
    if (picked != null) {
      setState(() {
        _birthTime = picked;
      });
    }
  }

  int _colorToStorage(Color color) {
    return color.toARGB32();
  }

  Future<void> _onSave(bool isEditing) async {
    if (_isSaving) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null || _birthTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa la fecha y hora de nacimiento.'),
        ),
      );
      return;
    }

    final weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    final height = double.tryParse(_heightController.text.replaceAll(',', '.'));

    final profile = BabyProfile(
      id: widget.existingBaby?.id,
      name: _nameController.text.trim(),
      gender: _selectedGender,
      birthDate: _birthDate!,
      birthTimeMinutes: minutesFromTimeOfDay(_birthTime!),
      birthWeightKg: weight,
      birthLengthCm: height,
      accentColorValue: _colorToStorage(_accentColor),
      photoPath: _photoPath,
    );

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(babyRepositoryProvider).saveBaby(profile);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Perfil actualizado.' : 'Perfil guardado.'),
        ),
      );
      if (isEditing && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryAccent : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.black : Colors.white70,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSelector extends StatelessWidget {
  const _PhotoSelector({
    required this.accentColor,
    required this.onTap,
    this.photoPath,
  });

  final Color accentColor;
  final VoidCallback onTap;
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final borderColor = accentColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 4),
          color: AppColors.surfaceVariant,
        ),
        alignment: Alignment.center,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    if (!hasPhoto) {
      return const Icon(LucideIcons.imagePlus, size: 32);
    }

    final file = File(photoPath!);
    return ClipOval(
      child: Image.file(
        file,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(LucideIcons.imageOff, size: 32);
        },
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
