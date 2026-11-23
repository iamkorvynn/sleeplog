import 'dart:math';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/models/sleep_stats.dart';

class SleepCalculator {
  static Duration computeDuration(DateTime bedtime, DateTime wakeTime) {
    return wakeTime.difference(bedtime);
  }

  static Duration calculateAverageDuration(List<SleepNight> nights) {
    if (nights.isEmpty) return Duration.zero;
    final totalMinutes = nights.fold<int>(0, (sum, night) => sum + night.durationMinutes);
    return Duration(minutes: (totalMinutes / nights.length).round());
  }

  static List<SleepNight> calculateNightsInWindow(
    List<SleepNight> nights,
    int days, {
    DateTime? referenceDate,
  }) {
    if (nights.isEmpty) return const [];
    final ref = referenceDate ?? DateTime.now();
    final cutoff = ref.subtract(Duration(days: days));
    return nights.where((n) => n.bedtime.isAfter(cutoff) || n.wakeTime.isAfter(cutoff)).toList();
  }

  static SleepNight? calculateLongestNight(List<SleepNight> nights) {
    if (nights.isEmpty) return null;
    return nights.reduce((curr, next) => next.durationMinutes > curr.durationMinutes ? next : curr);
  }

  static SleepNight? calculateShortestNight(List<SleepNight> nights) {
    if (nights.isEmpty) return null;
    return nights.reduce((curr, next) => next.durationMinutes < curr.durationMinutes ? next : curr);
  }

  static Map<String, double> calculateBedtimeConsistency(List<SleepNight> nights) {
    if (nights.length < 2) {
      return {'score': 100.0, 'stdDevMinutes': 0.0};
    }

    final relativeMinutes = nights.map((night) {
      final hour = night.bedtime.hour;
      final minute = night.bedtime.minute;
      final totalMin = hour * 60 + minute;
      return totalMin >= 720 ? totalMin - 1440 : totalMin;
    }).toList();

    final mean = relativeMinutes.reduce((a, b) => a + b) / relativeMinutes.length;
    final variance = relativeMinutes.map((m) => pow(m - mean, 2)).reduce((a, b) => a + b) / (relativeMinutes.length - 1);
    final stdDev = sqrt(variance);

    double score;
    if (stdDev <= 15.0) {
      score = 100.0;
    } else if (stdDev <= 120.0) {
      score = max(20.0, 100.0 - ((stdDev - 15.0) * 0.7));
    } else {
      score = max(5.0, 26.5 - ((stdDev - 120.0) * 0.15));
    }

    return {
      'score': (score * 10).roundToDouble() / 10,
      'stdDevMinutes': (stdDev * 10).roundToDouble() / 10,
    };
  }

  static int calculateGoalStreak(List<SleepNight> nights, double goalHours) {
    if (nights.isEmpty) return 0;
    final sorted = List<SleepNight>.from(nights)..sort((a, b) => b.bedtime.compareTo(a.bedtime));
    int streak = 0;
    for (final night in sorted) {
      if (night.isGoalMet(goalHours)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static int calculateBestGoalStreak(List<SleepNight> nights, double goalHours) {
    if (nights.isEmpty) return 0;
    final sorted = List<SleepNight>.from(nights)..sort((a, b) => a.bedtime.compareTo(b.bedtime));
    int bestStreak = 0;
    int currentStreak = 0;
    for (final night in sorted) {
      if (night.isGoalMet(goalHours)) {
        currentStreak++;
        if (currentStreak > bestStreak) bestStreak = currentStreak;
      } else {
        currentStreak = 0;
      }
    }
    return bestStreak;
  }

  static Duration calculateSleepDebt(
    List<SleepNight> nights,
    double goalHours, {
    int days = 7,
    DateTime? referenceDate,
  }) {
    final windowNights = calculateNightsInWindow(nights, days, referenceDate: referenceDate);
    final expectedMinutes = (days * goalHours * 60).round();
    final actualMinutes = windowNights.fold<int>(0, (sum, n) => sum + n.durationMinutes);
    return Duration(minutes: expectedMinutes - actualMinutes);
  }

  static Map<int, int> calculateQualityDistribution(List<SleepNight> nights) {
    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final night in nights) {
      if (dist.containsKey(night.quality)) {
        dist[night.quality] = dist[night.quality]! + 1;
      }
    }
    return dist;
  }

  static double calculateAverageQuality(List<SleepNight> nights) {
    if (nights.isEmpty) return 0.0;
    final total = nights.fold<int>(0, (sum, n) => sum + n.quality);
    return ((total / nights.length) * 10).roundToDouble() / 10;
  }

  }
