import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// 38 px rounded button with an icon and a label.
/// Filled by default; use [PillButton.soft] for the light variant.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  })  : background = AppColors.colorBrand,
        foreground = AppColors.textOnAction;

  const PillButton.soft({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  })  : background = AppColors.colorSoft,
        foreground = AppColors.colorPressed;

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(13);
    return Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: SizedBox(
          height: 38,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.s,
            children: [
              Icon(icon, size: 20, color: foreground),
              Text(label, style: AppTextStyles.pillButton.copyWith(color: foreground)),
            ],
          ),
        ),
      ),
    );
  }
}
