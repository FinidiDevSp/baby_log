import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../domain/entities/bath_entry.dart';

/// Exposes the stored bath entries ordered from newest to oldest.
final bathEntriesProvider = StreamProvider.autoDispose<List<BathEntry>>((ref) {
  return ref.watch(bathRepositoryProvider).watchBaths();
});
