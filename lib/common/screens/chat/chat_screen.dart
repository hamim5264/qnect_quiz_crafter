import 'package:audioplayers/audioplayers.dart';
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

  final AudioPlayer _player = AudioPlayer();
  String _playingId = "";

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

    _player.onPlayerComplete.listen((event) {
      if (!mounted) return;
      setState(() => _playingId = "");
    });

    _scrollToBottom();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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

  Future<void> _togglePlay(ChatMessage msg) async {
    if (msg.audioUrl == null || msg.audioUrl!.isEmpty) return;

    try {
      if (_playingId == msg.id) {
        await _player.pause();
        if (!mounted) return;
        setState(() => _playingId = "");
        return;
      }

      await _player.stop();

      await _player.play(UrlSource(msg.audioUrl!));

      if (!mounted) return;
      setState(() => _playingId = msg.id);
    } catch (e) {
      debugPrint("AUDIO PLAY ERROR: $e");
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
                widget.chatId.isEmpty
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

                        if (_playingId.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => _scrollToBottom(),
                          );
                        }

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
                              messageId: msg.id,
                              chatId: widget.chatId,
                              onDelete:
                                  (chatId, messageId) => _chatRepo
                                      .deleteMessage(chatId, messageId),

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

                              isPlaying: _playingId == msg.id,
                              onPlayPause: () => _togglePlay(msg),
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
