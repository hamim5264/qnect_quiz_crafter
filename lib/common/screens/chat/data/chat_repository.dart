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
  final String type;
  final String? imageUrl;
  final String? audioUrl;
  final int? audioDuration;
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

  String _chatIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _loadMyDoc() {
    final uid = auth.currentUser!.uid;
    return firestore.collection("users").doc(uid).get();
  }

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

          final threads =
              snap.docs.map((doc) {
                final data = doc.data();

                final participants = List<String>.from(
                  data['participants'] ?? [],
                );
                final peerId = participants.firstWhere(
                  (id) => id != uid,
                  orElse: () => uid,
                );

                final names = Map<String, dynamic>.from(
                  data['participantNames'] ?? {},
                );
                final avatars = Map<String, dynamic>.from(
                  data['participantAvatars'] ?? {},
                );
                final roles = Map<String, dynamic>.from(
                  data['participantRoles'] ?? {},
                );
                final lastSeenMap = Map<String, dynamic>.from(
                  data['participantLastSeen'] ?? {},
                );

                final peerName = names[peerId] ?? "Unknown User";
                final peerAvatar = avatars[peerId];
                final peerRole = roles[peerId] ?? "student";

                DateTime? lastSeen;
                final lastSeenRaw = lastSeenMap[peerId];
                if (lastSeenRaw is Timestamp) lastSeen = lastSeenRaw.toDate();

                final isActive =
                    lastSeen != null &&
                    now.difference(lastSeen) <= const Duration(minutes: 3);

                final cipher = data['lastMessage'] ?? "";
                final lastMessage =
                    cipher.isNotEmpty ? ChatCryptoHelper.decrypt(cipher) : "";

                final lastMessageAtRaw = data['lastMessageAt'];
                final lastMessageAt =
                    lastMessageAtRaw is Timestamp
                        ? lastMessageAtRaw.toDate()
                        : null;

                final seenBy = List<String>.from(
                  data['lastMessageSeenBy'] ?? [],
                );
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

          if (roleFilter != null && roleFilter != "All") {
            threads.removeWhere(
              (t) => t.peerRole.toLowerCase() != roleFilter.toLowerCase(),
            );
          }

          final q = (searchQuery ?? "").trim().toLowerCase();
          if (q.isEmpty) return threads;

          return threads.where((t) {
            final n = t.peerName.toLowerCase();
            final lm = t.lastMessage.toLowerCase();
            return n.contains(q) || lm.contains(q);
          }).toList();
        });
  }

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

  Future<void> _writeMessage({
    required String peerId,
    required String peerName,
    required String? peerAvatar,
    required String peerRole,
    required Map<String, dynamic> messageData,
    required String lastMessagePlain,
  }) async {
    final uid = auth.currentUser!.uid;

    final myDoc = await _loadMyDoc();
    final myFirst = myDoc.data()?["firstName"] ?? "";
    final myLast = myDoc.data()?["lastName"] ?? "";
    final myName = "$myFirst $myLast".trim();

    final chatId = _chatIdFor(uid, peerId);
    final cipherLast = ChatCryptoHelper.encrypt(lastMessagePlain);

    final msgRef =
        firestore.collection('chats').doc(chatId).collection('messages').doc();

    final participants = [uid, peerId]..sort();
    final chatRef = firestore.collection('chats').doc(chatId);

    await firestore.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': uid,
        'receiverId': peerId,
        'createdAt': FieldValue.serverTimestamp(),
        'seenBy': [uid],
        ...messageData,
      });

      tx.set(chatRef, {
        'participants': participants,
        'participantNames': {uid: myName, peerId: peerName},
        'participantAvatars': {
          uid: myDoc.data()?["profileImage"],
          peerId: peerAvatar,
        },
        'participantRoles': {uid: myDoc.data()?["role"], peerId: peerRole},
        'lastMessage': cipherLast,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'lastMessageSenderId': uid,
        'lastMessageSeenBy': [uid],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

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
