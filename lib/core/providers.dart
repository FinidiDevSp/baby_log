import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/local/app_database.dart' as db;
import '../data/repositories/baby_repository_impl.dart';
import '../data/repositories/bath_repository_impl.dart';
import '../data/repositories/feeding_repository_impl.dart';
import '../data/repositories/stool_repository_impl.dart';
import '../data/repositories/temperature_repository_impl.dart';
import '../data/repositories/vomit_repository_impl.dart';
import '../data/repositories/pediatrician_question_repository_impl.dart';
import '../data/repositories/medical_appointment_repository_impl.dart';
import '../data/services/csv_export_service.dart';
import '../data/services/csv_import_service.dart';
import '../domain/entities/baby_profile.dart';
import '../domain/repositories/baby_repository.dart';
import '../domain/repositories/bath_repository.dart';
import '../domain/repositories/feeding_repository.dart';
import '../domain/repositories/stool_repository.dart';
import '../domain/repositories/temperature_repository.dart';
import '../domain/repositories/vomit_repository.dart';
import '../domain/repositories/pediatrician_question_repository.dart';
import '../domain/repositories/medical_appointment_repository.dart';

final appDatabaseProvider = Provider<db.AppDatabase>((ref) {
  final database = db.AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final babyRepositoryProvider = Provider<BabyRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return BabyRepositoryImpl(database);
});

final feedingRepositoryProvider = Provider<FeedingRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return FeedingRepositoryImpl(database);
});

final bathRepositoryProvider = Provider<BathRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return BathRepositoryImpl(database);
});

final stoolRepositoryProvider = Provider<StoolRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return StoolRepositoryImpl(database);
});

final vomitRepositoryProvider = Provider<VomitRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return VomitRepositoryImpl(database);
});

final temperatureRepositoryProvider = Provider<TemperatureRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return TemperatureRepositoryImpl(database);
});

final pediatricianQuestionRepositoryProvider =
    Provider<PediatricianQuestionRepository>((ref) {
      final database = ref.watch(appDatabaseProvider);
      return PediatricianQuestionRepositoryImpl(database);
    });

final medicalAppointmentRepositoryProvider =
    Provider<MedicalAppointmentRepository>((ref) {
      final database = ref.watch(appDatabaseProvider);
      return MedicalAppointmentRepositoryImpl(database);
    });

final csvImportServiceProvider = Provider<CsvImportService>((ref) {
  return CsvImportService(
    feedingRepository: ref.watch(feedingRepositoryProvider),
    stoolRepository: ref.watch(stoolRepositoryProvider),
    vomitRepository: ref.watch(vomitRepositoryProvider),
    bathRepository: ref.watch(bathRepositoryProvider),
    temperatureRepository: ref.watch(temperatureRepositoryProvider),
    questionRepository: ref.watch(pediatricianQuestionRepositoryProvider),
    babyRepository: ref.watch(babyRepositoryProvider),
  );
});

final csvExportServiceProvider = Provider<CsvExportService>((ref) {
  return CsvExportService(
    babyRepository: ref.watch(babyRepositoryProvider),
    feedingRepository: ref.watch(feedingRepositoryProvider),
    stoolRepository: ref.watch(stoolRepositoryProvider),
    vomitRepository: ref.watch(vomitRepositoryProvider),
    bathRepository: ref.watch(bathRepositoryProvider),
    temperatureRepository: ref.watch(temperatureRepositoryProvider),
    questionRepository: ref.watch(pediatricianQuestionRepositoryProvider),
  );
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
