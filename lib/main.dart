import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/app/baby_log_app.dart';

void main() {
  runApp(const ProviderScope(child: BabyLogApp()));
}
