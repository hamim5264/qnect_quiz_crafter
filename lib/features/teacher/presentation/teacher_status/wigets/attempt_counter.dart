import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class AttemptProgressBar extends StatelessWidget {
  final int attemptCount;
  final int maxAttempts;

  const AttemptProgressBar({
    super.key,
    required this.attemptCount,
    this.maxAttempts = 3,
  });

  @override
  Widget build(BuildContext context) {
    double progress = attemptCount / maxAttempts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 12,
            width: double.infinity,
            color: Colors.white12,

            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryDark,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Center(
          child: Text(
            "Attempts used: $attemptCount / $maxAttempts",
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
