import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeService {
  final _db = FirebaseFirestore.instance.collection('notices');

  Future<void> addNotice({
    required String title,
    required String description,
    required String audience,
  }) async {
    await _db.add({
      'title': title,
      'description': description,
      'audience': audience,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNotice(
    String id, {
    required String title,
    required String description,
    required String audience,
  }) async {
    await _db.doc(id).update({
      'title': title,
      'description': description,
      'audience': audience,
    });
  }

  Future<void> deleteNotice(String id) async {
    await _db.doc(id).delete();
  }

  Stream<QuerySnapshot> adminNotices() {
    return _db.orderBy('createdAt', descending: true).snapshots();
  }

  Stream<QuerySnapshot> audienceNotices(String role) {
    return _db
        .where('audience', whereIn: ['All', role])
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
