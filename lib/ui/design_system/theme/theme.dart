import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/typography.dart';

class AppTheme {
  static ThemeData build() {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.white,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.textPrimary,
      error: const Color(0xFFB3261E),
      onError: AppColors.white,
      errorContainer: const Color(0xFFF9DEDC),
      onErrorContainer: const Color(0xFF410E0B),
      surface: AppColors.primaryLight,
      onSurface: AppColors.white,
      surfaceContainerHighest: AppColors.cardSecondary,
      onSurfaceVariant: AppColors.textPrimary,
      outline: Colors.white30,
      outlineVariant: Colors.white24,
      shadow: Colors.black,
      scrim: Colors.black54,
      inverseSurface: AppColors.white,
      onInverseSurface: AppColors.primaryDark,
      inversePrimary: AppColors.secondaryDark,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.primaryDark,
      textTheme: AppTypography.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.family,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      cardTheme: CardTheme(
        color: AppColors.primaryLight,
        elevation: 0,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardPrimary,
        hintStyle: const TextStyle(color: Colors.white70),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.secondaryDark, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryLight,
        selectedItemColor: AppColors.secondaryDark,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
      ),
    );

    return base.copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.secondaryDark,
          foregroundColor: AppColors.textPrimary,
          textStyle: const TextStyle(fontFamily: AppTypography.family, fontWeight: FontWeight.w700, fontSize: 18),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.white,
          textStyle: const TextStyle(fontFamily: AppTypography.family, fontWeight: FontWeight.w700, fontSize: 18),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white54),
          textStyle: const TextStyle(fontFamily: AppTypography.family, fontWeight: FontWeight.w600, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontFamily: AppTypography.family, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
