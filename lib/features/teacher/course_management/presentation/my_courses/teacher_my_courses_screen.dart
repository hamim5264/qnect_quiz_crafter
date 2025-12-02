import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../../common/widgets/app_loader.dart';

// App bar
import '../../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

// Providers
import '../../../course_management/providers/teacher_course_providers.dart';

// UI widgets
import 'widgets/teacher_course_card.dart';

class TeacherMyCoursesScreen extends ConsumerWidget {
  const TeacherMyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ⭐ DIRECTLY WATCH teacher’s course stream
    final data = ref.watch(teacherCoursesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,

      appBar: const CommonRoundedAppBar(
        title: "My Courses",
      ),

      body: data.when(
        loading: () => const Center(child: AppLoader()),
        error: (e, _) => Center(
          child: Text(
            "Error loading courses: $e",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (courses) {
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 96,
                    color: Colors.white.withOpacity(0.40),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No courses added yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the + button below to create your first course.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (_, i) => TeacherCourseCard(course: courses[i]),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryDark,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          context.pushNamed("teacherAddCourse");
        },
      ),
    );
  }
}
