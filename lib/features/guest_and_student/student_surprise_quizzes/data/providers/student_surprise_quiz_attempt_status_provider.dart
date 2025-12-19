import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final surpriseQuizAttemptedProvider = FutureProvider.family<bool, String>((
  ref,
  quizId,
) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return false;

  final doc =
      await FirebaseFirestore.instance
          .collection('surpriseQuizzes')
          .doc(quizId)
          .collection('attempts')
          .doc(uid)
          .get();

  return doc.exists;
});
