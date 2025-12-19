import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentMyCourseCard extends StatelessWidget {
  final String courseId;
  final Map<String, dynamic> course;
  final double progress;
  final int completedQuizzes;
  final int totalQuizzes;

  const StudentMyCourseCard({
    super.key,
    required this.courseId,
    required this.course,
    required this.progress,
    required this.completedQuizzes,
    required this.totalQuizzes,
  });

  @override
  Widget build(BuildContext context) {
    final title = (course['title'] ?? 'Untitled Course') as String;
    final description = (course['description'] ?? '') as String;
    final iconPath = (course['iconPath'] ?? '') as String;
    final group = (course['group'] ?? '') as String;
    final level = (course['level'] ?? '') as String;

    final percent = (progress * 100).round();

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'studentCourseDetails',
          pathParameters: {'courseId': courseId},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.white.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:
                    iconPath.isNotEmpty
                        ? Image.asset(iconPath, fit: BoxFit.contain)
                        : const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
              ),
            ),
            const SizedBox(width: 14),

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
                      fontSize: 16,
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
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _pill(group, AppColors.chip2),
                      const SizedBox(width: 8),
                      _pill(level, AppColors.chip3),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey.shade300,
                                minHeight: 8,
                                color: AppColors.secondaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$completedQuizzes of $totalQuizzes quizzes completed',
                        style: const TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text, Color bg) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTypography.family,
          color: Colors.black,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
