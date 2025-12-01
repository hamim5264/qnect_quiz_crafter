import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import 'widgets/community_input_bar.dart';
import 'widgets/community_message_bubble.dart';

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final uid = _auth.currentUser!.uid;

    final userDoc = await _firestore.collection("users").doc(uid).get();
    final first = userDoc.data()?["firstName"] ?? "";
    final last = userDoc.data()?["lastName"] ?? "";
    final myName = "$first $last".trim();

    await _firestore.collection("community_chat").add({
      "senderId": uid,
      "senderName": myName,
      "text": text.trim(),
      "createdAt": FieldValue.serverTimestamp(),
      "seenBy": [uid],
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<String?> _getUserAvatar(String uid) async {
    final snap = await _firestore.collection("users").doc(uid).get();
    if (!snap.exists) return null;
    return snap.data()?["profileImage"];
  }

  Future<List<String?>> _loadSeenAvatars(List<String> seenBy) async {
    final limited = seenBy.take(4).toList();
    return await Future.wait(limited.map((uid) => _getUserAvatar(uid)));
  }

  Future<void> _deleteMessage(String messageId) async {
    await _firestore.collection("community_chat").doc(messageId).delete();
  }

  String _formattedTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $ampm";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: "Community Chat"),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore
                      .collection("community_chat")
                      .orderBy("createdAt")
                      .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondaryDark,
                    ),
                  );
                }

                final docs = snap.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final messageId = docs[index].id;

                    final senderId = data["senderId"];
                    final isMe = senderId == _auth.currentUser!.uid;

                    final seenBy = List<String>.from(data["seenBy"] ?? []);

                    if (!seenBy.contains(_auth.currentUser!.uid)) {
                      _firestore
                          .collection("community_chat")
                          .doc(messageId)
                          .update({
                            "seenBy": FieldValue.arrayUnion([
                              _auth.currentUser!.uid,
                            ]),
                          });
                    }

                    return FutureBuilder<List<String?>>(
                      future: _loadSeenAvatars(seenBy),
                      builder: (context, avatarSnap) {
                        final avatars = avatarSnap.data ?? [];

                        return GestureDetector(
                          onLongPress:
                              isMe
                                  ? () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            backgroundColor:
                                                AppColors.primaryLight,
                                            title: const Text(
                                              "Delete Message?",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this message?",
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      _deleteMessage(messageId);
                                    }
                                  }
                                  : null,
                          child: CommunityMessageBubble(
                            name: data["senderName"] ?? "Unknown",
                            text: data["text"] ?? "",
                            time:
                                data["createdAt"] == null
                                    ? ""
                                    : _formattedTime(
                                      (data["createdAt"] as Timestamp).toDate(),
                                    ),
                            isMe: isMe,
                            seen: seenBy.length > 1,
                            seenCount: seenBy.length,

                            seenAvatars: avatars.map((a) => a ?? "").toList(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          CommunityInputBar(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
