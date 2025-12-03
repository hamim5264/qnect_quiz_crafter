// lib/features/teacher/course_management/presentation/course_details/teacher_course_details_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../ui/design_system/tokens/typography.dart';

import '../../../../../common/widgets/utils/icon_mapper.dart';
import '../../../course_management/providers/teacher_course_providers.dart';
import '../../models/teacher_course_model.dart';

import 'widgets/course_header_card.dart';
import 'widgets/quiz_list_item.dart';

class TeacherCourseDetailsScreen extends ConsumerWidget {
  final TeacherCourseModel course;

  const TeacherCourseDetailsScreen({
    super.key,
    required this.course,
  });

  // ---------------------------------------------------------------------------
  // DELETE CONFIRMATION DIALOG
  // ---------------------------------------------------------------------------
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Course",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this course?\n"
                "This action cannot be undone.",
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.pop(context);

                // 🔥 Delete the course
                await ref.read(deleteCourseProvider(course.id).future);

                // Pop screen after delete
                if (context.mounted) {
                  context.pop();
                }
              },
            ),
          ],
        );
      },
    );
  }


  double _calculateQuizProgress(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();

    if (now.isBefore(startDate)) return 0;
    if (now.isAfter(endDate)) return 100;

    final total = endDate.difference(startDate).inSeconds;
    final passed = now.difference(startDate).inSeconds;

    return (passed / total * 100).clamp(0, 100);
  }


  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizStream = ref.watch(courseQuizzesProvider(course.id));

    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: const CommonRoundedAppBar(title: "Course Details"),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -------------------------------------------------------------------
            // COURSE DETAILS HEADER
            // -------------------------------------------------------------------
            CourseDetailsHeader(
              course: course,
              onEdit: () => context.pushNamed(
                "teacherEditCourse",
                extra: course,
              ),
              onDelete: () => _confirmDelete(context, ref),
            ),

            const SizedBox(height: 48),

            // -------------------------------------------------------------------
            // QUIZ LIST
            // -------------------------------------------------------------------
            quizStream.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (e, _) => Text(
                "Error: $e",
                style: const TextStyle(color: Colors.white),
              ),
              data: (quizzes) {
                if (quizzes.isEmpty) {
                  return Column(
                    children: const [
                      Icon(Icons.menu_book_outlined,
                          size: 80, color: Colors.white70),
                      SizedBox(height: 8),
                      Text(
                        "No quizzes added yet",
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: AppTypography.family,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: quizzes.map((q) {
                    final repo = ref.read(teacherCourseRepositoryProvider);

                    return QuizListItem(
                      title: q["title"] ?? "Untitled Quiz",
                      subtitle: q["subtitle"] ?? "",

                      progress: _calculateQuizProgress(
                        DateTime.tryParse(q["startDate"] ?? "") ?? DateTime.now(),
                        DateTime.tryParse(q["endDate"] ?? "") ?? DateTime.now(),
                      ),

                      icon: IconData(
                        q["icon"] ?? Icons.menu_book_rounded.codePoint,
                        fontFamily: 'MaterialIcons',
                      ),

                      attempts: q["attemptCount"] ?? 0,
                      totalStudents: course.enrolledCount,   // ⭐ use existing field

                      onDelete: () async {
                        await repo.deleteQuiz(course.id, q["id"]);
                      },
                    );




                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
