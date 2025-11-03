import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class ManageUserGrowthCard extends StatefulWidget {
  const ManageUserGrowthCard({super.key});

  @override
  State<ManageUserGrowthCard> createState() => _ManageUserGrowthCardState();
}

class _ManageUserGrowthCardState extends State<ManageUserGrowthCard> {
  late String selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateFormat('MMMM-yyyy').format(DateTime.now());
  }

  Future<void> _selectMonth(BuildContext context) async {
    final now = DateTime.now();
    final months = List.generate(12, (i) {
      final date = DateTime(now.year, i + 1);
      return DateFormat('MMMM-yyyy').format(date);
    });

    String? picked = await showDialog<String>(
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
                fontFamily: AppTypography.family,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: months.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      months[index],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: AppTypography.family,
                      ),
                    ),
                    onTap: () => Navigator.pop(context, months[index]),
                  );
                },
              ),
            ),
          ),
    );

    if (picked != null && picked.isNotEmpty) {
      setState(() => selectedMonth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '9.12%',
                      style: TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        color: AppColors.secondaryDark,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Growth',
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 14,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedMonth,
                          style: TextStyle(
                            fontFamily: AppTypography.family,
                            fontSize: 13,
                            color: AppColors.white.withValues(alpha: 0.7),
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
