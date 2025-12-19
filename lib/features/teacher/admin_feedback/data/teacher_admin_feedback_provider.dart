import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

final teacherRejectedCoursesProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
      final uid = _auth.currentUser!.uid;

      return _db
          .collection('courses')
          .where('teacherId', isEqualTo: uid)
          .where('status', isEqualTo: 'Rejected')
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map(
            (snap) =>
                snap.docs.map((doc) {
                  final data = doc.data();
                  return {
                    'id': doc.id,
                    'title': data['title'],
                    'status': data['status'],
                    'remark': data['remark'],
                  };
                }).toList(),
          );
    });
