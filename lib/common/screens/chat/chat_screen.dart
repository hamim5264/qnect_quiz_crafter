import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String avatar;
  final bool isActive;

  const ChatScreen({
    super.key,
    required this.name,
    required this.avatar,
    required this.isActive,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello mam, can you help me with calculus quiz?',
      'time': '08:15 PM',
      'isMe': true,
      'seen': true,
    },
    {
      'text': 'Sure, check the notice section. I’ve uploaded notes.',
      'time': '09:05 PM',
      'isMe': false,
      'seen': false,
    },
    {'text': 'Thank you mam!', 'time': '09:06 PM', 'isMe': true, 'seen': true},
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': text.trim(),
        'time': _formattedTime(),
        'isMe': true,
        'seen': false,
      });
    });
    _controller.clear();
    _scrollToBottom();
  }

  String _formattedTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _confirmDeleteMessage(int index) async {
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
              style: TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
              ),
            ),
            content: const Text(
              'Are you sure you want to delete this message?',
              style: TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 14,
              ),
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

    if (confirm == true) {
      setState(() => _messages.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: ChatAppBar(
        name: widget.name,
        avatar: widget.avatar,
        isActive: widget.isActive,
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? const Center(
                      child: Text(
                        'Start your conversation',
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return GestureDetector(
                          onLongPress: () => _confirmDeleteMessage(index),
                          child: ChatBubble(
                            text: msg['text'],
                            time: msg['time'],
                            isMe: msg['isMe'],
                            seen: msg['seen'],
                            avatar: widget.avatar,
                          ),
                        );
                      },
                    ),
          ),
          ChatInputBar(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
