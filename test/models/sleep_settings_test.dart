import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/models/sleep_settings.dart';

void main() {
  group('SleepSettings Model Tests', () {
    test('default settings values', () {
      const s = SleepSettings.defaults();
      expect(s.goalHours, 8.0);
      expect(s.bedtimeReminderEnabled, isTrue);
      expect(s.bedtimeReminderMinutesBefore, 30);
      expect(s.targetBedtimeHour, 23);
      expect(s.targetBedtimeMinute, 0);
      expect(s.morningSummaryEnabled, isTrue);
      expect(s.morningSummaryHour, 8);
      expect(s.morningSummaryMinute, 0);
      expect(s.use24HourFormat, isFalse);
      expect(s.themeMode, 'dark');
    });

    for (double g = 4.0; g <= 12.0; g += 0.5) {
      test('copyWith goalHours $g', () {
        const s = SleepSettings.defaults();
        final updated = s.copyWith(goalHours: g);
        expect(updated.goalHours, g);
      });
    }

    for (int offset in [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60]) {
      test('copyWith reminder offset $offset min', () {
        const s = SleepSettings.defaults();
        expect(s.copyWith(bedtimeReminderMinutesBefore: offset).bedtimeReminderMinutesBefore, offset);
      });
    }

    for (int h = 0; h < 24; h++) {
      test('targetBedtime hour $h', () {
        final s = SleepSettings(targetBedtimeHour: h, targetBedtimeMinute: 15);
        expect(s.targetBedtime.hour, h);
        expect(s.targetBedtime.minute, 15);
      });
    }

    for (int h = 5; h <= 11; h++) {
      test('morningSummaryHour $h', () {
        final s = SleepSettings(morningSummaryHour: h, morningSummaryMinute: 30);
        expect(s.morningSummaryTime.hour, h);
        expect(s.morningSummaryTime.minute, 30);
      });
    }

    test('serialization roundtrip', () {
      const s = SleepSettings(
        goalHours: 7.5,
        bedtimeReminderEnabled: false,
        bedtimeReminderMinutesBefore: 45,
        targetBedtimeHour: 22,
        use24HourFormat: true,
      );
      final map = s.toMap();
      expect(SleepSettings.fromMap(map), equals(s));
      expect(SleepSettings.fromJson(s.toJson()), equals(s));
    });

    test('equality and hashCode', () {
      const a = SleepSettings(goalHours: 8.0);
      const b = SleepSettings(goalHours: 8.0);
      const c = SleepSettings(goalHours: 7.0);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });
  });
}  });
}
