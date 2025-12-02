// lib/features/teacher/course_management/providers/teacher_course_form_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../auth/providers/auth_providers.dart';

// ⭐ Correct import (from same providers folder)
import 'teacher_course_providers.dart';

import '../controllers/teacher_course_form_controller.dart';
import '../controllers/teacher_course_form_state.dart';

final teacherCourseFormControllerProvider =
StateNotifierProvider.autoDispose<TeacherCourseFormController,
    TeacherCourseFormState>((ref) {

  // ⭐ Correct provider reference
  final repo = ref.read(teacherCourseRepositoryProvider);

  final auth = ref.read(firebaseAuthProvider);
  final teacherId = auth.currentUser!.uid;

  return TeacherCourseFormController(repo, teacherId);
});
