import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define your colors here
  static const Color paperColor = Color(0xFFFBF7F0); // Background
  static const Color inkColor = Color(0xFF4A4238); // Text
  static const Color accentColor = Color(0xFFA88E70); // Accents/Buttons

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: paperColor,
    primaryColor: accentColor,

    textTheme: GoogleFonts.playpenSansTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(color: inkColor),
        titleLarge: TextStyle(color: inkColor),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: paperColor,
      foregroundColor: inkColor,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paperColor,
      indicatorColor: accentColor.withOpacity(0.2), // The pill shape color
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: accentColor);
        }
        return const IconThemeData(color: inkColor);
      }),
    ),
  );
}
