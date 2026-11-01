import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1976D2);

  static const Color secondaryBlue = Color(0xFF42A5F5);

  static const Color backgroundColor = Color(0xFFF5F9FF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),

    scaffoldBackgroundColor: backgroundColor,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}
