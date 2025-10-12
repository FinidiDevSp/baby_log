import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/app_database.dart' as db;
import '../data/repositories/baby_repository_impl.dart';
import '../domain/entities/baby_profile.dart';
import '../domain/repositories/baby_repository.dart';

final appDatabaseProvider = Provider<db.AppDatabase>((ref) {
  final database = db.AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final babyRepositoryProvider = Provider<BabyRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return BabyRepositoryImpl(database);
});

final babyStreamProvider = StreamProvider<BabyProfile?>((ref) {
  final repository = ref.watch(babyRepositoryProvider);
  return repository.watchBaby();
});

final babyFutureProvider = FutureProvider<BabyProfile?>((ref) async {
  final repository = ref.watch(babyRepositoryProvider);
  return repository.fetchBaby();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences no inicializado');
});
