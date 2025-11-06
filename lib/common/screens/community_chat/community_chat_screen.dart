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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {
      'name': 'Arif Rahman',
      'text': 'Admin did you check my new course?',
      'time': '09:05 PM',
      'isMe': true,
      'seenCount': 10,
      'seenAvatars': [
        'assets/images/dummy_user_avatar/dummy_user_1.png',
        'assets/images/dummy_user_avatar/dummy_user_2.png',
        'assets/images/dummy_user_avatar/dummy_user_3.png',
        'assets/images/dummy_user_avatar/dummy_user_4.png',
      ],
      'seen': true,
    },
    {
      'name': 'Admin Hossain',
      'text': 'Ahh, I will review it soon!',
      'time': '09:06 PM',
      'isMe': false,
      'seenCount': 10,
      'seenAvatars': [
        'assets/images/dummy_user_avatar/dummy_user_5.png',
        'assets/images/dummy_user_avatar/dummy_user_6.png',
        'assets/images/dummy_user_avatar/dummy_user_7.png',
        'assets/images/dummy_user_avatar/dummy_user_8.png',
      ],
      'seen': true,
    },
    {
      'name': 'Rabia Khan',
      'text': 'Thank you sir!',
      'time': '09:07 PM',
      'isMe': false,
      'seenCount': 10,
      'seenAvatars': [
        'assets/images/dummy_user_avatar/dummy_user_3.png',
        'assets/images/dummy_user_avatar/dummy_user_5.png',
        'assets/images/dummy_user_avatar/dummy_user_6.png',
        'assets/images/dummy_user_avatar/dummy_user_7.png',
      ],
      'seen': true,
    },
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add({
        'name': 'You',
        'text': text.trim(),
        'time': _formattedTime(),
        'isMe': true,
        'seenCount': 0,
        'seenAvatars': <String>[],
        'seen': false,
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formattedTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  void _deleteMessage(int index) {
    setState(() => messages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: const CommonRoundedAppBar(title: 'Community Chat'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return GestureDetector(
                  onLongPress: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            backgroundColor: AppColors.primaryLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              'Delete Message?',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'Are you sure you want to delete this message?',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) _deleteMessage(index);
                  },
                  child: CommunityMessageBubble(
                    name: msg['name'],
                    text: msg['text'],
                    time: msg['time'],
                    isMe: msg['isMe'],
                    seen: msg['seen'],
                    seenCount: msg['seenCount'],
                    seenAvatars: msg['seenAvatars'],
                  ),
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
