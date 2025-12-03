import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseRepository {
  final FirebaseFirestore _db;

  CourseRepository(this._db);

  CollectionReference get _courses => _db.collection('courses');

  Stream<List<CourseModel>> watchTeacherCourses(String teacherId) {
    return _courses
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CourseModel.fromDoc(d)).toList());
  }

  Future<CourseModel> getCourseById(String id) async {
    final doc = await _courses.doc(id).get();
    return CourseModel.fromDoc(doc);
  }

  Future<String> createCourse(CourseModel course) async {
    final now = DateTime.now();
    final docRef = await _courses.add(
      course
          .copyWith(
            status: CourseStatus.draft,
            quizzesCount: 0,
            enrolledCount: 0,
            soldCount: 0,
            totalDurationSeconds: 0,
            createdAt: now,
            updatedAt: now,
          )
          .toJson(),
    );
    return docRef.id;
  }

  Future<void> updateCourse(CourseModel course) async {
    await _courses
        .doc(course.id)
        .update(course.copyWith(updatedAt: DateTime.now()).toJson());
  }

  Future<void> deleteCourse(String id) async {
    await _courses.doc(id).delete();
  }

  Future<void> updateCourseStatus({
    required String courseId,
    required CourseStatus status,
    String? rejectionReason,
  }) async {
    await _courses.doc(courseId).update({
      'status': status.name,
      'rejectionReason': rejectionReason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> incrementQuizStats({
    required String courseId,
    required int quizDurationSecondsDelta,
  }) async {
    await _courses.doc(courseId).update({
      'quizzesCount': FieldValue.increment(1),
      'totalDurationSeconds': FieldValue.increment(quizDurationSecondsDelta),
    });
  }
}
