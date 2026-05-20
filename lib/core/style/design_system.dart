import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/sudoku/presentation/cubit/settings_cubit.dart';

class InkColorPalette {
  final Color textClue;
  final Color textUser;
  final Color highlightSameValue;
  final Color highlightActive;

  const InkColorPalette({
    required this.textClue,
    required this.textUser,
    required this.highlightSameValue,
    required this.highlightActive,
  });
}

class AppColors {
  AppColors._();

  // Baseline Light Colors
  static const Color backgroundLight = Color(0xFFFAF7F2); // Soft warm printed newspaper cream
  static const Color surfaceLight = Color(0xFFFFFFFF); // Bright paper white
  static const Color cellBorderLight = Color(0xFFD6D0C2); // Muted sepia
  static const Color subgridBorderLight = Color(0xFF5C5850); // Medium sepia
  static const Color gridOuterLight = Color(0xFF1E2022); // Bold dark charcoal
  static const Color keyBackgroundLight = Color(0xFFF0EAE1);
  static const Color keyTextLight = Color(0xFF4A453E);

  // Baseline Dark Colors (Deep Slate Newsprint Theme)
  static const Color backgroundDark = Color(0xFF1E2022); // Deep slate paper black
  static const Color surfaceDark = Color(0xFF2D3033); // Slightly lighter container slate
  static const Color cellBorderDark = Color(0xFF4A4E52); // Muted dark sepia
  static const Color subgridBorderDark = Color(0xFF7F868D); // Medium gray/sepia
  static const Color gridOuterDark = Color(0xFFFAF7F2); // Bold light cream
  static const Color keyBackgroundDark = Color(0xFF2D3033);
  static const Color keyTextDark = Color(0xFFFAF7F2);

  // Custom Ink Colors Directory
  static const Map<String, InkColorPalette> inkPalettesLight = {
    'Charcoal': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFF2B6CB0), // Elegant Deep Blue Ink
      highlightSameValue: Color(0x142B6CB0), // 8% Blue ink wash
      highlightActive: Color(0xB2D6D0C2), // 70% active stamp
    ),
    'Vintage Sepia': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFF704214), // Sepia Brown Ink
      highlightSameValue: Color(0x14704214),
      highlightActive: Color(0xB2D6D0C2),
    ),
    'Prussian Blue': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFF003153), // Prussian Blue
      highlightSameValue: Color(0x14003153),
      highlightActive: Color(0xB2D6D0C2),
    ),
    'Teal Cyan': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFF0D7A80), // Teal Cyan
      highlightSameValue: Color(0x140D7A80),
      highlightActive: Color(0xB2D6D0C2),
    ),
    'Vintage Orange': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFFC85A17), // Vintage Orange
      highlightSameValue: Color(0x14C85A17),
      highlightActive: Color(0xB2D6D0C2),
    ),
    'Blush Pink': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFFD53F8C), // Blush Pink
      highlightSameValue: Color(0x14D53F8C),
      highlightActive: Color(0xB2D6D0C2),
    ),
    'Forest Pine': InkColorPalette(
      textClue: Color(0xFF1E2022),
      textUser: Color(0xFF224D17), // Forest Green Ink
      highlightSameValue: Color(0x14224D17),
      highlightActive: Color(0xB2D6D0C2),
    ),
  };

  static const Map<String, InkColorPalette> inkPalettesDark = {
    'Charcoal': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFF63B3ED), // Light Blue for readability
      highlightSameValue: Color(0x2463B3ED),
      highlightActive: Color(0xB24A4E52),
    ),
    'Vintage Sepia': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFFED8936), // Light Sepia Orange
      highlightSameValue: Color(0x24ED8936),
      highlightActive: Color(0xB24A4E52),
    ),
    'Prussian Blue': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFF4FD1C5), // Light Teal Ink
      highlightSameValue: Color(0x244FD1C5),
      highlightActive: Color(0xB24A4E52),
    ),
    'Teal Cyan': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFF4FD1C5), // Teal Cyan Dark Mode
      highlightSameValue: Color(0x244FD1C5),
      highlightActive: Color(0xB24A4E52),
    ),
    'Vintage Orange': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFFED8936), // Vintage Orange Dark Mode
      highlightSameValue: Color(0x24ED8936),
      highlightActive: Color(0xB24A4E52),
    ),
    'Blush Pink': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFFF687B3), // Blush Pink Dark Mode
      highlightSameValue: Color(0x24F687B3),
      highlightActive: Color(0xB24A4E52),
    ),
    'Forest Pine': InkColorPalette(
      textClue: Color(0xFFFAF7F2),
      textUser: Color(0xFF68D391), // Light Green Ink
      highlightSameValue: Color(0x2468D391),
      highlightActive: Color(0xB24A4E52),
    ),
  };

  // Safe Getter fallback
  static InkColorPalette getInk(bool isDark, String name) {
    final map = isDark ? inkPalettesDark : inkPalettesLight;
    return map[name] ?? map['Charcoal']!;
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData generate({
    required bool isDark,
    required String fontFamily,
    required String inkColorName,
  }) {
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final ink = AppColors.getInk(isDark, inkColorName);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.light(
        surface: surface,
        primary: ink.textUser,
        error: isDark ? const Color(0xFFE53E3E) : const Color(0xFFC53030),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ink.textClue,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ink.textClue,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ink.textClue,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: ink.textClue,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: ink.textClue,
        ),
      ),
    );
  }

  // Dynamic Typography Helpers dynamically computed
  static TextStyle cellClueStyle({required String fontFamily, required bool isDark, required String inkColorName}) {
    final ink = AppColors.getInk(isDark, inkColorName);
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: ink.textClue,
    );
  }

  static TextStyle cellUserStyle({required String fontFamily, required bool isDark, required String inkColorName}) {
    final ink = AppColors.getInk(isDark, inkColorName);
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: ink.textUser,
    );
  }

  static TextStyle cellInvalidStyle({required String fontFamily, required bool isDark}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: isDark ? const Color(0xFFFC8181) : const Color(0xFFC53030),
    );
  }

  static TextStyle noteStyle({required bool isDark}) {
    return TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF718096),
      height: 1.0,
    );
  }
}

