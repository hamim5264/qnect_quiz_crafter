// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class ChatBubble extends StatelessWidget {
//   final String text;
//   final String time;
//   final bool isMe;
//   final bool seen;
//   final String myAvatar;
//   final String peerAvatar;
//
//   const ChatBubble({
//     super.key,
//     required this.text,
//     required this.time,
//     required this.isMe,
//     required this.seen,
//     required this.myAvatar,
//     required this.peerAvatar,
//   });
//
//   ImageProvider? _resolveAvatar(String url) {
//     if (url.isEmpty) return null;
//     if (url.startsWith("http")) return NetworkImage(url);
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final avatarImage = isMe ? myAvatar : peerAvatar;
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           mainAxisAlignment:
//           isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // LEFT SIDE AVATAR FOR PEER
//             if (!isMe)
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Colors.white24,
//                 backgroundImage: _resolveAvatar(peerAvatar),
//                 child: peerAvatar.isEmpty
//                     ? const Icon(Icons.person, color: Colors.white70, size: 18)
//                     : null,
//               ),
//
//             if (!isMe) const SizedBox(width: 6),
//
//             Flexible(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isMe
//                       ? Colors.white.withOpacity(0.5)
//                       : AppColors.primaryLight.withOpacity(0.3),
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(16),
//                     topRight: const Radius.circular(16),
//                     bottomLeft: Radius.circular(isMe ? 16 : 4),
//                     bottomRight: Radius.circular(isMe ? 4 : 16),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       text,
//                       style: TextStyle(
//                         fontFamily: AppTypography.family,
//                         color: isMe ? Colors.black87 : Colors.white,
//                         fontSize: 13.5,
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           time,
//                           style: TextStyle(
//                             fontFamily: AppTypography.family,
//                             color: isMe ? Colors.black54 : Colors.white70,
//                             fontSize: 11.5,
//                           ),
//                         ),
//                         if (isMe) ...[
//                           const SizedBox(width: 4),
//                           Icon(
//                             Icons.done_all_rounded,
//                             size: 15,
//                             color:
//                             seen ? AppColors.chip2 : Colors.grey.shade400,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             if (isMe) const SizedBox(width: 6),
//
//             // RIGHT SIDE AVATAR FOR ME
//             if (isMe)
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Colors.white24,
//                 backgroundImage: _resolveAvatar(myAvatar),
//                 child: myAvatar.isEmpty
//                     ? const Icon(Icons.person, color: Colors.white70, size: 18)
//                     : null,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class ChatBubble extends StatefulWidget {
//   final String text;
//   final String time;
//   final bool isMe;
//   final bool seen;
//   final String myAvatar;
//   final String peerAvatar;
//
//   const ChatBubble({
//     super.key,
//     required this.text,
//     required this.time,
//     required this.isMe,
//     required this.seen,
//     required this.myAvatar,
//     required this.peerAvatar,
//   });
//
//   @override
//   State<ChatBubble> createState() => _ChatBubbleState();
// }
//
// class _ChatBubbleState extends State<ChatBubble> {
//   final _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//
//   ImageProvider? _resolveAvatar(String url) {
//     if (url.isEmpty) return null;
//     if (url.startsWith("http")) return NetworkImage(url);
//     return null;
//   }
//
//   bool get isImage => widget.text.startsWith("img::");
//   bool get isAudio => widget.text.startsWith("aud::");
//
//   String get pureUrl {
//     if (isImage || isAudio) {
//       return widget.text.split("::")[1];
//     }
//     return "";
//   }
//
//   // 🎵 PLAY / STOP AUDIO
//   Future<void> _toggleAudio() async {
//     if (!_isPlaying) {
//       try {
//         await _audioPlayer.setUrl(pureUrl);
//         _audioPlayer.play();
//         setState(() => _isPlaying = true);
//
//         _audioPlayer.playerStateStream.listen((event) {
//           if (event.processingState == ProcessingState.completed) {
//             setState(() => _isPlaying = false);
//           }
//         });
//       } catch (e) {
//         debugPrint("Audio play error: $e");
//       }
//     } else {
//       await _audioPlayer.stop();
//       setState(() => _isPlaying = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final avatarImage = widget.isMe ? widget.myAvatar : widget.peerAvatar;
//
//     return Align(
//       alignment:
//       widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           mainAxisAlignment: widget.isMe
//               ? MainAxisAlignment.end
//               : MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // LEFT SIDE AVATAR
//             if (!widget.isMe)
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Colors.white24,
//                 backgroundImage: _resolveAvatar(widget.peerAvatar),
//                 child: widget.peerAvatar.isEmpty
//                     ? const Icon(Icons.person,
//                     color: Colors.white70, size: 18)
//                     : null,
//               ),
//
//             if (!widget.isMe) const SizedBox(width: 6),
//
//             Flexible(
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isImage ? 6 : 14,
//                   vertical: isImage ? 6 : 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: widget.isMe
//                       ? Colors.white.withOpacity(0.5)
//                       : AppColors.primaryLight.withOpacity(0.3),
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(16),
//                     topRight: const Radius.circular(16),
//                     bottomLeft:
//                     Radius.circular(widget.isMe ? 16 : 4),
//                     bottomRight:
//                     Radius.circular(widget.isMe ? 4 : 16),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     // ============================
//                     // 📌 IMAGE MESSAGE
//                     // ============================
//                     if (isImage)
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           pureUrl,
//                           width: 200,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//
//                     // ============================
//                     // 🎵 AUDIO MESSAGE
//                     // ============================
//                     if (isAudio)
//                       GestureDetector(
//                         onTap: _toggleAudio,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 _isPlaying
//                                     ? Icons.stop
//                                     : Icons.play_arrow,
//                                 color: widget.isMe
//                                     ? Colors.black
//                                     : Colors.white,
//                               ),
//                               const SizedBox(width: 6),
//                               Text(
//                                 "Voice message",
//                                 style: TextStyle(
//                                   fontFamily: AppTypography.family,
//                                   color: widget.isMe
//                                       ? Colors.black87
//                                       : Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                     // ============================
//                     // TEXT MESSAGE
//                     // ============================
//                     if (!isImage && !isAudio)
//                       Text(
//                         widget.text,
//                         style: TextStyle(
//                           fontFamily: AppTypography.family,
//                           color: widget.isMe
//                               ? Colors.black87
//                               : Colors.white,
//                           fontSize: 13.5,
//                           height: 1.4,
//                         ),
//                       ),
//
//                     const SizedBox(height: 4),
//
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           widget.time,
//                           style: TextStyle(
//                             fontFamily: AppTypography.family,
//                             color: widget.isMe
//                                 ? Colors.black54
//                                 : Colors.white70,
//                             fontSize: 11.5,
//                           ),
//                         ),
//                         if (widget.isMe) ...[
//                           const SizedBox(width: 4),
//                           Icon(
//                             Icons.done_all_rounded,
//                             size: 15,
//                             color: widget.seen
//                                 ? AppColors.chip2
//                                 : Colors.grey.shade400,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             if (widget.isMe) const SizedBox(width: 6),
//
//             // RIGHT SIDE AVATAR
//             if (widget.isMe)
//               CircleAvatar(
//                 radius: 16,
//                 backgroundColor: Colors.white24,
//                 backgroundImage: _resolveAvatar(widget.myAvatar),
//                 child: widget.myAvatar.isEmpty
//                     ? const Icon(Icons.person,
//                     color: Colors.white70, size: 18)
//                     : null,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// lib/common/screens/chat/widgets/chat_bubble.dart

import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;
  final bool seen;
  final String myAvatar;
  final String peerAvatar;

  final String type;              // "text" | "image" | "audio"
  final String? imageUrl;
  final String? audioUrl;
  final int? audioDuration;
  final bool isPlaying;
  final VoidCallback? onPlayPause;

  const ChatBubble({
    super.key,
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
    final avatarImage = isMe ? myAvatar : peerAvatar;

    Widget content;

    if (type == 'image' && imageUrl != null && imageUrl!.isNotEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          imageUrl!,
          width: 200,
          fit: BoxFit.cover,
        ),
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
      // text
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

    return Align(
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
                child: avatarImage.isEmpty
                    ? const Icon(Icons.person,
                    color: Colors.white70, size: 18)
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
                  color: isMe
                      ? Colors.white.withOpacity(0.5)
                      : AppColors.primaryLight.withOpacity(0.3),
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
                child: avatarImage.isEmpty
                    ? const Icon(Icons.person,
                    color: Colors.white70, size: 18)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

