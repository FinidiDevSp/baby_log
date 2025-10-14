import 'package:equatable/equatable.dart';

/// Domain entity that represents a pediatrician question recorded by the family.
enum PediatricianQuestionSatisfaction {
  satisfied,
  neutral,
  dissatisfied,
}

class PediatricianQuestion extends Equatable {
  const PediatricianQuestion({
    this.id,
    required this.content,
    required this.isResolved,
    required this.createdAt,
    required this.updatedAt,
    this.satisfaction,
    this.resolutionNote,
  });

  /// Database identifier. Null when the question has not been persisted yet.
  final int? id;

  /// Free-form text describing the question.
  final String content;

  /// Whether the family has already clarified this question with the pediatrician.
  final bool isResolved;

  /// When the question was originally recorded.
  final DateTime createdAt;

  /// Last time the question was updated.
  final DateTime updatedAt;

  /// Satisfaction recorded after resolving the question.
  final PediatricianQuestionSatisfaction? satisfaction;

  /// Optional note that elaborates on the resolution.
  final String? resolutionNote;

  PediatricianQuestion copyWith({
    int? id,
    String? content,
    bool? isResolved,
    DateTime? createdAt,
    DateTime? updatedAt,
    PediatricianQuestionSatisfaction? satisfaction,
    bool satisfactionSet = false,
    String? resolutionNote,
    bool resolutionNoteSet = false,
  }) {
    return PediatricianQuestion(
      id: id ?? this.id,
      content: content ?? this.content,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      satisfaction: satisfactionSet ? satisfaction : this.satisfaction,
      resolutionNote: resolutionNoteSet ? resolutionNote : this.resolutionNote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        isResolved,
        createdAt,
        updatedAt,
        satisfaction,
        resolutionNote,
      ];
}
