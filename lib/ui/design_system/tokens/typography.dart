import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  static const family = 'BarlowCondensed';

  static TextTheme textTheme = const TextTheme(
    displayLarge:   TextStyle(fontFamily: family, fontSize: 54, fontWeight: FontWeight.w700, letterSpacing: 1),
    displayMedium:  TextStyle(fontFamily: family, fontSize: 44, fontWeight: FontWeight.w700, letterSpacing: 1),
    displaySmall:   TextStyle(fontFamily: family, fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 1),
    headlineLarge:  TextStyle(fontFamily: family, fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontFamily: family, fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall:  TextStyle(fontFamily: family, fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge:     TextStyle(fontFamily: family, fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium:    TextStyle(fontFamily: family, fontSize: 18, fontWeight: FontWeight.w500),
    titleSmall:     TextStyle(fontFamily: family, fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge:      TextStyle(fontFamily: family, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium:     TextStyle(fontFamily: family, fontSize: 15, fontWeight: FontWeight.w400),
    bodySmall:      TextStyle(fontFamily: family, fontSize: 13, fontWeight: FontWeight.w400),
    labelLarge:     TextStyle(fontFamily: family, fontSize: 16, fontWeight: FontWeight.w600),
    labelMedium:    TextStyle(fontFamily: family, fontSize: 14, fontWeight: FontWeight.w600),
    labelSmall:     TextStyle(fontFamily: family, fontSize: 12, fontWeight: FontWeight.w600),
  ).apply(
    bodyColor: AppColors.white,
    displayColor: AppColors.white,
  );
}
