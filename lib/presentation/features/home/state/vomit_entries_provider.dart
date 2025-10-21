import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/vomit_entry.dart';
import '../../../../core/providers.dart';

/// Exposes the stored vomit entries ordered from newest to oldest.
final vomitEntriesProvider = StreamProvider.autoDispose<List<VomitEntry>>((
  ref,
) {
  return ref.watch(vomitRepositoryProvider).watchVomits();
});
