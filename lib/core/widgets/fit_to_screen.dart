
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lays [child] out at the Figma design size and scales it uniformly
/// to the available space, so the whole screen fits without scrolling.
class FitToScreen extends StatelessWidget {
  const FitToScreen({
    super.key,
    required this.designSize,
    required this.child,
  });

  final Size designSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Wait until Flutter provides valid screen dimensions.
        if (!constraints.hasBoundedWidth ||
            !constraints.hasBoundedHeight ||
            constraints.maxWidth <= 0 ||
            constraints.maxHeight <= 0 ||
            designSize.width <= 0 ||
            designSize.height <= 0) {
          return const SizedBox.shrink();
        }

        final scale = math.min(
          constraints.maxWidth / designSize.width,
          constraints.maxHeight / designSize.height,
        );

        if (!scale.isFinite || scale <= 0) {
          return const SizedBox.shrink();
        }

        return FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth / scale,
            height: constraints.maxHeight / scale,
            child: MediaQuery.withNoTextScaling(child: child),
          ),
        );
      },
    );
  }
}
