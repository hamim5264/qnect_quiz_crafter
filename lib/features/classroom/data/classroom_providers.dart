import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _db = FirebaseFirestore.instance;

final classroomRoleProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'student';

  final snap =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  final role = snap.data()?['role'];

  if (role == null) return 'student';

  return role.toString().trim().toLowerCase();
});

final classroomTeachersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final snap =
      await _db.collection('users').where('role', isEqualTo: 'teacher').get();

  return snap.docs.map((e) => e.data()).toList();
});

final classroomStudentsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final snap =
      await _db.collection('users').where('role', isEqualTo: 'student').get();

  return snap.docs.map((e) => e.data()).toList();
});

final classroomEnrolledCountProvider = FutureProvider<int>((ref) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final snap =
      await _db.collection('courses').where('teacherId', isEqualTo: uid).get();

  int total = 0;

  for (final doc in snap.docs) {
    total += (doc.data()['enrolledCount'] ?? 0) as int;
  }

  return total;
});

final classroomEnrolledStudentsProvider = FutureProvider<
  List<Map<String, dynamic>>
>((ref) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final courseSnap =
      await _db.collection('courses').where('teacherId', isEqualTo: uid).get();

  if (courseSnap.docs.isEmpty) return [];

  final teacherCourseIds = courseSnap.docs.map((e) => e.id).toSet();

  final studentsSnap =
      await _db.collection('users').where('role', isEqualTo: 'student').get();

  final List<Map<String, dynamic>> enrolledStudents = [];

  for (final student in studentsSnap.docs) {
    final myCoursesSnap = await student.reference.collection('myCourses').get();

    final isEnrolled = myCoursesSnap.docs.any(
      (c) => teacherCourseIds.contains(c.id),
    );

    if (isEnrolled) {
      enrolledStudents.add(student.data());
    }
  }

  return enrolledStudents;
});
