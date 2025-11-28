import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TeacherRequestHeader extends StatelessWidget {
  final String name;
  final String email;
  final String avatar;
  final bool expanded;
  final VoidCallback onToggle;

  const TeacherRequestHeader({
    super.key,
    required this.name,
    required this.email,
    required this.avatar,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primaryDark.withValues(alpha: 0.4),
              child: const Icon(Icons.person, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.chip3,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Teacher',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
