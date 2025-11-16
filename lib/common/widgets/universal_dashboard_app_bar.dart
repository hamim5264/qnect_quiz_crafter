import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../ui/design_system/tokens/colors.dart';
import '../../ui/design_system/tokens/typography.dart';

class UniversalDashboardAppBar extends StatelessWidget {
  final String greeting;
  final String username;
  final String motto;
  final String levelText;
  final String xpText;
  final String? profileImage;
  final bool isGuest;
  final VoidCallback? onLoginTap;

  const UniversalDashboardAppBar({
    super.key,
    required this.greeting,
    required this.username,
    required this.motto,
    required this.levelText,
    required this.xpText,
    this.profileImage,
    this.isGuest = false,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
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
                onTap: () {},
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
                        child: Image.network(
                          profileImage ?? 'https://i.pravatar.cc/150?img=12',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

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
                      username,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      motto,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppTypography.family,
                        color: Colors.white.withValues(alpha: .85),
                      ),
                    ),

                    const SizedBox(height: 6),

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
                  IconButton(
                    icon: const Icon(CupertinoIcons.bell, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.bubble_right,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildXPBar(),

          const SizedBox(height: 10),

          if (isGuest)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You're in guest_and_student mode ",
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: AppTypography.family,
                  ),
                ),
                GestureDetector(
                  onTap: onLoginTap,
                  child: const Text(
                    "Login",
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

  Widget _buildXPBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Progress to Level 1",
              style: TextStyle(
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
                xpText,
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
            value: 0.0,
            minHeight: 8,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
          ),
        ),
      ],
    );
  }
}
