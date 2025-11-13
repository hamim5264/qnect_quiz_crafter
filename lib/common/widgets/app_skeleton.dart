import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui/design_system/tokens/colors.dart';

class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AppSkeleton({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.white.withValues(alpha: 0.4),
      highlightColor: AppColors.white.withValues(alpha: 0.3),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 16,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.6),
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      ),
    );
  }
}
