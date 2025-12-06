import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizTitleFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController subtitleController;
  final VoidCallback onChanged;

  const QuizTitleFields({
    super.key,
    required this.titleController,
    required this.subtitleController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _textField(
          controller: titleController,
          hint: 'Basic Grammar',
          maxLines: 1,
        ),
        _textField(
          controller: subtitleController,
          hint: 'Parts of speech, sentence structure',
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
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
