import 'package:flutter_test/flutter_test.dart';
import 'package:sleeplog/main.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/services/mock_notification_service.dart';
import 'package:sleeplog/state/sleep_provider.dart';

void main() {
  group('App Integration End-to-End Tests', () {
    testWidgets('Full user lifecycle flow', (tester) async {
      final sleepRepo = InMemorySleepRepository();
      final prefsRepo = InMemoryPreferencesRepository();
      final notificationService = MockNotificationService();

      final provider = SleepProvider(
        repository: sleepRepo,
        preferencesRepository: prefsRepo,
        notificationService: notificationService,
      );
      await provider.load();

      await tester.pumpWidget(SleepLogApp(provider: provider));
      await tester.pump();

      expect(find.text('SleepLog'), findsOneWidget);
      expect(find.text('No Log Yet'), findsOneWidget);

      await provider.addNight(SleepNight(
        id: 'flow_1',
        bedtime: DateTime(2026, 11, 22, 23, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 30),
        quality: 5,
        notes: 'Flow night',
      ));
      await tester.pump();

      expect(find.text('8h 30m'), findsWidgets);
      expect(find.text('Goal Met'), findsOneWidget);

      await tester.tap(find.text('History'));
      await tester.pump();
      expect(find.text('Flow night'), findsOneWidget);

      await tester.tap(find.text('Stats'));
      await tester.pump();
      expect(find.text('Sleep Statistics'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pump();
      expect(find.text('100% Local & Private. No accounts, no network calls.'), findsOneWidget);
    });
  });
}
