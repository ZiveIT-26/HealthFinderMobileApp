import 'package:flutter/material.dart';

import '../widgets/gradient_surface.dart';
import 'theme.dart';

/// TEMPORARY screen to check the theme visually.
/// No longer used; safe to delete.
class ThemePreview extends StatelessWidget {
  const ThemePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
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
            _card('AI Health Assistant', AppGradients.ai, AppColors.ai),
            _card("Today's Medications", AppGradients.medications, AppColors.medications),
            _card('Mood Today', AppGradients.mood, AppColors.mood),
            _card('Weather & Health', AppGradients.weather, AppColors.weather),
            Row(
              children: [
                _metric('UV Index', '2 · Low', AppColors.info, AppGradients.metricLow),
                const SizedBox(width: AppSpacing.s),
                _metric('Air Quality', 'Good', AppColors.success, AppGradients.metricGood),
                const SizedBox(width: AppSpacing.s),
                _metric('Pollen', 'Moderate', AppColors.warning, AppGradients.metricModerate),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            Text('15°C', style: AppTextStyles.temperature),
            Text('Vitamin D', style: AppTextStyles.medication),
            Text('Type your health question...', style: AppTextStyles.body),
            Text('1000 IU', style: AppTextStyles.meta),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, CardBackground background, Color accent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: GradientSurface(
        background: background,
        child: SizedBox(
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.title),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.l,
                  vertical: AppSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: Text(
                  'Save',
                  style: AppTextStyles.label.copyWith(color: AppColors.onAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color color, Gradient gradient) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        child: Column(
          children: [
            Text(label, style: AppTextStyles.meta),
            Text(value, style: AppTextStyles.metric.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
