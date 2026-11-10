import 'package:flutter/material.dart';

/// Кольори з Figma (HealthFinder / Home 06).
/// Назви — за роллю, а не за відтінком.
abstract final class AppColors {
  // Текст
  static const ink = Color(0xFF23262D); // основний текст
  static const muted = Color(0xFF535965); // другорядний текст, плейсхолдери

  // Поверхні
  static const canvas = Color(0xFFFCFCFD); // фон екрана
  static const surface = Color(0xFFFFFFFF); // картки, поля, кнопки всередині віджетів
  static const soft = Color(0xFFF0EAF5); // активна вкладка навігації
  static const track = Color(0xFFE7E7E7); // фон прогрес-бару

  // Навігація
  static const navIcon = Color(0xFF1F8B79); // TODO: уточнити з дизайном

  // Бренд
  static const brand = Color(0xFF6D5085);
  static const onAccent = Color(0xFFFFFFFF); // текст і іконки на кольорових кнопках

  // Акценти віджетів: кожен віджет має свій колір кнопок.
  static const ai = brand;
  static const aiPressed = Color(0xFF563B6B);
  static const medications = Color(0xFF0B7350);
  static const medicationsPressed = Color(0xFF095C40);
  static const mood = Color(0xFF9B4269);
  static const moodPressed = Color(0xFF7C3554);
  static const weather = Color(0xFF185D9F);
  static const weatherPressed = Color(0xFF134A7F);

  // Статуси (значення метрик, прогрес)
  static const success = medications; // "Good", "4 of 8 taken"
  static const info = weather; // "Low", "2 · Low"
  static const warning = Color(0xFF8D580A); // "Moderate"
  // TODO: уточнити з дизайном колір для High / Very high / Extreme
}
