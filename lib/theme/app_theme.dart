import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryGreen = Color(0xFF1B5E20); // Colors.green[900]
  static const Color secondaryGreen = Color.fromARGB(255, 35, 99, 38); // Colors.green[700]
  static const Color accentGreen = Color(0xFF4CAF50); // Colors.green[500]
  static const Color lightGreen = Color(0xFFE8F5E9); // Colors.green[100]

  // Dark Theme Colors
  static const Color darkPrimaryGreen =
      Color(0xFF1B5E20); // Light green for primary
  static const Color darkSecondaryGreen =
      Color.fromARGB(255, 35, 99, 38); // Slightly darker green
  static const Color darkAccentGreen = Color(0xFF4CAF50); // Same accent
  static const Color darkSurface = Color(0xFF1E1E1E); // Darker surface
  static const Color darkCardColor =
      Color(0xFF2D2D2D); // Slightly lighter than surface
  static const Color darkTextColor =
      Color(0xCCFFFFFF); // Light text with 80% opacity
  static const Color darkTextSecondary =
      Color(0xFFB0B0B0); // Slightly dimmer text
  static const Color darkError = Color(0xFFCF6679); // Material dark theme error
  static const Color darkDivider = Color(0xFF424242); // Divider color

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryGreen,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryGreen,
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: primaryGreen.withValues(alpha: 0.2),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen),
      ),
      hintStyle: TextStyle(color: Colors.grey[600]),
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: darkPrimaryGreen,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryGreen,
      secondary: darkSecondaryGreen,
      surface: darkSurface,
      error: darkError,
      onPrimary: Colors.black87,
      onSecondary: Colors.black87,
      onSurface: darkTextColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkTextColor,
      iconTheme: IconThemeData(color: darkTextColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: darkPrimaryGreen,
      unselectedItemColor: Colors.black87,
      backgroundColor: darkPrimaryGreen,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.2),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkTextColor),
      bodyMedium: TextStyle(color: darkTextColor),
      titleLarge: TextStyle(color: darkTextColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkPrimaryGreen),
      ),
      hintStyle: const TextStyle(color: darkTextSecondary),
    ),
    dividerTheme: const DividerThemeData(
      color: darkDivider,
      thickness: 1,
    ),
  );
}
