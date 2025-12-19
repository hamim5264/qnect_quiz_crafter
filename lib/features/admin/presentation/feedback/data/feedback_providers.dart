import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

final feedbackRoleProvider = FutureProvider<String>((ref) async {
  final user = _auth.currentUser;

  if (user == null) {
    debugPrint('👤 Role: guest');
    return 'guest';
  }

  try {
    final snap = await _db.collection('users').doc(user.uid).get();
    final role = snap.data()?['role']?.toString().toLowerCase() ?? 'student';

    debugPrint('👤 Role loaded: $role');
    return role;
  } catch (e) {
    debugPrint('🔴 Role fetch error: $e');
    return 'student';
  }
});

final allFeedbackProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return _db
      .collection('feedback')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) {
        debugPrint('🟢 Feedback snapshot → ${snap.docs.length} docs');

        return snap.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      })
      .handleError((e) {
        debugPrint('🔴 Feedback stream error: $e');
      });
});

final allFeedbackCountProvider = StreamProvider<int>((ref) {
  return _db.collection('feedback').snapshots().map((snap) {
    debugPrint('🔢 Feedback count → ${snap.docs.length}');
    return snap.docs.length;
  });
});

final courseFeedbackProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, courseId) {
      return _db
          .collection('feedback')
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snap) {
            debugPrint('📘 Course($courseId) feedback → ${snap.docs.length}');

            return snap.docs.map((doc) {
              final data = doc.data();
              return {...data, 'id': doc.id};
            }).toList();
          })
          .handleError((e) {
            debugPrint('🔴 Course feedback error ($courseId): $e');
          });
    });

final feedbackCountProvider = StreamProvider.family<int, String>((
  ref,
  courseId,
) {
  return _db
      .collection('feedback')
      .where('courseId', isEqualTo: courseId)
      .snapshots()
      .map((snap) => snap.docs.length);
});

final hasReviewedProvider = FutureProvider.family<bool, String>((
  ref,
  courseId,
) async {
  final user = _auth.currentUser;
  if (user == null) return false;

  try {
    final snap =
        await _db
            .collection('feedback')
            .where('courseId', isEqualTo: courseId)
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

    final reviewed = snap.docs.isNotEmpty;
    debugPrint('📝 hasReviewed($courseId) → $reviewed');
    return reviewed;
  } catch (e) {
    debugPrint('🔴 hasReviewed error: $e');
    return false;
  }
});
