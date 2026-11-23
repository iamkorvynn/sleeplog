import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/history_screen.dart';

void main() {
  group('HistoryScreen Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
      );
      await provider.load();
    });

    testWidgets('empty history shows empty state', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HistoryScreen(provider: provider)));
      expect(find.text('Sleep History'), findsOneWidget);
      expect(find.text('No sleep logged yet'), findsOneWidget);
    });

    testWidgets('history list with filter chips', (tester) async {
      await provider.addNight(SleepNight(id: '1', bedtime: DateTime(2026, 11, 22, 23, 0), wakeTime: DateTime(2026, 11, 23, 7, 30), quality: 4));
      await provider.addNight(SleepNight(id: '2', bedtime: DateTime(2026, 11, 21, 23, 0), wakeTime: DateTime(2026, 11, 22, 6, 0), quality: 3));

      await tester.pumpWidget(MaterialApp(home: HistoryScreen(provider: provider)));
      expect(find.text('All (2)'), findsOneWidget);
      expect(find.text('Goal Met (1)'), findsOneWidget);

      await tester.tap(find.text('Goal Met (1)'));
      await tester.pump();
      expect(find.text('8h 30m'), findsOneWidget);
      expect(find.text('7h 00m'), findsNothing);
    });
  });
}
