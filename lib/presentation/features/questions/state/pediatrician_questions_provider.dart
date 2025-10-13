import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:baby_log/core/providers.dart';
import 'package:baby_log/domain/entities/pediatrician_question.dart';

final pediatricianQuestionsProvider =
    StreamProvider<List<PediatricianQuestion>>((ref) {
      final repository = ref.watch(pediatricianQuestionRepositoryProvider);
      return repository.watchQuestions();
    });
