import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../../domain/entities/temperature_entry.dart';

final temperatureEntriesProvider =
    StreamProvider.autoDispose<List<TemperatureEntry>>((ref) {
  return ref.watch(temperatureRepositoryProvider).watchTemperatures();
});
