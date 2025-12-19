import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentSurpriseQuizListProvider =
    StreamProvider<List<QueryDocumentSnapshot>>((ref) {
      return FirebaseFirestore.instance
          .collection('surpriseQuizzes')
          .where('published', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .snapshots()
          .map((snap) => snap.docs);
    });
