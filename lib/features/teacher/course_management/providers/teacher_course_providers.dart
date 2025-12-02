import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_providers.dart';
import '../models/teacher_course_model.dart';
import '../repositories/teacher_course_repository.dart';

/// ------------------------------------------------------------
///  REPOSITORY PROVIDER
/// ------------------------------------------------------------
final teacherCourseRepositoryProvider =
Provider<TeacherCourseRepository>((ref) {
  return TeacherCourseRepository();
});

/// ------------------------------------------------------------
///  STREAM: Teacher Courses (My Courses screen)
/// ------------------------------------------------------------
final teacherCoursesStreamProvider =
StreamProvider.autoDispose<List<TeacherCourseModel>>((ref) {
  final repo = ref.read(teacherCourseRepositoryProvider);
  final user = ref.watch(firebaseAuthProvider).currentUser;

  if (user == null) {
    // ❗ FIX: typed empty stream
    return Stream<List<TeacherCourseModel>>.value([]);
  }

  return repo.streamTeacherCourses(user.uid);
});

/// ------------------------------------------------------------
/// STREAM: Single Course by ID
/// ------------------------------------------------------------
final courseByIdProvider =
StreamProvider.family.autoDispose<TeacherCourseModel?, String>(
        (ref, courseId) {
      final repo = ref.read(teacherCourseRepositoryProvider);
      return repo.streamCourseById(courseId);
    });

/// ------------------------------------------------------------
/// STREAM: Quizzes under a Course
/// ------------------------------------------------------------
final courseQuizzesProvider =
StreamProvider.family.autoDispose<List<Map<String, dynamic>>, String>(
        (ref, courseId) {
      final repo = ref.read(teacherCourseRepositoryProvider);
      return repo.streamQuizzes(courseId);
    });

/// ------------------------------------------------------------
/// ACTION: Request course publish
/// ------------------------------------------------------------
final publishCourseProvider =
FutureProvider.family.autoDispose<void, String>((ref, courseId) async {
  final repo = ref.read(teacherCourseRepositoryProvider);
  await repo.requestPublish(courseId);
});

/// ------------------------------------------------------------
/// ACTION: Delete course
/// ------------------------------------------------------------
final deleteCourseProvider =
FutureProvider.family.autoDispose<void, String>((ref, courseId) async {
  final repo = ref.read(teacherCourseRepositoryProvider);
  await repo.deleteCourse(courseId);
});

/// ------------------------------------------------------------
/// ACTION: Update course fields
/// ------------------------------------------------------------
final updateCourseFieldsProvider = FutureProvider.family
    .autoDispose<void, Map<String, dynamic>>((ref, data) async {
  final repo = ref.read(teacherCourseRepositoryProvider);

  final courseId = data["courseId"];
  final fields = data["fields"];

  await repo.updateCourseFields(courseId, fields);
});
