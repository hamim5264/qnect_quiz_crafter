import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher_course_model.dart';

class TeacherCourseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<TeacherCourseModel>> streamTeacherCourses(String teacherId) {
    return _db
        .collection('courses')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => TeacherCourseModel.fromDoc(d)).toList(),
        );
  }

  Stream<TeacherCourseModel?> streamCourseById(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.exists ? TeacherCourseModel.fromDoc(doc) : null);
  }

  Future<String> createCourse(TeacherCourseModel model) async {
    final doc = _db.collection('courses').doc();

    await doc.set({
      ...model.toJson(),
      'id': doc.id,
      'courseId': doc.id,
      'quizCount': 0,
      'enrolledCount': 0,
      'status': 'draft',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return doc.id;
  }

  Future<void> updateCourseFields(
    String courseId,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('courses').doc(courseId).update(data);
  }

  Future<void> requestPublish(String courseId) async {
    await _db.collection('courses').doc(courseId).update({
      'status': 'pending',
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteCourse(String courseId) async {
    await _db.collection('courses').doc(courseId).delete();
  }

  Stream<List<Map<String, dynamic>>> streamQuizzes(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .collection('quizzes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<void> addQuiz(String courseId, Map<String, dynamic> quizData) async {
    final col = _db.collection('courses').doc(courseId).collection('quizzes');
    final doc = col.doc();

    await doc.set({
      "id": doc.id,
      "createdAt": DateTime.now().toIso8601String(),
      ...quizData,
    });

    await _db.collection('courses').doc(courseId).update({
      'quizCount': FieldValue.increment(1),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateQuiz(
    String courseId,
    String quizId,
    Map<String, dynamic> data,
  ) async {
    await _db
        .collection("courses")
        .doc(courseId)
        .collection("quizzes")
        .doc(quizId)
        .update(data);
  }

  Future<void> deleteQuiz(String courseId, String quizId) async {
    await _db
        .collection('courses')
        .doc(courseId)
        .collection('quizzes')
        .doc(quizId)
        .delete();

    await _db.collection('courses').doc(courseId).update({
      'quizCount': FieldValue.increment(-1),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteCourseWithQuizzes(String courseId) async {
    final batch = _db.batch();
    final courseRef = _db.collection('courses').doc(courseId);

    final quizzes = await courseRef.collection('quizzes').get();
    for (var q in quizzes.docs) {
      batch.delete(q.reference);
    }

    final enrollments = await courseRef.collection('enrollments').get();
    for (var e in enrollments.docs) {
      batch.delete(e.reference);
    }

    batch.delete(courseRef);

    await batch.commit();
  }

  Future<void> updateStatusAdmin({
    required String courseId,
    required String status,
    String? rejectionReason,
  }) async {
    await _db.collection('courses').doc(courseId).update({
      'status': status,
      'rejectionReason': rejectionReason,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String message,
    required String type,
  }) async {
    final doc = _db.collection("notifications").doc();

    await doc.set({
      'id': doc.id,
      'receiverId': receiverId,
      'title': title,
      'message': message,
      'type': type,
      'createdAt': DateTime.now().toIso8601String(),
      'seen': false,
    });
  }
}
