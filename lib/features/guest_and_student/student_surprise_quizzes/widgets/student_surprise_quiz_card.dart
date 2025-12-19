import 'package:flutter/material.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

class StudentSurpriseQuizCard extends StatelessWidget {
  final String title;
  final String description;
  final int duration;
  final int points;
  final bool expired;
  final String visibilityText;
  final VoidCallback? onAttempt;

  const StudentSurpriseQuizCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.points,
    required this.expired,
    required this.visibilityText,
    this.onAttempt,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (duration / 60).ceil();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? "Surprise Quiz 🎁" : title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),

          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "⏱ $minutes min • ⭐ $points XP",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Text(
                visibilityText,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: expired ? Colors.redAccent : AppColors.secondaryDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: expired ? null : onAttempt,
              style: ElevatedButton.styleFrom(
                backgroundColor: expired ? Colors.grey : AppColors.primaryLight,
                disabledBackgroundColor: Colors.white12,
                elevation: expired ? 0 : 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                expired
                    ? visibilityText == "Already Attempted"
                        ? "Already Attempted"
                        : "Expired"
                    : "Attempt Quiz",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
