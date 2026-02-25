import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0D1117);
  static const Color primaryNeon = Color(0xFF00FF41);
  static const Color secondaryNeon = Color(0xFFADFF2F);
  static const Color text = Color(0xFFF1F2F1);
  static const Color danger = Color(0xFFFF0040);
  static const Color warning = Color(0xFFFFAA00);
  static const Color surfaceLight = Color(0xFF161B22);
  static const Color glass = Color(0x1A0D1117);
  static const Color glassBorder = Color(0x2200FF41);
}

class AppFonts {
  static TextStyle heading({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.text,
    double letterSpacing = 0.5,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.primaryNeon,
    double letterSpacing = 0.0,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryNeon,
        secondary: AppColors.secondaryNeon,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.primaryNeon,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryNeon),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          color: AppColors.text,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        headlineMedium: GoogleFonts.inter(
          color: AppColors.text,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.text,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.inter(
          color: const Color(0xFF8B949E),
          fontSize: 12,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          color: AppColors.primaryNeon,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
