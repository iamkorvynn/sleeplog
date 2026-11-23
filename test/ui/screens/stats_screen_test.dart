import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/stats_screen.dart';

void main() {
  group('StatsScreen Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
      );
      await provider.load();
    });

    testWidgets('empty stats view', (tester) async {
      await tester.pumpWidget(MaterialApp(home: StatsScreen(provider: provider)));
      expect(find.text('Sleep Statistics'), findsOneWidget);
      expect(find.text('No stats yet'), findsOneWidget);
    });

    testWidgets('populated stats view', (tester) async {
      await provider.addNight(SleepNight(
        id: '1',
        bedtime: DateTime(2026, 11, 22, 23, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 30),
        quality: 5,
      ));

      await tester.pumpWidget(MaterialApp(home: StatsScreen(provider: provider)));
      expect(find.text('AVERAGES'), findsOneWidget);
      expect(find.text('7-Day Average'), findsOneWidget);
      expect(find.text('Consistency'), findsOneWidget);
      expect(find.text('GOAL PERFORMANCE'), findsOneWidget);
      expect(find.text('SLEEP QUALITY RATINGS'), findsOneWidget);
    });
  });
}
