import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/fit_to_screen.dart';
import '../../data/home_mock_data.dart';
import '../widgets/ai_assistant_widget.dart';
import '../widgets/medications_widget.dart';
import '../widgets/mood_widget.dart';
import '../widgets/weather_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Figma Home frame (430 x 925) minus the bottom navigation (84) = 841.
  /// Content adds up to 847: the AI and medications cards are a few px
  /// taller than in Figma, where their content is clipped. Hence the slack.
  static const _designSize = Size(430, 850);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: FitToScreen(
        designSize: _designSize,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 51,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      style: AppTextStyles.logo,
                      children: const [
                        TextSpan(text: 'Health'),
                        TextSpan(
                          text: 'Finder',
                          style: TextStyle(color: AppColors.brand),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const AiAssistantWidget(),
              const SizedBox(height: AppSpacing.m),
              const MedicationsWidget(data: HomeMockData.medications),
              const SizedBox(height: AppSpacing.m),
              const MoodWidget(),
              const SizedBox(height: AppSpacing.m),
              const WeatherWidget(data: HomeMockData.weather),
            ],
          ),
        ),
      ),
    );
  }
}
