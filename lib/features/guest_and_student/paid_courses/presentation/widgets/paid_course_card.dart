// FILE: paid_course_card.dart
// PATH: lib/features/student/paid_courses/presentation/widgets/

import 'package:flutter/material.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class PaidCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onBuy;

  const PaidCourseCard({
    super.key,
    required this.course,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final int price = (course["price"] ?? 0).toInt();
    final int discount = (course["discountPercent"] ?? 0).toInt();
    final bool applyDiscount = course["applyDiscount"] ?? false;

    // ⭐ CALCULATE TOTAL PRICE MANUALLY
    final int finalPrice =
    applyDiscount ? price - ((price * discount) ~/ 100) : price;

    final String iconPath = course["iconPath"] ?? "assets/icons/default.png";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9E9E9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------ ICON + TITLE ------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(iconPath, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(width: 12),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["title"],
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      course["description"],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.family,
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ------------------------ PRICE ROW ------------------------
          Row(
            children: [
              // FINAL PRICE BUBBLE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "৳ $finalPrice",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Original price crossed out
              if (applyDiscount)
                Text(
                  "৳ $price",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: Colors.redAccent,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

              const SizedBox(width: 8),

              // % OFF TEXT
              if (applyDiscount)
                Text(
                  "-$discount% Off",
                  style: const TextStyle(
                    fontFamily: AppTypography.family,
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ------------------------ BUY NOW ------------------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  fontFamily: AppTypography.family,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
