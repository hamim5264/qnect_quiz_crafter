import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class TeacherStatsGrid extends StatelessWidget {
  const TeacherStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_StatItem> items = [
      _StatItem(
        animation: "assets/animations/like.json",
        value: "00",
        label: "Total Like",
        subLabel: "Keep it up!",
      ),
      _StatItem(
        animation: "assets/animations/enroll.json",
        value: "00",
        label: "Total Enrollment",
        subLabel: "Impact rising",
      ),
      _StatItem(
        animation: "assets/animations/courses.json",
        value: "00",
        label: "Total Courses",
        subLabel: "Build & grow",
      ),
      _StatItem(
        animation: "assets/animations/exam.json",
        value: "00",
        label: "Total Quizzes",
        subLabel: "Challenge on",
      ),
    ];

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
              const SizedBox(height: 2),
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
