import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Visual style of an [AppButton].
enum AppButtonVariant {
  /// Brand color background, light foreground.
  filled,

  /// Soft background, brand color foreground.
  soft,
}

/// Size presets of an [AppButton].
enum AppButtonSize {
  small(height: 32, icon: 16, radius: 11, fontSize: 13, padding: 12),
  medium(height: 38, icon: 20, radius: 13, fontSize: 15, padding: 16),
  large(height: 48, icon: 24, radius: 16, fontSize: 17, padding: 20);

  const AppButtonSize({
    required this.height,
    required this.icon,
    required this.radius,
    required this.fontSize,
    required this.padding,
  });

  final double height;
  final double icon;
  final double radius;
  final double fontSize;
  final double padding;
}

/// Generic button: icon only, label only, or icon + label.
///
/// ```dart
/// AppButton(label: 'Book', onTap: ...)                       // text only
/// AppButton(icon: Icons.add, onTap: ..., tooltip: 'Add')     // icon only
/// AppButton(icon: Icons.add, label: 'Add', onTap: ...)       // both
/// AppButton(label: 'Book', variant: AppButtonVariant.soft)   // inverted colors
/// AppButton(label: 'Book', size: AppButtonSize.large, expanded: true)
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.icon,
    this.label,
    this.onTap,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.tooltip,
  }) : assert(
          icon != null || label != null,
          'AppButton needs at least an icon or a label',
        );

  /// Shortcut for the light variant, same as the old `PillButton.soft`.
  const AppButton.soft({
    super.key,
    this.icon,
    this.label,
    this.onTap,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.tooltip,
  })  : variant = AppButtonVariant.soft,
        assert(
          icon != null || label != null,
          'AppButton needs at least an icon or a label',
        );

  final IconData? icon;
  final String? label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Stretch to the full available width.
  final bool expanded;

  /// Accessibility label. Strongly recommended for icon-only buttons.
  final String? tooltip;

  bool get _iconOnly => label == null;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      AppButtonVariant.filled => (AppColors.brandDark, AppColors.onAccent),
      AppButtonVariant.soft => (AppColors.soft, AppColors.brandDark),
    };

    final radius = BorderRadius.circular(size.radius);

    Widget content;
    if (_iconOnly) {
      // Square button.
      content = SizedBox.square(
        dimension: size.height,
        child: Icon(icon, size: size.icon, color: foreground),
      );
    } else {
      content = SizedBox(
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.padding),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.s,
            children: [
              if (icon != null) Icon(icon, size: size.icon, color: foreground),
              Flexible(
                child: Text(
                  label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pillButton.copyWith(
                    color: foreground,
                    fontSize: size.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget button = Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: content,
      ),
    );

    // Dim when disabled.
    if (onTap == null) {
      button = Opacity(opacity: 0.5, child: button);
    }

    final semanticLabel = tooltip ?? label;
    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: button,
    );
  }
}