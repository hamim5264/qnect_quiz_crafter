// lib/features/teacher/course_management/data/teacher_course_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_providers.dart';
import '../repositories/teacher_course_repository.dart';
import '../models/teacher_course_model.dart';

class TeacherCourseService {
  final TeacherCourseRepository repo;
  final Ref ref;

  TeacherCourseService(this.repo, this.ref);

  String get teacherId => ref.read(firebaseAuthProvider).currentUser!.uid;

  // ----------------------------------------------------------
  // My Courses List Stream
  // ----------------------------------------------------------
  Stream<List<TeacherCourseModel>> watchMyCourses() {
    return repo.streamTeacherCourses(teacherId);
  }

  // ----------------------------------------------------------
  // Watch Single Course
  // ----------------------------------------------------------
  Stream<TeacherCourseModel?> watchCourse(String courseId) {
    return repo.streamCourseById(courseId);
  }

  // ----------------------------------------------------------
  // Delete Course
  // ----------------------------------------------------------
  Future<void> deleteCourse(String courseId) async {
    await repo.deleteCourse(courseId);
  }

  // ----------------------------------------------------------
  // Request Publish
  // ----------------------------------------------------------
  Future<void> requestPublish(String courseId) async {
    await repo.requestPublish(courseId);
  }

  // ----------------------------------------------------------
  // Update Course Fields
  // ----------------------------------------------------------
  Future<void> updateCourseFields(
      String courseId, Map<String, dynamic> data) async {
    await repo.updateCourseFields(courseId, data);
  }

  // ----------------------------------------------------------
  // Stream Quizzes under course
  // ----------------------------------------------------------
  Stream<List<Map<String, dynamic>>> watchQuizzes(String courseId) {
    return repo.streamQuizzes(courseId);
  }
}
