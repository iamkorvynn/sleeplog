import 'dart:math';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/models/sleep_stats.dart';

class SleepCalculator {
  static Duration computeDuration(DateTime bedtime, DateTime wakeTime) {
    return wakeTime.difference(bedtime);
  }

  }
