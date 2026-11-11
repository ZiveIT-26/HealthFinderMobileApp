import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Home widget header: title on the left, white button on the right.
class WidgetHeader extends StatelessWidget {
  const WidgetHeader({super.key, required this.title, required this.action});

  final String title;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.title)),
          action,
        ],
      ),
    );
  }
}

/// White arrow button. Inactive when [onTap] is null.
class WidgetArrowButton extends StatelessWidget {
  const WidgetArrowButton({super.key, required this.color, this.label, this.onTap});

  final Color color;

  /// Optional text before the arrow, e.g. "3 more".
  final String? label;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.control);
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(
            horizontal: label == null ? AppSpacing.xxs : AppSpacing.s,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xxs,
            children: [
              if (label != null)
                Text(label!, style: AppTextStyles.label.copyWith(color: color)),
              SizedBox.square(
                dimension: 24,
                child: Icon(Icons.chevron_right, size: 20, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
