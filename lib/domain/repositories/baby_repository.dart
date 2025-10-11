import '../entities/baby_profile.dart';

abstract class BabyRepository {
  Stream<BabyProfile?> watchBaby();

  Future<BabyProfile?> fetchBaby();

  Future<BabyProfile> saveBaby(BabyProfile profile);
}
