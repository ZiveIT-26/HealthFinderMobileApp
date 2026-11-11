import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lays [child] out at the Figma design size and scales it uniformly
/// to the available space, so the whole screen fits without scrolling.
///
/// The width always fills the screen: on screens with a different aspect
/// ratio the virtual canvas becomes slightly wider (or taller) than the design.
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
        final scale = math.min(
          constraints.maxWidth / designSize.width,
          constraints.maxHeight / designSize.height,
        );
        return FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: constraints.maxWidth / scale,
            height: constraints.maxHeight / scale,
            // The canvas is already scaled as a whole, so system text scaling
            // is disabled here to keep the layout from overflowing.
            child: MediaQuery.withNoTextScaling(child: child),
          ),
        );
      },
    );
  }
}
