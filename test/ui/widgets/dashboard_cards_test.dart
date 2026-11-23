import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/ui/widgets/dashboard_cards.dart';

void main() {
  group('Dashboard Cards Tests', () {
    testWidgets('LastNightCard empty state', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LastNightCard(night: null, goalHours: 8.0, use24Hour: false, onLogTap: () => tapped = true),
          ),
        ),
      );
      expect(find.text('No Log Yet'), findsOneWidget);
      await tester.tap(find.text('Log Last Night'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('LastNightCard populated state', (tester) async {
      final night = SleepNight(
        id: '1',
        bedtime: DateTime(2026, 11, 22, 23, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 30),
        quality: 4,
        notes: 'Peaceful sleep',
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LastNightCard(night: night, goalHours: 8.0, use24Hour: false),
          ),
        ),
      );
      expect(find.text('8h 30m'), findsOneWidget);
      expect(find.text('Goal Met'), findsOneWidget);
      expect(find.text('Peaceful sleep'), findsOneWidget);
    });

    testWidgets('TargetBedtimeCard display', (tester) async {
      const s = SleepSettings(targetBedtimeHour: 23, targetBedtimeMinute: 0, bedtimeReminderEnabled: true);
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: TargetBedtimeCard(settings: s))));
      expect(find.text("Tonight's Target Bedtime"), findsOneWidget);
      expect(find.text('11:00 PM'), findsOneWidget);
    });

    testWidgets('WeeklyAverageCard display', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WeeklyAverageCard(averageDuration: Duration(hours: 8), goalHours: 8.0)),
        ),
      );
      expect(find.text('7-Day Average'), findsOneWidget);
      expect(find.text('8h 00m'), findsOneWidget);
    });

    testWidgets('StreakCard display', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: StreakCard(streak: 4))));
      expect(find.text('4 nights'), findsOneWidget);
    });

    testWidgets('QuickActionSection tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: QuickActionSection(onLogSleep: () => tapped = true))));
      await tester.tap(find.text('Log Last Night Sleep'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });
}
