import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/repositories/in_memory_sleep_repository.dart';
import 'package:sleeplog/repositories/in_memory_preferences_repository.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/screens/home_shell.dart';

void main() {
  group('HomeShell Tests', () {
    late SleepProvider provider;

    setUp(() async {
      provider = SleepProvider(
        repository: InMemorySleepRepository(),
        preferencesRepository: InMemoryPreferencesRepository(),
      );
      await provider.load();
    });

    testWidgets('switches between bottom navigation tabs smoothly', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeShell(provider: provider)));

      expect(find.text('SleepLog'), findsOneWidget);

      await tester.tap(find.text('History'));
      await tester.pump();
      expect(find.text('Sleep History'), findsOneWidget);

      await tester.tap(find.text('Stats'));
      await tester.pump();
      expect(find.text('Sleep Statistics'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pump();
      expect(find.text('SLEEP GOAL'), findsOneWidget);
    });
  });
}
