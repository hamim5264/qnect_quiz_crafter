import 'package:flutter/material.dart';

import '../../../ui/design_system/tokens/colors.dart';
import '../app_skeleton.dart';

class QCVaultQuestionSkeleton extends StatelessWidget {
  const QCVaultQuestionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppSkeleton(height: 14),
          SizedBox(height: 10),

          AppSkeleton(height: 12),
          SizedBox(height: 6),

          AppSkeleton(height: 12),
          SizedBox(height: 6),

          AppSkeleton(height: 12),
          SizedBox(height: 6),

          AppSkeleton(height: 12),
        ],
      ),
    );
  }
}
