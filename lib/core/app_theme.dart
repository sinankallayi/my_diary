import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF9F7F9),
      primaryColor: AppColors.pink,
      useMaterial3: true,
      fontFamily: GoogleFonts.dmSans().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.pink,
        primary: AppColors.pink,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(),
    );
  }

  static TextStyle get serifTitleStyle => GoogleFonts.playfairDisplay(
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );
}
