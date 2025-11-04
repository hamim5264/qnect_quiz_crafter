import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import 'user_details_header.dart';

class UserOverviewCard extends StatelessWidget {
  final String role;
  final bool isExpanded;
  final VoidCallback onChanged;

  const UserOverviewCard({
    super.key,
    required this.role,
    required this.isExpanded,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = role == "Teacher";

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              UserDetailsHeader(role: role),

              const SizedBox(height: 12),

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 6,
                childAspectRatio: 3.8,
                children:
                    isTeacher
                        ? const [
                          _BulletItem("23 Courses Created"),
                          _BulletItem("124 Quizzes Created"),
                          _BulletItem("55 Liked"),
                          _BulletItem("3.12% Monthly Growth"),
                        ]
                        : const [
                          _BulletItem("18 Courses Enrolled"),
                          _BulletItem("76 Quizzes Given"),
                          _BulletItem("Science Group"),
                          _BulletItem("Level: HSC"),
                        ],
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ChipButton(
                    label: isTeacher ? "Teacher" : "Student",
                    color: AppColors.secondaryDark,
                    textColor: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 10),
                  _ChipButton(
                    label: isTeacher ? "Sells Report" : "Leaderboard #1",
                    color: Colors.white,
                    textColor: AppColors.textPrimary,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 6, color: Colors.white),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _ChipButton({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontFamily: AppTypography.family,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
