import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/models/sleep_settings.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';
import 'package:sleeplog/utils/time_formatter.dart';
import 'package:sleeplog/ui/widgets/star_rating_bar.dart';
import 'package:sleeplog/ui/widgets/goal_progress_badge.dart';

class LastNightCard extends StatelessWidget {
  final SleepNight? night;
  final double goalHours;
  final bool use24Hour;
  final VoidCallback? onLogTap;

  const LastNightCard({
    super.key,
    required this.night,
    required this.goalHours,
    required this.use24Hour,
    this.onLogTap,
  });

  @override
  Widget build(BuildContext context) {
    if (night == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Last Night's Sleep",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'No Log Yet',
                      style: TextStyle(fontSize: 12, color: AppColors.primaryLight, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Track your sleep to monitor sleep duration, debt, consistency, and reach your goals.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onLogTap,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Log Last Night'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryLight,
                  side: const BorderSide(color: AppColors.primaryLight),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isMet = night!.isGoalMet(goalHours);
    final bedtimeStr = TimeFormatter.formatTime(night!.bedtime, use24HourFormat: use24Hour);
    final wakeStr = TimeFormatter.formatTime(night!.wakeTime, use24HourFormat: use24Hour);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Last Night's Sleep",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GoalProgressBadge(isMet: isMet),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  TimeFormatter.formatDuration(night!.duration),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'vs ${TimeFormatter.formatDurationHours(goalHours)} goal',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.bedtime_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(bedtimeStr, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('→', style: TextStyle(color: AppColors.textMuted)),
                ),
                const Icon(Icons.wb_sunny_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(wakeStr, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StarRatingBar(
                  rating: night!.quality,
                  starSize: 18,
                  readOnly: true,
                  showLabel: true,
                ),
                if (night!.notes != null && night!.notes!.isNotEmpty)
                  Expanded(
                    child: Text(
                      night!.notes!,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

