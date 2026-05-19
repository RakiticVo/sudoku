import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // App Background: Soft warm printed newspaper cream
  static const Color background = Color(0xFFFAF7F2);

  // Surface Background: Bright paper white for container cards
  static const Color surface = Color(0xFFFFFFFF);

  // Grid Borders
  static const Color gridOuter = Color(0xFF1E2022); // Bold dark charcoal ink
  static const Color subgridBorder = Color(0xFF5C5850); // Medium charcoal/sepia
  static const Color cellBorder = Color(0xFFD6D0C2); // Muted fading sepia

  // Text / Input Placements
  static const Color textClue = Color(0xFF1E2022); // High-contrast dark charcoal ink
  static const Color textUser = Color(0xFF2B6CB0); // Elegant deep print-blue ink
  static const Color textNote = Color(0xFF718096); // newsprint slate gray

  // Error States
  static const Color textInvalid = Color(0xFFC53030); // Muted ink-crimson
  static const Color bgInvalid = Color(0xFFFFF5F5); // Soft warm warning pink

  // Highlights
  static const Color highlightActive = Color(0xB2D6D0C2); // Transparent warm active cell stamp (70%)
  static const Color highlightCrosshair = Color(0x4CD6D0C2); // Muted sepia gridlines (30%)
  static const Color highlightSameValue = Color(0x142B6CB0); // Subtle blue ink wash (8%)

  // Keypad Accents
  static const Color keyBackground = Color(0xFFF0EAE1);
  static const Color keyText = Color(0xFF4A453E);
  static const Color keyActiveBackground = Color(0xFFD6D0C2);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        surface: AppColors.surface,
        primary: AppColors.textUser,
        error: AppColors.textInvalid,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textClue,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textClue,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textClue,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textClue,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textClue,
        ),
      ),
    );
  }

  // Typography helpers
  static const TextStyle cellClueStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textClue,
  );

  static const TextStyle cellUserStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textUser,
  );

  static const TextStyle cellInvalidStyle = TextStyle(
    fontFamily: 'Georgia',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textInvalid,
  );

  static const TextStyle noteStyle = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.textNote,
    height: 1.0,
  );
}
