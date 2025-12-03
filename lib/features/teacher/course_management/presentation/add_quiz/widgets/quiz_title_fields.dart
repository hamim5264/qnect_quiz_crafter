import 'package:flutter/material.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

class QuizTitleFields extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;

  const QuizTitleFields({
    super.key,
    required this.titleCtrl,
    required this.descCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _outlinedField(controller: titleCtrl, hint: "Quiz Name"),
        _outlinedField(
          controller: descCtrl,
          hint: "Quiz Description",
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _outlinedField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: AppTypography.family,
            color: Colors.white60,
          ),
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white54, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.secondaryDark,
              width: 1.6,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
