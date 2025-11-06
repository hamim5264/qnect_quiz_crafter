import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isRead;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.isRead,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isRead
                          ? Colors.white.withValues(alpha: 0.6)
                          : AppColors.secondaryDark,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                description,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  _chipButton(
                    label: isRead ? 'Read' : 'Mark as Read',
                    color:
                        isRead
                            ? Colors.grey.withValues(alpha: 0.4)
                            : AppColors.primaryLight,
                    onTap: isRead ? null : onMarkRead,
                  ),
                  const SizedBox(width: 10),
                  _chipButton(
                    label: 'Delete',
                    color: Colors.red,
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipButton({
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
