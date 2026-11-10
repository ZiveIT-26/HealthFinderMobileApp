import 'package:flutter/material.dart';

/// Фони віджетів з Figma. Кожен фон — лінійний градієнт
/// і кілька м'яких еліптичних "плям" (radial) поверх нього.
/// Малює їх віджет GradientSurface з core/widgets.
abstract final class AppGradients {
  static const ai = CardBackground(
    base: LinearGradient(
      begin: Alignment(-0.72, -1.73),
      end: Alignment(0.72, 1.73),
      colors: [Color(0xFFF2E8EF), Color(0xFFE9D8EB), Color(0xFFF7EFEA)],
      stops: [0, 0.55, 1],
    ),
    glows: [
      Glow(
        center: Alignment(-0.88, -0.84),
        radiusX: 0.75,
        radiusY: 0.90,
        colors: [Color(0x00CCA8DB), Color(0x74CCA8DB), Color(0xC2CA8EE8)],
        stops: [0, 0.423, 0.846],
      ),
      Glow(center: Alignment(-0.50, 0.74), radiusX: 0.80, radiusY: 0.50, color: Color(0xFFF6B5CC), opacity: 0.6),
      Glow(center: Alignment(-0.10, 0.10), radiusX: 0.65, radiusY: 0.55, color: Color(0xFFFFF8EA), opacity: 0.5),
    ],
  );

  static const medications = CardBackground(
    base: LinearGradient(
      begin: Alignment(-0.83, -1.44),
      end: Alignment(0.83, 1.44),
      colors: [Color(0xFF7EBED3), Color(0xFFB4D5AC), Color(0xFFE6E575)],
      stops: [0, 0.48, 1],
    ),
    glows: [
      Glow(center: Alignment(-0.60, -0.84), radiusX: 0.70, radiusY: 0.75, color: Color(0xFF7AAF87), opacity: 0.55),
      Glow(center: Alignment(0.76, 0.76), radiusX: 0.80, radiusY: 0.60, color: Color(0xFFE6E575), opacity: 0.66),
      Glow(center: Alignment(-0.20, -0.06), radiusX: 0.70, radiusY: 0.60, color: Color(0xFFF7F5D8), opacity: 0.42),
    ],
  );

  static const mood = CardBackground(
    base: LinearGradient(
      begin: Alignment(-0.81, -1.48),
      end: Alignment(0.81, 1.48),
      colors: [Color(0xFFF5D6DD), Color(0xFFF6DDE2), Color(0xFFF7EFEA)],
      stops: [0, 0.60, 1],
    ),
    glows: [
      // У Figma дві нижні плями трохи повернуті — тут без повороту, візуально майже те саме.
      Glow(center: Alignment(1.00, -1.00), radiusX: 1.10, radiusY: 1.02, color: Color(0xFFF57783), opacity: 0.79),
      Glow(center: Alignment(-0.83, 0.60), radiusX: 0.87, radiusY: 0.92, color: Color(0xFFF3C979), opacity: 0.70),
      Glow(center: Alignment(0.98, 0.90), radiusX: 0.80, radiusY: 0.75, color: Color(0xFFE3A7A1), opacity: 0.44),
      Glow(center: Alignment(-0.26, -0.70), radiusX: 0.75, radiusY: 0.65, color: Color(0xFFFFF4E7), opacity: 0.48),
    ],
  );

  static const weather = CardBackground(
    base: LinearGradient(
      begin: Alignment(-0.94, -1.17),
      end: Alignment(0.94, 1.17),
      colors: [Color(0xFFDCEFF2), Color(0xFFC0E7FF), Color(0xFF88C7F1)],
      stops: [0, 0.55, 1],
    ),
    glows: [
      Glow(center: Alignment(-0.14, 0.72), radiusX: 0.80, radiusY: 0.75, color: Color(0xFF6EDFD0), opacity: 0.61),
      Glow(center: Alignment(0.06, -0.16), radiusX: 0.725, radiusY: 0.70, color: Color(0xFF7AAF87), opacity: 0.25),
      Glow(center: Alignment(-0.92, -0.88), radiusX: 0.85, radiusY: 0.70, color: Color(0xFFF4F8EA), opacity: 0.43),
    ],
  );

  // Фони плиток погодних метрик: колір зверху → білий знизу.
  static const metricLow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFC6EDFF), Color(0xFFFFFFFF)],
  ); // UV Low, Heatwave Low
  static const metricGood = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD5FFC6), Color(0xFFFFFFFF)],
  ); // Air Quality Good
  static const metricModerate = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF1C6), Color(0xFFFFFFFF)],
  ); // Pollen Moderate
  static const metricHigh = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFC6D8), Color(0xFFFFFFFF)],
  ); // High / Very high
  // Метрики без статусу (тиск, вологість) — просто AppColors.surface.
}

/// Фон картки: базовий градієнт + плями, від нижньої до верхньої.
class CardBackground {
  const CardBackground({required this.base, required this.glows});

  final LinearGradient base;
  final List<Glow> glows;
}

/// Еліптична пляма кольору, що м'яко зникає до країв.
/// [center] — у координатах Alignment (-1..1),
/// [radiusX] / [radiusY] — частка ширини / висоти картки.
class Glow {
  const Glow({
    required this.center,
    required this.radiusX,
    required this.radiusY,
    Color? color,
    double opacity = 1,
    List<Color>? colors,
    List<double>? stops,
  })  : _color = color,
        _opacity = opacity,
        _colors = colors,
        _stops = stops;

  final Alignment center;
  final double radiusX;
  final double radiusY;
  final Color? _color;
  final double _opacity;
  final List<Color>? _colors;
  final List<double>? _stops;

  RadialGradient toGradient() {
    final colors = _colors ?? _fade(_color!, _opacity);
    return RadialGradient(
      center: center,
      radius: 0.5,
      colors: colors,
      stops: _stops ?? const [0, 0.5, 1],
      transform: _EllipseTransform(center, radiusX, radiusY),
    );
  }
}

List<Color> _fade(Color color, double opacity) => [
      color.withValues(alpha: opacity),
      color.withValues(alpha: opacity * 0.6),
      color.withValues(alpha: 0),
    ];

/// Розтягує коло RadialGradient в еліпс потрібного розміру.
class _EllipseTransform extends GradientTransform {
  const _EllipseTransform(this.center, this.radiusX, this.radiusY);

  final Alignment center;
  final double radiusX;
  final double radiusY;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final baseRadius = bounds.shortestSide * 0.5;
    final sx = radiusX * bounds.width / baseRadius;
    final sy = radiusY * bounds.height / baseRadius;
    final p = center.withinRect(bounds);
    return Matrix4.translationValues(p.dx, p.dy, 0)
      ..multiply(Matrix4.diagonal3Values(sx, sy, 1))
      ..multiply(Matrix4.translationValues(-p.dx, -p.dy, 0));
  }
}
