import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baby_log/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/time_of_day_utils.dart';
import '../../../domain/entities/baby_profile.dart';
import '../../../domain/value_objects/baby_gender.dart';

const _accentPalette = <Color>[
  Color(0xFFFF8C32),
  Color(0xFFFF6B6B),
  Color(0xFFFFC542),
  Color(0xFF2D81FF),
  Color(0xFF4CAF50),
  Color(0xFF1ABC9C),
  Color(0xFF9C27B0),
  Color(0xFFAF52DE),
  Color(0xFFE53935),
  Color(0xFFFF5E78),
];

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
  late final ThemeController _themeController;

  BabyGender _selectedGender = BabyGender.girl;
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  final ImagePicker _imagePicker = ImagePicker();
  Color _accentColor = _accentPalette.first;
  late final Color _initialAccentColor;
  String? _photoPath;
  bool _isSaving = false;
  bool _hasPersistedAccent = false;

  AppLocalizations get l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    final baby = widget.existingBaby;
    _themeController = ref.read(themeControllerProvider.notifier);
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

    _accentColor = ref.read(themeControllerProvider).colorScheme.primary;

    if (baby != null) {
      _selectedGender = baby.gender;
      _birthDate = baby.birthDate;
      _birthTime = timeOfDayFromMinutes(baby.birthTimeMinutes);
      _accentColor = Color(baby.accentColorValue);
      _photoPath = baby.photoPath;
    }

    _initialAccentColor = _accentColor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _themeController.updateAccent(_accentColor);
    });
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

    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop || _hasPersistedAccent) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _themeController.updateAccent(_initialAccentColor);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? l10n.formEditTitle : l10n.formCreateTitle),
        ),
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
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 32,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 72),
                      child: _GenderOption(
                        label: l10n.formGenderBoy,
                        semanticLabel: l10n.formGenderBoySemantic,
                        icon: LucideIcons.mars,
                        selected: _selectedGender == BabyGender.boy,
                        accentColor: _accentColor,
                        onTap: () => setState(() {
                          _selectedGender = BabyGender.boy;
                        }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 72),
                      child: _GenderOption(
                        label: l10n.formGenderGirl,
                        semanticLabel: l10n.formGenderGirlSemantic,
                        icon: LucideIcons.venus,
                        selected: _selectedGender == BabyGender.girl,
                        accentColor: _accentColor,
                        onTap: () => setState(() {
                          _selectedGender = BabyGender.girl;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: _PhotoSelector(
                accentColor: _accentColor,
                photoPath: _photoPath,
                onTap: _onPhotoTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.formNameLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          textInputAction: TextInputAction.next,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: l10n.formNameHint,
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.formNameError;
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
        : l10n.formBirthDatePlaceholder;
    final birthTimeLabel = _birthTime != null
        ? _birthTime!.format(context)
        : l10n.formBirthTimePlaceholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.formBirthSection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SelectableTile(
                icon: LucideIcons.calendarDays,
                label: l10n.formBirthDateLabel,
                value: birthDateLabel,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SelectableTile(
                icon: LucideIcons.clock8,
                label: l10n.formBirthTimeLabel,
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
          l10n.formMeasurementsSection,
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
                decoration: InputDecoration(
                  labelText: l10n.formWeightLabel,
                  hintText: l10n.formWeightHint,
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
                decoration: InputDecoration(
                  labelText: l10n.formHeightLabel,
                  hintText: l10n.formHeightHint,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterfaceColor() {
    return GestureDetector(
      onTap: _showAccentColorPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
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
                    l10n.formInterfaceColorTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.formInterfaceColorSubtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _accentColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(LucideIcons.chevronRight, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _showAccentColorPicker() async {
    Color tempSelection = _accentColor;

    final selected = await showModalBottomSheet<Color>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.formColorPickerTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.formSheetCloseTooltip,
                          icon: const Icon(LucideIcons.x),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final color in _accentPalette)
                          _ColorSwatchOption(
                            color: color,
                            selected: tempSelection.value == color.value,
                            onTap: () {
                              setSheetState(() {
                                tempSelection = color;
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(tempSelection),
                        child: Text(l10n.formColorPickerConfirm),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;
    if (selected == null) return;

    final chosen = selected; // non-null here
    setState(() {
      _accentColor = chosen;
    });
    _themeController.updateAccent(chosen);
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
          : Text(l10n.formSaveButton),
    );
  }

  Future<void> _onPhotoTap() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(LucideIcons.camera),
                title: Text(l10n.formPhotoSheetCamera),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(LucideIcons.image),
                title: Text(l10n.formPhotoSheetGallery),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );

      if (picked == null) {
        return;
      }

      final savedPath = await _persistPhoto(picked);
      if (!mounted) {
        return;
      }

      setState(() {
        _photoPath = savedPath;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formPhotoLoadError(error.toString()))),
      );
    }
  }

  Future<String> _persistPhoto(XFile file) async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(directory.path, 'baby_photos'));

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final extension = p.extension(file.path);
    final fileName =
        'baby_${DateTime.now().millisecondsSinceEpoch}${extension.isEmpty ? '.jpg' : extension}';
    final destination = File(p.join(photosDir.path, fileName));

    final bytes = await file.readAsBytes();
    await destination.writeAsBytes(bytes, flush: true);

    return destination.path;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _birthDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: l10n.formBirthDateHelp,
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
      helpText: l10n.formBirthTimeHelp,
    );
    if (picked != null) {
      setState(() {
        _birthTime = picked;
      });
    }
  }

  int _colorToStorage(Color color) {
    // Guarda como ARGB de 32 bits (estándar en Flutter).
    return color.value;
  }

  Future<void> _onSave(bool isEditing) async {
    if (_isSaving) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null || _birthTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.formBirthMissingError)));
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
      _hasPersistedAccent = true;
      _themeController.updateAccent(_accentColor);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? l10n.formUpdateSuccess : l10n.formCreateSuccess,
          ),
        ),
      );
      if (isEditing && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.formSaveError(error.toString()))),
      );
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
    required this.semanticLabel,
    required this.icon,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final String semanticLabel;
  final IconData icon;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onAccent =
        ThemeData.estimateBrightnessForColor(accentColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.0 : 0.94,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 108,
            height: 108,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selected ? accentColor : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: selected ? onAccent : Colors.white70,
                  size: 30,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: selected ? onAccent : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
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
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        scale: hasPhoto ? 1.0 : 0.97,
        curve: Curves.easeOut,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accentColor, width: 4),
            color: AppColors.surfaceVariant,
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;

    if (!hasPhoto) {
      return const Icon(
        LucideIcons.imagePlus,
        size: 36,
        key: ValueKey('placeholder'),
      );
    }

    final file = File(photoPath!);
    return ClipOval(
      key: ValueKey(photoPath),
      child: Image.file(
        file,
        width: 112,
        height: 112,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Icon(
            LucideIcons.imageOff,
            size: 36,
            key: ValueKey('error'),
          );
        },
      ),
    );
  }
}

class _ColorSwatchOption extends StatelessWidget {
  const _ColorSwatchOption({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: selected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: selected
            ? Icon(LucideIcons.check, color: onColor, size: 20)
            : null,
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
          borderRadius: BorderRadius.circular(4),
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
