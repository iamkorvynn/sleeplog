import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/utils/time_formatter.dart';

void main() {
  group('TimeFormatter Tests', () {
    test('formatDuration hours and minutes formatting', () {
      expect(TimeFormatter.formatDuration(const Duration(hours: 8, minutes: 30)), '8h 30m');
      expect(TimeFormatter.formatDuration(const Duration(hours: 7, minutes: 5)), '7h 05m');
      expect(TimeFormatter.formatDuration(const Duration(hours: 8)), '8h 00m');
      expect(TimeFormatter.formatDuration(const Duration(minutes: 45)), '45m');
      expect(TimeFormatter.formatDuration(Duration.zero), '0h 00m');
    });

    test('formatDuration short mode', () {
      expect(TimeFormatter.formatDuration(const Duration(hours: 8), short: true), '8h');
      expect(TimeFormatter.formatDuration(const Duration(minutes: 30), short: true), '30m');
      expect(TimeFormatter.formatDuration(const Duration(hours: 7, minutes: 15), short: true), '7h 15m');
    });

    for (int m = 0; m <= 55; m += 5) {
      test('formatDuration for 7h $m m', () {
        final d = Duration(hours: 7, minutes: m);
        expect(TimeFormatter.formatDuration(d), contains('7h'));
      });
    }

    for (double h = 4.0; h <= 12.0; h += 0.25) {
      test('formatDurationHours for $h hours', () {
        final formatted = TimeFormatter.formatDurationHours(h);
        expect(formatted, contains('h'));
      });
    }

    for (int hour = 0; hour < 24; hour++) {
      test('formatTime 12h vs 24h for hour $hour', () {
        final dt = DateTime(2026, 11, 23, hour, 30);
        final t12 = TimeFormatter.formatTime(dt, use24HourFormat: false);
        final t24 = TimeFormatter.formatTime(dt, use24HourFormat: true);
        expect(t24, contains(':30'));
        expect(t12, anyOf(contains('AM'), contains('PM')));
      });
    }

    test('formatDate outputs expected format', () {
      final dt = DateTime(2026, 11, 23);
      expect(TimeFormatter.formatDate(dt, includeWeekday: true, includeYear: false), 'Mon, Nov 23');
      expect(TimeFormatter.formatDate(dt, includeWeekday: false, includeYear: true), 'Nov 23, 2026');
    });

    test('formatRelativeNight outputs relative strings', () {
      final ref = DateTime(2026, 11, 23, 12, 0);
      expect(TimeFormatter.formatRelativeNight(DateTime(2026, 11, 23), referenceDate: ref), 'Tonight');
      expect(TimeFormatter.formatRelativeNight(DateTime(2026, 11, 22), referenceDate: ref), 'Last night');
      expect(TimeFormatter.formatRelativeNight(DateTime(2026, 11, 21), referenceDate: ref), '2 nights ago');
    });

    for (int debtMin = -120; debtMin <= 120; debtMin += 20) {
      test('formatDebt for $debtMin min', () {
        final d = Duration(minutes: debtMin);
        final res = TimeFormatter.formatDebt(d);
        if (debtMin.abs() < 5) {
          expect(res, 'On track');
        } else if (debtMin < 0) {
          expect(res, contains('surplus'));
        } else {
          expect(res, contains('debt'));
        }
      });
    }
  });
}  });
}
