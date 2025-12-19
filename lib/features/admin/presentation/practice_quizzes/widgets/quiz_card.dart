import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String groupLabel;
  final String levelLabel;
  final bool isPublished;
  final VoidCallback onPublish;
  final VoidCallback onDelete;

  const QuizCard({
    super.key,
    required this.title,
    required this.groupLabel,
    required this.levelLabel,
    required this.isPublished,
    required this.onPublish,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.white,
                  child: Image.asset(
                    "assets/images/certificates/app_logo.png",
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: AppColors.secondaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  "$groupLabel • $levelLabel".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.black87,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isPublished ? null : onPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPublished ? Colors.grey.shade500 : AppColors.chip3,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isPublished ? 'Unpublish' : 'Publish',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: isPublished ? Colors.black45 : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    CupertinoIcons.delete,
                    color: Colors.redAccent,
                    size: 18,
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
