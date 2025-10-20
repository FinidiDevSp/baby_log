import 'dart:async';
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
import '../../domain/value_objects/baby_gender.dart';

/// How the importer should behave when encountering duplicates.
enum CsvImportMode { overwriteDuplicates, skipDuplicates }

/// Supported CSV layouts.
enum CsvImportFormat { centralized, legacy }

/// Result with the amount of imported entries per category.
class CsvImportResult {
  /// Creates a result with the imported counters.
  const CsvImportResult({
    this.feedings = 0,
    this.stools = 0,
    this.vomits = 0,
    this.baths = 0,
    this.temperatures = 0,
    this.questions = 0,
    this.babyProfileUpdated = false,
  });

  /// Imported bottle feedings count.
  final int feedings;

  /// Imported stool entries count.
  final int stools;

  /// Imported vomit entries count.
  final int vomits;

  /// Imported bath entries count.
  final int baths;

  /// Imported temperature entries count.
  final int temperatures;

  /// Imported pediatrician questions count.
  final int questions;

  /// Whether the baby profile was created or updated.
  final bool babyProfileUpdated;

  /// Total imported records across all categories.
  int get total =>
      feedings +
      stools +
      vomits +
      baths +
      temperatures +
      questions +
      (babyProfileUpdated ? 1 : 0);

  /// Creates a new result accumulating the provided deltas.
  CsvImportResult copyWithDelta({
    int feedingsDelta = 0,
    int stoolsDelta = 0,
    int vomitsDelta = 0,
    int bathsDelta = 0,
    int temperaturesDelta = 0,
    int questionsDelta = 0,
    bool babyProfileUpdated = false,
  }) {
    return CsvImportResult(
      feedings: feedings + feedingsDelta,
      stools: stools + stoolsDelta,
      vomits: vomits + vomitsDelta,
      baths: baths + bathsDelta,
      temperatures: temperatures + temperaturesDelta,
      questions: questions + questionsDelta,
      babyProfileUpdated: this.babyProfileUpdated || babyProfileUpdated,
    );
  }
}

/// All the entries that would be imported from a CSV file.
class CsvImportPreview {
  /// Creates a preview with the consolidated entries.
  CsvImportPreview({
    required this.format,
    required this.parsedRows,
    required List<String> issues,
    required List<FeedingEntry> feedingsToInsert,
    required List<FeedingEntry> feedingsToOverwrite,
    required List<StoolEntry> stoolsToInsert,
    required List<StoolEntry> stoolsToOverwrite,
    required List<VomitEntry> vomitsToInsert,
    required List<VomitEntry> vomitsToOverwrite,
    required List<BathEntry> bathsToInsert,
    required List<BathEntry> bathsToOverwrite,
    required List<TemperatureEntry> temperaturesToInsert,
    required List<TemperatureEntry> temperaturesToOverwrite,
    required List<PediatricianQuestion> questionsToInsert,
    required List<PediatricianQuestion> questionsToOverwrite,
    this.newBabyProfile,
    this.babyProfileToOverwrite,
  })  : issues = List.unmodifiable(issues),
        feedingsToInsert = List.unmodifiable(feedingsToInsert),
        feedingsToOverwrite = List.unmodifiable(feedingsToOverwrite),
        stoolsToInsert = List.unmodifiable(stoolsToInsert),
        stoolsToOverwrite = List.unmodifiable(stoolsToOverwrite),
        vomitsToInsert = List.unmodifiable(vomitsToInsert),
        vomitsToOverwrite = List.unmodifiable(vomitsToOverwrite),
        bathsToInsert = List.unmodifiable(bathsToInsert),
        bathsToOverwrite = List.unmodifiable(bathsToOverwrite),
        temperaturesToInsert = List.unmodifiable(temperaturesToInsert),
        temperaturesToOverwrite = List.unmodifiable(temperaturesToOverwrite),
        questionsToInsert = List.unmodifiable(questionsToInsert),
        questionsToOverwrite = List.unmodifiable(questionsToOverwrite);

  /// Recognized CSV layout.
  final CsvImportFormat format;

  /// Number of data rows parsed (excluding the header).
  final int parsedRows;

  /// Non-fatal parsing issues detected while reading the file.
  final List<String> issues;

  /// Entries that are brand new and will be inserted.
  final List<FeedingEntry> feedingsToInsert;

  /// Entries that match an existing feeding and can be overwritten.
  final List<FeedingEntry> feedingsToOverwrite;

  /// Entries that are brand new and will be inserted.
  final List<StoolEntry> stoolsToInsert;

