import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class CommunityMessageBubble extends StatelessWidget {
  final String name;
  final String text;
  final String time;
  final bool isMe;
  final bool seen;
  final int seenCount;
  final List<String> seenAvatars;

  const CommunityMessageBubble({
    super.key,
    required this.name,
    required this.text,
    required this.time,
    required this.isMe,
    required this.seen,
    required this.seenCount,
    required this.seenAvatars,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: isMe ? Colors.black87 : Colors.white,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
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
                              seen ? Colors.greenAccent : Colors.grey.shade400,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            if (seenAvatars.isNotEmpty)
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  ...seenAvatars.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white24,
                        backgroundImage:
                            (a.isNotEmpty) ? NetworkImage(a) : null,
                        child:
                            (a.isEmpty)
                                ? const Icon(
                                  Icons.person,
                                  color: Colors.white70,
                                  size: 10,
                                )
                                : null,
                      ),
                    ),
                  ),
                  if (seenCount > 4)
                    Text(
                      ' +${seenCount - 4} others',
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
