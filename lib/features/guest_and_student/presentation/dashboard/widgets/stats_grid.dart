import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_loader.dart';
import 'package:qnect_quiz_crafter/features/guest_and_student/presentation/dashboard/provider/student_stats_provider.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class StatsGrid extends ConsumerWidget {
  final String? uid;

  const StatsGrid({super.key, this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (uid == null || uid!.isEmpty) {
      final guestItems = [
        _StatItem(
          animation: "assets/animations/exam.json",
          value: "00",
          label: "Total Quizzes",
          subLabel: "Quiz. Repeat",
        ),
        _StatItem(
          animation: "assets/animations/courses.json",
          value: "00",
          label: "Total Courses",
          subLabel: "Expand learning",
        ),
        _StatItem(
          animation: "assets/animations/current_rank.json",
          value: "00",
          label: "Current Rank",
          subLabel: "Eyes on #1",
        ),
        _StatItem(
          animation: "assets/animations/growth.json",
          value: "0%",
          label: "Weekly Growth Rate",
          subLabel: "Keep the streak",
        ),
      ];

      return _buildGrid(guestItems);
    }

    final stats = ref.watch(studentStatsProvider(uid!));

    return stats.when(
      // loading: () => const Center(child: AppLoader()),
      loading: () => const Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primaryLight,
          radius: 14,
        ),
      ),

      error:
          (e, _) =>
              Text("Error: $e", style: const TextStyle(color: Colors.white)),
      data: (data) {
        final items = [
          _StatItem(
            animation: "assets/animations/exam.json",
            value: data.totalQuizzes.toString(),
            label: "Total Quizzes",
            subLabel: "Quiz. Repeat",
          ),
          _StatItem(
            animation: "assets/animations/courses.json",
            value: data.totalCourses.toString(),
            label: "Total Courses",
            subLabel: "Expand learning",
          ),
          _StatItem(
            animation: "assets/animations/current_rank.json",
            value: data.rank.toString(),
            label: "Current Rank",
            subLabel: "Eyes on #1",
          ),
          _StatItem(
            animation: "assets/animations/growth.json",
            value: "${data.weeklyGrowth.toStringAsFixed(1)}%",
            label: "Weekly Growth Rate",
            subLabel: "Keep the streak",
          ),
        ];

        return _buildGrid(items);
      },
    );
  }

  Widget _buildGrid(List<_StatItem> items) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 16,
        childAspectRatio: 0.80,
      ),
      itemBuilder: (context, i) {
        final item = items[i];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset(item.animation, fit: BoxFit.contain),
              ),
              const SizedBox(height: 6),
              Text(
                item.value,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.subLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 12,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem {
  final String animation;
  final String value;
  final String label;
  final String subLabel;

  _StatItem({
    required this.animation,
    required this.value,
    required this.label,
    required this.subLabel,
  });
}
