import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/utils/sleep_calculator.dart';

void main() {
  group('SleepCalculator Tests', () {
    test('computeDuration correctly calculates across midnight', () {
      final bedtime = DateTime(2026, 11, 22, 23, 0);
      final wakeTime = DateTime(2026, 11, 23, 7, 0);
      expect(SleepCalculator.computeDuration(bedtime, wakeTime), const Duration(hours: 8));
    });

    test('calculateAverageDuration returns zero for empty list', () {
      expect(SleepCalculator.calculateAverageDuration([]), Duration.zero);
    });

    for (int i = 1; i <= 15; i++) {
      test('calculateAverageDuration with $i nights', () {
        final list = List.generate(
          i,
          (idx) => SleepNight(
            id: 'n$idx',
            bedtime: DateTime(2026, 1, 1, 23, 0),
            wakeTime: DateTime(2026, 1, 2, 7, 0),
            quality: 4,
          ),
        );
        expect(SleepCalculator.calculateAverageDuration(list), const Duration(hours: 8));
      });
    }

    test('calculateNightsInWindow filters past N days', () {
      final ref = DateTime(2026, 11, 23, 12, 0);
      final nights = [
        SleepNight(id: '1', bedtime: DateTime(2026, 11, 22, 23, 0), wakeTime: DateTime(2026, 11, 23, 7, 0), quality: 4),
        SleepNight(id: '2', bedtime: DateTime(2026, 11, 20, 23, 0), wakeTime: DateTime(2026, 11, 21, 7, 0), quality: 4),
        SleepNight(id: '3', bedtime: DateTime(2026, 10, 1, 23, 0), wakeTime: DateTime(2026, 10, 2, 7, 0), quality: 3),
      ];

      expect(SleepCalculator.calculateNightsInWindow(nights, 7, referenceDate: ref).length, 2);
      expect(SleepCalculator.calculateNightsInWindow(nights, 30, referenceDate: ref).length, 2);
      expect(SleepCalculator.calculateNightsInWindow(nights, 90, referenceDate: ref).length, 3);
    });

    test('calculateLongestNight and calculateShortestNight identify records', () {
      final n1 = SleepNight(id: '6h', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 6), quality: 3);
      final n2 = SleepNight(id: '8h', bedtime: DateTime(2026, 1, 2), wakeTime: DateTime(2026, 1, 2, 8), quality: 4);
      final n3 = SleepNight(id: '10h', bedtime: DateTime(2026, 1, 3), wakeTime: DateTime(2026, 1, 3, 10), quality: 5);

      final list = [n2, n1, n3];
      expect(SleepCalculator.calculateLongestNight(list)?.id, '10h');
      expect(SleepCalculator.calculateShortestNight(list)?.id, '6h');
    });

    test('bedtime consistency calculation handles empty & single', () {
      expect(SleepCalculator.calculateBedtimeConsistency([])['score'], 100.0);
      final single = [
        SleepNight(id: '1', bedtime: DateTime(2026, 1, 1, 23, 0), wakeTime: DateTime(2026, 1, 2, 7, 0), quality: 4),
      ];
      expect(SleepCalculator.calculateBedtimeConsistency(single)['score'], 100.0);
    });

    for (int k = 1; k <= 10; k++) {
      test('streak count of $k nights', () {
        final list = List.generate(
          k,
          (idx) => SleepNight(
            id: 'n$idx',
            bedtime: DateTime(2026, 1, 20 - idx, 23, 0),
            wakeTime: DateTime(2026, 1, 21 - idx, 7, 30), // 8.5h Met
            quality: 4,
          ),
        );
        expect(SleepCalculator.calculateGoalStreak(list, 8.0), k);
        expect(SleepCalculator.calculateBestGoalStreak(list, 8.0), k);
      });
    }

    for (int days = 1; days <= 14; days++) {
      test('calculateSleepDebt for $days days window', () {
        final ref = DateTime(2026, 11, 23, 12, 0);
        final nights = List.generate(
          days,
          (i) => SleepNight(
            id: 'n$i',
            bedtime: ref.subtract(Duration(days: i + 1)),
            wakeTime: ref.subtract(Duration(days: i + 1)).add(const Duration(hours: 7)),
            quality: 3,
          ),
        );
        final debt = SleepCalculator.calculateSleepDebt(nights, 8.0, days: days, referenceDate: ref);
        expect(debt.inHours, days * 1); // 1h deficit per day
      });
    }

    test('calculateQualityDistribution counts ratings', () {
      final list = [
        SleepNight(id: '1', bedtime: DateTime(2026, 1, 1), wakeTime: DateTime(2026, 1, 1, 8), quality: 5),
        SleepNight(id: '2', bedtime: DateTime(2026, 1, 2), wakeTime: DateTime(2026, 1, 2, 8), quality: 5),
        SleepNight(id: '3', bedtime: DateTime(2026, 1, 3), wakeTime: DateTime(2026, 1, 3, 8), quality: 4),
      ];
      final dist = SleepCalculator.calculateQualityDistribution(list);
      expect(dist[5], 2);
      expect(dist[4], 1);
      expect(dist[3], 0);
    });

    test('computeAllStats produces complete SleepStats', () {
      const s = SleepSettings(goalHours: 8.0);
      final list = [
        SleepNight(id: '1', bedtime: DateTime(2026, 11, 22, 23, 0), wakeTime: DateTime(2026, 11, 23, 7, 30), quality: 5),
      ];
      final stats = SleepCalculator.computeAllStats(list, s);
      expect(stats.totalNights, 1);
      expect(stats.currentGoalStreak, 1);
      expect(stats.goalMetPercentage, 100.0);
    });
  });
}
