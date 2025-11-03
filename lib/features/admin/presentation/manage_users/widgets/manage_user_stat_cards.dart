import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/typography.dart';
import '../../../../../ui/design_system/tokens/colors.dart';

class ManageUserStatCards extends StatelessWidget {
  const ManageUserStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _StatCard(
          label: 'Teacher',
          value: '75',
          color: AppColors.chip3,
          textColor: AppColors.white,
        ),
        const _StatCard(
          label: 'Student',
          value: '362',
          color: Colors.white,
          textColor: AppColors.textPrimary,
        ),
        _StatCard(
          label: 'Blocked',
          value: '29',
          color: Colors.red,
          textColor: Colors.white,
        ),
      ],
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
