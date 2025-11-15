import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../models/quiz_genie_models.dart';

class QuestionCard extends StatelessWidget {
  final GeneratedQuestion question;
  final int number;

  const QuestionCard({super.key, required this.number, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ${question.question}",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(question.options.length, (i) {
            final isCorrect = i == question.correctIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${String.fromCharCode(97 + i)}) ",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: isCorrect ? AppColors.chip1 : Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      question.options[i],
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: isCorrect ? AppColors.chip1 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
