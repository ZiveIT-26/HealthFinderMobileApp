import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Типографіка з Figma. Шрифт — Inter.
/// height = lineHeight / fontSize, як у Figma.
abstract final class AppTextStyles {
  static TextStyle _inter(double size, double lineHeight, FontWeight weight, Color color) =>
      GoogleFonts.inter(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        color: color,
      );

  /// Логотип "HealthFinder" (22/28 Bold).
  static TextStyle get logo =>
      _inter(22, 28, FontWeight.w700, AppColors.ink).copyWith(letterSpacing: -0.44);

  /// Заголовок сторінки: "Medical Card", "Profile" (22/28 SemiBold).
  /// TODO: звірити розмір з Figma.
  static TextStyle get pageTitle => _inter(22, 28, FontWeight.w600, AppColors.ink);

  /// Заголовок віджета: "AI Health Assistant" (18/24 SemiBold).
  static TextStyle get title => _inter(18, 24, FontWeight.w600, AppColors.ink);

  /// Велика температура: "15°C" (26/32 SemiBold).
  static TextStyle get temperature => _inter(26, 32, FontWeight.w600, AppColors.ink);

  /// Назва ліків: "Vitamin D" (15/20 SemiBold).
  static TextStyle get medication => _inter(15, 20, FontWeight.w600, AppColors.ink);

  /// Звичайний текст, плейсхолдери (14/20 Regular).
  static TextStyle get body => _inter(14, 20, FontWeight.w400, AppColors.muted);

  /// Текст кнопок, акцентні підписи: "Save", "4 of 8 taken" (14/20 SemiBold).
  static TextStyle get label => _inter(14, 20, FontWeight.w600, AppColors.ink);

  /// Значення метрики: "1015 hPa" (14/18 SemiBold).
  static TextStyle get metric => _inter(14, 18, FontWeight.w600, AppColors.ink);

  /// Дрібний текст: "1000 IU", "UV Index", вкладки навігації (12/16 Regular).
  static TextStyle get meta => _inter(12, 16, FontWeight.w400, AppColors.muted);
}
