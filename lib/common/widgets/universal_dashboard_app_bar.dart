import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

class UniversalDashboardAppBar extends StatelessWidget {
  final String role;
  final String greeting;
  final String username;
  final String email;
  final String motto;
  final String levelText;
  final String xpText;
  final String? profileImage;
  final bool isGuest;
  final VoidCallback? onLoginTap;

  const UniversalDashboardAppBar({
    super.key,
    required this.role,
    required this.greeting,
    required this.username,
    required this.email,
    required this.motto,
    required this.levelText,
    required this.xpText,
    this.profileImage,
    this.isGuest = false,
    this.onLoginTap,
  });

  String _guestName() {
    final list = [
      "Guest User",
      "Guest Learner",
      "Explorer",
      "New Visitor",
      "Guest Member",
    ];
    return list[Random().nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    final String finalName = isGuest ? _guestName() : username;
    final String finalXp = isGuest ? "XP 0" : xpText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (role == "teacher") {
                    context.push(
                      '/guest_teacher-profile',
                      extra: {
                        'isGuest': isGuest,
                        'username': finalName,
                        'email': email,
                        'profileImage': profileImage,
                      },
                    );
                  } else if (role == "student" || role == "guest") {
                    context.push(
                      '/student-profile',
                      extra: {
                        'isGuest': isGuest,
                        'username': finalName,
                        'email': email,
                        'profileImage': profileImage,
                      },
                    );
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildProfileImage(),
                      ),
                    ),

                    if (!isGuest)
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                            color: AppColors.chip3,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: AppColors.textPrimary,
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      finalName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isGuest ? "Welcome to QuizCrafter!" : motto,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppTypography.family,
                        color: Colors.white.withValues(alpha: .85),
                      ),
                    ),

                    const SizedBox(height: 6),

                    if (!isGuest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.chip1,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          levelText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Column(
                children: [
                  _glassButton(
                    disabled: isGuest,
                    icon: CupertinoIcons.bell,
                    onTap: () {},
                  ),
                  _glassButton(
                    disabled: isGuest,
                    icon: CupertinoIcons.bubble_right,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildXPBar(finalXp),

          const SizedBox(height: 10),

          if (isGuest)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You're in guest mode ",
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: AppTypography.family,
                  ),
                ),
                GestureDetector(
                  onTap: onLoginTap,
                  child: const Text(
                    "Login now",
                    style: TextStyle(
                      color: AppColors.secondaryDark,
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _glassButton({
    required bool disabled,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              disabled
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20),
          onPressed: disabled ? null : onTap,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (isGuest || profileImage == null || profileImage!.isEmpty) {
      return Container(
        color: Colors.white12,
        child: const Icon(Icons.person, color: Colors.white70, size: 40),
      );
    }
    return Image.network(profileImage!, fit: BoxFit.cover);
  }

  Widget _buildXPBar(String xpString) {
    final int currentXP =
        int.tryParse(xpString.replaceAll("XP", "").trim()) ?? 0;

    const int maxXP = 100;
    final double progress = isGuest ? 0 : (currentXP / maxXP).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress to $levelText",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: AppTypography.family,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondaryDark,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                xpString,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
