import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

class QCVaultCourseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int questions;
  final VoidCallback onView;
  final VoidCallback onAdd;

  const QCVaultCourseCard({
    super.key,
    required this.icon,
    required this.title,
    required this.questions,
    required this.onView,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.white.withValues(alpha: 0.4),
                  child: Icon(icon, color: AppColors.secondaryDark, size: 18),
                ),

                const SizedBox(height: 6),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "$questions Questions",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: const Size.fromHeight(28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "View",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.chip3,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: const Size.fromHeight(28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 11,
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
