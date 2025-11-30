// import 'package:flutter/material.dart';
// import '../../../../ui/design_system/tokens/colors.dart';
// import '../../../../ui/design_system/tokens/typography.dart';
// import 'widgets/chat_app_bar.dart';
// import 'widgets/chat_input_bar.dart';
// import 'widgets/chat_bubble.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String name;
//   final String avatar;
//   final bool isActive;
//
//   const ChatScreen({
//     super.key,
//     required this.name,
//     required this.avatar,
//     required this.isActive,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   final _scrollController = ScrollController();
//
//   final List<Map<String, dynamic>> _messages = [
//     {
//       'text': 'Hello mam, can you help me with calculus quiz?',
//       'time': '08:15 PM',
//       'isMe': true,
//       'seen': true,
//     },
//     {
//       'text': 'Sure, check the notice section. I’ve uploaded notes.',
//       'time': '09:05 PM',
//       'isMe': false,
//       'seen': false,
//     },
//     {'text': 'Thank you mam!', 'time': '09:06 PM', 'isMe': true, 'seen': true},
//   ];
//
//   void _sendMessage(String text) {
//     if (text.trim().isEmpty) return;
//     setState(() {
//       _messages.add({
//         'text': text.trim(),
//         'time': _formattedTime(),
//         'isMe': true,
//         'seen': false,
//       });
//     });
//     _controller.clear();
//     _scrollToBottom();
//   }
//
//   String _formattedTime() {
//     final now = DateTime.now();
//     final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
//     final minute = now.minute.toString().padLeft(2, '0');
//     final ampm = now.hour >= 12 ? 'PM' : 'AM';
//     return '$hour:$minute $ampm';
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent + 80,
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Future<void> _confirmDeleteMessage(int index) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             backgroundColor: AppColors.primaryLight,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: const Text(
//               'Delete Message?',
//               style: TextStyle(
//                 fontFamily: AppTypography.family,
//                 color: Colors.white,
//               ),
//             ),
//             content: const Text(
//               'Are you sure you want to delete this message?',
//               style: TextStyle(
//                 fontFamily: AppTypography.family,
//                 color: Colors.white70,
//                 fontSize: 14,
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: const Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.redAccent),
//                 ),
//               ),
//             ],
//           ),
//     );
//
//     if (confirm == true) {
//       setState(() => _messages.removeAt(index));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       appBar: ChatAppBar(
//         name: widget.name,
//         avatar: widget.avatar,
//         isActive: widget.isActive,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child:
//                 _messages.isEmpty
//                     ? const Center(
//                       child: Text(
//                         'Start your conversation',
//                         style: TextStyle(
//                           fontFamily: AppTypography.family,
//                           color: Colors.white70,
//                           fontSize: 15,
//                         ),
//                       ),
//                     )
//                     : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10,
//                       ),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         return GestureDetector(
//                           onLongPress: () => _confirmDeleteMessage(index),
//                           child: ChatBubble(
//                             text: msg['text'],
//                             time: msg['time'],
//                             isMe: msg['isMe'],
//                             seen: msg['seen'],
//                             avatar: widget.avatar,
//                           ),
//                         );
//                       },
//                     ),
//           ),
//           ChatInputBar(controller: _controller, onSend: _sendMessage),
//         ],
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../../../ui/design_system/tokens/colors.dart';
// import '../../../../ui/design_system/tokens/typography.dart';
// import 'widgets/chat_app_bar.dart';
// import 'widgets/chat_input_bar.dart';
// import 'widgets/chat_bubble.dart';
// import '../chat/data/chat_repository.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String peerId;
//   final String name;
//   final String? avatar;
//   final bool isActive;
//   final String peerRole;
//
//   const ChatScreen({
//     super.key,
//     required this.chatId,
//     required this.peerId,
//     required this.name,
//     required this.avatar,
//     required this.isActive,
//     required this.peerRole,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   final _scrollController = ScrollController();
//   late final ChatRepository _chatRepo;
//
//   @override
//   void initState() {
//     super.initState();
//     _chatRepo = ChatRepository(
//       FirebaseFirestore.instance,
//       FirebaseAuth.instance,
//     );
//
//     if (widget.chatId.isNotEmpty) {
//       _chatRepo.markThreadAsRead(widget.chatId);
//     }
//
//     _scrollToBottom();
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent + 80,
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   Future<void> _sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//
//     await _chatRepo.sendTextMessage(
//       peerId: widget.peerId,
//       peerName: widget.name,
//       peerAvatar: widget.avatar,
//       peerRole: widget.peerRole,
//       text: text.trim(),
//     );
//
//     // 🔥 Force rebuild so the first message appears instantly
//     if (mounted) setState(() {});
//
//     _controller.clear();
//     _scrollToBottom();
//   }
//
//
//   Future<void> _confirmDeleteMessage(String messageId) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: AppColors.primaryLight,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: const Text(
//           'Delete Message?',
//           style: TextStyle(
//             fontFamily: AppTypography.family,
//             color: Colors.white,
//           ),
//         ),
//         content: const Text(
//           'Are you sure you want to delete this message?',
//           style: TextStyle(
//             fontFamily: AppTypography.family,
//             color: Colors.white70,
//             fontSize: 14,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.white70),
//             ),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.redAccent),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     if (confirm == true) {
//       await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatId)
//           .collection('messages')
//           .doc(messageId)
//           .delete();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       appBar: ChatAppBar(
//         name: widget.name,
//         avatar: widget.avatar,
//         isActive: widget.isActive,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: widget.chatId.isEmpty
//                 ? const Center(
//               child: Text(
//                 'No conversation yet',
//                 style: TextStyle(
//                   fontFamily: AppTypography.family,
//                   color: Colors.white70,
//                   fontSize: 16,
//                 ),
//               ),
//             )
//                 : StreamBuilder<List<ChatMessage>>(
//               stream: _chatRepo.watchMessages(widget.chatId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: AppColors.secondaryDark,
//                     ),
//                   );
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       'Start your conversation',
//                       style: TextStyle(
//                         fontFamily: AppTypography.family,
//                         color: Colors.white70,
//                         fontSize: 15,
//                       ),
//                     ),
//                   );
//                 }
//
//                 final msgs = snapshot.data!;
//
//                 _chatRepo.markThreadAsRead(widget.chatId);
//
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _scrollToBottom();
//                 });
//
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 10,
//                   ),
//                   itemCount: msgs.length,
//                   itemBuilder: (context, index) {
//                     final msg = msgs[index];
//
//                     return GestureDetector(
//                       onLongPress: () => _confirmDeleteMessage(msg.id),
//                       child: ChatBubble(
//                       text: msg.text,
//                       time: _formatTime(msg.createdAt),
//                       isMe: msg.isMe,
//                       seen: msg.seen,
//
//                       // NEW
//                       myAvatar: FirebaseAuth.instance.currentUser?.photoURL ?? '',
//                       peerAvatar: widget.avatar ?? '',
//                     ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//
//           ChatInputBar(
//             controller: _controller,
//             onSend: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatTime(DateTime? dt) {
//     if (dt == null) return '';
//     final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
//     final minute = dt.minute.toString().padLeft(2, '0');
//     final ampm = dt.hour >= 12 ? 'PM' : 'AM';
//     return '$hour:$minute $ampm';
//   }
// }


