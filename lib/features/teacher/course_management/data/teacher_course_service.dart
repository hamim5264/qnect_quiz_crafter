import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_providers.dart';
import '../repositories/teacher_course_repository.dart';
import '../models/teacher_course_model.dart';

class TeacherCourseService {
  final TeacherCourseRepository repo;
  final Ref ref;

  TeacherCourseService(this.repo, this.ref);

  String get teacherId => ref.read(firebaseAuthProvider).currentUser!.uid;

  Stream<List<TeacherCourseModel>> watchMyCourses() {
    return repo.streamTeacherCourses(teacherId);
  }

  Stream<TeacherCourseModel?> watchCourse(String courseId) {
    return repo.streamCourseById(courseId);
  }

  Future<void> deleteCourse(String courseId) async {
    await repo.deleteCourse(courseId);
  }

  Future<void> requestPublish(String courseId) async {
    await repo.requestPublish(courseId);
  }

  Future<void> updateCourseFields(
    String courseId,
    Map<String, dynamic> data,
  ) async {
    await repo.updateCourseFields(courseId, data);
  }

  Stream<List<Map<String, dynamic>>> watchQuizzes(String courseId) {
    return repo.streamQuizzes(courseId);
  }
}
