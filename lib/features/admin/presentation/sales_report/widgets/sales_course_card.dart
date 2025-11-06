import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SellsCourseCard extends StatelessWidget {
  final String course;
  final String soldBy;
  final String date;
  final int amount;
  final bool isRefunded;

  const SellsCourseCard({
    super.key,
    required this.course,
    required this.soldBy,
    required this.date,
    required this.amount,
    this.isRefunded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: AppColors.secondaryDark),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(color: Colors.yellow, fontSize: 16),
                  ),
                  Text(
                    course,
                    style: const TextStyle(
                      fontFamily: AppTypography.family,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Sold by: $soldBy',
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
              Text(
                'Date: $date',
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white60,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          Text(
            '${amount.toString()} BDT',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: isRefunded ? Colors.grey : AppColors.secondaryDark,
              decoration: isRefunded ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
