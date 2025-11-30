import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final unreadMessageCountProvider = StreamProvider<int>((ref) {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    int count = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final lastSender = data['lastMessageSenderId'];
      final seenBy = List<String>.from(data['lastMessageSeenBy'] ?? []);

      final isUnread = lastSender != uid && !seenBy.contains(uid);

      if (isUnread) count++;
    }

    return count;
  });
});

