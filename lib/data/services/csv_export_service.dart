import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

import '../../domain/entities/baby_profile.dart';
import '../../domain/entities/bath_entry.dart';
import '../../domain/entities/feeding_entry.dart';
import '../../domain/entities/pediatrician_question.dart';
import '../../domain/entities/stool_entry.dart';
import '../../domain/entities/temperature_entry.dart';
import '../../domain/entities/vomit_entry.dart';
import '../../domain/repositories/baby_repository.dart';
import '../../domain/repositories/bath_repository.dart';
import '../../domain/repositories/feeding_repository.dart';
import '../../domain/repositories/pediatrician_question_repository.dart';
import '../../domain/repositories/stool_repository.dart';
import '../../domain/repositories/temperature_repository.dart';
import '../../domain/repositories/vomit_repository.dart';

/// Result produced after generating the centralized CSV export.
class CsvExportResult {
  /// Creates a CSV export result with metadata and raw bytes.
  const CsvExportResult({
    required this.fileName,
    required this.bytes,
    this.feedings = 0,
    this.stools = 0,
    this.vomits = 0,
    this.baths = 0,
    this.temperatures = 0,
    this.questions = 0,
    this.includesBabyProfile = false,
  });

  /// Suggested filename (without path) for the generated CSV file.
  final String fileName;

  /// Raw CSV bytes encoded as UTF-8.
  final Uint8List bytes;

  /// Number of feeding entries included.
  final int feedings;

  /// Number of stool entries included.
  final int stools;

  /// Number of vomit entries included.
  final int vomits;

  /// Number of bath entries included.
  final int baths;

  /// Number of temperature entries included.
  final int temperatures;

  /// Number of pediatrician questions included.
  final int questions;

  /// Whether the baby profile information is present.
  final bool includesBabyProfile;

  /// Total number of rows exported (excluding the header).
  int get totalRows =>
      feedings +
      stools +
      vomits +
      baths +
      temperatures +
      questions +
      (includesBabyProfile ? 1 : 0);
}

/// Builds a centralized CSV snapshot with every record stored in the database.
class CsvExportService {
  /// Creates the service with the necessary repositories.
  CsvExportService({
    required BabyRepository babyRepository,
    required FeedingRepository feedingRepository,
    required StoolRepository stoolRepository,
    required VomitRepository vomitRepository,
    required BathRepository bathRepository,
    required TemperatureRepository temperatureRepository,
    required PediatricianQuestionRepository questionRepository,
  })  : _babyRepository = babyRepository,
        _feedingRepository = feedingRepository,
        _stoolRepository = stoolRepository,
        _vomitRepository = vomitRepository,
        _bathRepository = bathRepository,
        _temperatureRepository = temperatureRepository,
        _questionRepository = questionRepository;

  static const _header = <String>[
    'type',
    'timestamp',
    'value',
    'details',
    'notes',
    'payload',
  ];

  final BabyRepository _babyRepository;
  final FeedingRepository _feedingRepository;
  final StoolRepository _stoolRepository;
  final VomitRepository _vomitRepository;
  final BathRepository _bathRepository;
  final TemperatureRepository _temperatureRepository;
  final PediatricianQuestionRepository _questionRepository;

  /// Generates a CSV snapshot that contains every record stored locally.
  Future<CsvExportResult> exportAll() async {
    final baby = await _babyRepository.fetchBaby();
    final feedings = await _feedingRepository.watchFeedings().first;
    final stools = await _stoolRepository.watchStools().first;
    final vomits = await _vomitRepository.watchVomits().first;
    final baths = await _bathRepository.watchBaths().first;
    final temperatures = await _temperatureRepository.watchTemperatures().first;
    final questions = await _questionRepository.watchQuestions().first;

    final rows = <List<dynamic>>[_header];

    final payloadEncoder = const JsonEncoder();

    if (baby != null) {
      rows.add(_buildBabyProfileRow(baby, payloadEncoder));
    }
    for (final entry in feedings) {
      rows.add(_buildFeedingRow(entry, payloadEncoder));
    }
    for (final entry in stools) {
      rows.add(_buildStoolRow(entry, payloadEncoder));
    }
    for (final entry in vomits) {
      rows.add(_buildVomitRow(entry, payloadEncoder));
    }
    for (final entry in baths) {
      rows.add(_buildBathRow(entry, payloadEncoder));
    }
    for (final entry in temperatures) {
      rows.add(_buildTemperatureRow(entry, payloadEncoder));
    }
    for (final entry in questions) {
      rows.add(_buildQuestionRow(entry, payloadEncoder));
    }

    final csv = const ListToCsvConverter().convert(rows);
    final bytes = Uint8List.fromList(utf8.encode(csv));
    final fileName = _resolveFileName();

    return CsvExportResult(
      fileName: fileName,
      bytes: bytes,
      feedings: feedings.length,
      stools: stools.length,
      vomits: vomits.length,
      baths: baths.length,
      temperatures: temperatures.length,
      questions: questions.length,
      includesBabyProfile: baby != null,
    );
  }

