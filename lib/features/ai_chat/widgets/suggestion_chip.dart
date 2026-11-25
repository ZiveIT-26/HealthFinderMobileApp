import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.field);

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
            // Figma: Chat / Suggestion chip, 12 / 8 padding, 20 px icon.
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.xs,
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  size: 20,
                  color: AppColors.actionPurple,
                ),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.body.copyWith(color: AppColors.ink),
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