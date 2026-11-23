import 'package:material_ui/material_ui.dart';
import 'package:sleeplog/ui/theme/app_colors.dart';

class MoonIconWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const MoonIconWidget({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (color ?? AppColors.accentAmber).withAlpha(30),
      ),
      child: Center(
        child: Icon(
          Icons.nightlight_round,
          size: size,
          color: color ?? AppColors.accentAmber,
        ),
      ),
    );
  }
}
