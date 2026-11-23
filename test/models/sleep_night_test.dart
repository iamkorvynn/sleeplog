import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_night.dart';

void main() {
  group('SleepNight Model Tests', () {
    final bedtime = DateTime(2026, 11, 22, 23, 0);
    final wakeTime = DateTime(2026, 11, 23, 7, 30);

    test('constructor assigns all fields', () {
      final night = SleepNight(
        id: 'n1',
        bedtime: bedtime,
        wakeTime: wakeTime,
        quality: 4,
        notes: 'Good rest',
      );
      expect(night.id, 'n1');
      expect(night.bedtime, bedtime);
      expect(night.wakeTime, wakeTime);
      expect(night.quality, 4);
      expect(night.notes, 'Good rest');
      expect(night.createdAt, bedtime);
      expect(night.updatedAt, wakeTime);
    });

    for (int m = 15; m <= 720; m += 20) {
      test('duration calculation for $m minutes', () {
        final w = bedtime.add(Duration(minutes: m));
        final n = SleepNight(id: 'n_$m', bedtime: bedtime, wakeTime: w, quality: 3);
        expect(n.durationMinutes, m);
        expect(n.durationHours, m / 60.0);
        expect(n.duration, Duration(minutes: m));
      });
    }

    for (double g = 4.0; g <= 11.0; g += 0.5) {
      test('isGoalMet for goal $g with 8.5h sleep', () {
        final n = SleepNight(id: 'n', bedtime: bedtime, wakeTime: wakeTime, quality: 4); // 8.5h
        expect(n.isGoalMet(g), 8.5 >= g);
      });
    }

    for (int month = 1; month <= 12; month++) {
      test('dateKey formats properly for month $month', () {
        final dt = DateTime(2026, month, 15, 23, 0);
        final n = SleepNight(id: 'm_$month', bedtime: dt, wakeTime: dt.add(const Duration(hours: 8)), quality: 4);
        final expectedMonth = month.toString().padLeft(2, '0');
        expect(n.dateKey, '2026-$expectedMonth-15');
      });
    }

    for (int h = 18; h <= 23; h++) {
      test('bedtimeMinuteOfDay for hour $h:15', () {
        final dt = DateTime(2026, 11, 22, h, 15);
        final n = SleepNight(id: 'n', bedtime: dt, wakeTime: dt.add(const Duration(hours: 8)), quality: 4);
        expect(n.bedtimeMinuteOfDay, h * 60 + 15);
      });
    }

    for (int q = 1; q <= 5; q++) {
      test('copyWith quality $q', () {
        final night = SleepNight(id: 'n1', bedtime: bedtime, wakeTime: wakeTime, quality: 3);
        expect(night.copyWith(quality: q).quality, q);
      });
    }

    test('copyWith updates individual fields', () {
      final night = SleepNight(id: 'n1', bedtime: bedtime, wakeTime: wakeTime, quality: 3, notes: 'Old');
      expect(night.copyWith(id: 'new_id').id, 'new_id');
      expect(night.copyWith(notes: 'New').notes, 'New');
    });

    test('toMap and fromMap fidelity', () {
      final night = SleepNight(id: 'n1', bedtime: bedtime, wakeTime: wakeTime, quality: 5, notes: 'Saved');
      final map = night.toMap();
      expect(SleepNight.fromMap(map), equals(night));
    });

    test('toJson and fromJson fidelity', () {
      final night = SleepNight(id: 'n1', bedtime: bedtime, wakeTime: wakeTime, quality: 4);
      expect(SleepNight.fromJson(night.toJson()), equals(night));
    });

    test('equality and hashCode', () {
      final a = SleepNight(id: '1', bedtime: bedtime, wakeTime: wakeTime, quality: 4, notes: 'A');
      final b = SleepNight(id: '1', bedtime: bedtime, wakeTime: wakeTime, quality: 4, notes: 'A');
      final c = SleepNight(id: '2', bedtime: bedtime, wakeTime: wakeTime, quality: 4, notes: 'A');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('toString returns description', () {
      final night = SleepNight(id: 'n1', bedtime: bedtime, wakeTime: wakeTime, quality: 4);
      expect(night.toString(), contains('SleepNight'));
      expect(night.toString(), contains('8.5h'));
    });

    
    for (int h = 1; h <= 24; h++) {
      test('boundary duration check for  hours', () {
        final w = bedtime.add(Duration(hours: h));
        final n = SleepNight(id: 'boundary_', bedtime: bedtime, wakeTime: w, quality: 3);
        expect(n.duration.inHours, h);
      });
    }

    for (double target = 4.0; target <= 12.0; target += 0.25) {
      test('goal met precision check against target ', () {
        final n = SleepNight(id: 't_', bedtime: bedtime, wakeTime: bedtime.add(const Duration(hours: 8)), quality: 4);
        expect(n.isGoalMet(target), 8.0 >= target);
      });
    }

    group('validation rules', () {
      test('valid night returns empty errors', () {
        final night = SleepNight(id: '1', bedtime: bedtime, wakeTime: wakeTime, quality: 4);
        expect(night.validate(), isEmpty);
      });

      test('wake time before bedtime returns error', () {
        final night = SleepNight(id: '1', bedtime: wakeTime, wakeTime: bedtime, quality: 4);
        expect(night.validate(), contains('Wake time must be after bedtime'));
      });

      test('duration < 15 min returns error', () {
        final night = SleepNight(id: '1', bedtime: bedtime, wakeTime: bedtime.add(const Duration(minutes: 10)), quality: 4);
        expect(night.validate(), contains('Sleep duration must be at least 15 minutes'));
      });

      test('duration > 24 hours returns error', () {
        final night = SleepNight(id: '1', bedtime: bedtime, wakeTime: bedtime.add(const Duration(hours: 25)), quality: 4);
        expect(night.validate(), contains('Sleep duration cannot exceed 24 hours'));
      });

      test('invalid quality ratings return error', () {
        expect(SleepNight(id: '1', bedtime: bedtime, wakeTime: wakeTime, quality: 0).validate(), contains('Quality rating must be between 1 and 5'));
        expect(SleepNight(id: '1', bedtime: bedtime, wakeTime: wakeTime, quality: 6).validate(), contains('Quality rating must be between 1 and 5'));
      });
    });
  });
}
