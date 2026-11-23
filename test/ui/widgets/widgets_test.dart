import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/ui/widgets/star_rating_bar.dart';
import 'package:sleeplog/ui/widgets/metric_card.dart';
import 'package:sleeplog/ui/widgets/goal_progress_badge.dart';
import 'package:sleeplog/ui/widgets/moon_icon_widget.dart';
import 'package:sleeplog/ui/widgets/empty_state_view.dart';
import 'package:sleeplog/ui/widgets/confirm_dialog.dart';

void main() {
  group('UI Widgets Tests', () {
    for (int r = 1; r <= 5; r++) {
      testWidgets('StarRatingBar displays rating $r', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: StarRatingBar(rating: r, readOnly: true)),
          ),
        );
        expect(find.byType(StarRatingBar), findsOneWidget);
      });
    }

    testWidgets('StarRatingBar tap triggers callback', (tester) async {
      int selected = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StarRatingBar(rating: 3, onRatingChanged: (r) => selected = r),
          ),
        ),
      );
      final stars = find.byIcon(Icons.star_outline_rounded);
      await tester.tap(stars.last);
      await tester.pump();
      expect(selected, 5);
    });

    testWidgets('MetricCard displays title, value, subtitle and tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MetricCard(
              title: 'Streak',
              value: '7 nights',
              subtitle: 'Active',
              icon: Icons.local_fire_department_rounded,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('7 nights'), findsOneWidget);
      await tester.tap(find.byType(MetricCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('GoalProgressBadge met and missed states', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                GoalProgressBadge(isMet: true),
                GoalProgressBadge(isMet: false),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Goal Met'), findsOneWidget);
      expect(find.text('Goal Missed'), findsOneWidget);
    });

    testWidgets('MoonIconWidget renders', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: MoonIconWidget())));
      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
    });

      });
}
