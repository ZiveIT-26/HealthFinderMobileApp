/// Відступи та радіуси з Figma.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 6;
  static const double s = 8;
  static const double m = 12;
  static const double card = 14; // внутрішній відступ віджета
  static const double l = 16;
  static const double screen = 18; // відступ екрана зліва і справа
}

abstract final class AppRadius {
  static const double control = 8; // кнопки
  static const double field = 12; // поля, рядки, метрики, вкладки
  static const double card = 24; // віджети на головному екрані
}