  /// Entries that match an existing stool event and can be overwritten.
  final List<StoolEntry> stoolsToOverwrite;

  /// Entries that are brand new and will be inserted.
  final List<VomitEntry> vomitsToInsert;

  /// Entries that match an existing vomit event and can be overwritten.
  final List<VomitEntry> vomitsToOverwrite;

  /// Entries that are brand new and will be inserted.
  final List<BathEntry> bathsToInsert;

  /// Entries that match an existing bath event and can be overwritten.
  final List<BathEntry> bathsToOverwrite;

  /// Entries that are brand new and will be inserted.
  final List<TemperatureEntry> temperaturesToInsert;

  /// Entries that match an existing temperature entry and can be overwritten.
  final List<TemperatureEntry> temperaturesToOverwrite;

  /// Questions that are brand new and will be inserted.
  final List<PediatricianQuestion> questionsToInsert;

  /// Questions that match existing records and can be overwritten.
  final List<PediatricianQuestion> questionsToOverwrite;

  /// Baby profile to create when none exists locally.
  final BabyProfile? newBabyProfile;

  /// Baby profile to overwrite when one already exists.
  final BabyProfile? babyProfileToOverwrite;

  /// Amount of new entries that will be inserted.
  int get totalNew =>
      feedingsToInsert.length +
      stoolsToInsert.length +
      vomitsToInsert.length +
      bathsToInsert.length +
      temperaturesToInsert.length +
      questionsToInsert.length +
      (newBabyProfile != null ? 1 : 0);

  /// Amount of entries that match existing records.
  int get totalToOverwrite =>
      feedingsToOverwrite.length +
      stoolsToOverwrite.length +
      vomitsToOverwrite.length +
      bathsToOverwrite.length +
      temperaturesToOverwrite.length +
      questionsToOverwrite.length +
      (babyProfileToOverwrite != null ? 1 : 0);

  /// Total entries detected in the file.
  int get totalIncoming => totalNew + totalToOverwrite;

  /// Whether there are entries that conflict with existing data.
  bool get hasDuplicates => totalToOverwrite > 0;

  /// Whether the file contains usable data.
  bool get hasData => totalIncoming > 0;
}

class _CsvParsedData {
  const _CsvParsedData({
    required this.format,
    required this.parsedRows,
    required this.feedings,
    required this.stools,
    required this.vomits,
    required this.baths,
    required this.temperatures,
    required this.questions,
    required this.issues,
    this.babyProfile,
  });

  final CsvImportFormat format;
  final int parsedRows;
  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;
  final List<PediatricianQuestion> questions;
  final List<String> issues;
  final BabyProfile? babyProfile;

  bool get isEmpty =>
      feedings.isEmpty &&
      stools.isEmpty &&
      vomits.isEmpty &&
      baths.isEmpty &&
      temperatures.isEmpty &&
      questions.isEmpty &&
      babyProfile == null;
}

class _ExistingDataSnapshot {
  const _ExistingDataSnapshot({
    required this.feedings,
    required this.stools,
    required this.vomits,
    required this.baths,
    required this.temperatures,
    required this.questions,
    required this.baby,
  });

  final List<FeedingEntry> feedings;
  final List<StoolEntry> stools;
  final List<VomitEntry> vomits;
  final List<BathEntry> baths;
  final List<TemperatureEntry> temperatures;
  final List<PediatricianQuestion> questions;
  final BabyProfile? baby;
}

class _SplitResult<T> {
  const _SplitResult({required this.toInsert, required this.toOverwrite});

  final List<T> toInsert;
  final List<T> toOverwrite;
}

/// Imports timeline data from a CSV file into the local database.
class CsvImportService {
  /// Creates a new import service with the required repositories.
  CsvImportService({
    required FeedingRepository feedingRepository,
    required StoolRepository stoolRepository,
    required VomitRepository vomitRepository,
    required BathRepository bathRepository,
    required TemperatureRepository temperatureRepository,
    required PediatricianQuestionRepository questionRepository,
    required BabyRepository babyRepository,
  })  : _feedingRepository = feedingRepository,
        _stoolRepository = stoolRepository,
        _vomitRepository = vomitRepository,
        _bathRepository = bathRepository,
        _temperatureRepository = temperatureRepository,
        _questionRepository = questionRepository,
        _babyRepository = babyRepository;

  static const _defaultStoolConsistency = StoolConsistency.soft;
  static const _defaultVomitAmount = VomitAmount.medium;
  static const _defaultBathType = BathType.full;

