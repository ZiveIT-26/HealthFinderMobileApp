import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_surface.dart';
import '../../data/home_mock_data.dart';
import 'widget_header.dart';

/// "Today's Medications": daily progress and the next dose.
class MedicationsWidget extends StatelessWidget {
  const MedicationsWidget({super.key, required this.data});

  final MedicationsSummary data;

  @override
  Widget build(BuildContext context) {
    return GradientSurface(
      background: AppGradients.medications,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s,
        children: [
          WidgetHeader(
            title: "Today's Medications",
            action: WidgetArrowButton(
              color: AppColors.medications,
              label: '${data.moreCount} more',
            ),
          ),
          _ProgressCard(taken: data.taken, total: data.total),
          _MedicationRow(dose: data.next),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.taken, required this.total});

  final int taken;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.s,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's progress", style: AppTextStyles.body),
              Text(
                '$taken of $total taken',
                style: AppTextStyles.label.copyWith(color: AppColors.success),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: 8,
              color: AppColors.track,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: total == 0 ? 0 : taken / total,
                heightFactor: 1,
                child: const ColoredBox(color: AppColors.success),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicationRow extends StatelessWidget {
  const _MedicationRow({required this.dose});

  final MedicationDose dose;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: AppGradients.medicationDue,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        spacing: AppSpacing.s,
        children: [
          Expanded(child: _TwoLines(dose.name, dose.dose)),
          SizedBox(width: 62, child: _TwoLines(dose.time, dose.amount)),
          // Empty "mark as taken" circle.
          SizedBox.square(
            dimension: 44,
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.brand, width: 1.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoLines extends StatelessWidget {
  const _TwoLines(this.top, this.bottom);

  final String top;
  final String bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        Text(top, style: AppTextStyles.medication),
        Text(bottom, style: AppTextStyles.meta),
      ],
    );
  }
}
