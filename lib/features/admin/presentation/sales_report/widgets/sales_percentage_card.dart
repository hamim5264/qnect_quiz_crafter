import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SellsPercentageCard extends StatelessWidget {
  final int science;
  final int arts;
  final int commerce;

  const SellsPercentageCard({
    super.key,
    required this.science,
    required this.arts,
    required this.commerce,
  });

  double _percent(int part, int total) {
    if (total == 0) return 0;
    return (part / total) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final total = science + arts + commerce;

    final sciP = _percent(science, total).toStringAsFixed(2);
    final artP = _percent(arts, total).toStringAsFixed(2);
    final comP = _percent(commerce, total).toStringAsFixed(2);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _CategoryItem(
                  title: 'Science',
                  value: '$sciP%',
                  color: Colors.redAccent,
                ),
                _CategoryItem(
                  title: 'Arts',
                  value: '$artP%',
                  color: AppColors.chip2,
                ),
                _CategoryItem(
                  title: 'Commerce',
                  value: '$comP%',
                  color: Colors.lightGreen,
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(LucideIcons.info, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'This report is based on monthly increments',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    color: Colors.white,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _CategoryItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppTypography.family,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTypography.family,
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
