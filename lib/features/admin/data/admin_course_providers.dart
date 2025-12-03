import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminCourseProvider = StreamProvider.family((ref, String courseId) {
  return FirebaseFirestore.instance
      .collection('courses')
      .doc(courseId)
      .snapshots()
      .map((doc) => doc.data());
});

final adminCourseQuizzesProvider = StreamProvider.family((
  ref,
  String courseId,
) {
  return FirebaseFirestore.instance
      .collection('courses')
      .doc(courseId)
      .collection('quizzes')
      .snapshots()
      .map((snap) => snap.docs.map((d) => d.data()).toList());
});
