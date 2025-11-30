import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class MessageCard extends StatelessWidget {
  final String chatId;
  final String peerId;
  final String name;
  final String lastMessage;
  final String time;
  final String? avatar;
  final bool isActive;
  final bool isRead;
  final String peerRole;

  const MessageCard({
    super.key,
    required this.chatId,
    required this.peerId,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    required this.isActive,
    required this.isRead,
    required this.peerRole,
  });

  ImageProvider? _buildAvatar() {
    if (avatar == null || avatar!.trim().isEmpty) return null;
    if (avatar!.startsWith('http')) return NetworkImage(avatar!);
    return AssetImage(avatar!) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    final avatarProvider = _buildAvatar();

    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'chat',
          extra: {
            'chatId': chatId,
            'peerId': peerId,
            'name': name,
            'avatar': avatar,
            'isActive': isActive,
            'peerRole': peerRole,
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isRead ? 8 : 0,
            sigmaY: isRead ? 8 : 0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isRead
                      ? Colors.white.withValues(alpha: 0.12)
                      : AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      backgroundImage: avatarProvider,
                      child:
                          avatarProvider == null
                              ? const Icon(
                                Icons.person,
                                size: 26,
                                color: Colors.black54,
                              )
                              : null,
                    ),
                    if (isActive)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryDark),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          fontSize: 15,
                          fontWeight:
                              isRead ? FontWeight.w500 : FontWeight.bold,
                          color:
                              isRead ? Colors.grey[400] : AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                fontSize: 13,
                                color:
                                    isRead ? Colors.grey[500] : Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              fontSize: 12,
                              color: isRead ? Colors.grey[400] : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