extension ActiveTheme on BuildContext {
  SettingsState get settings => select((SettingsCubit c) => c.state);
  bool get isDark => settings.isDarkNewsprint;
  String get fontFamily => settings.activeFontFamily;
  String get inkColorName => settings.activeInkColorName;
  InkColorPalette get inkPalette => AppColors.getInk(isDark, inkColorName);

  Color get scaffoldBg => isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surfaceBg => isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get cellBorder => isDark ? AppColors.cellBorderDark : AppColors.cellBorderLight;
  Color get subgridBorder => isDark ? AppColors.subgridBorderDark : AppColors.subgridBorderLight;
  Color get gridOuter => isDark ? AppColors.gridOuterDark : AppColors.gridOuterLight;
  Color get keyBg => isDark ? AppColors.keyBackgroundDark : AppColors.keyBackgroundLight;
  Color get keyText => isDark ? AppColors.keyTextDark : AppColors.keyTextLight;
  Color get textClue => inkPalette.textClue;
  Color get textUser => inkPalette.textUser;
  Color get textNote => isDark ? const Color(0xFFA0AEC0) : const Color(0xFF718096);
  Color get bgInvalid => isDark ? const Color(0xFF3D2020) : const Color(0xFFFFF5F5);
  Color get textInvalid => isDark ? const Color(0xFFFC8181) : const Color(0xFFC53030);

  TextStyle get cellClueStyle => AppTheme.cellClueStyle(fontFamily: fontFamily, isDark: isDark, inkColorName: inkColorName);
  TextStyle get cellUserStyle => AppTheme.cellUserStyle(fontFamily: fontFamily, isDark: isDark, inkColorName: inkColorName);
  TextStyle get cellInvalidStyle => AppTheme.cellInvalidStyle(fontFamily: fontFamily, isDark: isDark);
  TextStyle get noteStyle => AppTheme.noteStyle(isDark: isDark);
}

