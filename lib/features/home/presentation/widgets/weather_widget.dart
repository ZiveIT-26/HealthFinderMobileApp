import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_surface.dart';
import '../../data/home_mock_data.dart';
import 'widget_header.dart';

/// "Weather & Health": weather and six health metrics.
class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key, required this.data});

  final WeatherSummary data;

  @override
  Widget build(BuildContext context) {
    final rows = [data.metrics.sublist(0, 3), data.metrics.sublist(3, 6)];

    return GradientSurface(
      background: AppGradients.weather,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WidgetHeader(
            title: 'Weather & Health',
            action: WidgetArrowButton(color: AppColors.weather),
          ),
          const SizedBox(height: AppSpacing.s),
          Row(
            spacing: AppSpacing.s,
            children: [
              Text(data.temperature, style: AppTextStyles.temperature),
              Expanded(child: Text(data.condition, style: AppTextStyles.body)),
              Text(data.city, style: AppTextStyles.meta),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Column(
            spacing: AppSpacing.s,
            children: [
              for (final row in rows)
                Row(
                  spacing: AppSpacing.s,
                  children: [
                    for (final metric in row)
                      Expanded(child: _MetricTile(metric: metric)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.metric});

  final WeatherMetric metric;

  /// The tone tints the tile: blue for low, yellow for moderate,
  /// green for good and neutral values (as in the Figma "Try idea" frame).
  Gradient get _background => switch (metric.tone) {
        MetricTone.low => AppGradients.metricLow,
        MetricTone.moderate => AppGradients.metricModerate,
        MetricTone.good || MetricTone.neutral => AppGradients.metricGood,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: _background,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric.label,
            style: AppTextStyles.meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            metric.value,
            style: AppTextStyles.metric,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
