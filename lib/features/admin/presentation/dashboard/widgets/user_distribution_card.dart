import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../providers/admin_stats_provider.dart';

class UserDistributionCard extends ConsumerStatefulWidget {
  const UserDistributionCard({super.key});

  @override
  ConsumerState<UserDistributionCard> createState() =>
      _UserDistributionCardState();
}

class _UserDistributionCardState extends ConsumerState<UserDistributionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(adminStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),

      data: (stats) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Text(
                  'User Distribution',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 190,
                          height: 100,
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: 45,
                              sectionsSpace: 3,
                              centerSpaceRadius: 55,
                              sections: [
                                PieChartSectionData(
                                  color: Colors.white,
                                  value:
                                      stats.studentPercent * _animation.value,
                                  radius: 28,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  color: AppColors.primaryLight,
                                  value:
                                      stats.teacherPercent * _animation.value,
                                  radius: 28,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value:
                                      stats.blockedPercent * _animation.value,
                                  radius: 28,
                                  showTitle: false,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
                              'Total Users',
                              style: TextStyle(
                                fontFamily: AppTypography.family,
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              stats.totalUsers.toString(),
                              style: const TextStyle(
                                fontFamily: AppTypography.family,
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    _buildLegendRow(
                      Colors.white,
                      'Students',
                      "${stats.studentPercent.toStringAsFixed(1)}%",
                    ),
                    const SizedBox(height: 6),
                    _buildLegendRow(
                      AppColors.primaryLight,
                      'Teachers',
                      "${stats.teacherPercent.toStringAsFixed(1)}%",
                    ),
                    const SizedBox(height: 6),
                    _buildLegendRow(
                      Colors.red,
                      'Blocked',
                      "${stats.blockedPercent.toStringAsFixed(1)}%",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.push('/manage-users'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                      side: const BorderSide(
                        color: AppColors.textPrimary,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendRow(Color color, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTypography.family,
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
