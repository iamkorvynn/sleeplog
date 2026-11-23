import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/settings_screen.dart';

void main() {
  group('SettingsScreen Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
      );
      await provider.load();
    });

    testWidgets('renders settings sections and toggles 24h clock', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(MaterialApp(home: SettingsScreen(provider: provider)));

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('SLEEP GOAL'), findsOneWidget);
      expect(find.text('BEDTIME & REMINDERS'), findsOneWidget);
      expect(find.text('DISPLAY PREFERENCES'), findsOneWidget);

      final switchFinder = find.widgetWithText(SwitchListTile, '24-Hour Clock');
      expect(provider.is24Hour, isFalse);
      await tester.tap(switchFinder);
      await tester.pump();
      expect(provider.is24Hour, isTrue);
    });

    testWidgets('Clear All Data triggers confirmation and clears data', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await provider.addNight(SleepNight(
        id: 'to_clear',
        bedtime: DateTime(2026, 11, 22, 23, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 0),
        quality: 4,
      ));
      expect(provider.nights.length, 1);

      await tester.pumpWidget(MaterialApp(home: SettingsScreen(provider: provider)));

      await tester.tap(find.text('Clear All Data'));
      await tester.pump();

      expect(find.text('Clear All'), findsOneWidget);
      await tester.tap(find.text('Clear All'));
      await tester.pump();

      expect(provider.nights, isEmpty);
    });
  });
}
