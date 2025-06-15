// In: lib/theme/AppTheme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define the colors from the design for easy reference
  static const Color primaryBlue = Color(0xFF3D8BFF);
  static const Color lightGrey = Color(0xFFF0F2F5);
  static const Color darkText = Color(0xFF1E2022);
  static const Color lightText = Color(0xFF77838F);

  // Now we build the theme using these colors
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryBlue, // Use the new blue
    scaffoldBackgroundColor: Colors.white,

    // Define the color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      background: Colors.white,
    ),

    // Define the default font family
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: darkText,
      displayColor: darkText,
    ),

    // Define the global style for all TextFormFields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightGrey, // Use the new light grey
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        color: lightText,
        fontSize: 14,
      ),
      prefixIconColor: lightText, // Style for icons inside fields
    ),

    // Define the global style for all ElevatedButtons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
    ),

    useMaterial3: true,
  );
}