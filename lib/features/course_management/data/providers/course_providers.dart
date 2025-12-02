import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/course_repository.dart';
import '../repositories/quiz_repository.dart';
import '../models/course_model.dart';
import '../models/quiz_model.dart';

final firestoreProvider =
Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return CourseRepository(db);
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return QuizRepository(db);
});

// Stream of courses for a teacher (used in Teacher "My Courses")
final teacherCoursesStreamProvider =
StreamProvider.family<List<CourseModel>, String>((ref, teacherId) {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.watchTeacherCourses(teacherId);
});

// Stream of quizzes for a course (used in Teacher Course Details)
final courseQuizzesStreamProvider =
StreamProvider.family<List<QuizModel>, String>((ref, courseId) {
  final repo = ref.watch(quizRepositoryProvider);
  return repo.watchQuizzesForCourse(courseId);
});
