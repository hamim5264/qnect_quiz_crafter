// lib/common/widgets/achievements/user_achievement_info_dialog.dart

import 'package:flutter/material.dart';
import '../../../ui/design_system/tokens/colors.dart';
import '../../../ui/design_system/tokens/typography.dart';

class UserAchievementInfoDialog extends StatelessWidget {
  final String badgeName;
  final int requiredXp;
  final int requiredLevel;

  const UserAchievementInfoDialog({
    super.key,
    required this.badgeName,
    required this.requiredXp,
    required this.requiredLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline,
                color: Colors.amber, size: 40),
            const SizedBox(height: 10),
            Text(
              badgeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "To unlock this badge you need:",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "• Level $requiredLevel or higher\n"
                  "• At least $requiredXp XP",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Got it",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
