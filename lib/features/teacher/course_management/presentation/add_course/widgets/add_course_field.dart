import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class AddCourseField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const AddCourseField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white70,
          ),
          filled: true,
          fillColor: AppColors.white.withValues(alpha: 0.10),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
