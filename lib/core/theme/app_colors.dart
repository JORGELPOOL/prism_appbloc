import 'package:flutter/material.dart';

/// PRISM design system — colour tokens.
/// Non-negotiable. Do not introduce ad-hoc colours anywhere in the app.
class AppColors {
  AppColors._();

  // Backgrounds — three layers of dark
  static const Color bgPrimary = Color(0xFF050508); // main background
  static const Color bgVoid = Color(0xFF0A0A14); // cards
  static const Color bgSurface = Color(0xFF16162B); // elevated elements

  // Brand accents
  static const Color cyan = Color(0xFF00D4FF); // PRIMARY — CTA, active states
  static const Color violet = Color(0xFF6B5FFF); // gradient only
  static const Color orange = Color(0xFFFF6B35); // gradient only
  static const Color gold = Color(0xFFFFD166); // money numbers ONLY
  static const Color mint = Color(0xFF00FFCC); // success states ONLY

  // Text hierarchy
  static const Color textWhite = Color(0xFFFFFFFF); // headings
  static const Color textMist = Color(0xFFD0D8F0); // primary body
  static const Color textSilver = Color(0xFF9AA8C2); // secondary body
  static const Color textDim = Color(0xFF4A5270); // labels, placeholders

  // State colours
  static const Color success = Color(0xFF00FFCC);
  static const Color error = Color(0xFFFF4D6A);
  static const Color warning = Color(0xFFFFD166);

  // Borders — very subtle
  static const Color border1 = Color(0x0FFFFFFF); // 6% white
  static const Color border2 = Color(0x1AFFFFFF); // 10% white
  static const Color border3 = Color(0x2BFFFFFF); // 17% white

  // Spectrum gradient — logo X and hero moments ONLY
  static const LinearGradient spectrum = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4FF), Color(0xFF6B5FFF), Color(0xFFFF6B35)],
    stops: [0.0, 0.55, 1.0],
  );
}
