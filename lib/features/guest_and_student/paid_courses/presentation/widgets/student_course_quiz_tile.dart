import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentCourseQuizTile extends StatelessWidget {
  final String courseId;
  final String quizId;
  final String title;
  final String description;
  final int totalPoints; // total questions
  final int earnedPoints; // current earned points
  final bool locked;
  final bool expired;
  final bool completed;
  final DateTime startDate;
  final DateTime endDate;

  const StudentCourseQuizTile({
    super.key,
    required this.courseId,
    required this.quizId,
    required this.title,
    required this.description,
    required this.totalPoints,
    required this.earnedPoints,
    required this.locked,
    required this.expired,
    required this.completed,
    required this.startDate,
    required this.endDate,
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
    final bool disabled = locked || expired;

    return Column(
      children: [
        // MAIN CARD + LOCK OVERLAY
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                          color: AppColors.secondaryDark,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          CupertinoIcons.doc_text_fill,
                          color: Colors.white,
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
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        size: 18,
                        color: Colors.black45,
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
                        textColor: Colors.black87,
                      ),
                      const SizedBox(width: 8),
                      _pill(
                        text: '$earnedPoints Earned',
                        bgColor: const Color(0xFFB2EBF2),
                        textColor: Colors.black87,
                      ),
                      const Spacer(),
                      _detailsPill(
                        enabled: !disabled && completed,
                        onTap: () {
                          if (!disabled && completed) {
                            // TODO: navigate to quiz result / details
                          }
                        },
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
                        const Icon(
                          CupertinoIcons.lock_fill,
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _durationLabel,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
    final textColor = enabled ? Colors.black : Colors.black45;

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
