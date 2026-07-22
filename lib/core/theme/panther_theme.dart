import 'package:flutter/material.dart';

class PantherColors {
  PantherColors._();

  static const Color black = Color(0xFF111015);
  static const Color surface = Color(0xFF1A191F);
  static const Color elevatedSurface = Color(0xFF242229);

  static const Color gold = Color(0xFFFFC72C);
  static const Color goldMuted = Color(0xFFD7A91E);

  static const Color white = Color(0xFFF7F4EE);
  static const Color textSecondary = Color(0xFFBDB7C4);
}

class PantherTheme {
  PantherTheme._();

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: PantherColors.gold,
      brightness: Brightness.dark,
      surface: PantherColors.surface,
      primary: PantherColors.gold,
      onPrimary: PantherColors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: PantherColors.black,

      appBarTheme: const AppBarTheme(
        backgroundColor: PantherColors.black,
        foregroundColor: PantherColors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: PantherColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),

      cardTheme: const CardThemeData(
        color: PantherColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: PantherColors.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
        headlineMedium: TextStyle(
          color: PantherColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: PantherColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: PantherColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
          color: PantherColors.black,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: PantherColors.gold,
          foregroundColor: PantherColors.black,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: PantherColors.elevatedSurface,
        thickness: 1,
      ),
    );
  }
}
