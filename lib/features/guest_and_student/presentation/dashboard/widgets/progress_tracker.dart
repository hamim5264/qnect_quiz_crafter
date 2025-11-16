import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ProgressTracker extends StatelessWidget {
  final double progress;
  final String label;

  const ProgressTracker({
    super.key,
    required this.progress,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: progress,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation(AppColors.primaryLight),
          ),
        ),
      ],
    );
  }
}
