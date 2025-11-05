import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/action_feedback_dialog.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class RatingsCard extends StatelessWidget {
  final String name;
  final String avatar;
  final int performance;
  final int privacy;
  final int experience;
  final String comment;

  const RatingsCard({
    super.key,
    required this.name,
    required this.avatar,
    required this.performance,
    required this.privacy,
    required this.experience,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22,
                backgroundImage: AssetImage(avatar),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _ratingRow('Performance', performance),
          _ratingRow('Fairness & Privacy', privacy),
          _ratingRow('Experience', experience),

          const SizedBox(height: 8),

          const Text(
            'Comment',
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryDark, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              comment,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 13,
                color: Colors.white70,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (_) => ActionFeedbackDialog(
                          icon: CupertinoIcons.trash,
                          title: 'Delete Rating?',
                          subtitle:
                              'Are you sure you want to delete this rating permanently?',
                          buttonText: 'Confirm Delete',
                          onPressed: () => Navigator.pop(context),
                        ),
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingRow(String title, int stars) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          ...List.generate(
            stars,
            (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
          ),
        ],
      ),
    );
  }
}
