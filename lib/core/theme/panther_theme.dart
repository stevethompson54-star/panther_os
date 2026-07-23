import 'package:flutter/material.dart';

class PantherColors {
  PantherColors._();

  // Core brand colors
  static const Color pantherBlack = Color(0xFF0D0D0D);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color elevatedSurface = Color(0xFF242424);

  static const Color pantherGold = Color(0xFFD4AF37);
  static const Color accentGold = Color(0xFFF2C14E);

  static const Color white = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8B8);
  static const Color border = Color(0xFF383838);

  // Mission-status colors
  static const Color success = Color(0xFF28C76F);
  static const Color warning = Color(0xFFF2C14E);
  static const Color critical = Color(0xFFFF5C5C);
  static const Color information = Color(0xFF3B82F6);

  // Backward-compatible aliases
  static const Color black = pantherBlack;
  static const Color surface = charcoal;
  static const Color gold = pantherGold;
  static const Color goldMuted = accentGold;
}

class PantherTheme {
  PantherTheme._();

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: PantherColors.pantherGold,
      onPrimary: PantherColors.pantherBlack,
      secondary: PantherColors.accentGold,
      onSecondary: PantherColors.pantherBlack,
      surface: PantherColors.charcoal,
      onSurface: PantherColors.white,
      error: PantherColors.critical,
      onError: PantherColors.white,
      outline: PantherColors.border,
      outlineVariant: PantherColors.elevatedSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: PantherColors.pantherBlack,

      appBarTheme: const AppBarTheme(
        backgroundColor: PantherColors.pantherBlack,
        foregroundColor: PantherColors.white,
        centerTitle: false,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: PantherColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),

      cardTheme: const CardThemeData(
        color: PantherColors.charcoal,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          side: BorderSide(
            color: PantherColors.border,
            width: 1,
          ),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: PantherColors.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.1,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          color: PantherColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        titleLarge: TextStyle(
          color: PantherColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleMedium: TextStyle(
          color: PantherColors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
        bodyLarge: TextStyle(
          color: PantherColors.white,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: PantherColors.textSecondary,
          fontSize: 14,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: PantherColors.pantherBlack,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
        labelMedium: TextStyle(
          color: PantherColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PantherColors.pantherGold,
          foregroundColor: PantherColors.pantherBlack,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),

      iconTheme: const IconThemeData(
        color: PantherColors.pantherGold,
      ),

      dividerTheme: const DividerThemeData(
        color: PantherColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}