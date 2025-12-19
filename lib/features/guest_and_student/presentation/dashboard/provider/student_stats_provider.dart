import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentStatsProvider = FutureProvider.family<StudentStats, String>((
  ref,
  uid,
) async {
  final db = FirebaseFirestore.instance;

  int totalCourses = 0;
  int totalQuizzes = 0;
  int totalPoints = 0;

  final courseSnap =
      await db.collection("users").doc(uid).collection("myCourses").get();
  totalCourses = courseSnap.docs.length;

  for (var doc in courseSnap.docs) {
    final data = doc.data();
    data.forEach((key, value) {
      if (key.startsWith("earnedPoints_") && value is int) {
        totalQuizzes++;
        totalPoints += value;
      }
    });
  }

  int yourRank = 0;
  List<int> allUserPoints = [];

  final allUsers = await db.collection("users").get();
  for (var userDoc in allUsers.docs) {
    int userPoints = 0;

    final userCourseSnap =
        await db
            .collection("users")
            .doc(userDoc.id)
            .collection("myCourses")
            .get();

    for (var c in userCourseSnap.docs) {
      final data = c.data();
      data.forEach((key, value) {
        if (key.startsWith("earnedPoints_") && value is int) {
          userPoints += value;
        }
      });
    }

    allUserPoints.add(userPoints);
  }

  allUserPoints.sort((a, b) => b.compareTo(a));

  yourRank = allUserPoints.indexOf(totalPoints) + 1;

  int last7daysPoints = 0;
  final now = DateTime.now();

  for (var doc in courseSnap.docs) {
    final data = doc.data();
    data.forEach((key, value) {
      if (key.startsWith("earnedPoints_") && value is int) {
        final timestamp = data["timestamp_$key"];
        if (timestamp is Timestamp) {
          final quizDate = timestamp.toDate();
          if (quizDate.isAfter(now.subtract(const Duration(days: 7)))) {
            last7daysPoints += value;
          }
        }
      }
    });
  }

  double weeklyGrowth = 0;
  if (totalPoints > 0) {
    weeklyGrowth = (last7daysPoints / totalPoints) * 100;
  }

  return StudentStats(
    totalCourses: totalCourses,
    totalQuizzes: totalQuizzes,
    totalPoints: totalPoints,
    rank: yourRank,
    weeklyGrowth: weeklyGrowth,
  );
});

class StudentStats {
  final int totalCourses;
  final int totalQuizzes;
  final int totalPoints;
  final int rank;
  final double weeklyGrowth;

  StudentStats({
    required this.totalCourses,
    required this.totalQuizzes,
    required this.totalPoints,
    required this.rank,
    required this.weeklyGrowth,
  });
}
