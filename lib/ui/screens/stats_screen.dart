import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/state/sleep_provider.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';
import 'package:sleeplog/utils/time_formatter.dart';
import 'package:sleeplog/ui/widgets/metric_card.dart';
import 'package:sleeplog/ui/widgets/empty_state_view.dart';
import 'package:sleeplog/ui/screens/log_edit_sleep_screen.dart';

class StatsScreen extends StatelessWidget {
  final SleepProvider provider;

  const StatsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final stats = provider.stats;
    final settings = provider.settings;
    final nights = provider.nights;

    if (nights.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sleep Statistics')),
        body: EmptyStateView(
          icon: Icons.bar_chart_rounded,
          title: 'No stats yet',
          description: 'Log your sleep nights to unlock insights, averages, bedtime consistency, and sleep debt trends.',
          actionText: 'Log First Night',
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => LogEditSleepScreen(provider: provider)),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Statistics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Averages Overview
            const Text(
              'AVERAGES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: '7-Day Average',
                    value: TimeFormatter.formatDuration(stats.averageDuration7Days),
                    subtitle: 'Past week',
                    icon: Icons.date_range_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: '30-Day Average',
                    value: TimeFormatter.formatDuration(stats.averageDuration30Days),
                    subtitle: 'Past month',
                    icon: Icons.calendar_month_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Section 2: Consistency & Debt
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Consistency',
                    value: '${stats.bedtimeConsistencyScore.toStringAsFixed(0)}%',
                    subtitle: '±${stats.bedtimeConsistencyStdDevMinutes.toStringAsFixed(0)}m std dev',
                    icon: Icons.sync_rounded,
                    iconColor: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: 'Sleep Debt',
                    value: TimeFormatter.formatDebt(stats.sleepDebt7Days),
                    subtitle: 'vs ${settings.goalHours.toStringAsFixed(1)}h goal',
                    icon: Icons.hourglass_bottom_rounded,
                    iconColor: stats.sleepDebt7Days.inMinutes > 0 ? AppColors.warning : AppColors.success,
                    accentColor: stats.sleepDebt7Days.inMinutes > 0 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Section 3: Records (Longest / Shortest)
            Row(
              children: [
                Expanded(
                  child: MetricCard(
                    title: 'Longest Night',
                    value: stats.longestNight != null ? TimeFormatter.formatDuration(stats.longestNight!.duration) : '--',
                    subtitle: stats.longestNight != null ? TimeFormatter.formatDate(stats.longestNight!.bedtime) : null,
                    icon: Icons.arrow_upward_rounded,
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    title: 'Shortest Night',
                    value: stats.shortestNight != null ? TimeFormatter.formatDuration(stats.shortestNight!.duration) : '--',
                    subtitle: stats.shortestNight != null ? TimeFormatter.formatDate(stats.shortestNight!.bedtime) : null,
                    icon: Icons.arrow_downward_rounded,
                    iconColor: AppColors.danger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section 4: Goal Performance
            const Text(
              'GOAL PERFORMANCE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Goal Met Rate', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        Text(
                          '${stats.goalMetPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: stats.goalMetPercentage / 100.0,
                      backgroundColor: AppColors.darkBorder,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Streak: ${stats.currentGoalStreak} nights', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        Text('Best Streak: ${stats.bestGoalStreak} nights', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Section 5: Quality Trend & Distribution
            const Text(
              'SLEEP QUALITY RATINGS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Average Rating', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 18, color: AppColors.accentAmber),
                            const SizedBox(width: 4),
                            Text(
                              '${stats.averageQualityAllTime.toStringAsFixed(1)} / 5',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(5, (index) {
                      final star = 5 - index;
                      final count = stats.qualityDistribution[star] ?? 0;
                      final total = stats.totalNights > 0 ? stats.totalNights : 1;
                      final pct = count / total;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                '$star ★',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: AppColors.darkBorder,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentAmber),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '$count',
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
