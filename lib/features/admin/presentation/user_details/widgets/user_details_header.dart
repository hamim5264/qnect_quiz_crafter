import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class UserDetailsHeader extends StatelessWidget {
  final String role;

  const UserDetailsHeader({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final bool isTeacher = role == "Teacher";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/images/admin/sample_teacher.png'),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mst. Hasna Hena",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    isTeacher
                        ? const [
                          _BulletItem("23 Courses"),
                          _BulletItem("124 Quizzes"),
                          _BulletItem("55 Liked"),
                          _BulletItem("3.12% / monthly growth"),
                        ]
                        : const [
                          _BulletItem("18 Enrolled Courses"),
                          _BulletItem("76 Quizzes Attempted"),
                          _BulletItem("Science Group"),
                          _BulletItem("Level 6"),
                        ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _ChipButton(
                    label: isTeacher ? "Teacher" : "Student",
                    color: AppColors.secondaryDark,
                  ),
                  const SizedBox(width: 10),
                  _ChipButton(
                    label: isTeacher ? "Sells Report" : "Leaderboard #1",
                    color: Colors.white,
                    textColor: AppColors.textPrimary,
                    onTap: isTeacher ? () {} : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          const Icon(LucideIcons.circle, size: 6, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;

  const _ChipButton({
    required this.label,
    required this.color,
    this.textColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12.5,
            fontFamily: AppTypography.family,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
