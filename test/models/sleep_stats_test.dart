import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_stats.dart';

void main() {
  group('SleepStats Model Tests', () {
    test('empty constructor defaults', () {
      const s = SleepStats.empty();
      expect(s.totalNights, 0);
      expect(s.averageDuration7Days, Duration.zero);
      expect(s.bedtimeConsistencyScore, 100.0);
      expect(s.currentGoalStreak, 0);
      expect(s.bestGoalStreak, 0);
      expect(s.qualityDistribution, {1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
    });

    for (int streak = 0; streak <= 15; streak++) {
      test('copyWith currentGoalStreak $streak', () {
        const s = SleepStats.empty();
        expect(s.copyWith(currentGoalStreak: streak).currentGoalStreak, streak);
      });
    }

    test('copyWith updates specific properties', () {
      const s = SleepStats.empty();
      final updated = s.copyWith(totalNights: 15, goalMetPercentage: 85.5);
      expect(updated.totalNights, 15);
      expect(updated.goalMetPercentage, 85.5);
      expect(updated.bedtimeConsistencyScore, 100.0);
    });
  });
}  });
}
