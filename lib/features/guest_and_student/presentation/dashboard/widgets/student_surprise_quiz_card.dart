import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../provider/student_latest_surprise_quiz_provider.dart';

class StudentSurpriseQuizCard extends StatelessWidget {
  final StudentSurpriseQuizPreview? quiz;

  const StudentSurpriseQuizCard({super.key, required this.quiz});

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return "${h}h ${m}m left";
  }

  @override
  Widget build(BuildContext context) {
    final bool hasQuiz = quiz != null;
    final bool isExpired = quiz?.isExpired ?? true;

    return GestureDetector(
      onTap:
          (!hasQuiz || isExpired)
              ? null
              : () => context.pushNamed('studentSurpriseQuizList'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(
                'assets/icons/surprise_icon.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasQuiz ? "Surprise Quiz" : "No Surprise Quiz",
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    hasQuiz ? quiz!.title : "Check back later",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    !hasQuiz
                        ? "No active surprise quiz right now"
                        : isExpired
                        ? "Visibility expired"
                        : _formatDuration(quiz!.remainingTime),
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 13,
                      color:
                          (!hasQuiz || isExpired)
                              ? Colors.redAccent
                              : AppColors.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            if (hasQuiz && !isExpired)
              const Icon(
                Icons.chevron_right_rounded,
                size: 26,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
