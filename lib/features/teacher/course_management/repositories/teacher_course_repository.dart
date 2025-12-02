// lib/features/teacher/course_management/repositories/teacher_course_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher_course_model.dart';

class TeacherCourseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // STREAM: Teacher Courses
  Stream<List<TeacherCourseModel>> streamTeacherCourses(String teacherId) {
    return _db
        .collection('courses')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => TeacherCourseModel.fromDoc(d)).toList());
  }

  // STREAM: Single Course
  Stream<TeacherCourseModel?> streamCourseById(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.exists ? TeacherCourseModel.fromDoc(doc) : null);
  }

  // CREATE COURSE
  Future<String> createCourse(TeacherCourseModel model) async {
    final doc = _db.collection('courses').doc();
    await doc.set({
      ...model.toJson(),
      'courseId': doc.id,
    });
    return doc.id;
  }

  // UPDATE
  Future<void> updateCourseFields(
      String courseId, Map<String, dynamic> data) async {
    await _db.collection('courses').doc(courseId).update(data);
  }

  // REQUEST PUBLISH
  Future<void> requestPublish(String courseId) async {
    await _db.collection('courses').doc(courseId).update({
      'status': 'pending',
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // DELETE
  Future<void> deleteCourse(String courseId) async {
    await _db.collection('courses').doc(courseId).delete();
  }

  // STREAM QUIZZES
  Stream<List<Map<String, dynamic>>> streamQuizzes(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .collection('quizzes')
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }


  Future<void> addQuiz(String courseId, Map<String, dynamic> quizData) async {
    final col = _db
        .collection('courses')
        .doc(courseId)
        .collection('quizzes');

    final doc = col.doc();
    await doc.set({
      "id": doc.id,
      ...quizData,
    });
  }

  Future<void> deleteQuiz(String courseId, String quizId) async {
    await _db
        .collection('courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .delete();
  }


}
