import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Small pill label next to a list item: "Primary", "Intolerance".
class Tag extends StatelessWidget {
  const Tag(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.colorSoft,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Text(
        label,
        style: AppTextStyles.meta.copyWith(
          color: AppColors.colorBrand,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
