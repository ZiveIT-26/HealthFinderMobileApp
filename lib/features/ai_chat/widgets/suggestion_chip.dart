import 'package:material_ui/material_ui.dart';
import 'package:health_finder/core/theme/app_colors.dart';
import 'package:health_finder/core/theme/app_spacing.dart';
import 'package:health_finder/core/theme/app_text_styles.dart';

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  static const _radius = 14.0;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_radius);

    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.chipGradientStart,
              AppColors.chipGradientEnd,
            ],
          ),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          splashColor: AppColors.actionPurple.withValues(alpha: 0.12),
          highlightColor: AppColors.actionPurple.withValues(alpha: 0.06),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: 10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.s,
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  size: 22,
                  color: AppColors.actionPurple,
                ),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.chatBody.copyWith(
                      color: AppColors.ink,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}