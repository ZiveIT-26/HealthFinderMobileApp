import 'package:flutter/material.dart';
import 'package:health_finder/core/theme/app_colors.dart';
import 'package:health_finder/core/theme/app_spacing.dart';
import 'package:health_finder/core/theme/app_text_styles.dart';

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.card, vertical: AppSpacing.m),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.chatBorder),
          ),
          child: Text(label, style: AppTextStyles.chatBody),
        ),
      ),
    );
  }
}