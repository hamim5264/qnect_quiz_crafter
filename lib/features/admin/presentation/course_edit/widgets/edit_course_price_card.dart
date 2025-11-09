import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class EditCoursePriceCard extends StatelessWidget {
  final double totalPrice;
  final double originalPrice;

  const EditCoursePriceCard({
    super.key,
    required this.totalPrice,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Price',
            style: TextStyle(
              fontFamily: AppTypography.family,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Text(
                '৳ ${originalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: totalPrice == 0 ? Colors.redAccent : Colors.grey,
                  decoration:
                      totalPrice == originalPrice
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              if (totalPrice != originalPrice)
                Text(
                  totalPrice == 0
                      ? 'Free'
                      : '৳ ${totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color:
                        totalPrice == 0
                            ? AppColors.secondaryDark
                            : Colors.redAccent,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