  final FeedingRepository _feedingRepository;
  final StoolRepository _stoolRepository;
  final VomitRepository _vomitRepository;
  final BathRepository _bathRepository;
  final TemperatureRepository _temperatureRepository;
  final PediatricianQuestionRepository _questionRepository;
  final BabyRepository _babyRepository;

  /// Reads the provided CSV bytes and returns a preview without mutating the database.
  Future<CsvImportPreview> previewCsv(Uint8List bytes) async {
    if (bytes.isEmpty) {
      return _emptyPreview();
    }

    final csvContent = utf8.decode(bytes, allowMalformed: true);
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(csvContent);

    if (rows.isEmpty) {
      return _emptyPreview();
    }

    final header = rows.first.map((value) => _asString(value)).toList();
    final dataRows = rows.skip(1).cast<List<dynamic>>().toList();
    final parsed = _parseRows(header, dataRows);
    if (parsed.isEmpty) {
      return CsvImportPreview(
        format: parsed.format,
        parsedRows: parsed.parsedRows,
        issues: parsed.issues,
        feedingsToInsert: const [],
        feedingsToOverwrite: const [],
        stoolsToInsert: const [],
        stoolsToOverwrite: const [],
        vomitsToInsert: const [],
        vomitsToOverwrite: const [],
        bathsToInsert: const [],
        bathsToOverwrite: const [],
        temperaturesToInsert: const [],
        temperaturesToOverwrite: const [],
        questionsToInsert: const [],
        questionsToOverwrite: const [],
      );
    }

    final existing = await _loadExistingData();

    final feedingSplit = _splitEntries<FeedingEntry>(
      parsed.feedings,
      existing.feedings,
      (incoming, current) =>
          incoming.timestamp.isAtSameMomentAs(current.timestamp) &&
          incoming.amountMl == current.amountMl,
      (incoming, current) => incoming.copyWith(id: current.id),
    );

    final stoolSplit = _splitEntries<StoolEntry>(
      parsed.stools,
      existing.stools,
      (incoming, current) =>
          incoming.timestamp.isAtSameMomentAs(current.timestamp) &&
          incoming.consistency == current.consistency,
      (incoming, current) => incoming.copyWith(id: current.id),
    );

    final vomitSplit = _splitEntries<VomitEntry>(
      parsed.vomits,
      existing.vomits,
      (incoming, current) =>
          incoming.timestamp.isAtSameMomentAs(current.timestamp) &&
          incoming.amount == current.amount,
      (incoming, current) => incoming.copyWith(id: current.id),
    );

    final bathSplit = _splitEntries<BathEntry>(
      parsed.baths,
      existing.baths,
      (incoming, current) =>
          incoming.timestamp.isAtSameMomentAs(current.timestamp) &&
          incoming.type == current.type,
      (incoming, current) => incoming.copyWith(id: current.id),
    );

    final temperatureSplit = _splitEntries<TemperatureEntry>(
      parsed.temperatures,
      existing.temperatures,
      (incoming, current) =>
          incoming.timestamp.isAtSameMomentAs(current.timestamp) &&
          (incoming.celsius - current.celsius).abs() < 0.01,
      (incoming, current) => incoming.copyWith(id: current.id),
    );

    final questionSplit = _splitEntries<PediatricianQuestion>(
      parsed.questions,
      existing.questions,
      (incoming, current) =>
          _normalizeText(incoming.content) ==
              _normalizeText(current.content) &&
          incoming.createdAt.isAtSameMomentAs(current.createdAt),
      (incoming, current) => incoming.copyWith(
        id: current.id,
        satisfaction: incoming.satisfaction,
        satisfactionSet: true,
        resolutionNote: incoming.resolutionNote,
        resolutionNoteSet: true,
      ),
    );

    BabyProfile? newBabyProfile;
    BabyProfile? babyProfileToOverwrite;
    if (parsed.babyProfile != null) {
      final incoming = parsed.babyProfile!;
      final existingBaby = existing.baby;
      if (existingBaby == null) {
        newBabyProfile = incoming;
      } else {
        babyProfileToOverwrite = incoming.copyWith(id: existingBaby.id);
      }
    }

    return CsvImportPreview(
      format: parsed.format,
      parsedRows: parsed.parsedRows,
      issues: parsed.issues,
      feedingsToInsert: feedingSplit.toInsert,
      feedingsToOverwrite: feedingSplit.toOverwrite,
      stoolsToInsert: stoolSplit.toInsert,
      stoolsToOverwrite: stoolSplit.toOverwrite,
      vomitsToInsert: vomitSplit.toInsert,
      vomitsToOverwrite: vomitSplit.toOverwrite,
      bathsToInsert: bathSplit.toInsert,
      bathsToOverwrite: bathSplit.toOverwrite,
      temperaturesToInsert: temperatureSplit.toInsert,
      temperaturesToOverwrite: temperatureSplit.toOverwrite,
      questionsToInsert: questionSplit.toInsert,
      questionsToOverwrite: questionSplit.toOverwrite,
      newBabyProfile: newBabyProfile,
      babyProfileToOverwrite: babyProfileToOverwrite,
    );
  }

