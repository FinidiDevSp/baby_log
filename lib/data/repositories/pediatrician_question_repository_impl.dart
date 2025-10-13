import '../../domain/entities/pediatrician_question.dart';
import '../../domain/repositories/pediatrician_question_repository.dart';
import '../local/app_database.dart' as db;
import '../mappers/pediatrician_question_mapper.dart';

class PediatricianQuestionRepositoryImpl
    implements PediatricianQuestionRepository {
  PediatricianQuestionRepositoryImpl(this._db);

  final db.AppDatabase _db;

  @override
  Stream<List<PediatricianQuestion>> watchQuestions() {
    return _db.watchPediatricianQuestions().map(
      (rows) =>
          rows.map(mapPediatricianQuestionRowToDomain).toList(growable: false),
    );
  }

  @override
  Future<PediatricianQuestion> addQuestion(
    PediatricianQuestion question,
  ) async {
    final companion = mapPediatricianQuestionToCompanion(question);
    final row = await _db.createPediatricianQuestion(companion);
    return mapPediatricianQuestionRowToDomain(row);
  }

  @override
  Future<PediatricianQuestion> updateQuestion(
    PediatricianQuestion question,
  ) async {
    final id = question.id;
    if (id == null) {
      throw ArgumentError('Cannot update a question without an id.');
    }
    final companion = mapPediatricianQuestionToCompanion(question);
    final row = await _db.updatePediatricianQuestion(id, companion);
    return mapPediatricianQuestionRowToDomain(row);
  }

  @override
  Future<void> deleteQuestion(int id) {
    return _db.deletePediatricianQuestion(id);
  }
}
