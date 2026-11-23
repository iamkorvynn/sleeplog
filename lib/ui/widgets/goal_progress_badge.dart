import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';

class GoalProgressBadge extends StatelessWidget {
  final bool isMet;
  final String? label;

  const GoalProgressBadge({
    super.key,
    required this.isMet,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = isMet ? AppColors.success : AppColors.danger;
    final text = label ?? (isMet ? 'Goal Met' : 'Goal Missed');
    final icon = isMet ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
