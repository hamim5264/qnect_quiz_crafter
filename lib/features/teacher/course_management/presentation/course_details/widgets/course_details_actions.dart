import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/teacher_course_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/teacher_course_providers.dart';

class CourseDetailsActions extends ConsumerWidget {
  final TeacherCourseModel course;

  const CourseDetailsActions({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (course.status == CourseStatus.rejected)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.green),
            onPressed: () {
              context.pushNamed("teacherEditCourse", extra: course);
            },
          ),

        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await ref.read(deleteCourseProvider(course.id).future);
            context.pop();
          },
        ),
      ],
    );
  }
}
