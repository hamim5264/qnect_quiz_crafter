import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, roleOrUid) {
      final String docId = (roleOrUid == "admin") ? "admin-panel" : roleOrUid;

      return FirebaseFirestore.instance
          .collection("notifications")
          .doc(docId)
          .collection("items")
          .orderBy("timestamp", descending: true)
          .snapshots()
          .map((snap) {
            return snap.docs.map((d) {
              return {"id": d.id, ...d.data()};
            }).toList();
          });
    });
