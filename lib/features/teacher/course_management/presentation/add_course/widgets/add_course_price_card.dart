// lib/features/teacher/course_management/presentation/add_course/widgets/add_course_price_card.dart

import 'package:flutter/material.dart';

import '../../../../../../ui/design_system/tokens/typography.dart';


class AddCoursePriceCard extends StatelessWidget {
  final double originalPrice;
  final bool applyDiscount;
  final int discountPercent;

  const AddCoursePriceCard({
    super.key,
    required this.originalPrice,
    required this.applyDiscount,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    final discounted = applyDiscount
        ? (originalPrice - (originalPrice * discountPercent / 100))
        : originalPrice;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.price_change, color: Colors.white, size: 28),
          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Final Price",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "BDT $discounted",
                style: const TextStyle(
                  fontFamily: AppTypography.family,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              if (applyDiscount)
                Text(
                  "Discount: $discountPercent%",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontFamily: AppTypography.family,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
