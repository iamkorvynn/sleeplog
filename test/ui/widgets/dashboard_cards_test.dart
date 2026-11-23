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

      });
}
