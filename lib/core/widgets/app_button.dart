import 'package:material_ui/material_ui.dart';

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

/// Generic button that accepts any widgets as content.
///
/// Content is laid out as `[leading] [child] [trailing]`. Every slot is
/// optional, but at least one must be provided.
///
/// [Icon] and [Text] placed in any slot automatically inherit the button's
/// foreground color, icon size and font size (via [IconTheme] and
/// [DefaultTextStyle]).
///
/// ```dart
/// // Anything as content
/// AppButton(child: Text('Book'), onTap: ...)
/// AppButton(leading: Icon(Icons.add), child: Text('Add'), onTap: ...)
/// AppButton(child: MyBadge(count: 3), trailing: Icon(Icons.chevron_right))
/// AppButton(leading: Icon(Icons.add), tooltip: 'Add', onTap: ...) // square
///
/// // Shortcuts
/// AppButton.text('Book', onTap: ...)
/// AppButton.icon(Icons.add, tooltip: 'Add', onTap: ...)
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.leading,
    this.child,
    this.trailing,
    this.onTap,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.expanded = false,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(
          leading != null || child != null || trailing != null,
          'AppButton needs at least one of leading, child or trailing',
        );

  /// Text-only shortcut.
  factory AppButton.text(
    String label, {
    Key? key,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    AppButtonVariant variant = AppButtonVariant.filled,
    AppButtonSize size = AppButtonSize.medium,
    bool expanded = false,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return AppButton(
      key: key,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      variant: variant,
      size: size,
      expanded: expanded,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Text(label),
    );
  }

  /// Icon-only (square) shortcut.
  factory AppButton.icon(
    IconData icon, {
    Key? key,
    VoidCallback? onTap,
    AppButtonVariant variant = AppButtonVariant.filled,
    AppButtonSize size = AppButtonSize.medium,
    String? tooltip,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return AppButton(
      key: key,
      leading: Icon(icon),
      onTap: onTap,
      variant: variant,
      size: size,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Widget shown before [child].
  final Widget? leading;

  /// Main content. Usually a [Text], but can be any widget.
  final Widget? child;

  /// Widget shown after [child].
  final Widget? trailing;

  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final AppButtonSize size;

  /// Stretch to the full available width.
  final bool expanded;

  /// Accessibility label / hover tooltip. Strongly recommended for
  /// buttons without text.
  final String? tooltip;

  /// Overrides the variant's background color.
  final Color? backgroundColor;

  /// Overrides the variant's foreground color (text and icons).
  final Color? foregroundColor;

  /// Only one widget and no text -> render as a square button.
  bool get _square => child == null && (leading != null) != (trailing != null);

  @override
  Widget build(BuildContext context) {
    final (defaultBackground, defaultForeground) = switch (variant) {
      AppButtonVariant.filled => (AppColors.colorPressed, AppColors.textOnAction),
      AppButtonVariant.soft => (AppColors.colorSoft, AppColors.colorPressed),
    };
    final background = backgroundColor ?? defaultBackground;
    final foreground = foregroundColor ?? defaultForeground;

    final radius = BorderRadius.circular(size.radius);

    final Widget inner;
    if (_square) {
      inner = SizedBox.square(
        dimension: size.height,
        child: Center(child: leading ?? trailing),
      );
    } else {
      inner = SizedBox(
        height: size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.padding),
          child: Row(
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSpacing.s,
            children: [
              if (leading != null) leading!,
              if (child != null) Flexible(child: child!),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      );
    }

    // Children inherit color / sizes from here, so a plain Icon() or Text()
    // looks correct without any styling.
    final content = IconTheme(
      data: IconThemeData(color: foreground, size: size.icon),
      child: DefaultTextStyle(
        style: AppTextStyles.pillButton.copyWith(
          color: foreground,
          fontSize: size.fontSize,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: inner,
      ),
    );

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

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    // No excludeSemantics: a Text passed as child keeps its own label.
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: button,
    );
  }
}