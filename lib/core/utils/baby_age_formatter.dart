import 'package:baby_log/domain/entities/baby_profile.dart';
import 'package:baby_log/l10n/app_localizations.dart';

String? formatBabyAgeAt(
  AppLocalizations l10n,
  BabyProfile? baby,
  DateTime reference,
) {
  if (baby == null) {
    return null;
  }

  final birth = DateTime(
    baby.birthDate.year,
    baby.birthDate.month,
    baby.birthDate.day,
  ).add(Duration(minutes: baby.birthTimeMinutes));

  if (reference.isBefore(birth)) {
    return null;
  }

  final difference = reference.difference(birth);
  if (difference < const Duration(days: 7)) {
    return l10n.questionsAgeLessThanWeek;
  }

  final totalWeeks = difference.inDays ~/ 7;
  if (totalWeeks < 4) {
    return l10n.questionsAgeWeeks(totalWeeks);
  }

  var months =
      (reference.year - birth.year) * 12 + (reference.month - birth.month);
  var anchor = DateTime(
    birth.year,
    birth.month + months,
    birth.day,
    birth.hour,
    birth.minute,
  );

  if (anchor.isAfter(reference)) {
    months--;
    anchor = DateTime(
      birth.year,
      birth.month + months,
      birth.day,
      birth.hour,
      birth.minute,
    );
  }

  if (months <= 0) {
    return l10n.questionsAgeWeeks(totalWeeks);
  }

  final remaining = reference.difference(anchor);
  final weeks = remaining.inDays ~/ 7;

  if (weeks <= 0) {
    return l10n.questionsAgeMonths(months);
  }

  return l10n.questionsAgeMonthsAndWeeks(months, weeks);
}
