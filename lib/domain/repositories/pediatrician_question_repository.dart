import '../entities/pediatrician_question.dart';

/// Contract for managing pediatrician questions.
abstract class PediatricianQuestionRepository {
  /// Watches all stored questions ordered by status and recency.
  Stream<List<PediatricianQuestion>> watchQuestions();

  /// Persists a new question and returns the stored entity.
  Future<PediatricianQuestion> addQuestion(PediatricianQuestion question);

  /// Updates an existing question and returns the persisted entity.
  Future<PediatricianQuestion> updateQuestion(PediatricianQuestion question);

  /// Deletes a question by its identifier.
  Future<void> deleteQuestion(int id);
}
