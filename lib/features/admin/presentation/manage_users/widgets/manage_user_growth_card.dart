import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qnect_quiz_crafter/features/admin/presentation/manage_users/widgets/shimmer_loader.dart';

import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../growth/admin_growth_controller.dart';

class ManageUserGrowthCard extends ConsumerStatefulWidget {
  final bool isLoading;
  final int currentMonthUsers;
  final int previousMonthUsers;

  const ManageUserGrowthCard({
    super.key,
    required this.isLoading,
    required this.currentMonthUsers,
    required this.previousMonthUsers,
  });

  @override
  ConsumerState<ManageUserGrowthCard> createState() =>
      _ManageUserGrowthCardState();
}

class _ManageUserGrowthCardState extends ConsumerState<ManageUserGrowthCard> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(DateTime.now().year, DateTime.now().month);
  }

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();

    final List<DateTime> months = List.generate(
      12,
      (i) => DateTime(now.year, i + 1),
    );

    DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Select Month",
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 350,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: months.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(
                      DateFormat('MMMM yyyy').format(months[i]),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: AppTypography.family,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, months[i]),
                  );
                },
              ),
            ),
          ),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);

      await ref
          .read(adminGrowthControllerProvider.notifier)
          .loadGrowthForMonth(DateTime(picked.year, picked.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ShimmerBox(
          width: MediaQuery.of(context).size.width,
          height: 110,
        ),
      );
    }

    final growthPercentage = AdminGrowthController.calculateGrowth(
      widget.previousMonthUsers,
      widget.currentMonthUsers,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.trendingUp,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Row(
                  children: [
                    Text(
                      "${growthPercentage.toStringAsFixed(2)}%",
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Monthly Growth",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: AppTypography.family,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          DateFormat("MMMM yyyy").format(selectedDate),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontFamily: AppTypography.family,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () => _selectMonth(context),
                icon: const Icon(
                  LucideIcons.settings2,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
