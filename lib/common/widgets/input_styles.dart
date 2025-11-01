import 'package:flutter/material.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

InputDecoration pillInput({
  required String label,
  String? hint,
  Widget? suffix,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixIcon: suffix,
    labelStyle: const TextStyle(
      fontFamily: AppTypography.family,
      fontWeight: FontWeight.w600,
      color: Colors.white70,
      fontSize: 14,
    ),
    hintStyle: const TextStyle(
      fontFamily: AppTypography.family,
      color: Colors.white30,
      fontSize: 14,
    ),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.08),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: AppColors.secondaryDark, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
    ),
  );
}
