import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors (Matching logo color: rgba(9, 58, 142))
  static const Color primaryColor = Color(0xFF093A8E); // Logo blue: rgb(9, 58, 142)
  static const Color primaryLight = Color(0xFF2E5AA8); // Lighter blue variant
  static const Color primaryDark = Color(0xFF062A6B); // Darker blue variant
  
  // Accent Colors
  static const Color accentColor = Color(0xFF0EA5E9); // Sky blue accent
  static const Color errorColor = Color(0xFFEF4444); // Modern red
  static const Color warningColor = Color(0xFFF59E0B); // Amber warning
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF3F4F6);
  static const Color surfaceColor = Color(0xFFFCFCFD);
  static const Color textPrimary = Color(0xFF1A1D1F);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color borderColor = Color(0xFFE0E2E7);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: surfaceColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 11,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.cairo(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelSmall: GoogleFonts.cairo(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        color: surfaceColor,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide.none,
          textStyle: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: textSecondary,
        ),
        hintStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: surfaceColor,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: primaryLight,
        labelStyle: GoogleFonts.cairo(fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

