import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';

class StarRatingBar extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double starSize;
  final bool readOnly;
  final bool showLabel;

  const StarRatingBar({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.starSize = 28.0,
    this.readOnly = false,
    this.showLabel = true,
  });

  String _getRatingLabel(int r) {
    switch (r) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent';
      default:
        return 'Not rated';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= rating;
            return InkWell(
              onTap: readOnly ? null : () => onRatingChanged?.call(starIndex),
              borderRadius: BorderRadius.circular(starSize / 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFilled ? AppColors.accentAmber : AppColors.textMuted,
                  size: starSize,
                ),
              ),
            );
          }),
        ),
        if (showLabel && rating > 0) ...[
          const SizedBox(height: 4),
          Text(
            _getRatingLabel(rating),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.accentAmber,
            ),
          ),
        ],
      ],
    );
  }
}
