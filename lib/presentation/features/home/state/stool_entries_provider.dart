import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../domain/entities/stool_entry.dart';

/// Exposes the stored diaper change entries ordered from newest to oldest.
final stoolEntriesProvider =
    StreamProvider.autoDispose<List<StoolEntry>>((ref) {
  return ref.watch(stoolRepositoryProvider).watchStools();
});
