import 'package:drift/drift.dart';

import '../../domain/entities/baby_profile.dart';
import '../../domain/value_objects/baby_gender.dart';
import '../local/app_database.dart' as db;

BabyProfile? mapRowToDomain(db.BabyRow? data) {
  if (data == null) {
    return null;
  }

  return BabyProfile(
    id: data.id,
    name: data.name,
    gender: babyGenderFromStorage(data.gender),
    birthDate: data.birthDate,
    birthTimeMinutes: data.birthTimeMinutes,
    birthWeightKg: data.birthWeightKg,
    birthLengthCm: data.birthLengthCm,
    accentColorValue: data.accentColorValue,
    photoPath: data.photoPath,
  );
}

db.BabyProfilesCompanion mapDomainToCompanion(
  BabyProfile profile, {
  required DateTime updatedAt,
}) {
  return db.BabyProfilesCompanion(
    id: profile.id != null ? Value(profile.id!) : const Value.absent(),
    name: Value(profile.name),
    gender: Value(profile.gender.storageValue),
    birthDate: Value(profile.birthDate),
    birthTimeMinutes: Value(profile.birthTimeMinutes),
    birthWeightKg: profile.birthWeightKg != null
        ? Value(profile.birthWeightKg!)
        : const Value.absent(),
    birthLengthCm: profile.birthLengthCm != null
        ? Value(profile.birthLengthCm!)
        : const Value.absent(),
    accentColorValue: Value(profile.accentColorValue),
    photoPath: profile.photoPath != null
        ? Value(profile.photoPath!)
        : const Value.absent(),
    createdAt: const Value.absent(),
    updatedAt: Value(updatedAt),
  );
}
