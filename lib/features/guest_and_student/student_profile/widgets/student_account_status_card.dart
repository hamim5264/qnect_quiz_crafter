import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StudentAccountStatusCard extends StatelessWidget {
  final bool isGuest;
  final VoidCallback onLoginTap;
  final VoidCallback onCreateTap;

  const StudentAccountStatusCard({
    super.key,
    required this.isGuest,
    required this.onLoginTap,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.shield, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 12),

          Text(
            isGuest
                ? "You're now in Guest mode, Please Login!"
                : "Account Active",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryDark,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _FrostedDisableWrapper(
                  enabled: isGuest,
                  child: ElevatedButton(
                    onPressed: onCreateTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _FrostedDisableWrapper(
                  enabled: isGuest,
                  child: ElevatedButton(
                    onPressed: onLoginTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FrostedDisableWrapper extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const _FrostedDisableWrapper({required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return child;
    }

    return IgnorePointer(
      ignoring: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            child,

            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.white.withValues(alpha: 0.25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
