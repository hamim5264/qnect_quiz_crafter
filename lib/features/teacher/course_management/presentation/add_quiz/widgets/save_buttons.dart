import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class SaveQuizButtons extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onSaveAndNext;

  const SaveQuizButtons({
    super.key,
    required this.isSaving,
    required this.onSave,
    required this.onSaveAndNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _btn("Save", onSave),
        const SizedBox(height: 12),
        _btn("Add & Next", onSaveAndNext),
      ],
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
