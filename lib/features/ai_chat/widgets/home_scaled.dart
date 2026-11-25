import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Scales [child] by the same factor as the Home screen (`FitToScreen` with
/// the Home design size), so the chat welcome screen and Home look the same
/// size on any phone. [child] is laid out at the available width divided by
/// that factor, then scaled down to fill the width.
class HomeScaled extends StatelessWidget {
  const HomeScaled({super.key, required this.child});

  final Widget child;

  /// Design size of the Home screen content (`HomeScreen._designSize`).
  static const _designSize = Size(430, 850);

  /// Height of the bottom navigation, which the Home content excludes.
  static const _navigationHeight = 84.0;

  static double scaleOf(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final height = size.height - padding.vertical - _navigationHeight;
    return math.min(size.width / _designSize.width, height / _designSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => FittedBox(
        fit: BoxFit.fitWidth,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: constraints.maxWidth / scaleOf(context),
          // Scaled as a whole, so system text scaling would only break the
          // layout (same as FitToScreen).
          child: MediaQuery.withNoTextScaling(child: child),
        ),
      ),
    );
  }
}