// lib/common/screens/chat/chat_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_bubble.dart';
import '../chat/data/chat_repository.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String peerId;
  final String name;
  final String? avatar;
  final bool isActive;
  final String peerRole;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.peerId,
    required this.name,
    required this.avatar,
    required this.isActive,
    required this.peerRole,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatRepository _chatRepo;

  @override
  void initState() {
    super.initState();
    _chatRepo = ChatRepository(
      FirebaseFirestore.instance,
      FirebaseAuth.instance,
    );

    if (widget.chatId.isNotEmpty) {
      _chatRepo.markThreadAsRead(widget.chatId);
    }

    _scrollToBottom();
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

  Future<void> _sendText(String text) async {
    if (text.trim().isEmpty) return;

    await _chatRepo.sendTextMessage(
      peerId: widget.peerId,
      peerName: widget.name,
      peerAvatar: widget.avatar,
      peerRole: widget.peerRole,
      text: text.trim(),
    );

    if (!mounted) return;
    _controller.clear();
    _scrollToBottom();
  }

  Future<void> _sendImage(String url) async {
    await _chatRepo.sendImageMessage(
      peerId: widget.peerId,
      peerName: widget.name,
      peerAvatar: widget.avatar,
      peerRole: widget.peerRole,
      imageUrl: url,
    );

    if (!mounted) return;
    _scrollToBottom();
  }

  Future<void> _sendAudio(String url, int duration) async {
    await _chatRepo.sendAudioMessage(
      peerId: widget.peerId,
      peerName: widget.name,
      peerAvatar: widget.avatar,
      peerRole: widget.peerRole,
      audioUrl: url,
      durationSeconds: duration,
    );

    if (!mounted) return;
    _scrollToBottom();
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
            child: widget.chatId.isEmpty
                ? const Center(
              child: Text(
                'No conversation yet',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            )
                : StreamBuilder<List<ChatMessage>>(
              stream: _chatRepo.watchMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondaryDark,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Start your conversation',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  );
                }

                final msgs = snapshot.data!;

                _chatRepo.markThreadAsRead(widget.chatId);

                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                final myAvatar =
                    FirebaseAuth.instance.currentUser?.photoURL ?? '';

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final msg = msgs[index];

                    return ChatBubble(
                      text: msg.text,
                      time: _formatTime(msg.createdAt),
                      isMe: msg.isMe,
                      seen: msg.seen,
                      myAvatar: myAvatar,
                      peerAvatar: widget.avatar ?? '',
                      type: msg.type,
                      imageUrl: msg.imageUrl,
                      audioUrl: msg.audioUrl,
                      audioDuration: msg.audioDuration,
                      isPlaying: false,      // basic placeholder
                      onPlayPause: () {},    // TODO: implement player
                    );
                  },
                );
              },
            ),
          ),

          ChatInputBar(
            controller: _controller,
            onSend: _sendText,
            onSendImage: _sendImage,
            onSendAudio: _sendAudio,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }
}
