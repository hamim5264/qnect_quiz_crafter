import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminStatsProvider = FutureProvider<AdminStats>((ref) async {
  final firestore = FirebaseFirestore.instance;

  // Fetch Students
  final studentSnap =
  await firestore.collection('users').where('role', isEqualTo: 'student').get();
  final studentCount = studentSnap.docs.length;

  // Fetch Teachers
  final teacherSnap =
  await firestore.collection('users').where('role', isEqualTo: 'teacher').get();
  final teacherCount = teacherSnap.docs.length;

  // Fetch Blocked Users
  final blockedSnap = await firestore
      .collection('users')
      .where('accountStatus', isEqualTo: 'blocked')
      .get();
  final blockedCount = blockedSnap.docs.length;

  final total = studentCount + teacherCount + blockedCount;

  return AdminStats(
    totalUsers: total,
    students: studentCount,
    teachers: teacherCount,
    blocked: blockedCount,
  );
});

class AdminStats {
  final int totalUsers;
  final int students;
  final int teachers;
  final int blocked;

  AdminStats({
    required this.totalUsers,
    required this.students,
    required this.teachers,
    required this.blocked,
  });

  double get studentPercent =>
      totalUsers == 0 ? 0 : (students / totalUsers) * 100;

  double get teacherPercent =>
      totalUsers == 0 ? 0 : (teachers / totalUsers) * 100;

  double get blockedPercent =>
      totalUsers == 0 ? 0 : (blocked / totalUsers) * 100;
}
