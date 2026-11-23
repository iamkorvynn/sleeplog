import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/ui/widgets/night_list_item.dart';

void main() {
  group('NightListItem Tests', () {
    testWidgets('renders night card with duration and callbacks', (tester) async {
      final night = SleepNight(
        id: 'n1',
        bedtime: DateTime(2026, 11, 22, 23, 0),
        wakeTime: DateTime(2026, 11, 23, 7, 0),
        quality: 4,
        notes: 'Good rest',
      );
      bool tapped = false;
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NightListItem(
              night: night,
              goalHours: 8.0,
              use24Hour: false,
              onTap: () => tapped = true,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      expect(find.text('8h 00m'), findsOneWidget);
      expect(find.text('Goal Met'), findsOneWidget);
      expect(find.text('Good rest'), findsOneWidget);

      await tester.tap(find.byType(NightListItem));
      await tester.pump();
      expect(tapped, isTrue);

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pump();
      expect(deleted, isTrue);
    });
  });
}
