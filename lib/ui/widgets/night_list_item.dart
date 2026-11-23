import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/models/sleep_night.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';
import 'package:sleeplog/utils/time_formatter.dart';
import 'package:sleeplog/ui/widgets/star_rating_bar.dart';
import 'package:sleeplog/ui/widgets/goal_progress_badge.dart';

class NightListItem extends StatelessWidget {
  final SleepNight night;
  final double goalHours;
  final bool use24Hour;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NightListItem({
    super.key,
    required this.night,
    required this.goalHours,
    required this.use24Hour,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isMet = night.isGoalMet(goalHours);
    final bedtimeStr = TimeFormatter.formatTime(night.bedtime, use24HourFormat: use24Hour);
    final wakeStr = TimeFormatter.formatTime(night.wakeTime, use24HourFormat: use24Hour);
    final dateStr = TimeFormatter.formatDate(night.bedtime, includeWeekday: true, includeYear: true);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GoalProgressBadge(isMet: isMet),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TimeFormatter.formatDuration(night.duration),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  StarRatingBar(
                    rating: night.quality,
                    starSize: 16,
                    readOnly: true,
                    showLabel: false,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bedtime_outlined, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(bedtimeStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text('→', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ),
                      const Icon(Icons.wb_sunny_outlined, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(wakeStr, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.textMuted),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
              if (night.notes != null && night.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  night.notes!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
