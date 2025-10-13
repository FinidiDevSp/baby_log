import 'package:equatable/equatable.dart';

/// Domain entity that represents a pediatrician question recorded by the family.
class PediatricianQuestion extends Equatable {
  const PediatricianQuestion({
    this.id,
    required this.content,
    required this.isResolved,
    required this.createdAt,
    required this.updatedAt,
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

  PediatricianQuestion copyWith({
    int? id,
    String? content,
    bool? isResolved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PediatricianQuestion(
      id: id ?? this.id,
      content: content ?? this.content,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, content, isResolved, createdAt, updatedAt];
}
