import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LevelBadgeSkeleton extends StatelessWidget {
  const LevelBadgeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.15),
      highlightColor: Colors.white.withValues(alpha: 0.25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
