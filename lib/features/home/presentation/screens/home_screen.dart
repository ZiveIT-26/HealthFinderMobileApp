import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_surface.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen, AppSpacing.m, AppSpacing.screen, AppSpacing.m,
        ),
        children: [
          Text.rich(
            TextSpan(
              style: AppTextStyles.logo,
              children: const [
                TextSpan(text: 'Health'),
                TextSpan(text: 'Finder', style: TextStyle(color: AppColors.brand)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // TODO: замінити на справжні віджети
          for (final (title, background) in [
            ('AI Health Assistant', AppGradients.ai),
            ("Today's Medications", AppGradients.medications),
            ('Mood Today', AppGradients.mood),
            ('Weather & Health', AppGradients.weather),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.m),
              child: GradientSurface(
                background: background,
                child: SizedBox(
                  height: 140,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(title, style: AppTextStyles.title),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
