import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizInstructionsList extends StatelessWidget {
  const QuizInstructionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> instructions = [
      "1 mark awarded for a correct answer and no marks for an incorrect answer.",
      "Tap on option to select the correct answer.",
      "Screenshot and screen record are not allowed.",
      "Once you press the back or home button, quiz will be dismissed.",
      "If anyone doesn’t attend within the assigned time, -5 points will be deducted.",
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final text in instructions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13.5,
                        color: Colors.redAccent,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
