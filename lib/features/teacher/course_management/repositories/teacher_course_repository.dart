// // lib/features/teacher/course_management/repositories/teacher_course_repository.dart
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/teacher_course_model.dart';
//
// class TeacherCourseRepository {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // STREAM: Teacher Courses
//   Stream<List<TeacherCourseModel>> streamTeacherCourses(String teacherId) {
//     return _db
//         .collection('courses')
//         .where('teacherId', isEqualTo: teacherId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map((s) => s.docs.map((d) => TeacherCourseModel.fromDoc(d)).toList());
//   }
//
//   // STREAM: Single Course
//   Stream<TeacherCourseModel?> streamCourseById(String courseId) {
//     return _db
//         .collection('courses')
//         .doc(courseId)
//         .snapshots()
//         .map((doc) => doc.exists ? TeacherCourseModel.fromDoc(doc) : null);
//   }
//
//   // CREATE COURSE
//   Future<String> createCourse(TeacherCourseModel model) async {
//     final doc = _db.collection('courses').doc();
//     await doc.set({
//       ...model.toJson(),
//       'courseId': doc.id,
//     });
//     return doc.id;
//   }
//
//   // UPDATE
//   Future<void> updateCourseFields(
//       String courseId, Map<String, dynamic> data) async {
//     await _db.collection('courses').doc(courseId).update(data);
//   }
//
//   // REQUEST PUBLISH
//   Future<void> requestPublish(String courseId) async {
//     await _db.collection('courses').doc(courseId).update({
//       'status': 'pending',
//       'updatedAt': DateTime.now().toIso8601String(),
//     });
//   }
//
//   // DELETE
//   Future<void> deleteCourse(String courseId) async {
//     await _db.collection('courses').doc(courseId).delete();
//   }
//
//   // STREAM QUIZZES
//   Stream<List<Map<String, dynamic>>> streamQuizzes(String courseId) {
//     return _db
//         .collection('courses')
//         .doc(courseId)
//         .collection('quizzes')
//         .snapshots()
//         .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
//   }
//
//
//   Future<void> addQuiz(String courseId, Map<String, dynamic> quizData) async {
//     final col = _db
//         .collection('courses')
//         .doc(courseId)
//         .collection('quizzes');
//
//     final doc = col.doc();
//     await doc.set({
//       "id": doc.id,
//       ...quizData,
//     });
//   }
//
//   Future<void> deleteQuiz(String courseId, String quizId) async {
//     await _db
//         .collection('courses')
//         .doc(courseId)
//         .collection('quizzes')
//         .doc(quizId)
//         .delete();
//   }
//
//   Future<void> updateQuiz(String courseId, String quizId, Map<String, dynamic> data) async {
//     await _db
//         .collection("courses")
//         .doc(courseId)
//         .collection("quizzes")
//         .doc(quizId)
//         .update(data);
//   }
//
//   Future<void> deleteCourseWithQuizzes(String courseId) async {
//     final batch = _db.batch();
//
//     final quizCol = _db.collection('courses').doc(courseId).collection('quizzes');
//     final quizzes = await quizCol.get();
//
//     // Delete quizzes
//     for (var doc in quizzes.docs) {
//       batch.delete(doc.reference);
//     }
//
//     // Delete course
//     batch.delete(_db.collection('courses').doc(courseId));
//
//     await batch.commit();
//   }
//
//
//
//
//
// }


// lib/features/teacher/course_management/repositories/teacher_course_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher_course_model.dart';

class TeacherCourseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ============================================================================
  // STREAM: TEACHER COURSES
  // ============================================================================
  Stream<List<TeacherCourseModel>> streamTeacherCourses(String teacherId) {
    return _db
        .collection('courses')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => TeacherCourseModel.fromDoc(d)).toList());
  }

  // ============================================================================
  // STREAM: SINGLE COURSE
  // ============================================================================
  Stream<TeacherCourseModel?> streamCourseById(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.exists ? TeacherCourseModel.fromDoc(doc) : null);
  }

  // ============================================================================
  // CREATE COURSE
  // ============================================================================
  Future<String> createCourse(TeacherCourseModel model) async {
    final doc = _db.collection('courses').doc();

    await doc.set({
      ...model.toJson(),
      'id': doc.id,
      'courseId': doc.id, // keep your old field
      'quizCount': 0,
      'enrolledCount': 0,
      'status': 'draft',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    return doc.id;
  }

  // ============================================================================
  // UPDATE COURSE FIELDS
  // ============================================================================
  Future<void> updateCourseFields(String courseId, Map<String, dynamic> data) async {
    await _db.collection('courses').doc(courseId).update(data);
  }

  // ============================================================================
  // TEACHER — REQUEST PUBLISH
  // (But will validate in provider)
  // ============================================================================
  Future<void> requestPublish(String courseId) async {
    await _db.collection('courses').doc(courseId).update({
      'status': 'pending',
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // ============================================================================
  // DELETE ONLY COURSE
  // ============================================================================
  Future<void> deleteCourse(String courseId) async {
    await _db.collection('courses').doc(courseId).delete();
  }

  // ============================================================================
  // STREAM QUIZZES
  // ============================================================================
  Stream<List<Map<String, dynamic>>> streamQuizzes(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .collection('quizzes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {
      'id': d.id,
      ...d.data(),
    }).toList());
  }

  // ============================================================================
  // ADD QUIZ
  // ============================================================================
  Future<void> addQuiz(String courseId, Map<String, dynamic> quizData) async {
    final col = _db.collection('courses').doc(courseId).collection('quizzes');
    final doc = col.doc();

    await doc.set({
      "id": doc.id,
      "createdAt": DateTime.now().toIso8601String(),
      ...quizData,
    });

    // increment quiz count
    await _db.collection('courses').doc(courseId).update({
      'quizCount': FieldValue.increment(1),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // ============================================================================
  // UPDATE QUIZ
  // ============================================================================
  Future<void> updateQuiz(String courseId, String quizId, Map<String, dynamic> data) async {
    await _db
        .collection("courses")
        .doc(courseId)
        .collection("quizzes")
        .doc(quizId)
        .update(data);
  }

  // ============================================================================
  // DELETE QUIZ (1)
  // ============================================================================
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

  // ============================================================================
  // DELETE COURSE + QUIZZES (Batch)
  // ============================================================================
  Future<void> deleteCourseWithQuizzes(String courseId) async {
    final batch = _db.batch();
    final courseRef = _db.collection('courses').doc(courseId);

    // delete quizzes
    final quizzes = await courseRef.collection('quizzes').get();
    for (var q in quizzes.docs) {
      batch.delete(q.reference);
    }

    // delete enrollments (if any)
    final enrollments = await courseRef.collection('enrollments').get();
    for (var e in enrollments.docs) {
      batch.delete(e.reference);
    }

    // delete course
    batch.delete(courseRef);

    await batch.commit();
  }

  // ============================================================================
  // ADMIN: UPDATE COURSE STATUS
  // ============================================================================
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

  // ============================================================================
  // NOTIFICATION SEND (Reusable)
  // ============================================================================
  Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String message,
    required String type, // "course_publish", "approved", "rejected"
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
