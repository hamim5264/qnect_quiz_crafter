import 'package:flutter/material.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizTitleFields extends StatelessWidget {
  final VoidCallback onChanged;

  const SurpriseQuizTitleFields({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field("Quiz Title", onChanged),
        _field("Short Description", onChanged, maxLines: 2),
      ],
    );
  }

  Widget _field(String hint, VoidCallback onChanged, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        onChanged: (_) => onChanged(),
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
          fillColor: AppColors.white.withValues(alpha: 0.1),
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
