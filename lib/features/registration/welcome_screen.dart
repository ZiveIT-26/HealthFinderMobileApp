import 'package:material_ui/material_ui.dart';
import 'package:health_finder/features/registration/Language_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onLanguageSelected});

  final ValueChanged<Locale> onLanguageSelected;

  // Figma sizes used for proportions.
  static const double _mascotAspect = 430 / 696;
  static const double _fadeHeight = 234;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Mascot illustration, pinned to the bottom, full width.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AspectRatio(
              aspectRatio: _mascotAspect,
              child: Image.asset(
                'assets/illustrations/welcome_avatar.png',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                excludeFromSemantics: true,
              ),
            ),
          ),

          // Lilac fade behind the language picker.
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _fadeHeight,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.fadeStart,
                      AppColors.fadeEnd,
                      AppColors.fadeEnd,
                    ],
                    stops: [0.0, 0.1923, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Foreground content.
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(24, 25, 24, 25),
            child: Column(
              children: [
                Text(
                  'HealthFinder',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title,
                ),
                const Spacer(),
                LanguagePicker(onSelected: onLanguageSelected),
              ],
            ),
          ),
        ],
      ),
    );
  }
}