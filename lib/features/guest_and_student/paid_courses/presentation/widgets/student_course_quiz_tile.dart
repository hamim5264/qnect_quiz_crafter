import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentCourseQuizTile extends StatelessWidget {
  final String courseId;
  final String quizId;
  final String title;
  final String subtitle;
  final int totalPoints; // total questions
  final int earnedPoints; // current earned points
  final bool locked;
  final bool expired;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;
  final List questions;
  final int durationSeconds;
  final String? attemptId;



  const StudentCourseQuizTile({
    super.key,
    required this.courseId,
    required this.quizId,
    required this.title,
    required this.subtitle,
    required this.totalPoints,
    required this.earnedPoints,
    required this.locked,
    required this.expired,
    required this.completed,
    required this.startDate,
    required this.endDate,
    required this.questions,
    required this.durationSeconds,
    required this.attemptId,


  });

  String get _durationLabel {
    final now = DateTime.now();

    if (now.isBefore(startDate)) {
      final diff = startDate.difference(now);
      final days = diff.inDays;
      final hours = diff.inHours % 24;
      return 'Unlock in ${days}d ${hours}h';
    }

    if (now.isAfter(endDate)) {
      return 'Time over';
    }

    final diff = endDate.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    return '${days}d ${hours}h left';
  }

  @override
  Widget build(BuildContext context) {
    //final bool disabled = locked || expired;
    final bool isAttempted = earnedPoints > 0;
    final bool disabled = locked || expired || isAttempted;


    return Column(
      children: [
        // MAIN CARD + LOCK OVERLAY
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP ROW: ICON + TITLE + SUBTITLE + CHEVRON
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white24,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.doc_text_fill,
                          color: AppColors.chip2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppTypography.family,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (locked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Quiz is locked until the start date.")),
                            );
                            return;
                          }

                          if (expired) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Quiz time has expired.")),
                            );
                            return;
                          }

                          if (isAttempted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("You have already attempted this quiz.")),
                            );
                            return;
                          }

                          // ⭐ Quiz is available — go to instruction screen
                          context.pushNamed(
                            'studentQuizInstruction',
                            extra: {
                              'courseId': courseId,
                              'quizId': quizId,
                              'title': title,
                              'durationSeconds': durationSeconds,
                              'questions': questions,
                            },
                          );
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: locked || expired || isAttempted
                                ? Colors.white24
                                : AppColors.secondaryDark,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Icon(
                            CupertinoIcons.chevron_right,
                            size: 18,
                            color: locked || expired || isAttempted ? Colors.black38 : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // BOTTOM ROW: POINTS / EARNED / DETAILS
                  Row(
                    children: [
                      _pill(
                        text: '$totalPoints Points',
                        bgColor: const Color(0xFFFFC4C4),
                        textColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      _pill(
                        text: '$earnedPoints Earned',
                        bgColor: const Color(0xFFB2EBF2),
                        textColor: Colors.white,
                      ),
                      //const Spacer(),
                      const SizedBox(width: 8),
                      _detailsPill(
                        enabled: isAttempted,
                        onTap: () {
                          if (locked || expired) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Quiz is locked.")),
                            );
                            return;
                          }

                          // If already completed — show details screen
                          if (completed && attemptId != null) {
                            context.pushNamed(
                              'studentQuizDetails',
                              extra: {
                                'courseId': courseId,
                                'quizId': quizId,
                                'title': title,
                                'questions': questions,
                                'attemptId': attemptId,
                              },
                            );
                            return;
                          }

                          // If not completed — go to quiz instruction
                          context.pushNamed(
                            'studentQuizInstruction',
                            extra: {
                              'courseId': courseId,
                              'quizId': quizId,
                              'title': title,
                              'durationSeconds': durationSeconds,
                              'questions': questions,
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      if (isAttempted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.chip2,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            "Completed",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // LOCK OVERLAY FOR LOCKED QUIZZES
            if (locked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Icon(
                        //   CupertinoIcons.lock_fill,
                        //   color: Colors.white,
                        //   size: 26,
                        // ),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: Lottie.asset(
                            'assets/animations/blocked.json',
                            repeat: true,
                            animate: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                        //const SizedBox(height: 6),
                        // Text(
                        //   _durationLabel,
                        //   textAlign: TextAlign.center,
                        //   style: const TextStyle(
                        //     fontFamily: AppTypography.family,
                        //     color: Colors.white,
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        // ATTACHED DURATION "TAIL" UNDER CARD
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 28,
                width: 28,
                child: Lottie.asset(
                  'assets/icons/quiz_time.json',
                  repeat: true,
                  animate: true,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _durationLabel,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  // Colored tag pills (Points / Earned)
  Widget _pill({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.family,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // Details pill (right side)
  Widget _detailsPill({
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final bg = enabled ? const Color(0xFFCDEB87) : Colors.grey.shade300;
    final textColor = enabled ? Colors.white : Colors.black45;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'Details',
          style: TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
