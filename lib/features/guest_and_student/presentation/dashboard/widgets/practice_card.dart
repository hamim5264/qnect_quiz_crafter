import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class PracticeCard extends StatelessWidget {
  final VoidCallback onTap;

  const PracticeCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.chip3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Lottie.asset(
                  "assets/icons/quiz_time.json",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Try a Free Quiz??",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.chip1,
                    ),
                  ),
                  Text(
                    "Experience QuizCrafter in minutes",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 24,
              color: AppColors.chip1,
            ),
          ],
        ),
      ),
    );
  }
}
