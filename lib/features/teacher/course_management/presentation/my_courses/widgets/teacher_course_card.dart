// lib/features/teacher/course_management/presentation/my_courses/widgets/teacher_course_card.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';
import '../../../models/teacher_course_model.dart';

class TeacherCourseCard extends StatelessWidget {
  final TeacherCourseModel course;

  const TeacherCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final statusColor = {
      CourseStatus.draft: Colors.orange,
      CourseStatus.pending: Colors.blue,
      CourseStatus.approved: Colors.green,
      CourseStatus.rejected: Colors.red,
    }[course.status]!;

    final remainingDays = course.endDate
        .difference(DateTime.now())
        .inDays
        .clamp(0, 999);

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'teacherCourseDetails',
          extra: course,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                course.iconPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${course.group} • ${course.level}',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Remaining days: $remainingDays',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    course.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${course.quizCount} Quizzes',
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
