import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final TextTheme _textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRed,
        tertiary: AppColors.tertiaryGreen,
        secondary: AppColors.secondaryGrey,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightText,
      ),
      textTheme: _textTheme.apply(
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightIcon,
      ),
      fontFamily: 'Inter',
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        secondary: AppColors.secondaryGrey,
        tertiary: AppColors.tertiaryGreen,
        onPrimary: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkText,
      ),
      textTheme: _textTheme.apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkIcon,
      ),
      fontFamily: 'Inter',
    );
  }
}
