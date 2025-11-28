import 'package:flutter/material.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/manage_users/widgets/shimmer_loader.dart';

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 64) / 3;

    return ShimmerBox(width: width, height: 70, radius: 12);
  }
}
