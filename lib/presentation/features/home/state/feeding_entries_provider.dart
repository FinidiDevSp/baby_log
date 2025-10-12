import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../domain/entities/feeding_entry.dart';

/// Exposes the stored bottle feeding entries ordered from newest to oldest.
final feedingEntriesProvider =
    StreamProvider.autoDispose<List<FeedingEntry>>((ref) {
  return ref.watch(feedingRepositoryProvider).watchFeedings();
});
