import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography from Figma. Font: Inter.
/// height = lineHeight / fontSize, as in Figma.
abstract final class AppTextStyles {
  static TextStyle _inter(double size, double lineHeight, FontWeight weight, Color color) =>
      GoogleFonts.inter(
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        color: color,
      );

  /// "HealthFinder" logo (22/28 Bold).
  static TextStyle get logo =>
      _inter(22, 28, FontWeight.w700, AppColors.ink).copyWith(letterSpacing: -0.44);

  /// Page title: "Clinic Details", "Medical Card", "Profile" (19/24 Bold).
  static TextStyle get pageTitle =>
      _inter(19, 24, FontWeight.w700, AppColors.chatInk).copyWith(letterSpacing: -0.45);

  /// Widget title: "AI Health Assistant" (18/24 SemiBold).
  static TextStyle get title => _inter(18, 24, FontWeight.w600, AppColors.ink);

  /// Large temperature: "15°C" (26/32 SemiBold).
  static TextStyle get temperature => _inter(26, 32, FontWeight.w600, AppColors.ink);

  /// Medication name: "Vitamin D" (15/20 SemiBold).
  static TextStyle get medication => _inter(15, 20, FontWeight.w600, AppColors.ink);

  /// Body text, placeholders (14/20 Regular).
  static TextStyle get body => _inter(14, 20, FontWeight.w400, AppColors.muted);

  /// Button text, accent labels: "Save", "4 of 8 taken" (14/20 SemiBold).
  static TextStyle get label => _inter(14, 20, FontWeight.w600, AppColors.ink);

  /// Metric value: "1015 hPa" (14/18 SemiBold).
  static TextStyle get metric => _inter(14, 18, FontWeight.w600, AppColors.ink);

  /// Small text: "1000 IU", "UV Index", navigation tabs (12/16 Regular).
  static TextStyle get meta => _inter(12, 16, FontWeight.w400, AppColors.muted);

  // AI chat

  /// Chat title: "AI Health Assistant" (19/24 Bold).
  static TextStyle get chatTitle =>
      _inter(19, 24, FontWeight.w700, AppColors.chatInk).copyWith(letterSpacing: -0.45);

  /// Chat subtitle: "Care guidance & clinic finder" (11/16 Regular).
  static TextStyle get chatSubtitle => _inter(11, 16, FontWeight.w400, AppColors.chatSubtitle);

  /// Message text (14/24.75 Regular).
  static TextStyle get chatBody => _inter(14, 24.75, FontWeight.w400, AppColors.chatText);

  /// "HealthFinder AI" label (14/24 Bold).
  static TextStyle get chatSender => _inter(14, 24, FontWeight.w700, AppColors.chatText);

  /// Card eyebrow: "NEUROLOGY · KOŠICE" (12/20 Bold).
  static TextStyle get chatEyebrow => _inter(12, 20, FontWeight.w700, AppColors.chatEyebrow);

  /// Card title: doctor name (19/25 Bold).
  static TextStyle get chatCardTitle => _inter(19, 25, FontWeight.w700, AppColors.brandDark);

  /// Card meta: clinic, address, hours (12.5/19.5 Regular).
  static TextStyle get chatMeta => _inter(12.5, 19.5, FontWeight.w400, AppColors.chatMeta);

  /// Button label: "View Clinic" (12.6/16 Bold).
  static TextStyle get chatButton => _inter(12.6, 16, FontWeight.w700, AppColors.onAccent);

  /// Footnote: "AI can make mistakes..." (11/17 Regular).
  static TextStyle get chatFootnote => _inter(11, 17, FontWeight.w400, AppColors.chatFootnote);

  // Detail pages (Clinic Details, Medical Card)

  /// Hero kicker: "NEUROLOGY · OUTPATIENT CLINIC" (15/23 Bold, tracked).
  static TextStyle get detailKicker =>
      _inter(15, 23, FontWeight.w700, AppColors.brand).copyWith(letterSpacing: 1);

  /// Section heading: "About the clinic" (15.5/20 Bold).
  static TextStyle get detailHeading =>
      _inter(15.5, 20, FontWeight.w700, AppColors.chatInk).copyWith(letterSpacing: -0.25);

  /// Strong line: clinic name (15/23 Bold).
  static TextStyle get detailStrong => _inter(15, 23, FontWeight.w700, AppColors.chatInk);

  /// Body text: descriptions, hints (14/22.5 Regular).
  static TextStyle get detailBody => _inter(14, 22.5, FontWeight.w400, AppColors.chatFootnote);

  /// Field label: "Address", "Phone" (14/18 Bold).
  static TextStyle get detailLabel => _inter(14, 18, FontWeight.w700, AppColors.chatInk);

  /// Field value: address, phone, email (14.5/23 Regular).
  static TextStyle get detailValue => _inter(14.5, 23, FontWeight.w400, AppColors.detailValue);

  /// Table row: "Monday" (14.5/22.5 Regular).
  static TextStyle get detailRow => _inter(14.5, 22.5, FontWeight.w400, AppColors.chatInk);

  /// Table value: "10:00–16:00" (14.5/22.5 SemiBold).
  static TextStyle get detailRowValue => _inter(14.5, 22.5, FontWeight.w600, AppColors.chatInk);

  /// Pill button label: "Call Clinic" (13/16 Bold).
  static TextStyle get pillButton => _inter(13, 16, FontWeight.w700, AppColors.onAccent);

  // Profile and info cards

  /// Top bar title on tab pages: "Profile" (22/27 Bold).
  static TextStyle get tabTitle =>
      _inter(22, 27, FontWeight.w700, AppColors.chatInk).copyWith(letterSpacing: -0.6);

  /// Large hero name: "Alex Morgan" (21/26 Bold).
  static TextStyle get heroName => _inter(21, 26, FontWeight.w700, AppColors.chatInk);

  /// Hero title: "Emergency Health Information" (19.5/25 Bold).
  static TextStyle get heroTitle =>
      _inter(19.5, 25, FontWeight.w700, AppColors.chatInk).copyWith(letterSpacing: -0.45);

  /// Small caps kicker: "HEALTHFINDER · MEDICAL CARD" (10/12 ExtraBold, tracked).
  static TextStyle get cardKicker =>
      _inter(10, 12, FontWeight.w800, AppColors.brand).copyWith(letterSpacing: 0.9);

  /// Small helper text (11/18 Regular).
  static TextStyle get caption => _inter(11, 18, FontWeight.w400, AppColors.muted);

  /// Info row label: "Blood type" (11.5/16 Regular).
  static TextStyle get infoLabel => _inter(11.5, 16, FontWeight.w400, AppColors.muted);

  /// Info row value: "O+" (13/19.5 SemiBold).
  static TextStyle get infoValue => _inter(13, 19.5, FontWeight.w600, AppColors.chatText);

  /// Group title: "MY HEALTH" (15.5/20 Bold).
  static TextStyle get groupTitle =>
      _inter(15.5, 20, FontWeight.w700, AppColors.muted).copyWith(letterSpacing: -0.25);

  /// Settings row title: "Medical Card" (13.5/18 Bold).
  static TextStyle get settingsTitle => _inter(13.5, 18, FontWeight.w700, AppColors.chatInk);

  /// Settings row subtitle (11/16 Regular).
  static TextStyle get settingsSubtitle => _inter(11, 16, FontWeight.w400, AppColors.chatText);
}
