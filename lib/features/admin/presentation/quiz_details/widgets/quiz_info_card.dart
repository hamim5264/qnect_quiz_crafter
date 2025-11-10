import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizInfoCard extends StatelessWidget {
  final int totalQuestions;
  final int durationMinutes;

  const QuizInfoCard({
    super.key,
    required this.totalQuestions,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Lottie.asset(
                        'assets/icons/question_hub.json',
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$totalQuestions QUESTIONS",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const Text(
                      "1 point for a correct answer",
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.2,
                height: 80,
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Lottie.asset(
                        'assets/icons/times.json',
                        repeat: true,
                        animate: true,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$durationMinutes MINUTES",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const Text(
                      "Total duration of the quiz",
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(thickness: 1, color: AppColors.white.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
