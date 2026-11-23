import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';
import 'package:sleeplog/utils/time_formatter.dart';
import 'package:sleeplog/ui/widgets/dashboard_cards.dart';
import 'package:sleeplog/ui/widgets/metric_card.dart';
import 'package:sleeplog/ui/screens/log_edit_sleep_screen.dart';

class DashboardScreen extends StatelessWidget {
  final SleepProvider provider;

  const DashboardScreen({super.key, required this.provider});

  void _openLogScreen(BuildContext context, [SleepNight? night]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LogEditSleepScreen(
          provider: provider,
          existingNight: night,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats = provider.stats;
    final settings = provider.settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SleepLog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Log Sleep',
            onPressed: () => _openLogScreen(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target bedtime reminder card
            TargetBedtimeCard(settings: settings),
            const SizedBox(height: 12),

            // Last night's sleep summary
            LastNightCard(
              night: provider.lastNight,
              goalHours: settings.goalHours,
              use24Hour: settings.use24HourFormat,
              onLogTap: () => _openLogScreen(context),
            ),
            const SizedBox(height: 12),

            // Quick metrics row
            Row(
              children: [
                Expanded(
                  child: WeeklyAverageCard(
                    averageDuration: stats.averageDuration7Days,
                    goalHours: settings.goalHours,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StreakCard(streak: stats.currentGoalStreak),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Additional stats row
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Bedtime Consistency',
                    value: '${stats.bedtimeConsistencyScore.toStringAsFixed(0)}%',
                    subtitle: stats.bedtimeConsistencyStdDevMinutes > 0
                        ? '±${stats.bedtimeConsistencyStdDevMinutes.toStringAsFixed(0)} min variance'
                        : 'Consistent schedule',
                    icon: Icons.sync_rounded,
                    iconColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: '7-Day Sleep Debt',
                    value: TimeFormatter.formatDebt(stats.sleepDebt7Days),
                    subtitle: 'vs ${settings.goalHours.toStringAsFixed(1)}h nightly goal',
                    icon: Icons.hourglass_bottom_rounded,
                    iconColor: stats.sleepDebt7Days.inMinutes > 0 ? AppColors.warning : AppColors.success,
                    accentColor: stats.sleepDebt7Days.inMinutes > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick log action
            QuickActionSection(onLogSleep: () => _openLogScreen(context)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
