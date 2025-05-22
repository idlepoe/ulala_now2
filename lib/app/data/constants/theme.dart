import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      fontFamily: 'MapoGoldenPier',
      colorScheme: ColorScheme.light(
        primary: AppColors.vividLavender,
        secondary: AppColors.deepLavender,
        surface: AppColors.cardBackground,
        background: AppColors.backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'MapoGoldenPier',
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.softChipColor,
        labelStyle: const TextStyle(fontSize: 12, color: Colors.black87),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        selectedColor: AppColors.vividLavender.withOpacity(0.8),
        secondarySelectedColor: AppColors.vividLavender,
      ),
      cardColor: AppColors.cardBackground,
      cardTheme: const CardTheme(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.mascotHairColor,
        foregroundColor: AppColors.deepLavender,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.mascotHairColor,
        selectedItemColor: Colors.black,
        unselectedItemColor: AppColors.vividLavender,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        labelSmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}
