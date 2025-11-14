import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String group;
  final String level;
  final String quizTime;
  final String timeRemainingText;
  final String icon;
  final bool isPublished;
  final VoidCallback onPublish;
  final VoidCallback onDelete;

  const SurpriseQuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.group,
    required this.level,
    required this.quizTime,
    required this.timeRemainingText,
    required this.icon,
    required this.isPublished,
    required this.onPublish,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              icon,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),

          Text(
            subtitle.isEmpty ? "No Description" : subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: AppTypography.family,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "• $group • $level",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Time: $quizTime",
            style: const TextStyle(
              color: AppColors.secondaryDark,
              fontSize: 12,
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Visibility: $timeRemainingText",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.secondaryDark,
              fontSize: 12,
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isPublished ? null : onPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPublished ? Colors.grey : AppColors.chip3,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isPublished ? "Unpublish" : "Publish",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTypography.family,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.redAccent,
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
