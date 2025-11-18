import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FormFieldSkeleton extends StatelessWidget {
  const FormFieldSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.25),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white24),
          ),
        ),
      ),
    );
  }
}
