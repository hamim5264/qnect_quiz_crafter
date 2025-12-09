import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final unreadNotificationCountProvider = StreamProvider.family<int, String>((ref, roleOrUid) {
  final String docId = (roleOrUid == "admin") ? "admin-panel" : roleOrUid;

  return FirebaseFirestore.instance
      .collection("notifications")
      .doc(docId)
      .collection("items")
      .where("isRead", isEqualTo: false)
      .snapshots()
      .map((snap) => snap.docs.length);
});