  static List<dynamic> _buildBabyProfileRow(
    BabyProfile profile,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'baby_profile',
      'name': profile.name,
      'gender': profile.gender.name,
      'birthDate': profile.birthDate.toIso8601String(),
      'birthTimeMinutes': profile.birthTimeMinutes,
      'birthWeightKg': profile.birthWeightKg,
      'birthLengthCm': profile.birthLengthCm,
      'accentColorValue': profile.accentColorValue,
      'photoPath': profile.photoPath,
    });
    final birthTime = _minutesToTime(profile.birthTimeMinutes);
    final details = 'gender=${profile.gender.name};time=$birthTime';

    return <dynamic>[
      'baby_profile',
      profile.birthDate.toIso8601String(),
      profile.name,
      details,
      profile.photoPath ?? '',
      payload,
    ];
  }

  static List<dynamic> _buildFeedingRow(
    FeedingEntry entry,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'feeding',
      'timestamp': entry.timestamp.toIso8601String(),
      'amountMl': entry.amountMl,
      'notes': entry.notes,
    });
    return <dynamic>[
      'feeding',
      entry.timestamp.toIso8601String(),
      entry.amountMl,
      'amount_ml',
      entry.notes ?? '',
      payload,
    ];
  }

  static List<dynamic> _buildStoolRow(
    StoolEntry entry,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'stool',
      'timestamp': entry.timestamp.toIso8601String(),
      'consistency': entry.consistency.name,
      'notes': entry.notes,
    });
    return <dynamic>[
      'stool',
      entry.timestamp.toIso8601String(),
      entry.consistency.name,
      'consistency',
      entry.notes ?? '',
      payload,
    ];
  }

  static List<dynamic> _buildVomitRow(
    VomitEntry entry,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'vomit',
      'timestamp': entry.timestamp.toIso8601String(),
      'amount': entry.amount.name,
      'notes': entry.notes,
    });
    return <dynamic>[
      'vomit',
      entry.timestamp.toIso8601String(),
      entry.amount.name,
      'amount',
      entry.notes ?? '',
      payload,
    ];
  }

  static List<dynamic> _buildBathRow(
    BathEntry entry,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'bath',
      'timestamp': entry.timestamp.toIso8601String(),
      'bathType': entry.type.name,
      'notes': entry.notes,
    });
    return <dynamic>[
      'bath',
      entry.timestamp.toIso8601String(),
      entry.type.name,
      'bath_type',
      entry.notes ?? '',
      payload,
    ];
  }

  static List<dynamic> _buildTemperatureRow(
    TemperatureEntry entry,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'temperature',
      'timestamp': entry.timestamp.toIso8601String(),
      'celsius': entry.celsius,
      'notes': entry.notes,
    });
    return <dynamic>[
      'temperature',
      entry.timestamp.toIso8601String(),
      entry.celsius,
      'temperature_celsius',
      entry.notes ?? '',
      payload,
    ];
  }

  static List<dynamic> _buildQuestionRow(
    PediatricianQuestion entry,
    JsonEncoder encoder,
  ) {
    final payload = encoder.convert({
      'type': 'pediatrician_question',
      'content': entry.content,
      'isResolved': entry.isResolved,
      'createdAt': entry.createdAt.toIso8601String(),
      'updatedAt': entry.updatedAt.toIso8601String(),
      'satisfaction': entry.satisfaction?.name,
      'resolutionNote': entry.resolutionNote,
    });
    final details = StringBuffer('resolved=${entry.isResolved}');
    if (entry.satisfaction != null) {
      details.write(';satisfaction=${entry.satisfaction!.name}');
    }
    return <dynamic>[
      'pediatrician_question',
      entry.updatedAt.toIso8601String(),
      entry.content,
      details.toString(),
      entry.resolutionNote ?? '',
      payload,
    ];
  }

  static String _resolveFileName() {
    final now = DateTime.now();
    final yyyy = now.year.toString().padLeft(4, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    final hh = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    final ss = now.second.toString().padLeft(2, '0');
    return 'baby-log-export-$yyyy$mm$dd-$hh$min$ss.csv';
  }

  static String _minutesToTime(int minutes) {
    final total = minutes.clamp(0, 1440);
    final hours = (total ~/ 60).toString().padLeft(2, '0');
    final mins = (total % 60).toString().padLeft(2, '0');
    return '$hours:$mins';
  }
}
