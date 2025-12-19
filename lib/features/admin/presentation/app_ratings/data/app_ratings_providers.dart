import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

final ratingsRoleProvider = FutureProvider<String>((ref) async {
  final user = _auth.currentUser;
  if (user == null) return 'guest';

  try {
    final snap = await _db.collection('users').doc(user.uid).get();
    return snap.data()?['role']?.toString().toLowerCase() ?? 'student';
  } catch (e) {
    debugPrint('🔴 ratingsRoleProvider error: $e');
    return 'student';
  }
});

final appRatingsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return _db
      .collection('app_ratings')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) {
        return snap.docs.map((doc) {
          final data = doc.data();
          return {...data, 'id': doc.id};
        }).toList();
      });
});

final appRatingsSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final async = ref.watch(appRatingsProvider);

  return async.maybeWhen(
    data: (list) {
      if (list.isEmpty) {
        return {
          'total': 0,
          'performanceAvg': 0.0,
          'privacyAvg': 0.0,
          'experienceAvg': 0.0,
        };
      }

      double avgOf(String key) {
        final sum = list.fold<int>(0, (s, r) => s + ((r[key] ?? 0) as int));
        return sum / list.length;
      }

      return {
        'total': list.length,
        'performanceAvg': avgOf('performance'),
        'privacyAvg': avgOf('privacy'),
        'experienceAvg': avgOf('experience'),
      };
    },
    orElse:
        () => {
          'total': 0,
          'performanceAvg': 0.0,
          'privacyAvg': 0.0,
          'experienceAvg': 0.0,
        },
  );
});
