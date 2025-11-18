import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentProfileHeader extends StatelessWidget {
  final bool isGuest;
  final String? username;
  final String? email;
  final String? profileImage;
  final VoidCallback onLogout;

  const StudentProfileHeader({
    super.key,
    required this.isGuest,
    required this.username,
    required this.email,
    required this.profileImage,
    required this.onLogout,
  });

  String _randomGuestName() {
    final names = [
      "Guest Learner",
      "Guest User",
      "Explorer",
      "Guest Member",
      "Random User",
    ];
    return names[Random().nextInt(names.length)];
  }

  String _randomGuestEmail() {
    final numbers = Random().nextInt(9000) + 1000;
    return "guest$numbers@quizcrafter.com";
  }

  @override
  Widget build(BuildContext context) {
    final String finalName = isGuest ? _randomGuestName() : (username ?? "");
    final String finalEmail = isGuest ? _randomGuestEmail() : (email ?? "");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const Text(
              "Profile",
              style: TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildProfileImage(),
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    finalName.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    finalEmail,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 14),

                  Opacity(
                    opacity: isGuest ? 0.35 : 1,
                    child: IgnorePointer(
                      ignoring: isGuest,
                      child: GestureDetector(
                        onTap: onLogout,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isGuest
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.redAccent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              fontFamily: AppTypography.family,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    if (isGuest || profileImage == null || profileImage!.isEmpty) {
      return Container(
        width: 90,
        height: 90,
        color: AppColors.primaryDark.withValues(alpha: 0.2),
        child: const Icon(Icons.person, size: 45, color: Colors.white70),
      );
    }

    return Image.network(
      profileImage!,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
    );
  }
}