  /// Persists the entries described in [preview] using the provided mode.
  Future<CsvImportResult> importPreview(
    CsvImportPreview preview, {
    required CsvImportMode mode,
  }) async {
    var result = const CsvImportResult();

    for (final entry in preview.feedingsToInsert) {
      await _feedingRepository.addFeeding(entry);
      result = result.copyWithDelta(feedingsDelta: 1);
    }
    if (mode == CsvImportMode.overwriteDuplicates) {
      for (final entry in preview.feedingsToOverwrite) {
        await _feedingRepository.updateFeeding(entry);
        result = result.copyWithDelta(feedingsDelta: 1);
      }
    }

    for (final entry in preview.stoolsToInsert) {
      await _stoolRepository.addStool(entry);
      result = result.copyWithDelta(stoolsDelta: 1);
    }
    if (mode == CsvImportMode.overwriteDuplicates) {
      for (final entry in preview.stoolsToOverwrite) {
        await _stoolRepository.updateStool(entry);
        result = result.copyWithDelta(stoolsDelta: 1);
      }
    }

    for (final entry in preview.vomitsToInsert) {
      await _vomitRepository.addVomit(entry);
      result = result.copyWithDelta(vomitsDelta: 1);
    }
    if (mode == CsvImportMode.overwriteDuplicates) {
      for (final entry in preview.vomitsToOverwrite) {
        await _vomitRepository.updateVomit(entry);
        result = result.copyWithDelta(vomitsDelta: 1);
      }
    }

    for (final entry in preview.bathsToInsert) {
      await _bathRepository.addBath(entry);
      result = result.copyWithDelta(bathsDelta: 1);
    }
    if (mode == CsvImportMode.overwriteDuplicates) {
      for (final entry in preview.bathsToOverwrite) {
        await _bathRepository.updateBath(entry);
        result = result.copyWithDelta(bathsDelta: 1);
      }
    }

    for (final entry in preview.temperaturesToInsert) {
      await _temperatureRepository.addTemperature(entry);
      result = result.copyWithDelta(temperaturesDelta: 1);
    }
    if (mode == CsvImportMode.overwriteDuplicates) {
      for (final entry in preview.temperaturesToOverwrite) {
        await _temperatureRepository.updateTemperature(entry);
        result = result.copyWithDelta(temperaturesDelta: 1);
      }
    }

    for (final entry in preview.questionsToInsert) {
      await _questionRepository.addQuestion(entry);
      result = result.copyWithDelta(questionsDelta: 1);
    }
    if (mode == CsvImportMode.overwriteDuplicates) {
      for (final entry in preview.questionsToOverwrite) {
        await _questionRepository.updateQuestion(entry);
        result = result.copyWithDelta(questionsDelta: 1);
      }
    }

    if (preview.newBabyProfile != null) {
      await _babyRepository.saveBaby(preview.newBabyProfile!);
      result = result.copyWithDelta(babyProfileUpdated: true);
    } else if (preview.babyProfileToOverwrite != null &&
        mode == CsvImportMode.overwriteDuplicates) {
      await _babyRepository.saveBaby(preview.babyProfileToOverwrite!);
      result = result.copyWithDelta(babyProfileUpdated: true);
    }

    return result;
  }

  static CsvImportPreview _emptyPreview() {
    return CsvImportPreview(
      format: CsvImportFormat.centralized,
      parsedRows: 0,
      issues: <String>[],
      feedingsToInsert: <FeedingEntry>[],
      feedingsToOverwrite: <FeedingEntry>[],
      stoolsToInsert: <StoolEntry>[],
      stoolsToOverwrite: <StoolEntry>[],
      vomitsToInsert: <VomitEntry>[],
      vomitsToOverwrite: <VomitEntry>[],
      bathsToInsert: <BathEntry>[],
      bathsToOverwrite: <BathEntry>[],
      temperaturesToInsert: <TemperatureEntry>[],
      temperaturesToOverwrite: <TemperatureEntry>[],
      questionsToInsert: <PediatricianQuestion>[],
      questionsToOverwrite: <PediatricianQuestion>[],
    );
  }

