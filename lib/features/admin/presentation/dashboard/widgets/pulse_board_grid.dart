import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.height,
    required this.width,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.20),
      highlightColor: Colors.white.withValues(alpha: 0.35),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          backgroundBlendMode: BlendMode.overlay,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
      ),
    );
  }
}

class PulseBoardGrid extends StatefulWidget {
  const PulseBoardGrid({super.key});

  @override
  State<PulseBoardGrid> createState() => _PulseBoardGridState();
}

class _PulseBoardGridState extends State<PulseBoardGrid> {
  bool loading = true;

  int pending = 0;
  int approved = 0;

  int totalSold = 0;
  int soldScience = 0;
  int soldArts = 0;
  int soldCommerce = 0;

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadPulseboard();
  }

  Future<void> _loadPulseboard() async {
    setState(() => loading = true);

    final courseSnap = await db.collection("courses").get();

    pending = 0;
    approved = 0;

    totalSold = 0;
    soldScience = 0;
    soldArts = 0;
    soldCommerce = 0;

    for (var doc in courseSnap.docs) {
      final data = doc.data();

      final String status = data["status"] ?? "";
      final int sold = (data["sold"] ?? 0);
      final String group = data["group"] ?? "";

      if (status == "Pending") pending++;
      if (status == "Approved") approved++;

      totalSold += sold;

      if (group == "Science") soldScience += sold;
      if (group == "Arts") soldArts += sold;
      if (group == "Commerce") soldCommerce += sold;
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QuizCrafter Pulseboard',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child:
                    loading
                        ? const ShimmerBox(height: 180, width: double.infinity)
                        : _PulseCard(
                          title: 'Pending Courses',
                          value: pending.toString(),
                          percentage: _percentage(pending, approved + pending),
                          subtitle: 'Awaiting review',
                          buttonText: 'Review Now',
                          icon: LucideIcons.clock,
                          iconColor: AppColors.primaryLight,
                          valueColor: AppColors.chip1,
                        ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    loading
                        ? const ShimmerBox(height: 180, width: double.infinity)
                        : _PulseCard(
                          title: 'Approved Courses',
                          value: approved.toString(),
                          percentage: _percentage(approved, approved + pending),
                          subtitle: 'Ready for students',
                          buttonText: 'View Approved',
                          icon: LucideIcons.checkCircle2,
                          iconColor: AppColors.secondaryDark,
                          valueColor: AppColors.chip2,
                        ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          loading
              ? const ShimmerBox(height: 200, width: double.infinity)
              : _PulseCardWide(
                totalSold: totalSold,
                soldScience: soldScience,
                soldArts: soldArts,
                soldCommerce: soldCommerce,
              ),
        ],
      ),
    );
  }

  String _percentage(int part, int total) {
    if (total == 0) return "0%";
    final p = (part / total) * 100;
    return "${p.toStringAsFixed(1)}%";
  }
}

class _PulseCard extends StatelessWidget {
  final String title, value, percentage, subtitle, buttonText;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;

  const _PulseCard({
    required this.title,
    required this.value,
    required this.percentage,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  color: valueColor,
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: AppTypography.family,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () => context.pushNamed('adminCourseAllCourse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppTypography.family,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseCardWide extends StatelessWidget {
  final int totalSold;
  final int soldScience;
  final int soldArts;
  final int soldCommerce;

  const _PulseCardWide({
    required this.totalSold,
    required this.soldScience,
    required this.soldArts,
    required this.soldCommerce,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Sold',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                totalSold.toString(),
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.w900,
                  fontSize: 44, // was 36
                  color: Colors.red,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BulletColumn(
                      color: AppColors.primaryLight,
                      label: 'Science',
                      value: '$soldScience',
                      percent: _percent(soldScience, totalSold),
                    ),
                    _BulletColumn(
                      color: AppColors.cardOthers,
                      label: 'Arts',
                      value: '$soldArts',
                      percent: _percent(soldArts, totalSold),
                    ),
                    _BulletColumn(
                      color: AppColors.chip1,
                      label: 'Commerce',
                      value: '$soldCommerce',
                      percent: _percent(soldCommerce, totalSold),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Units sold',
            style: TextStyle(
              fontFamily: AppTypography.family,
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.pushNamed('salesReport'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Sales Report',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppTypography.family,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _percent(int part, int total) {
    if (total == 0) return "0%";
    final p = (part / total) * 100;
    return "${p.toStringAsFixed(1)}%";
  }
}

class _BulletColumn extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String percent;

  const _BulletColumn({
    required this.color,
    required this.label,
    required this.value,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),

        Text(
          percent,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
