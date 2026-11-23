import 'dart:convert';
import 'package:intl/intl.dart';

class SleepNight {
  final int? id;
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int qualityRating;
  final String? notes;

  const SleepNight({
    this.id,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.qualityRating,
    this.notes,
  });

  Duration get duration => wakeTime.difference(bedtime);
  double get durationHours => duration.inMinutes / 60.0;
}