  static _CsvParsedData _parseRows(
    List<String> header,
    List<List<dynamic>> rows,
  ) {
    final normalizedHeader =
        header.map((value) => _normalizeHeader(value)).toList(growable: false);
    final typeIndex = _resolveColumnIndex(normalizedHeader, const ['type']);
    final payloadIndex =
        _resolveColumnIndex(normalizedHeader, const ['payload', 'data']);
    if (typeIndex != -1 && payloadIndex != -1) {
      return _parseCentralizedFormat(
        rows,
        typeIndex: typeIndex,
        payloadIndex: payloadIndex,
      );
    }
    return _parseLegacyFormat(header, rows);
  }

  static _CsvParsedData _parseCentralizedFormat(
    List<List<dynamic>> rows, {
    required int typeIndex,
    required int payloadIndex,
  }) {
    final feedings = <FeedingEntry>[];
    final stools = <StoolEntry>[];
    final vomits = <VomitEntry>[];
    final baths = <BathEntry>[];
    final temperatures = <TemperatureEntry>[];
    final questions = <PediatricianQuestion>[];
    BabyProfile? babyProfile;
    final issues = <String>[];

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) {
        continue;
      }
      final typeValue = _readCell(row, typeIndex)?.toLowerCase();
      final payloadText = _readCell(row, payloadIndex);
      if (typeValue == null || payloadText == null) {
        issues.add('row ${i + 2}: missing type or payload');
        continue;
      }

      Map<String, dynamic>? payload;
      try {
        final decoded = jsonDecode(payloadText);
        if (decoded is Map<String, dynamic>) {
          payload = decoded;
        }
      } catch (_) {
        // Ignore parsing errors; the issue is logged below.
      }

      if (payload == null) {
        issues.add('row ${i + 2}: payload is not a JSON object');
        continue;
      }

