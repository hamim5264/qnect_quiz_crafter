import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';
import '../../services/user_achievements_controller.dart';
import 'user_achievement_info_dialog.dart';

class UserAchievementBadgeItem extends StatelessWidget {
  final UserAchievementBadge badge;

  const UserAchievementBadgeItem({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final locked = !badge.unlocked;

    final parts = badge.name.split(' ');
    final first = parts.first;
    final second = parts.length > 1 ? parts.sublist(1).join(" ") : "";

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: locked ? 0.3 : 1,
                child: Lottie.asset(badge.lottiePath, height: 60),
              ),
              const SizedBox(height: 6),
              Text(
                first,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              if (second.isNotEmpty)
                Text(
                  second,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),

        // Top-right icon
        Positioned(
          top: -6,
          right: -6,
          child: IconButton(
            icon: Icon(
              locked ? Icons.lock_outline : Icons.info_outline,
              color: Colors.white70,
              size: 18,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (_) => UserAchievementInfoDialog(
                      badgeName: badge.name,
                      requiredXp: badge.requiredXp,
                      requiredLevel: badge.requiredLevel,
                    ),
              );
            },
          ),
        ),
      ],
    );
  }
}
