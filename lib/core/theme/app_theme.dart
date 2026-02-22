import 'package:flutter/material.dart';

class AppTheme {
  // Broken White color palette
  static const Color brokenWhite = Color(0xFFF5F5F0);
  static const Color cardWhite = Color(0xFFFAFAF8);
  static const Color limeGreen = Color(0xFF8DEE10);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: limeGreen,
    scaffoldBackgroundColor: brokenWhite,
    canvasColor: brokenWhite,
    cardColor: cardWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: brokenWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: limeGreen,
      brightness: Brightness.light,
      surface: brokenWhite,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: brokenWhite,
      selectedItemColor: limeGreen,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
    dividerColor: const Color(0xFFE0E0DA),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
  );
}
