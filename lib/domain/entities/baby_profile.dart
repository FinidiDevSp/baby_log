import '../value_objects/baby_gender.dart';

/// Domain entity representing a baby profile stored locally.
class BabyProfile {
  const BabyProfile({
    this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.birthTimeMinutes,
    required this.accentColorValue,
    this.birthWeightKg,
    this.birthLengthCm,
    this.photoPath,
  });

  /// Primary key in the local database. Null until persisted.
  final int? id;
  final String name;
  final BabyGender gender;
  final DateTime birthDate;

  /// Minutes since midnight representing the birth time.
  final int birthTimeMinutes;

  final double? birthWeightKg;
  final double? birthLengthCm;

  /// Color value stored as ARGB integer.
  final int accentColorValue;

  /// Optional local path to the baby's photo.
  final String? photoPath;

  BabyProfile copyWith({
    int? id,
    String? name,
    BabyGender? gender,
    DateTime? birthDate,
    int? birthTimeMinutes,
    double? birthWeightKg,
    double? birthLengthCm,
    int? accentColorValue,
    String? photoPath,
  }) {
    return BabyProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthTimeMinutes: birthTimeMinutes ?? this.birthTimeMinutes,
      birthWeightKg: birthWeightKg ?? this.birthWeightKg,
      birthLengthCm: birthLengthCm ?? this.birthLengthCm,
      accentColorValue: accentColorValue ?? this.accentColorValue,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
