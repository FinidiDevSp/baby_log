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
    satisfaction: row.satisfaction == null
        ? null
        : PediatricianQuestionSatisfaction.values[row.satisfaction!],
    resolutionNote: row.resolutionNote,
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
    satisfaction: question.satisfaction == null
        ? const Value.absent()
        : Value(question.satisfaction!.index),
    resolutionNote: question.resolutionNote == null
        ? const Value.absent()
        : Value(question.resolutionNote!),
  );
}
