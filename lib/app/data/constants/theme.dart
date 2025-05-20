import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      // ✅ 여기!
      fontFamily: 'MapoGoldenPier',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mascotHairColor, // ✅ AppBar 배경색
        elevation: 1,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'MapoGoldenPier',
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.vividLavender,
        inactiveTrackColor: AppColors.mascotHairColor.withOpacity(0.3),
        thumbColor: AppColors.mascotHairColor,
        overlayColor: AppColors.mascotHairColor.withOpacity(0.2),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.vividLavender, // 원하는 색상
        strokeCap: StrokeCap.round,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mascotHairColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 0,
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'MapoGoldenPier',
            color: AppColors.deepLavender,
          ),
          foregroundColor: AppColors.deepLavender,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.mascotHairColor, // ✅ BottomNavigationBar 배경색
        selectedItemColor: Colors.black,
        unselectedItemColor: AppColors.vividLavender,
        type: BottomNavigationBarType.fixed,
      ),
      cardColor: const Color(0xFFFFF7E6),
      cardTheme: CardTheme(color: Color(0xFFFFF7E6)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.mascotHairColor,
        foregroundColor: AppColors.deepLavender,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
