import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Full-width pill-ish button used for language choices
/// (Figma: "Choice" – 50 high, radius 15, #503264).
class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  static const double height = 50;
  static const double _radius = 15;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return Material(
      color: AppColors.colorPressed,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ),
        ),
      ),
    );
  }
}