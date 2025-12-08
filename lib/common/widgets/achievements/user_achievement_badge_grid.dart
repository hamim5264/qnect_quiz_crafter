// lib/common/widgets/achievements/user_achievement_badge_grid.dart

import 'package:flutter/material.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';
import '../../services/user_achievements_controller.dart';
import 'user_achievement_badge_item.dart';

class UserAchievementBadgeGrid extends StatelessWidget {
  final String role;
  final List<UserAchievementBadge> badges;

  const UserAchievementBadgeGrid({
    super.key,
    required this.role,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Badges",
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: badges.length + 2, // 10 + 2 "coming soon"
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            if (index >= badges.length) {
              // Coming soon slot
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.lock_clock,
                          color: Colors.white70),
                      SizedBox(height: 6),
                      Text(
                        "Coming\nSoon!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTypography.family,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return UserAchievementBadgeItem(
              badge: badges[index],
            );
          },
        ),
      ],
    );
  }
}
