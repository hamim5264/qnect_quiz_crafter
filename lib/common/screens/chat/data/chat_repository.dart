// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'chat_crypto_helper.dart';
//
// class ChatThread {
//   final String chatId;
//   final String peerId;
//   final String peerName;
//   final String? peerAvatar;
//   final String peerRole;
//   final String lastMessage;
//   final DateTime? lastMessageAt;
//   final bool isActive;
//   final bool isRead;
//
//   ChatThread({
//     required this.chatId,
//     required this.peerId,
//     required this.peerName,
//     required this.peerAvatar,
//     required this.peerRole,
//     required this.lastMessage,
//     required this.lastMessageAt,
//     required this.isActive,
//     required this.isRead,
//   });
// }
//
// class ChatMessage {
//   final String id;
//   final String text;
//   final String type; // text | image
//   final String? imageUrl;
//   final String senderId;
//   final bool isMe;
//   final bool seen;
//   final DateTime? createdAt;
//
//   ChatMessage({
//     required this.id,
//     required this.text,
//     required this.type,
//     required this.imageUrl,
//     required this.senderId,
//     required this.isMe,
//     required this.seen,
//     required this.createdAt,
//   });
// }
//
// class ChatRepository {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth auth;
//
//   ChatRepository(this.firestore, this.auth);
//
//   /// Generate consistent chatId using sorted UIDs
//   String _chatIdFor(String a, String b) {
//     final ids = [a, b]..sort();
//     return ids.join('_');
//   }
//
//   // ============================================================
//   // THREAD LIST STREAM
//   // ============================================================
//   // Stream<List<ChatThread>> watchThreads({
//   //   String? roleFilter,
//   //   String? searchQuery,
//   // }) {
//   //   final uid = auth.currentUser!.uid;
//   //
//   //   return firestore
//   //       .collection('chats')
//   //       .where('participants', arrayContains: uid)
//   //       .orderBy('lastMessageAt', descending: true)
//   //       .snapshots()
//   //       .map((snap) {
//   //     final now = DateTime.now();
//   //
//   //     final threads = snap.docs.map((doc) {
//   //       final data = doc.data();
//   //
//   //       final participants = List<String>.from(data['participants'] ?? []);
//   //       final peerId =
//   //       participants.firstWhere((id) => id != uid, orElse: () => uid);
//   //
//   //       // Participant maps
//   //       final names =
//   //       Map<String, dynamic>.from(data['participantNames'] ?? {});
//   //       final avatars =
//   //       Map<String, dynamic>.from(data['participantAvatars'] ?? {});
//   //       final roles =
//   //       Map<String, dynamic>.from(data['participantRoles'] ?? {});
//   //       final lastSeenMap =
//   //       Map<String, dynamic>.from(data['participantLastSeen'] ?? {});
//   //
//   //       final peerName = names[peerId] ?? "Unknown User";
//   //       final peerAvatar = avatars[peerId];
//   //       final peerRole = roles[peerId] ?? "student";
//   //
//   //       // Last seen
//   //       DateTime? lastSeen;
//   //       final lastSeenRaw = lastSeenMap[peerId];
//   //       if (lastSeenRaw is Timestamp) lastSeen = lastSeenRaw.toDate();
//   //
//   //       final isActive = lastSeen != null &&
//   //           now.difference(lastSeen) <= const Duration(minutes: 3);
//   //
//   //       // Message + decrypt
//   //       final cipher = data['lastMessage'] ?? "";
//   //       final lastMessage =
//   //       cipher.isNotEmpty ? ChatCryptoHelper.decrypt(cipher) : "";
//   //
//   //       final lastMessageAtRaw = data['lastMessageAt'];
//   //       final lastMessageAt =
//   //       lastMessageAtRaw is Timestamp ? lastMessageAtRaw.toDate() : null;
//   //
//   //       final seenBy = List<String>.from(data['lastMessageSeenBy'] ?? []);
//   //       final lastSenderId = data['lastMessageSenderId'] ?? "";
//   //       final isRead = seenBy.contains(uid) || lastSenderId == uid;
//   //
//   //       return ChatThread(
//   //         chatId: doc.id,
//   //         peerId: peerId,
//   //         peerName: peerName,
//   //         peerAvatar: peerAvatar,
//   //         peerRole: peerRole,
//   //         lastMessage: lastMessage,
//   //         lastMessageAt: lastMessageAt,
//   //         isActive: isActive,
//   //         isRead: isRead,
//   //       );
//   //     }).toList();
//   //
//   //     // Role filter
//   //     if (roleFilter != null && roleFilter != "All") {
//   //       threads.removeWhere((t) =>
//   //       t.peerRole.toLowerCase() != roleFilter.toLowerCase());
//   //     }
//   //
//   //     // Search
//   //     final q = (searchQuery ?? "").trim().toLowerCase();
//   //     if (q.isEmpty) return threads;
//   //
//   //     return threads.where((t) {
//   //       final n = t.peerName.toLowerCase();
//   //       final lm = t.lastMessage.toLowerCase();
//   //       return n.contains(q) || lm.contains(q);
//   //     }).toList();
//   //   });
//   // }
//
//   Stream<List<ChatThread>> watchThreads({
//     String? roleFilter,
//     String? searchQuery,
//   }) {
//     final uid = auth.currentUser!.uid;
//
//     return firestore
//         .collection('chats')
//         .where('participants', arrayContains: uid)
//         .orderBy('lastMessageAt', descending: true)
//         .snapshots()
//         .map((snap) {
//       final now = DateTime.now();
//
//       final threads = snap.docs.map((doc) {
//         final data = doc.data();
//
//         final participants = List<String>.from(data['participants'] ?? []);
//         final peerId =
//         participants.firstWhere((id) => id != uid, orElse: () => uid);
//
//         // Maps
//         final names = Map<String, dynamic>.from(data['participantNames'] ?? {});
//         final avatars =
//         Map<String, dynamic>.from(data['participantAvatars'] ?? {});
//         final roles =
//         Map<String, dynamic>.from(data['participantRoles'] ?? {});
//         final lastSeenMap =
//         Map<String, dynamic>.from(data['participantLastSeen'] ?? {});
//
//         // -------------------------------
//         // 🔥 FIXED NAME LOADING LOGIC
//         // -------------------------------
//         String peerName = (names[peerId]?.toString().trim() ?? "");
//
//         // If missing → fallback to Firestore name stored earlier
//         if (peerName.isEmpty ||
//             peerName.toLowerCase() == "unknown" ||
//             peerName.toLowerCase() == "unknown user") {
//           final first = data['fallbackFirstNames']?[peerId] ?? "";
//           final last = data['fallbackLastNames']?[peerId] ?? "";
//           final full = "$first $last".trim();
//           peerName = full.isNotEmpty ? full : "Unknown";
//         }
//
//         final peerAvatar = avatars[peerId];
//         final peerRole = roles[peerId] ?? "student";
//
//         // Last seen
//         DateTime? lastSeen;
//         final lastSeenRaw = lastSeenMap[peerId];
//         if (lastSeenRaw is Timestamp) lastSeen = lastSeenRaw.toDate();
//
//         final isActive =
//             lastSeen != null &&
//                 now.difference(lastSeen) <= const Duration(minutes: 3);
//
//         // Message + decrypt
//         final cipher = data['lastMessage'] ?? "";
//         final lastMessage =
//         cipher.isNotEmpty ? ChatCryptoHelper.decrypt(cipher) : "";
//
//         final lastMessageAtRaw = data['lastMessageAt'];
//         final lastMessageAt =
//         lastMessageAtRaw is Timestamp ? lastMessageAtRaw.toDate() : null;
//
//         final seenBy = List<String>.from(data['lastMessageSeenBy'] ?? []);
//         final lastSenderId = data['lastMessageSenderId'] ?? "";
//         final isRead = seenBy.contains(uid) || lastSenderId == uid;
//
//         return ChatThread(
//           chatId: doc.id,
//           peerId: peerId,
//           peerName: peerName,
//           peerAvatar: peerAvatar,
//           peerRole: peerRole,
//           lastMessage: lastMessage,
//           lastMessageAt: lastMessageAt,
//           isActive: isActive,
//           isRead: isRead,
//         );
//       }).toList();
//
//       // Filter by role
//       if (roleFilter != null && roleFilter != "All") {
//         threads.removeWhere((t) =>
//         t.peerRole.toLowerCase() != roleFilter.toLowerCase());
//       }
//
//       // Search
//       final q = (searchQuery ?? "").trim().toLowerCase();
//       if (q.isEmpty) return threads;
//
//       return threads.where((t) {
//         final n = t.peerName.toLowerCase();
//         final lm = t.lastMessage.toLowerCase();
//         return n.contains(q) || lm.contains(q);
//       }).toList();
//     });
//   }
//
//
//   // ============================================================
//   // MESSAGE STREAM
//   // ============================================================
//   Stream<List<ChatMessage>> watchMessages(String chatId) {
//     final uid = auth.currentUser!.uid;
//
//     return firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('createdAt')
//         .snapshots()
//         .map((snap) {
//       return snap.docs.map((doc) {
//         final data = doc.data();
//
//         final cipher = data['text'] ?? '';
//         final plain =
//         cipher.isNotEmpty ? ChatCryptoHelper.decrypt(cipher) : '';
//
//         final createdAtRaw = data['createdAt'];
//         final createdAt =
//         createdAtRaw is Timestamp ? createdAtRaw.toDate() : null;
//
//         final seenBy = List<String>.from(data['seenBy'] ?? []);
//
//         return ChatMessage(
//           id: doc.id,
//           text: plain,
//           type: data['type'] ?? "text",
//           imageUrl: data['imageUrl'],
//           senderId: data['senderId'] ?? "",
//           isMe: data['senderId'] == uid,
//           seen: seenBy.contains(uid),
//           createdAt: createdAt,
//         );
//       }).toList();
//     });
//   }
//
//   // ============================================================
//   // SEND MESSAGE
//   // ============================================================
//   Future<void> sendTextMessage({
//     required String peerId,
//     required String peerName,
//     required String? peerAvatar,
//     required String peerRole,
//     required String text,
//   }) async {
//     final uid = auth.currentUser!.uid;
//
//     // --- FIX #1: Load my real name ---
//     final myDoc = await firestore.collection("users").doc(uid).get();
//     final myFirst = myDoc.data()?["firstName"] ?? "";
//     final myLast  = myDoc.data()?["lastName"] ?? "";
//     final myName  = "$myFirst $myLast".trim();
//
//
//     final chatId = _chatIdFor(uid, peerId);
//     final now = DateTime.now();
//     final cipher = ChatCryptoHelper.encrypt(text.trim());
//
//     final msgRef = firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc();
//
//     final participants = [uid, peerId]..sort();
//
//     await firestore.runTransaction((tx) async {
//       tx.set(msgRef, {
//         'senderId': uid,
//         'receiverId': peerId,
//         'text': cipher,
//         'type': 'text',
//         'imageUrl': null,
//         'createdAt': FieldValue.serverTimestamp(),
//         'seenBy': [uid],
//       });
//
//       final chatRef = firestore.collection('chats').doc(chatId);
//
//       tx.set(chatRef, {
//         'participants': participants,
//
//         // --- FIX #2: Save BOTH names correctly ---
//         'participantNames': {
//           uid: myName,
//           peerId: peerName,
//         },
//
//         'participantAvatars': {
//           uid: myDoc.data()?["profileImage"],
//           peerId: peerAvatar,
//         },
//
//         'participantRoles': {
//           uid: myDoc.data()?["role"],
//           peerId: peerRole,
//         },
//
//         'lastMessage': cipher,
//         'lastMessageAt': FieldValue.serverTimestamp(),
//         'lastMessageSenderId': uid,
//         'lastMessageSeenBy': [uid],
//         'createdAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//     });
//   }
//
//   // ============================================================
// // SEND IMAGE MESSAGE
// // ============================================================
//   Future<void> sendImageMessage({
//     required String peerId,
//     required String peerName,
//     required String? peerAvatar,
//     required String peerRole,
//     required String imageUrl,
//   }) async {
//     final uid = auth.currentUser!.uid;
//
//     // Load my name (same logic as your sendTextMessage)
//     final myDoc = await firestore.collection("users").doc(uid).get();
//     final myFirst = myDoc.data()?["firstName"] ?? "";
//     final myLast  = myDoc.data()?["lastName"] ?? "";
//     final myName  = "$myFirst $myLast".trim();
//
//     final chatId = _chatIdFor(uid, peerId);
//     final cipher = ChatCryptoHelper.encrypt("[image]");
//
//     final msgRef = firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc();
//
//     await msgRef.set({
//       'senderId': uid,
//       'receiverId': peerId,
//       'type': 'image',
//       'text': cipher,
//       'imageUrl': imageUrl,
//       'createdAt': FieldValue.serverTimestamp(),
//       'seenBy': [uid],
//     });
//
//     // Update chat thread
//     await firestore.collection('chats').doc(chatId).set({
//       'participants': [uid, peerId]..sort(),
//       'participantNames': { uid: myName, peerId: peerName },
//       'participantAvatars': {
//         uid: myDoc.data()?["profileImage"],
//         peerId: peerAvatar,
//       },
//       'participantRoles': {
//         uid: myDoc.data()?["role"],
//         peerId: peerRole,
//       },
//       'lastMessage': cipher,
//       'lastMessageAt': FieldValue.serverTimestamp(),
//       'lastMessageSenderId': uid,
//       'lastMessageSeenBy': [uid],
//     }, SetOptions(merge: true));
//   }
//
//
//   // ============================================================
// // SEND AUDIO MESSAGE
// // ============================================================
//   Future<void> sendAudioMessage({
//     required String peerId,
//     required String peerName,
//     required String? peerAvatar,
//     required String peerRole,
//     required String audioUrl,
//     required int duration,
//   }) async {
//     final uid = auth.currentUser!.uid;
//
//     final myDoc = await firestore.collection("users").doc(uid).get();
//     final myFirst = myDoc.data()?["firstName"] ?? "";
//     final myLast  = myDoc.data()?["lastName"] ?? "";
//     final myName  = "$myFirst $myLast".trim();
//
//     final chatId = _chatIdFor(uid, peerId);
//     final cipher = ChatCryptoHelper.encrypt("[voice]");
//
//     final msgRef = firestore
//         .collection('chats')
//         .doc(chatId)
//         .collection('messages')
//         .doc();
//
//     await msgRef.set({
//       'senderId': uid,
//       'receiverId': peerId,
//       'type': 'audio',
//       'text': cipher,
//       'audioUrl': audioUrl,
//       'audioDuration': duration,
//       'createdAt': FieldValue.serverTimestamp(),
//       'seenBy': [uid],
//     });
//
//     await firestore.collection('chats').doc(chatId).set({
//       'participants': [uid, peerId]..sort(),
//       'participantNames': { uid: myName, peerId: peerName },
//       'participantAvatars': {
//         uid: myDoc.data()?["profileImage"],
//         peerId: peerAvatar,
//       },
//       'participantRoles': {
//         uid: myDoc.data()?["role"],
//         peerId: peerRole,
//       },
//       'lastMessage': cipher,
//       'lastMessageAt': FieldValue.serverTimestamp(),
//       'lastMessageSenderId': uid,
//       'lastMessageSeenBy': [uid],
//     }, SetOptions(merge: true));
//   }
//
//
//
//   // ============================================================
//   // FIXED ✔ markThreadAsRead — safe even for new chats
//   // ============================================================
//   Future<void> markThreadAsRead(String chatId) async {
//     final uid = auth.currentUser!.uid;
//
//     final ref = firestore.collection('chats').doc(chatId);
//
//     final snap = await ref.get();
//
//     // If thread does not exist yet → DO NOTHING (no crash, no Firestore rule hit)
//     if (!snap.exists) return;
//
//     await ref.update({
//       'lastMessageSeenBy': FieldValue.arrayUnion([uid]),
//     });
//   }
// }
// lib/common/screens/chat/data/chat_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_crypto_helper.dart';

