import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/manage_users/widgets/stat_card_skeleton.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../dashboard/providers/admin_stats_provider.dart';

class ManageUserStatCards extends ConsumerWidget {
  const ManageUserStatCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return statsAsync.when(
      loading:
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              StatCardSkeleton(),
              StatCardSkeleton(),
              StatCardSkeleton(),
            ],
          ),

      error:
          (e, _) => Text(
            "Error loading stats",
            style: const TextStyle(color: Colors.red),
          ),

      data: (stats) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatCard(
              label: 'Teacher',
              value: stats.teachers.toString(),
              color: AppColors.chip3,
              textColor: AppColors.white,
            ),
            _StatCard(
              label: 'Student',
              value: stats.students.toString(),
              color: Colors.white,
              textColor: AppColors.textPrimary,
            ),
            _StatCard(
              label: 'Blocked',
              value: stats.blocked.toString(),
              color: Colors.red,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: AppTypography.family,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontFamily: AppTypography.family,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
