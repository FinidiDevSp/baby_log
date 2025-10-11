enum BabyGender { boy, girl }

extension BabyGenderX on BabyGender {
  String get label {
    switch (this) {
      case BabyGender.boy:
        return 'Niño';
      case BabyGender.girl:
        return 'Niña';
    }
  }

  int get storageValue => index;

  String get semanticLabel {
    switch (this) {
      case BabyGender.boy:
        return 'Bebé niño';
      case BabyGender.girl:
        return 'Bebé niña';
    }
  }
}

BabyGender babyGenderFromStorage(int value) {
  final clamped = value.clamp(0, BabyGender.values.length - 1).toInt();
  return BabyGender.values[clamped];
}
