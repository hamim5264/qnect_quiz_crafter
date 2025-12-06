import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherStats {
  final int totalLikes;
  final int totalEnrollment;
  final int totalCourses;
  final int totalQuizzes;

  const TeacherStats({
    required this.totalLikes,
    required this.totalEnrollment,
    required this.totalCourses,
    required this.totalQuizzes,
  });
}

final teacherStatsProvider = FutureProvider<TeacherStats>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const TeacherStats(
      totalLikes: 0,
      totalEnrollment: 0,
      totalCourses: 0,
      totalQuizzes: 0,
    );
  }

  final snap =
      await FirebaseFirestore.instance
          .collection("courses")
          .where("teacherId", isEqualTo: user.uid)
          .get();

  int totalEnrollment = 0;
  int totalQuizzes = 0;

  for (var doc in snap.docs) {
    final data = doc.data();

    totalEnrollment += (data["sold"] ?? 0) as int;
    totalQuizzes += (data["quizCount"] ?? 0) as int;
  }

  return TeacherStats(
    totalLikes: 0,
    totalEnrollment: totalEnrollment,
    totalCourses: snap.docs.length,
    totalQuizzes: totalQuizzes,
  );
});
