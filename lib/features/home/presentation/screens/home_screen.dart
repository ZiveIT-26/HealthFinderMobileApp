
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

  static const _designSize = Size(430, 850);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogo(),
                  Expanded(
                    child: CustomScrollView(
                      key: const PageStorageKey('home-landscape-scroll'),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const AiAssistantWidget(),
                                    const SizedBox(height: AppSpacing.m),
                                    const MedicationsWidget(
                                      data: HomeMockData.medications,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: Column(
                                  children: [
                                    const MoodWidget(),
                                    const SizedBox(height: AppSpacing.m),
                                    const WeatherWidget(
                                      data: HomeMockData.weather,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          bottom: false,
          child: FitToScreen(
            designSize: _designSize,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLogo(),
                  const AiAssistantWidget(),
                  const SizedBox(height: AppSpacing.m),
                  const MedicationsWidget(
                    data: HomeMockData.medications,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  const MoodWidget(),
                  const SizedBox(height: AppSpacing.m),
                  const WeatherWidget(
                    data: HomeMockData.weather,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return SizedBox(
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
    );
  }
}
