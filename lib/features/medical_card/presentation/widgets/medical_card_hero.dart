import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/surface_card.dart';

/// "Emergency Health Information" card with a shield emblem.
///
/// With [onTap] it is a shortcut to the medical card (on the profile tab).
class MedicalCardHero extends StatelessWidget {
  const MedicalCardHero({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      gradient: AppGradients.detailHero,
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 13,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HEALTHFINDER · EMERGENCY CARD', style: AppTextStyles.cardKicker),
                const SizedBox(height: 14),
                Text('Emergency Health Information', style: AppTextStyles.heroTitle),
                const SizedBox(height: 6),
                Text(
                  'Important information you can keep in one place.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          // Same size as the icon tiles of the profile menu rows.
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.shield_outlined, size: 20, color: AppColors.colorBrand),
          ),
        ],
      ),
    );
  }
}
