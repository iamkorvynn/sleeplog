import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/log_edit_sleep_screen.dart';

void main() {
  group('LogEditSleepScreen Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
      );
      await provider.load();
    });

    testWidgets('renders add mode initial form', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LogEditSleepScreen(provider: provider)));
      expect(find.text('Log Sleep'), findsOneWidget);
      expect(find.text('CALCULATED DURATION'), findsOneWidget);
      expect(find.text('Bedtime'), findsOneWidget);
      expect(find.text('Wake-up Time'), findsOneWidget);
      expect(find.text('Sleep Quality'), findsOneWidget);
    });

    testWidgets('renders edit mode with existing night', (tester) async {
      final night = SleepNight(
        id: 'edit_target',
        bedtime: DateTime(2026, 11, 22, 22, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 0),
        quality: 5,
        notes: 'Pre-existing note',
      );

      await tester.pumpWidget(MaterialApp(home: LogEditSleepScreen(provider: provider, existingNight: night)));
      expect(find.text('Edit Sleep'), findsOneWidget);
      expect(find.text('9h 00m'), findsOneWidget);
      expect(find.text('Pre-existing note'), findsOneWidget);
    });

    testWidgets('save night via AppBar save button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LogEditSleepScreen(provider: provider)));
      final saveBtn = find.widgetWithText(TextButton, 'Save');
      expect(saveBtn, findsOneWidget);
      await tester.tap(saveBtn);
      await tester.pump();
      expect(provider.nights.length, 1);
    });
  });
}
