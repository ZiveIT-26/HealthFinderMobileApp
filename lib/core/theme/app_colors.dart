import 'package:material_ui/material_ui.dart';

abstract final class AppColors {
  static const colorBrand = Color(0xFF6D5085);
  static const colorPressed = Color(0xFF563B6B);
  static const colorSoft = Color(0xFFF0EAF5);

  static const ink = Color(0xFF19202F);
  static const secondaryText = Color(0xFF3A4862);
  static const canvas = Color(0xFFFCFCFD);
  static const white = Color(0xFFFFFFFF);


  static const actionPurple = primitiveRawBrand;
  static const primitiveRawBrand = Color(0xFF5F3085);
  static const textOnAction = Color(0xFFFFFFFF);
  static const actionPurplePressed = Color(0xFF4B226C);
  static const actionGreen = Color(0xFF00714B);
  static const actionGreenPressed = Color(0xFF005B3C);
  static const actionPink = Color(0xFF9E1E56);
  static const actionPinkPressed = Color(0xFF7E1845);
  static const actionBlue = Color(0xFF00509C);
  static const actionBluePressed = Color(0xFF004383);


  static const purpleSoft = Color(0xFFE7D5F5);
  static const greenSoft = Color(0xFFD9F5E3);
  static const pinkSoft = Color(0xFFFFCDDD);
  static const blueSoft = Color(0xFFD4E6FF);
  
  static const feedbackUrgentBackground = Color(0xFFFFDCC4);
  static const feedbackUrgentText = Color(0xFF9F3800);
  static const feedbackInformationBackground = Color(0xFFE7CAFF);
  static const feedbackUnavailableBackground = Color(0xFFDBE5F2);

  // Not from Figma, but used in the app for chat links and track lines.

  static const chatLink = Color(0xFF00509C);
  static const track = Color(0xFFE7E7E7); 

  static const fadeStart = Color(0x00D1A7E7);
  static const fadeEnd = Color(0xFFD0A3EA);

  static const chipGradientStart = Color(0xFFF7BEF7); // pink
  static const chipGradientEnd = Color(0xFFD3BAF9);   // lavender


  // Placeholders

  static const chatBorder = Color.fromARGB(255, 255, 0, 255);
  static const chatPlaceholder = Color.fromARGB(255, 255, 0, 255);
  static const border = Color.fromARGB(255, 255, 0, 255);
}