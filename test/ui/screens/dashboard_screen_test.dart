import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/dashboard_screen.dart';

void main() {
  group('DashboardScreen Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
      );
      await provider.load();
    });

    testWidgets('empty dashboard view', (tester) async {
      await tester.pumpWidget(MaterialApp(home: DashboardScreen(provider: provider)));
      expect(find.text('SleepLog'), findsOneWidget);
      expect(find.text('No Log Yet'), findsOneWidget);
      expect(find.text('Log Last Night Sleep'), findsOneWidget);
    });

    testWidgets('populated dashboard view', (tester) async {
      await provider.addNight(SleepNight(
        id: '1',
        bedtime: DateTime(2026, 11, 22, 23, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 30),
        quality: 4,
      ));
      await tester.pumpWidget(MaterialApp(home: DashboardScreen(provider: provider)));
      expect(find.text('8h 30m'), findsWidgets);
      expect(find.text('Goal Met'), findsOneWidget);
    });
  });
}
