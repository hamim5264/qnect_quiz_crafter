import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class RatingsSummaryBox extends StatelessWidget {
  final int total;
  final double performanceAvg;
  final double privacyAvg;
  final double experienceAvg;

  const RatingsSummaryBox({
    super.key,
    required this.total,
    required this.performanceAvg,
    required this.privacyAvg,
    required this.experienceAvg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Review',
                    style: TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$total',
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _avgBox('Performance', performanceAvg)),
            const SizedBox(width: 8),
            Expanded(child: _avgBox('Privacy', privacyAvg)),
            const SizedBox(width: 8),
            Expanded(child: _avgBox('Experience', experienceAvg)),
          ],
        ),
      ],
    );
  }

  Widget _avgBox(String title, double avg) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: AppColors.secondaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
