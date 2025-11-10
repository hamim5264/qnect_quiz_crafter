import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizUpdateButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;

  const QuizUpdateButton({
    super.key,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isActive ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isActive ? AppColors.secondaryDark : AppColors.secondaryDark,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Update',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.white70,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
