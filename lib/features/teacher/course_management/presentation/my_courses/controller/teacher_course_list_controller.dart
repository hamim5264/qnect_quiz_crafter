// lib/features/teacher/course_management/presentation/my_courses/controller/teacher_course_list_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/teacher_course_service.dart';

class TeacherCourseListController {
  final TeacherCourseService service;

  TeacherCourseListController(this.service);

  Future<void> deleteCourse(String courseId) async {
    await service.deleteCourse(courseId);
  }
}
