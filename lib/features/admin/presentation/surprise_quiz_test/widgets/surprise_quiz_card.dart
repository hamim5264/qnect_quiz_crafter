import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SurpriseQuizCard extends StatelessWidget {
  final String title;
  final String icon;
  final bool isPublished;
  final String publishedDate;
  final VoidCallback onPublish;
  final VoidCallback onDelete;

  const SurpriseQuizCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isPublished,
    required this.publishedDate,
    required this.onPublish,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              icon,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isPublished ? null : onPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPublished ? Colors.grey.shade500 : AppColors.chip3,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isPublished ? 'Unpublish' : 'Publish',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "📅 Published: $publishedDate",
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
