import 'package:flutter/material.dart';

/// Colors from Figma (HealthFinder / Home 06).
/// Named by role, not by hue.
abstract final class AppColors {
  // Text
  static const ink = Color(0xFF23262D); // primary text
  static const muted = Color(0xFF535965); // secondary text, placeholders

  // Surfaces
  static const canvas = Color(0xFFFCFCFD); // screen background
  static const surface = Color(0xFFFFFFFF); // cards, fields, buttons inside widgets
  static const soft = Color(0xFFF0EAF5); // active navigation tab
  static const track = Color(0xFFE7E7E7); // progress bar track

  // Navigation
  static const navIcon = brand; // bottom navigation icons

  // Brand
  static const brand = Color(0xFF6D5085);
  static const brandDark = Color(0xFF563B6B); // dark purple headings
  static const onAccent = Color(0xFFFFFFFF); // text and icons on accent buttons

  // Widget accents: each widget has its own button color.
  static const ai = brand;
  static const aiPressed = brandDark;
  static const medications = Color(0xFF0B7350);
  static const medicationsPressed = Color(0xFF095C40);
  static const mood = Color(0xFF9B4269);
  static const moodPressed = Color(0xFF7C3554);
  static const weather = Color(0xFF185D9F);
  static const weatherPressed = Color(0xFF134A7F);

  // AI chat (layout from the "AI Chat" mockup, recolored to the brand purple)
  static const chatAccent = brand; // send, "View Clinic"
  static const chatAccentDark = brand; // icons on light backgrounds
  static const chatInk = Color(0xFF173547); // title, user message
  static const chatText = Color(0xFF557185); // assistant text
  static const chatSubtitle = Color(0xFF83939A);
  static const chatPlaceholder = Color(0xFF617987);
  static const chatEyebrow = brand; // "NEUROLOGY · KOŠICE"
  static const chatMeta = muted; // address, hours
  static const chatDescription = Color(0xFF71808D);
  static const chatFootnote = Color(0xFF5B6E80);
  static const chatLink = Color(0xFF117CBA);
  static const chatWarning = Color(0xFFFFFAF1); // "Seek urgent care" background
  static const chatSoft = soft; // "new conversation" button
  static const chatBorder = Color(0xFFE6DDEE); // composer outline

  // Detail pages
  static const detailValue = Color(0xFF758694); // field values (address, phone)
  static const infoCardTint = Color(0xFFF8F5FB); // tinted info cards (Medical Card)
  static const divider = Color(0x146D5085); // lines between info rows

  // Statuses (metric values, progress)
  static const success = medications; // "Good", "4 of 8 taken"
  static const info = weather; // "Low", "2 · Low"
  static const warning = Color(0xFF8D580A); // "Moderate"
  // TODO: confirm High / Very high / Extreme colors with design
}
