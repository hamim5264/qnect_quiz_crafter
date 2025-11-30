import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ChatBubble extends StatelessWidget {
  final String messageId;
  final String chatId;
  final void Function(String chatId, String messageId)? onDelete;

  final String text;
  final String time;
  final bool isMe;
  final bool seen;
  final String myAvatar;
  final String peerAvatar;

  final String type;
  final String? imageUrl;
  final String? audioUrl;
  final int? audioDuration;
  final bool isPlaying;
  final VoidCallback? onPlayPause;

  const ChatBubble({
    super.key,
    required this.messageId,
    required this.chatId,
    required this.onDelete,
    required this.text,
    required this.time,
    required this.isMe,
    required this.seen,
    required this.myAvatar,
    required this.peerAvatar,
    required this.type,
    this.imageUrl,
    this.audioUrl,
    this.audioDuration,
    this.isPlaying = false,
    this.onPlayPause,
  });

  ImageProvider? _resolveAvatar(String url) {
    if (url.isEmpty) return null;
    if (url.startsWith("http")) return NetworkImage(url);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (type == 'image' && imageUrl != null && imageUrl!.isNotEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(imageUrl!, width: 200, fit: BoxFit.cover),
      );
    } else if (type == 'audio' && audioUrl != null && audioUrl!.isNotEmpty) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPlayPause,
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: isMe ? AppColors.primaryLight : Colors.white,
            ),
          ),
          Text(
            audioDuration != null ? "${audioDuration!}s" : "Voice",
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: isMe ? Colors.black87 : Colors.white,
              fontSize: 13.5,
            ),
          ),
        ],
      );
    } else {
      content = Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.family,
          color: isMe ? Colors.black87 : Colors.white,
          fontSize: 13.5,
          height: 1.4,
        ),
      );
    }

    return GestureDetector(
      onLongPress: () {
        if (onDelete != null) {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: const Text("Delete Message"),
                  content: const Text("Do you want to delete this message?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete!(chatId, messageId);
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
          );
        }
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  backgroundImage: _resolveAvatar(peerAvatar),
                  child:
                      peerAvatar.isEmpty
                          ? const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 18,
                          )
                          : null,
                ),

              if (!isMe) const SizedBox(width: 6),

              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isMe
                            ? Colors.white.withValues(alpha: 0.5)
                            : AppColors.primaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      content,
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: isMe ? Colors.black54 : Colors.white70,
                              fontSize: 11.5,
                            ),
                          ),
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.done_all_rounded,
                              size: 15,
                              color:
                                  seen ? AppColors.chip2 : Colors.grey.shade400,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              if (isMe) const SizedBox(width: 6),

              if (isMe)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  backgroundImage: _resolveAvatar(myAvatar),
                  child:
                      myAvatar.isEmpty
                          ? const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 18,
                          )
                          : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
