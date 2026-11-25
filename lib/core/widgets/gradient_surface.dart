import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Rounded card with a layered gradient (Home widget background).
class GradientSurface extends StatelessWidget {
  const GradientSurface({
    super.key,
    required this.background,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.card),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.card)),
  });

  final CardBackground background;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: background.base),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            for (final glow in background.glows)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: glow.toGradient()),
                ),
              ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