class ChatThread {
  final String chatId;
  final String peerId;
  final String peerName;
  final String? peerAvatar;
  final String peerRole;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final bool isActive;
  final bool isRead;

  ChatThread({
    required this.chatId,
    required this.peerId,
    required this.peerName,
    required this.peerAvatar,
    required this.peerRole,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.isActive,
    required this.isRead,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final String type;          // "text" | "image" | "audio"
  final String? imageUrl;
  final String? audioUrl;
  final int? audioDuration;   // seconds
  final String senderId;
  final bool isMe;
  final bool seen;
  final DateTime? createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.imageUrl,
    required this.audioUrl,
    required this.audioDuration,
    required this.senderId,
    required this.isMe,
    required this.seen,
    required this.createdAt,
  });
}

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository(this.firestore, this.auth);

  /// Generate consistent chatId using sorted UIDs
  String _chatIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  // Small helper to load my user doc
  Future<DocumentSnapshot<Map<String, dynamic>>> _loadMyDoc() {
    final uid = auth.currentUser!.uid;
    return firestore.collection("users").doc(uid).get();
  }

  // ============================================================
  // THREAD LIST STREAM
  // ============================================================
  Stream<List<ChatThread>> watchThreads({
    String? roleFilter,
    String? searchQuery,
  }) {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) {
      final now = DateTime.now();

      final threads = snap.docs.map((doc) {
        final data = doc.data();

        final participants = List<String>.from(data['participants'] ?? []);
        final peerId =
        participants.firstWhere((id) => id != uid, orElse: () => uid);

        // Participant maps
        final names =
        Map<String, dynamic>.from(data['participantNames'] ?? {});
        final avatars =
        Map<String, dynamic>.from(data['participantAvatars'] ?? {});
        final roles =
        Map<String, dynamic>.from(data['participantRoles'] ?? {});
        final lastSeenMap =
        Map<String, dynamic>.from(data['participantLastSeen'] ?? {});

        final peerName = names[peerId] ?? "Unknown User";
        final peerAvatar = avatars[peerId];
        final peerRole = roles[peerId] ?? "student";

        // Last seen
        DateTime? lastSeen;
        final lastSeenRaw = lastSeenMap[peerId];
        if (lastSeenRaw is Timestamp) lastSeen = lastSeenRaw.toDate();

        final isActive = lastSeen != null &&
            now.difference(lastSeen) <= const Duration(minutes: 3);

        // Message + decrypt
        final cipher = data['lastMessage'] ?? "";
        final lastMessage =
        cipher.isNotEmpty ? ChatCryptoHelper.decrypt(cipher) : "";

        final lastMessageAtRaw = data['lastMessageAt'];
        final lastMessageAt =
        lastMessageAtRaw is Timestamp ? lastMessageAtRaw.toDate() : null;

        final seenBy = List<String>.from(data['lastMessageSeenBy'] ?? []);
        final lastSenderId = data['lastMessageSenderId'] ?? "";
        final isRead = seenBy.contains(uid) || lastSenderId == uid;

        return ChatThread(
          chatId: doc.id,
          peerId: peerId,
          peerName: peerName,
          peerAvatar: peerAvatar,
          peerRole: peerRole,
          lastMessage: lastMessage,
          lastMessageAt: lastMessageAt,
          isActive: isActive,
          isRead: isRead,
        );
      }).toList();

      // Role filter for admin screen
      if (roleFilter != null && roleFilter != "All") {
        threads.removeWhere(
              (t) => t.peerRole.toLowerCase() != roleFilter.toLowerCase(),
        );
      }

      // Search
      final q = (searchQuery ?? "").trim().toLowerCase();
      if (q.isEmpty) return threads;

      return threads.where((t) {
        final n = t.peerName.toLowerCase();
        final lm = t.lastMessage.toLowerCase();
        return n.contains(q) || lm.contains(q);
      }).toList();
    });
  }

  // ============================================================
  // MESSAGE STREAM
  // ============================================================
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    final uid = auth.currentUser!.uid;

    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();

        final type = data['type'] ?? 'text';

        final cipher = data['text'] ?? '';
        final plain =
        cipher.isNotEmpty ? ChatCryptoHelper.decrypt(cipher) : '';

        final createdAtRaw = data['createdAt'];
        final createdAt =
        createdAtRaw is Timestamp ? createdAtRaw.toDate() : null;

        final seenBy = List<String>.from(data['seenBy'] ?? []);

        return ChatMessage(
          id: doc.id,
          text: plain,
          type: type,
          imageUrl: data['imageUrl'],
          audioUrl: data['audioUrl'],
          audioDuration: data['audioDuration'],
          senderId: data['senderId'] ?? "",
          isMe: data['senderId'] == uid,
          seen: seenBy.contains(uid),
          createdAt: createdAt,
        );
      }).toList();
    });
  }

  // Common transaction body so all message types update thread correctly
  Future<void> _writeMessage({
    required String peerId,
    required String peerName,
    required String? peerAvatar,
    required String peerRole,
    required Map<String, dynamic> messageData,
    required String lastMessagePlain, // what to show in thread
  }) async {
    final uid = auth.currentUser!.uid;

    final myDoc = await _loadMyDoc();
    final myFirst = myDoc.data()?["firstName"] ?? "";
    final myLast = myDoc.data()?["lastName"] ?? "";
    final myName = "$myFirst $myLast".trim();

    final chatId = _chatIdFor(uid, peerId);
    final cipherLast = ChatCryptoHelper.encrypt(lastMessagePlain);

    final msgRef = firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final participants = [uid, peerId]..sort();
    final chatRef = firestore.collection('chats').doc(chatId);

    await firestore.runTransaction((tx) async {
      tx.set(
        msgRef,
        {
          'senderId': uid,
          'receiverId': peerId,
          'createdAt': FieldValue.serverTimestamp(),
          'seenBy': [uid],
          ...messageData,
        },
      );

      tx.set(
        chatRef,
        {
          'participants': participants,
          'participantNames': {
            uid: myName,
            peerId: peerName,
          },
          'participantAvatars': {
            uid: myDoc.data()?["profileImage"],
            peerId: peerAvatar,
          },
          'participantRoles': {
            uid: myDoc.data()?["role"],
            peerId: peerRole,
          },
          'lastMessage': cipherLast,
          'lastMessageAt': FieldValue.serverTimestamp(),
          'lastMessageSenderId': uid,
          'lastMessageSeenBy': [uid],
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    });
  }

  // ============================================================
  // SEND TEXT
  // ============================================================
  Future<void> sendTextMessage({
    required String peerId,
    required String peerName,
    required String? peerAvatar,
    required String peerRole,
    required String text,
  }) async {
    final cipher = ChatCryptoHelper.encrypt(text.trim());

    await _writeMessage(
      peerId: peerId,
      peerName: peerName,
      peerAvatar: peerAvatar,
      peerRole: peerRole,
      messageData: {
        'type': 'text',
        'text': cipher,
        'imageUrl': null,
        'audioUrl': null,
        'audioDuration': null,
      },
      lastMessagePlain: text.trim(),
    );
  }

  // ============================================================
  // SEND IMAGE
  // ============================================================
  Future<void> sendImageMessage({
    required String peerId,
    required String peerName,
    required String? peerAvatar,
    required String peerRole,
    required String imageUrl,
  }) async {
    await _writeMessage(
      peerId: peerId,
      peerName: peerName,
      peerAvatar: peerAvatar,
      peerRole: peerRole,
      messageData: {
        'type': 'image',
        'text': '',
        'imageUrl': imageUrl,
        'audioUrl': null,
        'audioDuration': null,
      },
      lastMessagePlain: "[Image]",
    );
  }

  // ============================================================
  // SEND AUDIO
  // ============================================================
  Future<void> sendAudioMessage({
    required String peerId,
    required String peerName,
    required String? peerAvatar,
    required String peerRole,
    required String audioUrl,
    required int durationSeconds,
  }) async {
    await _writeMessage(
      peerId: peerId,
      peerName: peerName,
      peerAvatar: peerAvatar,
      peerRole: peerRole,
      messageData: {
        'type': 'audio',
        'text': '',
        'imageUrl': null,
        'audioUrl': audioUrl,
        'audioDuration': durationSeconds,
      },
      lastMessagePlain: "[Voice message]",
    );
  }

  // ============================================================
  // markThreadAsRead — safe even for new chats
  // ============================================================
  Future<void> markThreadAsRead(String chatId) async {
    final uid = auth.currentUser!.uid;

    final ref = firestore.collection('chats').doc(chatId);
    final snap = await ref.get();

    if (!snap.exists) return;

    await ref.update({
      'lastMessageSeenBy': FieldValue.arrayUnion([uid]),
    });
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    final msgRef = firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId);

    await msgRef.delete();
  }

}
