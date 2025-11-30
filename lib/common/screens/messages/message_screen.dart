import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/common_rounded_app_bar.dart';
import '../../../../common/widgets/action_feedback_dialog.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import '../chat/data/chat_repository.dart';
import 'widgets/message_filter_bar.dart';
import 'widgets/message_search_bar.dart';
import 'widgets/message_card.dart';

class MessageScreen extends StatefulWidget {
  final String role;

  const MessageScreen({super.key, required this.role});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  late final ChatRepository _chatRepo;

  @override
  void initState() {
    super.initState();
    _chatRepo = ChatRepository(
      FirebaseFirestore.instance,
      FirebaseAuth.instance,
    );
  }

  void _deleteConversation(String chatId) {
    showDialog(
      context: context,
      builder:
          (_) => ActionFeedbackDialog(
            icon: CupertinoIcons.trash,
            title: 'Delete Conversation?',
            subtitle: 'Are you sure you want to delete this conversation?',
            buttonText: 'Confirm Delete',
            onPressed: () async {
              Navigator.pop(context);

              final chatRef = FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId);

              final messagesSnap = await chatRef.collection('messages').get();

              WriteBatch batch = FirebaseFirestore.instance.batch();

              for (var doc in messagesSnap.docs) {
                batch.delete(doc.reference);
              }

              batch.delete(chatRef);

              await batch.commit();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'admin';
    final filters = isAdmin ? ['All', 'Teacher', 'Student'] : <String>[];

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Messages'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              MessageSearchBar(
                onChanged: (v) => setState(() => searchQuery = v),
              ),
              const SizedBox(height: 14),

              if (isAdmin)
                MessageFilterBar(
                  filters: filters,
                  selected: selectedFilter,
                  onSelected: (v) => setState(() => selectedFilter = v),
                ),

              if (isAdmin)
                const SizedBox(height: 16)
              else
                const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder<List<ChatThread>>(
                  stream: _chatRepo.watchThreads(
                    roleFilter: isAdmin ? selectedFilter : null,
                    searchQuery: searchQuery,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _MessageListShimmer();
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load messages',
                          style: const TextStyle(
                            fontFamily: AppTypography.family,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }

                    final threads = snapshot.data ?? [];

                    if (threads.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              CupertinoIcons.chat_bubble_text,
                              color: Colors.white38,
                              size: 52,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No conversations yet',
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Start a chat to see messages here.',
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: threads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final t = threads[index];

                        final timeStr =
                            t.lastMessageAt != null
                                ? _formatTime(t.lastMessageAt!)
                                : '';

                        return Dismissible(
                          key: ValueKey(t.chatId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              CupertinoIcons.trash,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (_) async {
                            _deleteConversation(t.chatId);
                            return false;
                          },
                          child: MessageCard(
                            chatId: t.chatId,
                            peerId: t.peerId,
                            name: t.peerName,
                            lastMessage:
                                t.lastMessage.isNotEmpty
                                    ? t.lastMessage
                                    : 'Tap to start chatting',
                            time: timeStr,
                            avatar: t.peerAvatar,
                            isActive: t.isActive,
                            isRead: t.isRead,
                            peerRole: t.peerRole,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}

class _MessageListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.08),
      highlightColor: Colors.white.withValues(alpha: 0.18),
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
