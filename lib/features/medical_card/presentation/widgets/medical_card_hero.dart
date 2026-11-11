import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// "Emergency Health Information" card with a shield emblem.
class MedicalCardHero extends StatelessWidget {
  const MedicalCardHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 22),
      decoration: BoxDecoration(
        gradient: AppGradients.medicalCardHero,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 20),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('HEALTHFINDER · MEDICAL CARD', style: AppTextStyles.cardKicker),
              const SizedBox(height: 24),
              Text('Emergency Health Information', style: AppTextStyles.heroTitle),
              const SizedBox(height: 7),
              Text(
                'Important information you can keep in one place.',
                style: AppTextStyles.caption,
              ),
            ],
          ),
          Positioned(
            top: -8,
            right: -1,
            child: Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.57),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.shield_outlined, size: 20, color: AppColors.brand),
            ),
          ),
        ],
      ),
    );
  }
}
