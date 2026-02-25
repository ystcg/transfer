import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary creamy/pink palette
  static const Color cream = Color(0xFFFFF8F0);
  static const Color creamLight = Color(0xFFFFFDF9);
  static const Color creamCard = Color(0xFFFFF3E8);
  static const Color pink = Color(0xFFF4A0A0);
  static const Color pinkSoft = Color(0xFFFFC4C4);
  static const Color pinkLight = Color(0xFFFFE4E4);
  static const Color rose = Color(0xFFD4707A);
  static const Color roseDeep = Color(0xFFC25060);
  static const Color peach = Color(0xFFFFB5A0);
  static const Color lavender = Color(0xFFE8D5F0);
  static const Color mintSoft = Color(0xFFD5F0E8);
  static const Color skySoft = Color(0xFFD5E8F0);
  static const Color lemonSoft = Color(0xFFF0ECD5);

  // Text colors
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9B9B9B);
  static const Color textOnPink = Color(0xFFFFFFFF);

  // Utility
  static const Color divider = Color(0xFFEEE6DD);
  static const Color shadow = Color(0x12000000);
  static const Color shimmer = Color(0xFFF5E6D8);

  // Category colors
  static const List<Color> categoryColors = [
    Color(0xFFFFE0CC), // Lighting - warm orange
    Color(0xFFD5E8F0), // Plumbing - cool blue
    Color(0xFFD5F0E8), // Cleaning - mint
    Color(0xFFFFE4E4), // Kitchen - pink
    Color(0xFFF0ECD5), // Repairs - warm yellow
    Color(0xFFE8D5F0), // Garden - lavender
    Color(0xFFFFD5E5), // Laundry - rose
    Color(0xFFFFE8D5), // Safety - peach
  ];

  static const List<Color> categoryAccents = [
    Color(0xFFFF9F5F), // Lighting
    Color(0xFF5FA8C8), // Plumbing
    Color(0xFF5FC8A8), // Cleaning
    Color(0xFFF4A0A0), // Kitchen
    Color(0xFFC8B85F), // Repairs
    Color(0xFFA85FC8), // Garden
    Color(0xFFF07098), // Laundry
    Color(0xFFFF8F5F), // Safety
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream,
      primaryColor: AppColors.rose,
      colorScheme: ColorScheme.light(
        primary: AppColors.rose,
        secondary: AppColors.pink,
        surface: AppColors.cream,
        onPrimary: Colors.white,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: _headlineStyle,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.rose,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      textTheme: _textTheme,
      fontFamily: GoogleFonts.inter().fontFamily,
      dividerColor: AppColors.divider,
      splashColor: AppColors.pinkLight.withValues(alpha: 0.3),
      highlightColor: AppColors.pinkLight.withValues(alpha: 0.1),
    );
  }

  static TextStyle get _headlineStyle => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.rose,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      );
}
