import 'package:flutter/material.dart';

TimeOfDay timeOfDayFromMinutes(int minutesSinceMidnight) {
  final clamped = minutesSinceMidnight.clamp(0, 1439);
  final totalMinutes = clamped.toInt();
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return TimeOfDay(hour: hours, minute: minutes);
}

int minutesFromTimeOfDay(TimeOfDay time) {
  return time.hour * 60 + time.minute;
}
