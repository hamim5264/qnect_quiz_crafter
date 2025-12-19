import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';

class FeedbackCard extends StatelessWidget {
  final String name;
  final int stars;
  final String teacher;
  final String course;
  final String comment;
  final double average;
  final String? profileImage;

  final VoidCallback? onDelete;

  const FeedbackCard({
    super.key,
    required this.name,
    required this.stars,
    required this.teacher,
    required this.course,
    required this.comment,
    required this.average,
    this.profileImage,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.chip2,
                backgroundImage:
                    (profileImage != null && profileImage!.isNotEmpty)
                        ? NetworkImage(profileImage!)
                        : null,
                child:
                    (profileImage == null || profileImage!.isEmpty)
                        ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 22,
                        )
                        : null,
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: List.generate(
              stars,
              (_) => const Icon(Icons.star, color: Colors.amber, size: 18),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Teacher: $teacher\nCourse: $course',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.chip2, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              comment,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 13,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chip2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Average: $average',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              if (onDelete != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder:
                              (_) => ActionFeedbackDialog(
                                icon: CupertinoIcons.delete,
                                title: 'Delete Feedback?',
                                subtitle:
                                    'Are you sure you want to remove this feedback permanently?',
                                buttonText: 'Confirm Delete',
                                onPressed: onDelete!,
                              ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
