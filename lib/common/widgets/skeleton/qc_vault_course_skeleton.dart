import 'package:flutter/material.dart';

import '../../../ui/design_system/tokens/colors.dart';
import '../app_skeleton.dart';

class QCVaultCourseSkeleton extends StatelessWidget {
  const QCVaultCourseSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),

          const AppSkeleton(
            width: 50,
            height: 50,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),

          const SizedBox(height: 12),

          const AppSkeleton(height: 14),

          const SizedBox(height: 8),

          const AppSkeleton(width: 80, height: 12),

          const Spacer(),

          Row(
            children: const [
              Expanded(child: AppSkeleton(height: 28)),
              SizedBox(width: 6),
              Expanded(child: AppSkeleton(height: 28)),
            ],
          ),
        ],
      ),
    );
  }
}
