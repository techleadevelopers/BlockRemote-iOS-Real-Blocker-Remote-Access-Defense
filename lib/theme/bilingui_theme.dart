import 'package:flutter/material.dart';
import 'app_fonts.dart';

class BilinguiColors {
  static const Color deepPurple = Color(0xFF6A11CB);
  static const Color royalBlue = Color(0xFF2575FC);
  static const Color softLilac = Color(0xFFE0C3FC);
  static const Color lavender = Color(0xFFF3E5F5);
  static const Color darkSurface = Color(0xFF1A1032);
  static const Color cardSurface = Color(0xFFF8F0FF);
  static const Color accentPink = Color(0xFFE040FB);
  static const Color successGreen = Color(0xFF00E676);
  static const Color warningAmber = Color(0xFFFFAB40);
  static const Color errorRed = Color(0xFFFF5252);
  static const Color textPrimary = Color(0xFF1A1032);
  static const Color textSecondary = Color(0xFF6E5B8A);
  static const Color aiChatBubble = Color(0xFFEDE7F6);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [deepPurple, royalBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFB388FF), Color(0xFFCE93D8), Color(0xFFE1BEE7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient softGradient = LinearGradient(
    colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1032), Color(0xFF2D1B69)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient authGradient = LinearGradient(
    colors: [Color(0xFFE8D5F5), Color(0xFFD1B3F0), Color(0xFFB794E6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class BilinguiTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BilinguiColors.deepPurple,
        primary: BilinguiColors.deepPurple,
        secondary: BilinguiColors.softLilac,
        surface: BilinguiColors.lavender,
        onPrimary: Colors.white,
        onSecondary: BilinguiColors.textPrimary,
        onSurface: BilinguiColors.textPrimary,
      ),
      textTheme: AppFonts.textTheme.apply(
        bodyColor: BilinguiColors.textPrimary,
        displayColor: BilinguiColors.textPrimary,
      ),
      cardTheme: CardTheme(
        color: BilinguiColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: BilinguiColors.softLilac.withOpacity(0.3)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: AppFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: BilinguiColors.softLilac.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: BilinguiColors.deepPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: AppFonts.poppins(color: BilinguiColors.textSecondary),
        hintStyle: AppFonts.poppins(color: BilinguiColors.textSecondary.withOpacity(0.6)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
