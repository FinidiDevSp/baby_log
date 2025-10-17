import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

import '../../domain/entities/bath_entry.dart';
import '../../domain/entities/feeding_entry.dart';
import '../../domain/entities/stool_entry.dart';
import '../../domain/entities/vomit_entry.dart';
import '../../domain/repositories/bath_repository.dart';
import '../../domain/repositories/feeding_repository.dart';
import '../../domain/repositories/stool_repository.dart';
import '../../domain/repositories/vomit_repository.dart';

/// Result with the amount of imported entries per category.
class CsvImportResult {
  /// Creates a result with the imported counters.
  const CsvImportResult({
    this.feedings = 0,
    this.stools = 0,
    this.vomits = 0,
    this.baths = 0,
  });

  /// Imported bottle feedings count.
  final int feedings;

  /// Imported stool entries count.
  final int stools;

  /// Imported vomit entries count.
  final int vomits;

  /// Imported bath entries count.
  final int baths;

  /// Total imported records across all categories.
  int get total => feedings + stools + vomits + baths;

  /// Creates a new result accumulating the provided deltas.
  CsvImportResult copyWithDelta({
    int feedingsDelta = 0,
    int stoolsDelta = 0,
    int vomitsDelta = 0,
    int bathsDelta = 0,
  }) {
    return CsvImportResult(
      feedings: feedings + feedingsDelta,
      stools: stools + stoolsDelta,
      vomits: vomits + vomitsDelta,
      baths: baths + bathsDelta,
    );
  }
}

/// Imports timeline data from a CSV file into the local database.
class CsvImportService {
  /// Creates a new import service with the required repositories.
  CsvImportService({
    required FeedingRepository feedingRepository,
    required StoolRepository stoolRepository,
    required VomitRepository vomitRepository,
    required BathRepository bathRepository,
  })  : _feedingRepository = feedingRepository,
        _stoolRepository = stoolRepository,
        _vomitRepository = vomitRepository,
        _bathRepository = bathRepository;

  static const _defaultStoolConsistency = StoolConsistency.soft;
  static const _defaultVomitAmount = VomitAmount.medium;
  static const _defaultBathType = BathType.full;

  final FeedingRepository _feedingRepository;
  final StoolRepository _stoolRepository;
  final VomitRepository _vomitRepository;
  final BathRepository _bathRepository;

  /// Parses the provided CSV bytes and persists the contained events.
  Future<CsvImportResult> importCsv(Uint8List bytes) async {
    if (bytes.isEmpty) {
      return const CsvImportResult();
    }

    final csvContent = utf8.decode(bytes, allowMalformed: true);
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(csvContent);

    if (rows.isEmpty) {
      return const CsvImportResult();
    }

    final header = rows.first.map((value) => _asString(value)).toList();
    final dateIndex = _resolveColumnIndex(header, const ['fecha']);
    final timeIndex = _resolveColumnIndex(header, const ['hora']);
    final bottleIndex =
        _resolveColumnIndex(header, const ['biberonml', 'biberon (ml)'], fallback: 2);
    final stoolIndex =
        _resolveColumnIndex(header, const ['caca'], fallback: 3);
    final vomitIndex =
        _resolveColumnIndex(header, const ['vomito'], fallback: 4);
    final bathIndex =
        _resolveColumnIndex(header, const ['bano', 'baño'], fallback: 5);

    var result = const CsvImportResult();

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) {
        continue;
      }

      final dateValue = _readCell(row, dateIndex);
      final timeValue = _readCell(row, timeIndex);
      final timestamp = _parseTimestamp(dateValue, timeValue);

      if (timestamp == null) {
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
          await _feedingRepository.addFeeding(
            FeedingEntry(timestamp: timestamp, amountMl: amount),
          );
          result = result.copyWithDelta(feedingsDelta: 1);
        }
      }

      final stoolCell = _readCell(row, stoolIndex);
      if (_isTruthy(stoolCell)) {
        await _stoolRepository.addStool(
          StoolEntry(
            timestamp: timestamp,
            consistency: _defaultStoolConsistency,
          ),
        );
        result = result.copyWithDelta(stoolsDelta: 1);
      }

      final vomitCell = _readCell(row, vomitIndex);
      if (_isTruthy(vomitCell)) {
        await _vomitRepository.addVomit(
          VomitEntry(
            timestamp: timestamp,
            amount: _defaultVomitAmount,
          ),
        );
        result = result.copyWithDelta(vomitsDelta: 1);
      }

      final bathCell = _readCell(row, bathIndex);
      if (_isTruthy(bathCell)) {
        await _bathRepository.addBath(
          BathEntry(
            timestamp: timestamp,
            type: _defaultBathType,
          ),
        );
        result = result.copyWithDelta(bathsDelta: 1);
      }
    }

    return result;
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
    return normalizedNames.isNotEmpty
        ? normalizedHeader.indexOf(_normalizeHeader(normalizedNames.first))
        : -1;
  }

  static String _normalizeHeader(String value) {
    final lower = value.toLowerCase();
    final buffer = StringBuffer();
    for (final codeUnit in lower.codeUnits) {
      switch (codeUnit) {
        case 225: // á
        case 224: // à
        case 226: // â
        case 227: // ã
        case 228: // ä
        case 229: // å
        case 193: // Á
        case 192: // À
        case 194: // Â
        case 195: // Ã
        case 196: // Ä
        case 197: // Å
          buffer.write('a');
          break;
        case 233: // é
        case 232: // è
        case 234: // ê
        case 235: // ë
        case 201: // É
        case 200: // È
        case 202: // Ê
        case 203: // Ë
          buffer.write('e');
          break;
        case 237: // í
        case 236: // ì
        case 238: // î
        case 239: // ï
        case 205: // Í
        case 204: // Ì
        case 206: // Î
        case 207: // Ï
          buffer.write('i');
          break;
        case 243: // ó
        case 242: // ò
        case 244: // ô
        case 245: // õ
        case 246: // ö
        case 211: // Ó
        case 210: // Ò
        case 212: // Ô
        case 213: // Õ
        case 214: // Ö
          buffer.write('o');
          break;
        case 250: // ú
        case 249: // ù
        case 251: // û
        case 252: // ü
        case 218: // Ú
        case 217: // Ù
        case 219: // Û
        case 220: // Ü
          buffer.write('u');
          break;
        case 241: // ñ
        case 209: // Ñ
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
