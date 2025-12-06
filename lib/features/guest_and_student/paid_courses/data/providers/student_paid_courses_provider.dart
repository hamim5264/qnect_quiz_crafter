import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final studentPaidCoursesProvider = StreamProvider.autoDispose((ref) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("courses")
      .where("status", isEqualTo: "approved")
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((doc) => {...doc.data(), "id": doc.id}).toList(),
      );
});
