import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class FeedbackCountBox extends StatelessWidget {
  final int total;

  const FeedbackCountBox({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Total Review',
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '$total',
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