      switch (typeValue) {
        case 'feeding':
          final entry = _parseFeedingPayload(payload);
          if (entry != null) {
            feedings.add(entry);
          } else {
            issues.add('row ${i + 2}: invalid feeding');
          }
          break;
        case 'stool':
          final entry = _parseStoolPayload(payload);
          if (entry != null) {
            stools.add(entry);
          } else {
            issues.add('row ${i + 2}: invalid stool entry');
          }
          break;
        case 'vomit':
          final entry = _parseVomitPayload(payload);
          if (entry != null) {
            vomits.add(entry);
          } else {
            issues.add('row ${i + 2}: invalid vomit entry');
          }
          break;
        case 'bath':
          final entry = _parseBathPayload(payload);
          if (entry != null) {
            baths.add(entry);
          } else {
            issues.add('row ${i + 2}: invalid bath entry');
          }
          break;
        case 'temperature':
          final entry = _parseTemperaturePayload(payload);
          if (entry != null) {
            temperatures.add(entry);
          } else {
            issues.add('row ${i + 2}: invalid temperature entry');
          }
          break;
        case 'pediatrician_question':
          final entry = _parseQuestionPayload(payload);
          if (entry != null) {
            questions.add(entry);
          } else {
            issues.add('row ${i + 2}: invalid question entry');
          }
          break;
        case 'baby_profile':
          final parsedProfile = _parseBabyProfilePayload(payload);
          if (parsedProfile != null) {
            babyProfile = parsedProfile;
          } else {
            issues.add('row ${i + 2}: invalid baby profile');
          }
          break;
        default:
          issues.add('row ${i + 2}: unsupported record type "$typeValue"');
      }
    }

    return _CsvParsedData(
      format: CsvImportFormat.centralized,
      parsedRows: rows.length,
      feedings: feedings,
      stools: stools,
      vomits: vomits,
      baths: baths,
      temperatures: temperatures,
      questions: questions,
      issues: issues,
      babyProfile: babyProfile,
    );
  }

  static _CsvParsedData _parseLegacyFormat(
    List<String> header,
    List<List<dynamic>> rows,
  ) {
    final feedings = <FeedingEntry>[];
    final stools = <StoolEntry>[];
    final vomits = <VomitEntry>[];
    final baths = <BathEntry>[];
    final issues = <String>[];

    final dateIndex = _resolveColumnIndex(header, const ['fecha']);
    final timeIndex = _resolveColumnIndex(header, const ['hora']);
    final bottleIndex = _resolveColumnIndex(
      header,
      const ['biberonml', 'biberon (ml)'],
      fallback: 2,
    );
    final stoolIndex =
        _resolveColumnIndex(header, const ['caca'], fallback: 3);
    final vomitIndex =
        _resolveColumnIndex(header, const ['vomito'], fallback: 4);
    final bathIndex =
        _resolveColumnIndex(header, const ['bano', 'ba\u00f1o'], fallback: 5);

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) {
        continue;
      }

      final dateValue = _readCell(row, dateIndex);
      final timeValue = _readCell(row, timeIndex);
      final timestamp = _parseTimestamp(dateValue, timeValue);

      if (timestamp == null) {
        issues.add('row ${i + 2}: invalid date or time');
        continue;
      }

      final feedingCell = _readCell(row, bottleIndex);
      if (feedingCell != null && feedingCell.isNotEmpty) {
        final numericText = feedingCell
            .replaceAll(RegExp(r'[^0-9,\.]'), '')
            .replaceAll(',', '.');
        final amountValue = double.tryParse(numericText);
        final amount = amountValue?.round();
        if (amount != null && amount > 0) {
          feedings.add(
            FeedingEntry(timestamp: timestamp, amountMl: amount),
          );
        } else {
          issues.add('row ${i + 2}: invalid feeding amount');
        }
      }

      final stoolCell = _readCell(row, stoolIndex);
      if (_isTruthy(stoolCell)) {
        stools.add(
          StoolEntry(
            timestamp: timestamp,
            consistency: _defaultStoolConsistency,
          ),
        );
      }

      final vomitCell = _readCell(row, vomitIndex);
      if (_isTruthy(vomitCell)) {
        vomits.add(
          VomitEntry(
            timestamp: timestamp,
            amount: _defaultVomitAmount,
          ),
        );
      }

      final bathCell = _readCell(row, bathIndex);
      if (_isTruthy(bathCell)) {
        baths.add(
          BathEntry(
            timestamp: timestamp,
            type: _defaultBathType,
          ),
        );
      }
    }

    return _CsvParsedData(
      format: CsvImportFormat.legacy,
      parsedRows: rows.length,
      feedings: feedings,
      stools: stools,
      vomits: vomits,
      baths: baths,
      temperatures: const [],
      questions: const [],
      issues: issues,
    );
  }

  Future<_ExistingDataSnapshot> _loadExistingData() async {
    final feedings = await _feedingRepository.watchFeedings().first;
    final stools = await _stoolRepository.watchStools().first;
    final vomits = await _vomitRepository.watchVomits().first;
    final baths = await _bathRepository.watchBaths().first;
    final temperatures = await _temperatureRepository.watchTemperatures().first;
    final questions = await _questionRepository.watchQuestions().first;
    final baby = await _babyRepository.fetchBaby();

    return _ExistingDataSnapshot(
      feedings: List<FeedingEntry>.from(feedings),
      stools: List<StoolEntry>.from(stools),
      vomits: List<VomitEntry>.from(vomits),
      baths: List<BathEntry>.from(baths),
      temperatures: List<TemperatureEntry>.from(temperatures),
      questions: List<PediatricianQuestion>.from(questions),
      baby: baby,
    );
  }

  static _SplitResult<T> _splitEntries<T>(
    List<T> incoming,
    List<T> existing,
    bool Function(T incoming, T current) isDuplicate,
    T Function(T incoming, T current) buildReplacement,
  ) {
    final remaining = List<T>.from(existing);
    final toInsert = <T>[];
    final toOverwrite = <T>[];

    for (final entry in incoming) {
      final index = remaining.indexWhere(
        (current) => isDuplicate(entry, current),
      );
      if (index == -1) {
        toInsert.add(entry);
        continue;
      }
      final match = remaining.removeAt(index);
      toOverwrite.add(buildReplacement(entry, match));
    }

    return _SplitResult(toInsert: toInsert, toOverwrite: toOverwrite);
  }

  static FeedingEntry? _parseFeedingPayload(Map<String, dynamic> payload) {
    final timestamp = _parseDateTime(payload['timestamp']);
    final amount = _parseInt(payload['amountMl']);
    if (timestamp == null || amount == null) {
      return null;
    }
    final notes = _parseString(payload['notes']);
    return FeedingEntry(
      timestamp: timestamp,
      amountMl: amount,
      notes: notes?.isEmpty ?? true ? null : notes,
    );
  }

  static StoolEntry? _parseStoolPayload(Map<String, dynamic> payload) {
    final timestamp = _parseDateTime(payload['timestamp']);
    if (timestamp == null) {
      return null;
    }
    final consistencyName = _parseString(payload['consistency']);
    final consistency =
        _enumByName(StoolConsistency.values, consistencyName) ??
            _defaultStoolConsistency;
    final notes = _parseString(payload['notes']);
    return StoolEntry(
      timestamp: timestamp,
      consistency: consistency,
      notes: notes?.isEmpty ?? true ? null : notes,
    );
  }

  static VomitEntry? _parseVomitPayload(Map<String, dynamic> payload) {
    final timestamp = _parseDateTime(payload['timestamp']);
    if (timestamp == null) {
      return null;
    }
    final amountName = _parseString(payload['amount']);
    final amount =
        _enumByName(VomitAmount.values, amountName) ?? _defaultVomitAmount;
    final notes = _parseString(payload['notes']);
    return VomitEntry(
      timestamp: timestamp,
      amount: amount,
      notes: notes?.isEmpty ?? true ? null : notes,
    );
  }

  static BathEntry? _parseBathPayload(Map<String, dynamic> payload) {
    final timestamp = _parseDateTime(payload['timestamp']);
    if (timestamp == null) {
      return null;
    }
    final typeName = _parseString(payload['bathType']);
    final bathType = _enumByName(BathType.values, typeName) ?? _defaultBathType;
    final notes = _parseString(payload['notes']);
    return BathEntry(
      timestamp: timestamp,
      type: bathType,
      notes: notes?.isEmpty ?? true ? null : notes,
    );
  }

  static TemperatureEntry? _parseTemperaturePayload(
    Map<String, dynamic> payload,
  ) {
    final timestamp = _parseDateTime(payload['timestamp']);
    final value = _parseDouble(payload['celsius']);
    if (timestamp == null || value == null) {
      return null;
    }
    final notes = _parseString(payload['notes']);
    return TemperatureEntry(
      timestamp: timestamp,
      celsius: value,
      notes: notes?.isEmpty ?? true ? null : notes,
    );
  }

  static PediatricianQuestion? _parseQuestionPayload(
    Map<String, dynamic> payload,
  ) {
    final content = _parseString(payload['content']);
    final createdAt = _parseDateTime(payload['createdAt']);
    final updatedAtRaw = _parseDateTime(payload['updatedAt']);
    if (content == null || content.isEmpty || createdAt == null) {
      return null;
    }
    final updatedAt = updatedAtRaw ?? createdAt;
    final isResolved = _parseBool(payload['isResolved']) ?? false;
    final satisfactionName = _parseString(payload['satisfaction']);
    final satisfaction = _enumByName(
      PediatricianQuestionSatisfaction.values,
      satisfactionName,
    );
    final resolutionNote = _parseString(payload['resolutionNote']);
    return PediatricianQuestion(
      content: content,
      isResolved: isResolved,
      createdAt: createdAt,
      updatedAt: updatedAt,
      satisfaction: satisfaction,
      resolutionNote: resolutionNote?.isEmpty ?? true ? null : resolutionNote,
    );
  }

  static BabyProfile? _parseBabyProfilePayload(Map<String, dynamic> payload) {
    final name = _parseString(payload['name']);
    final genderName = _parseString(payload['gender']);
    final birthDate = _parseDateTime(payload['birthDate']);
    final birthTimeMinutes = _parseInt(payload['birthTimeMinutes']);
    final accentColorValue = _parseInt(payload['accentColorValue']);
    if (name == null ||
        name.isEmpty ||
        genderName == null ||
        birthDate == null ||
        birthTimeMinutes == null ||
        accentColorValue == null) {
      return null;
    }
    final gender = _enumByName(BabyGender.values, genderName);
    if (gender == null) {
      return null;
    }
    final birthWeight = _parseDouble(payload['birthWeightKg']);
    final birthLength = _parseDouble(payload['birthLengthCm']);
    final photoPath = _parseString(payload['photoPath']);
    return BabyProfile(
      name: name,
      gender: gender,
      birthDate: birthDate,
      birthTimeMinutes: birthTimeMinutes,
      birthWeightKg: birthWeight,
      birthLengthCm: birthLength,
      accentColorValue: accentColorValue,
      photoPath: photoPath?.isEmpty ?? true ? null : photoPath,
    );
  }

  static T? _enumByName<T extends Enum>(List<T> values, String? name) {
    if (name == null) {
      return null;
    }
    final normalized = name.trim().toLowerCase();
    for (final value in values) {
      if (value.name.toLowerCase() == normalized) {
        return value;
      }
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    final text = _parseString(value);
    if (text == null || text.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(text).toLocal();
    } catch (_) {
      return null;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    final text = _parseString(value);
    if (text == null || text.isEmpty) {
      return null;
    }
    return int.tryParse(text);
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    final text = _parseString(value)?.replaceAll(',', '.');
    if (text == null || text.isEmpty) {
      return null;
    }
    return double.tryParse(text);
  }

  static bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    final text = _parseString(value);
    if (text == null) {
      return null;
    }
    final normalized = text.toLowerCase();
    if (normalized.isEmpty) {
      return null;
    }
    if (const {'true', '1', 'yes', 'y', 'si'}.contains(normalized)) {
      return true;
    }
    if (const {'false', '0', 'no', 'n'}.contains(normalized)) {
      return false;
    }
    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return value.toString();
  }

  static String _normalizeText(String value) {
    return value.trim().toLowerCase();
  }

  static String _asString(dynamic value) {
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value.trim();
    }
    return value.toString().trim();
  }

  static String? _readCell(List<dynamic> row, int index) {
    if (index < 0 || index >= row.length) {
      return null;
    }
    final value = row[index];
    final normalized = _asString(value);
    return normalized.isEmpty ? null : normalized;
  }

  static int _resolveColumnIndex(
    List<String> header,
    List<String> normalizedNames, {
    int? fallback,
  }) {
    final normalizedHeader =
        header.map((value) => _normalizeHeader(value)).toList(growable: false);
    for (final name in normalizedNames) {
      final normalizedName = _normalizeHeader(name);
      final index = normalizedHeader.indexOf(normalizedName);
      if (index != -1) {
        return index;
      }
    }
    if (fallback != null && fallback < header.length) {
      return fallback;
    }
    return -1;
  }

  static String _normalizeHeader(String value) {
    final lower = value.toLowerCase();
    final buffer = StringBuffer();
    for (final codeUnit in lower.codeUnits) {
      switch (codeUnit) {
        case 225:
        case 224:
        case 226:
        case 227:
        case 228:
        case 193:
        case 192:
        case 194:
        case 195:
        case 196:
        case 197:
          buffer.write('a');
          break;
        case 233:
        case 232:
        case 234:
        case 235:
        case 201:
        case 200:
        case 202:
        case 203:
          buffer.write('e');
          break;
        case 237:
        case 236:
        case 238:
        case 239:
        case 205:
        case 204:
        case 206:
        case 207:
          buffer.write('i');
          break;
        case 243:
        case 242:
        case 244:
        case 245:
        case 246:
        case 211:
        case 210:
        case 212:
        case 213:
        case 214:
          buffer.write('o');
          break;
        case 250:
        case 249:
        case 251:
        case 252:
        case 218:
        case 217:
        case 219:
        case 220:
          buffer.write('u');
          break;
        case 241:
        case 209:
          buffer.write('n');
          break;
        default:
          final char = String.fromCharCode(codeUnit);
          if (RegExp(r'[a-z0-9()]').hasMatch(char)) {
            buffer.write(char);
          }
      }
    }
    return buffer.toString();
  }

  static DateTime? _parseTimestamp(String? date, String? time) {
    if (date == null || date.isEmpty) {
      return null;
    }

    final normalizedDate = date.replaceAll('/', '-');
    final segments =
        normalizedDate.split('-').map((value) => value.trim()).toList();

    if (segments.length != 3) {
      return null;
    }

    int? year;
    int? month;
    int? day;

    if (segments[0].length == 4) {
      year = int.tryParse(segments[0]);
      month = int.tryParse(segments[1]);
      day = int.tryParse(segments[2]);
    } else if (segments[2].length == 4) {
      day = int.tryParse(segments[0]);
      month = int.tryParse(segments[1]);
      year = int.tryParse(segments[2]);
    }

    if (year == null || month == null || day == null) {
      return null;
    }

    var hour = 0;
    var minute = 0;
    var second = 0;

    final trimmedTime = time?.trim() ?? '';
    if (trimmedTime.isNotEmpty) {
      final timeParts = trimmedTime
          .split(RegExp('[:hH]'))
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty)
          .toList();

      if (timeParts.isNotEmpty) {
        hour = int.tryParse(timeParts[0]) ?? 0;
      }
      if (timeParts.length > 1) {
        minute = int.tryParse(timeParts[1]) ?? 0;
      }
      if (timeParts.length > 2) {
        second = int.tryParse(timeParts[2]) ?? 0;
      }
    }

    return DateTime(year, month, day, hour, minute, second);
  }

  static bool _isTruthy(String? value) {
    if (value == null) {
      return false;
    }
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) {
      return false;
    }
    return !const {'0', 'no', 'false'}.contains(normalized);
  }
}
