import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Збирає токени в ThemeData, щоб стандартні Material-віджети
/// (TextField, Scaffold, кнопки) одразу виглядали як у Figma.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      onPrimary: AppColors.onAccent,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      // Inter для всього тексту за замовчуванням. interTextTheme() тут не
      // використовуємо: у google_fonts 9 він несумісний з ThemeData цієї версії Flutter.
      fontFamily: GoogleFonts.inter().fontFamily,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.body,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: const BorderSide(color: AppColors.brand, width: 1.5),
        ),
      ),
    );
  }
}
