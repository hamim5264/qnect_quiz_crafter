import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../ui/design_system/tokens/colors.dart';

class ShimmerCourseCard extends StatelessWidget {
  const ShimmerCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.15),
      highlightColor: Colors.white.withOpacity(0.3),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
