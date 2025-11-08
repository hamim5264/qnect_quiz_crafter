import 'package:flutter/material.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

class CommonSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: AppColors.secondaryDark,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.white70,
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppTypography.family,
      ),
    );
  }
}
