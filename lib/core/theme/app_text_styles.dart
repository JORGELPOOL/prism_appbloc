import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Space Grotesk — ALL headings, page titles, stat numbers, buttons
/// Inter — ALL body text, descriptions, nav items, form text
/// JetBrains Mono — ONLY small data tags, labels, IDs, timestamps
class AppTextStyles {
  AppTextStyles._();

  // Page titles
  static TextStyle pageTitle = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.8,
  );

  // Section headings
  static TextStyle sectionHead = GoogleFonts.spaceGrotesk(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    letterSpacing: -0.4,
  );

  // Large stat numbers (pool balance, view counts)
  static TextStyle statHero = GoogleFonts.spaceGrotesk(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    color: AppColors.textWhite,
    letterSpacing: -1.5,
  );

  static TextStyle statMedium = GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
    letterSpacing: -0.8,
  );

  // Body text
  static TextStyle bodyL = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMist,
    height: 1.65,
  );

  static TextStyle bodyM = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSilver,
    height: 1.6,
  );

  // Nav and UI items
  static TextStyle navItem = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSilver,
  );

  // Button text
  static TextStyle btnPrimary = GoogleFonts.spaceGrotesk(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.bgPrimary,
    letterSpacing: 0.3,
  );

  // Data labels — JetBrains Mono ONLY
  static TextStyle dataLabel = GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textDim,
    letterSpacing: 1.6,
  );

  static TextStyle dataTag = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.cyan,
    letterSpacing: 1.2,
  );

  static TextStyle timestamp = GoogleFonts.jetBrainsMono(
    fontSize: 10,
    color: AppColors.textDim,
  );

  // Extra styles needed for admin login / form field labels.
  // (Not explicitly named in the design system doc, but required by the
  // "Input field: label above in Inter 12px" rule under PrismInput.)
  static TextStyle inputLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textDim,
    letterSpacing: 0.4,
  );

  static TextStyle inputText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite,
  );
}
