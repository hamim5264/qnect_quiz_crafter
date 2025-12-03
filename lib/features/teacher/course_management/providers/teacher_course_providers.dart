import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_providers.dart';
import '../models/teacher_course_model.dart';
import '../repositories/teacher_course_repository.dart';

final teacherCourseRepositoryProvider = Provider<TeacherCourseRepository>((
  ref,
) {
  return TeacherCourseRepository();
});

final teacherCoursesStreamProvider =
    StreamProvider.autoDispose<List<TeacherCourseModel>>((ref) {
      final repo = ref.read(teacherCourseRepositoryProvider);
      final user = ref.watch(firebaseAuthProvider).currentUser;

      if (user == null) {
        return Stream<List<TeacherCourseModel>>.value([]);
      }

      return repo.streamTeacherCourses(user.uid);
    });

final courseByIdProvider = StreamProvider.family
    .autoDispose<TeacherCourseModel?, String>((ref, courseId) {
      final repo = ref.read(teacherCourseRepositoryProvider);
      return repo.streamCourseById(courseId);
    });

final courseQuizzesProvider = StreamProvider.family
    .autoDispose<List<Map<String, dynamic>>, String>((ref, courseId) {
      final repo = ref.read(teacherCourseRepositoryProvider);
      return repo.streamQuizzes(courseId);
    });

final publishCourseProvider = FutureProvider.family.autoDispose<void, String>((
  ref,
  courseId,
) async {
  final repo = ref.read(teacherCourseRepositoryProvider);
  await repo.requestPublish(courseId);
});

final deleteCourseProvider = FutureProvider.family.autoDispose<void, String>((
  ref,
  courseId,
) async {
  final repo = ref.read(teacherCourseRepositoryProvider);
  await repo.deleteCourse(courseId);
});

final updateCourseFieldsProvider = FutureProvider.family
    .autoDispose<void, Map<String, dynamic>>((ref, data) async {
      final repo = ref.read(teacherCourseRepositoryProvider);

      final courseId = data["courseId"];
      final fields = data["fields"];

      await repo.updateCourseFields(courseId, fields);
    });
