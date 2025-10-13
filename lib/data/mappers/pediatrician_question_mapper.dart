import 'package:drift/drift.dart';

import '../../domain/entities/pediatrician_question.dart';
import '../local/app_database.dart';

PediatricianQuestion mapPediatricianQuestionRowToDomain(
  PediatricianQuestionRow row,
) {
  return PediatricianQuestion(
    id: row.id,
    content: row.content,
    isResolved: row.resolved,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}

PediatricianQuestionsCompanion mapPediatricianQuestionToCompanion(
  PediatricianQuestion question,
) {
  return PediatricianQuestionsCompanion(
    id: question.id == null ? const Value.absent() : Value(question.id!),
    content: Value(question.content),
    resolved: Value(question.isResolved),
    createdAt: Value(question.createdAt),
    updatedAt: Value(question.updatedAt),
  );
}
